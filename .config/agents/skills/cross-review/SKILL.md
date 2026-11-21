---
name: cross-review
description: Cross-model review loop to run when implementation is complete. Opens a draft PR, gets a read-only review from the other vendor's model (GPT Sol if you are Claude, Opus if you are GPT), resolves findings, escalates only a disagreement about something the change makes worse, and marks the PR ready on sign-off. Use when work is done and before reporting it finished, or when the user says "cross review".
---

# cross-review

You are the implementer. The reviewer is a different model that reads and reports only. You decide what to fix. Make the smallest changes that resolve real findings; push back with evidence when a finding is wrong. Never agree just to end the loop.

## Where it runs

Only on Max's Mac, where Codex is signed in to his ChatGPT account and Claude Code to his Claude account. In a cloud session, do step 1 (checks, push, draft PR with the pr-description skill), then stop and report that cross-review is pending and must run from a Mac session. Do not install or sign in to a reviewer CLI in the cloud.

## Reviewer

- You are Claude: reviewer is GPT Sol through Codex.
- You are GPT: reviewer is Opus through Claude Code.
- Never substitute another model or vendor. If the CLI is missing or signed out, stop and report. A round that fails, times out or returns nothing is not approval: retry it once, then escalate (step 6).
- One reviewer per round, at effort high. The reviewer must not start subagents.
- Codex reviews at Ultrafast speed (`service_tier = "ultrafast"`). Pass it on every call, since `--ignore-user-config` drops the config's tier. If a round's output warns that the tier is not advertised for the model, Codex dropped it: run that round again with `-c service_tier='"priority"'` (Fast) before reading its verdict, use Fast for the rest of the review, and say so in the report.

Run each call in the background and wait for it to finish; rounds at high take minutes. Keep every brief and reply in a scratch dir `$R` outside the repo.

Codex (reviewer = Sol):

    codex exec -m gpt-6.2-sol -c model_reasoning_effort=high -c service_tier='"ultrafast"' -s read-only \
      --ignore-user-config -C "$REPO" --json -o "$R/round1.md" - < "$R/brief.md" > "$R/round1.jsonl"
    # rounds 2 and 3 resume the same session (resume takes no -s or -C; pass the sandbox as config, run it in the repo):
    cd "$REPO" && codex exec resume "$THREAD_ID" -c sandbox_mode='"read-only"' -c model_reasoning_effort=high \
      -c service_tier='"ultrafast"' --ignore-user-config -o "$R/round2.md" - < "$R/followup.md"

Take `$THREAD_ID` from the session-start event in round1.jsonl.

Claude (reviewer = Opus):

    claude -p --model claude-opus-5-5 --effort high --tools "Read,Grep,Glob" --strict-mcp-config \
      --output-format json < "$R/brief.md" > "$R/round1.json"
    # follow-up: same flags plus --resume "$SESSION_ID" (from .session_id in round1.json)

These flags are the read-only guard. The global allow lists permit edits under ~/dev and some MCP tools that write, so give the reviewer no Bash, Edit, Write, or MCP servers: `--tools` and `--strict-mcp-config` for Claude, `--ignore-user-config` for Codex (it drops the MCP servers in config.toml; sign-in still works).

## 1. Prepare

- On a feature branch, never master. Commit the work. Leave unrelated changes alone; if they don't separate cleanly from this change, stop and ask.
- `git fetch origin`; `BASE=$(git merge-base HEAD origin/<default-branch>)`.
- `git worktree add --detach "$R/head" HEAD` and give the reviewer that path as the repo, so it reads the committed head while you go on working. If uncommitted changes remain, run the checks in a second one (`git worktree add --detach "$R/checks" HEAD`), so they test only what the PR contains and their build output never lands in the reviewer's. When the review ends, move each worktree to the Trash and prune (`trash "$R/head" && git worktree prune`), as a command of its own: after `gh pr ready`, or once you stop to escalate. `git worktree remove --force` stops for Max's approval, and chained to another step it holds that step too: on 2026-11-20 that held four threads for 53 minutes.
- Write `git diff $BASE...HEAD` to `$R/diff.patch`.
- Start round 1 (step 2) in the background now, then run the project's checks (tests, lint, typecheck) while it reviews: a round and a check pass each take minutes, and the reviewer's worktree doesn't move while you work. Fix failures this change caused and commit them; they go to round 2 with the review fixes. Note checks that are missing or were already failing.
- Push and open a draft PR (`gh pr create --draft`), or reuse the existing one and turn it back into a draft with `gh pr ready <n> --undo` if it is ready. Write the description with the pr-description skill.

## 2. Round 1: full review

Brief:

    Review only. Do not edit, run commands that change anything, commit, push, comment, or start subagents.
    Repo: <abs path>  Base: <sha>  Head: <sha>
    Intent: <1-2 sentences>  Out of scope: <list>  Checks: running while you review; failures and their fixes come in round 2
    Diff: <$R/diff.patch path>. Read the surrounding code and callers.
    Find bugs, broken callers, gaps against the intent, and missing handling the intent requires.
    Skip style unless it hides a bug. Flag code, tests, or guards the intent does not need.
    blocker = the intended case is wrong. should = a real bug callers will hit within the intent. nit = everything else.
    Reply exactly:
    VERDICT: APPROVE or CHANGES
    S1 [blocker|should|nit] <file>:<line> <claim>. Fix: <suggestion>

