---
name: "skill-audit"
description: "Audit and slim down agent skills. Finds what each skill teaches that the model doesn't already know, distills the skill to that, fixes its description so it triggers, and verifies the result with blind rewrites and non-leading probes. Use whenever the user asks to audit, distill, trim, measure or benchmark skills, asks whether skills are still worth loading, or wants skills re-checked after a model update."
---

# Skill audit

Find what each skill teaches that the model doesn't already know, cut the skill down to that, and prove the cut version still works.

- Run each role below as its own agent (a subagent, worker or fresh session), so the blind roles never see the original. In steps 1 to 7, every agent works on one skill only; never give one agent several skills. Run skills in parallel when the harness allows. That's 7 agents per skill, plus 2 per restore round, then 1 consolidation agent and 2 more for each skill it changes. A re-audit that reuses saved probes needs 2 per skill (see the end).
- Every agent runs on the user's default model and reasoning settings. Don't set a model or effort. That default model is the model under test.
- Keep each agent's starting context small, because it is most of the cost: an agent can spend tens of thousands of tokens on it before doing any work.
  - Give each agent only the tools its role needs, with no connectors, MCP servers or project instructions loaded. In Claude Code, use a custom agent type with a `tools:` list.
  - Put the questions in the prompt, and for a skill-loaded answerer the SKILL.md text too, so it answers in one turn and reads reference files only when a question needs them.
  - Answers stay under about 150 words, with code only when the point is code.
- Blind roles, enforced with tool permissions:
  - the writer may only write files in its own output folder;
  - the no-skill answerer uses no tools;
  - a skill-loaded answerer may only read inside its one skill folder (in step 8, inside the folders it is given).
- Snapshot every original first. Later steps read the snapshot, because shipping replaces the live folder.

1. **Prep.** Read the original and split it into 20 to 60 units, scaled to its size. A unit is a distinct fact, rule, command or step an agent would act on; tag each one core or detail. Then write a 40 to 120 word topic prompt that leaks none of the original's rules, API names, steps or examples.
2. **Blind rewrite.** The writer writes the skill from the topic prompt alone.
3. **Grade and probe.** Mark each unit present, partial, absent or contradicted in the rewrite, and score the overlap from 0 to 100. Write up to 24 probes for the gap units, in this order: contradicted, absent core, absent detail, then partial core.
   - Each probe is non-leading: a task, code or a symptom that never names the answer, the API or the pitfall.
   - A workflow unit gets a task that shows whether the model follows the workflow unprompted.
   - Each expected answer states everything a correct answer must contain, so judges never need the original.
   - Skip any unit that looks doubtful or conflicts with the repo's agent instructions (AGENTS.md, CLAUDE.md or similar), and say why.
4. **Baseline.** The no-skill answerer answers the probes.
5. **Distill.** Judge each baseline answer against its expected answer as correct, partial, wrong or unaddressed, and flag any expected answer that looks doubtful. Then:
   - Drop units the rewrite had, units the model answered correctly, doubtful units, and units the repo's instructions already state or contradict.
   - Keep the rest, including gap units that got no probe: exact names, versions and house workflows.
   - Copy bundled scripts unchanged.
   - Write tersely: a Corrections section ("Not X. Use Y."), then the facts, then the steps.
   - Fix the description. It must say what the skill does and when to use it, in the words a user would type, within 1,024 characters. Authors often leave out the "when", list only API names, or run over the limit. Make it a little pushy, because skills tend to under-trigger.
6. **Verify.** A skill-loaded answerer answers the probes with the distilled skill. The verifier judges those answers against the expected answers and re-grades the distilled skill's overlap against the rewrite.
7. **Restore.** For each miss whose expected answer isn't doubtful, the verifier puts the fact back from the original. A skill-loaded answerer then re-asks only those probes, and a judge scores them. Repeat until nothing misses. Don't skip this step: one right answer with no skill over-drops facts (31 of 586 in the first audit, all fixed in one round).
8. **Consolidate.** Once every skill is distilled, one agent compares them all: what each description triggers on, and each fact.
   - A fact in two skills: keep it in the more specific or more authoritative one and delete it from the other. When the two disagree, ask the user which is right.
   - Merge skills that trigger on the same requests when one adds little on its own, such as a skill left with one or two facts, or house rules for one task split across two skills. Reconcile any rules that clash in the merge.
   - Keep skills separate when each holds unique facts and triggers on different requests. A separate skill loads only when its topic comes up; a merged one loads everything for any of its triggers. Don't merge only to cut the skill count.
   - A merged skill gets a description covering every trigger it absorbed, and keeps each source's provenance line and bundled scripts.
   - Re-ask the probes of every changed skill with it loaded (plus the skills that took its moved facts), judge them, and restore misses.
9. **Check the blinding.** Use each blind agent's transcript or tool log to confirm that it used only its allowed tools and paths. Rerun any agent that didn't.
10. **Ship.**
   - Move the originals to a backup folder the agent doesn't load (`.claude/skills-backup/` for Claude Code), with a README.
   - Put the distilled skills in place and update the skill list in the repo's agent instructions.
   - Save each skill's probes, expected answers and latest verdicts with the audit outputs, so a re-audit can reuse them.
   - End each SKILL.md with: `Source: <origin>. Distilled <date> for <model name>, keeping only what that model did not reproduce unaided; re-audit when the model changes. Audit: <link>`. Use the model's name, not an API ID.
   - Open a PR showing the probe scores (no skill vs distilled), the overlap change, the size change, the rewritten descriptions and any merges.

## Re-audit after a model change

Reuse the saved probes instead of starting over: per skill, a no-skill answerer on the new model answers every saved probe, and a judge scores the answers against the expected answers.

- A kept fact the new model now answers correctly: drop it, then verify and restore (steps 6 and 7).
- A dropped fact the new model now gets wrong: put it back from the backup, then verify.
- Leave a skill with neither untouched. Run the full audit only for new skills, or skills whose originals changed upstream.
- Update the provenance line's model name and date on every skill you re-checked, even an unchanged one.