---
name: cross-review
description: Cross-model review loop to run when implementation is complete. Opens a draft PR, gets a read-only review from the other vendor's model (GPT Sol if you are Claude, Opus if you are GPT), resolves findings, escalates unresolved disagreements to Max, and marks the PR ready only on sign-off. Use when work is done and before reporting it finished, or when the user says "cross review".
---

# cross-review

You are the implementer. The reviewer is a different model that reads and reports only. You decide what to fix. Make the smallest changes that resolve real findings; push back with evidence when a finding is wrong. Never agree just to end the loop.

## Where it runs

Only on Max's Mac, where Codex is signed in to his ChatGPT account and Claude Code to his Claude account. In a cloud session, do step 1 (checks, push, draft PR with the pr-description skill), then stop and report that cross-review is pending and must run from a Mac session. Do not install or sign in to a reviewer CLI in the cloud.

## Reviewer

- You are Claude: reviewer is GPT Sol through Codex.
- You are GPT: reviewer is Opus through Claude Code.
- Never substitute another model or vendor. If the CLI is missing or fails, stop and report; failure, timeout, or empty output is not approval.
- One reviewer per round, at effort high. The reviewer must not start subagents.

Run each call in the background and wait for it to finish; rounds at high take minutes. Keep every brief and reply in a scratch dir `$R` outside the repo.

Codex (reviewer = Sol):

    codex exec -m gpt-6.1-sol -c model_reasoning_effort=high -s read-only -C "$REPO" \
      --json -o "$R/round1.md" - < "$R/brief.md" > "$R/round1.jsonl"
    # follow-up in the same session (resume takes no -s; pass the sandbox as config):
    codex exec resume "$THREAD_ID" -c sandbox_mode='"read-only"' -c model_reasoning_effort=high \
      -o "$R/round2.md" - < "$R/followup.md"

Take `$THREAD_ID` from the session-start event in round1.jsonl.

Claude (reviewer = Opus):

    claude -p --model claude-opus-5-5 --effort high --tools "Read,Grep,Glob" \
      --output-format json < "$R/brief.md" > "$R/round1.json"
    # follow-up: same flags plus --resume "$SESSION_ID" (from .session_id in round1.json)

`--tools` is the read-only guard: the global allow list permits edits under ~/dev, so do not give this reviewer Bash, Edit, or Write.

## 1. Prepare

- On a feature branch, never master. Commit the work. Leave unrelated changes alone; if they don't separate cleanly from this change, stop and ask.
- `git fetch origin`; `BASE=$(git merge-base HEAD origin/<default-branch>)`.
- Run the project's checks (tests, lint, typecheck). Fix failures this change caused. Note checks that are missing or were already failing.
- Write `git diff $BASE...HEAD` to `$R/diff.patch`.
- Push and open a draft PR (`gh pr create --draft`), or reuse the existing one. Write the description with the pr-description skill.

## 2. Round 1: full review

Brief:

    Review only. Do not edit, run commands that change anything, commit, push, comment, or start subagents.
    Repo: <abs path>  Base: <sha>  Head: <sha>
    Intent: <1-2 sentences>  Out of scope: <list>  Checks: <results>
    Diff: <$R/diff.patch path>. Read the surrounding code and callers.
    Find bugs, broken callers, gaps against the intent, and missing handling the intent requires.
    Skip style unless it hides a bug. Flag code, tests, or guards the intent does not need.
    blocker = the intended case is wrong. should = a real bug callers will hit within the intent. nit = everything else.
    Reply exactly:
    VERDICT: APPROVE or CHANGES
    S1 [blocker|should|nit] <file>:<line> <claim>. Fix: <suggestion>

## 3. Triage

Check every finding yourself and re-grade its severity: a rare case, another code path, or a small cost is a nit whatever label it came with.

- Agree: smallest fix. Prefer deleting or narrowing over adding a lock, cache, helper, or option. Add one focused test that fails without the fix, if the intent needs it.
- Disagree: one line of reason plus evidence (file:line, test, output).
- Nit or out of scope: decline in one line and list it as a follow-up.

Keep a ledger: id, severity, outcome (fixed / disagree / declined), evidence. Re-run checks, commit, and compare `git diff --shortstat $BASE` before and after; if review grew the diff, cut first.

## 4. Round 2: final review, same session

Skip it if round 1 approved and nothing changed behavior. Otherwise resume the reviewer with the ledger (`fixed:` / `disagree:` / `declined:` + evidence) and `git diff <round1 head>..HEAD`. Ask it to mark each blocker and should `resolved` or `still open: <reason>`, and to flag new issues only in the changed code. Same reply format, same effort.

## 5. Escalate to Max

Escalate when, after round 2, any blocker or should is `still open` or newly raised, whether you disagree with the reviewer or the reviewer rejects your fix. Do not run a third round, switch models, or raise effort to settle it.

- Leave the PR as a draft. Push what you have.
- Message Max with one entry per open item:

      S2 [should] api/sync.ts:88 — <reviewer's claim>
      Reviewer: <their position, 1-2 lines>
      Implementer: <your position and evidence, 1-2 lines>
      Options: fix as suggested / keep as is / <other>

- Stop and wait. Max's call is final. Apply it, re-run checks, and go to Ship without another review round, unless Max asks for one.

A round that times out, errors, or returns nothing is not approval: retry once, then escalate it as a blocker.

## 6. Ship

Signed off means one of two things. Either the latest verdict is APPROVE, no blocker or should is open, and you have no concern of your own. Or Max has ruled on every open item. Checks must also pass. Then:

- Push. Update the description per pr-description: refresh the evidence if review fixes changed behavior, and list declined nits under Follow-ups.
- `gh pr ready <n>`. Never merge.

Report: rounds, model, findings fixed or declined with reasons, anything Max ruled on, diff size before and after, PR link and state.