## 3. Triage

Check every finding yourself and re-grade its severity: a rare case, another code path, or a small cost is a nit whatever label it came with.

The bar is that the change does what was intended and makes nothing worse than the base branch. A finding about something the base branch already does, or about a case outside the intent that the change leaves as it was, is a follow-up, whatever its label and however real the bug: decline it in one line and list it. Fixing it here is how a small PR grows a second and third approach.

- Agree: smallest fix. Prefer deleting or narrowing over adding a lock, cache, helper, or option. Add one focused test that fails without the fix, if the intent needs it.
- Disagree: one line of reason plus evidence (file:line, test, output).
- Nit or out of scope: decline in one line and list it as a follow-up.
- A finding that would need a different approach to one part of the change: if the rest stands without that part, move the part to its own PR and ship the rest.

Keep a ledger: id, severity, outcome (fixed / disagree / declined), evidence. Re-run only the checks a fix touches (its own tests, lint on the files it changed), commit, and compare `git diff --shortstat $BASE` before and after; if review grew the diff, cut first.

Between rounds, leave the slow work alone: the full check suite, a full build, screenshots and recordings, and the PR description. A round takes a minute or two, and redoing that work after each one is what makes a review take hours. It all runs once, in Ship.

## 4. Round 2: review the fixes, same session

Skip it if round 1 approved and nothing changed behavior, a fix for a failed check included. Move the review worktree to the new head first (`git -C "$R/head" checkout --detach <new head>`). Then resume the reviewer with the check results, the ledger (`fixed:` / `disagree:` / `declined:` + evidence) and `git diff <round1 head>..HEAD`. Ask it to mark each blocker and should `resolved` or `still open: <reason>`, and to flag new issues only in the changed code. Same reply format, same effort.

## 5. Round 3: check the round 2 fixes

Run it only when round 2 left a blocker or should `still open`, or raised a new one, and you agreed and fixed it. Triage those items as in step 3, commit, and move the review worktree to the new head as in round 2. Then resume the same session with the updated ledger and `git diff <round2 head>..HEAD`, and ask it to mark each of those items `resolved` or `still open: <reason>` and to flag new issues only in the lines changed since round 2. Same reply format, same effort.

Round 3 only checks fixes. An item you disagree with is not argued again here; it goes to Max. Round 3 is the last round.

If round 3 leaves an item `still open` or raises a new one, and you agree with the reviewer, fix it and go to Ship. Record it in the ledger as `fixed after the last round, not re-reviewed`.

## 6. Escalate to Max

Escalate a blocker or should only when you and the reviewer still disagree after round 2 or round 3 about something the change makes worse than the base branch: you reject its finding, or its reason for rejecting your fix. Waiting for Max can cost an hour, so nothing else waits for him:

- A finding you agree with is fixed, whichever round raised it.
- A finding you re-graded as a nit is declined and listed as a follow-up.
- A disagreement about anything else (behavior the base branch already has, a case outside the intent) goes under Follow-ups with both positions in a line each. It does not hold the PR.
- A product or design question the review turned up goes in your report. It does not hold the PR as a draft.

Do not run a fourth round, switch models, or raise effort to settle a disagreement.

- Leave the PR as a draft. Push what you have.
- Message Max with one entry per open item:

      S2 [should] api/sync.ts:88 — <reviewer's claim>
      Reviewer: <their position, 1-2 lines>
      Implementer: <your position and evidence, 1-2 lines>
      Options: fix as suggested / keep as is / <other>

- Stop and wait. Max's call is final. Apply it and go to Ship without another review round, unless Max asks for one.

A round that times out, errors, or returns nothing is not approval: retry once, then escalate it as a blocker.

## 7. Ship

Signed off means every blocker and should is settled and you have no concern of your own. An item is settled when the reviewer marked it `resolved`, when you agreed and fixed it after the last round, when Max ruled on it, or when the bar in Triage made it a follow-up and you listed it. A latest verdict of APPROVE settles them all. Then:

- If review changed any code, run the project's full checks once more, on the final head. Fix what this change broke. Where the project lands PRs with a check of its own (Orchard's `scripts/land.sh`), skip this one: that check runs after `gh pr ready` and is the final run.
- Push. Update the description per pr-description: refresh the evidence once, from the final head, if review fixes changed behavior. List declined nits under Follow-ups, and name every fix made after the last round as not re-reviewed.
- `gh pr ready <n>`. Then do what the project's instructions say about landing: where they have you land your own PR (Orchard does), follow them. Where they say nothing, never merge. Never release or upload a build from the PR branch.

Report: rounds, model, findings fixed or declined with reasons, fixes made after the last round, anything Max ruled on, diff size before and after, PR link and state.
