---
description: Survey for answers across both Claude and Codex
argument-hint: <question to survey>
---

# Multi-Model Survey: $ARGUMENTS

## Execution

Run **five model calls in parallel**:

| Call | Method |
|------|--------|
| A | Task tool: haiku |
| B | Task tool: sonnet |
| C | Task tool: opus |
| D | Bash: `codex exec -m gpt-5.2 "$QUESTION"` |
| E | Bash: `codex exec -m gpt-5.2-codex "$QUESTION"` |

**Prompt template** (for all models):
> Answer this question. RESEARCH ONLY—do not implement anything or modify files. You may read and explore the codebase.
>
> Question: $ARGUMENTS

**Shell escaping**: For Codex calls, properly escape the question for bash.

**Failure handling**: If a Codex call fails (timeout, API error), note it in synthesis and proceed with available results.

## Synthesis

After all calls complete, fill in this table:

| Call | Model | Key Points | Unique Insights |
|------|-------|------------|-----------------|
| A | haiku | | |
| B | sonnet | | |
| C | opus | | |
| D | gpt-5.2 | | |
| E | gpt-5.2-codex | | |

Then summarize:
1. **Consensus**: Points of agreement across models
2. **Disagreements**: Where models diverged and why
3. **Model differences**: Notable variations between Claude and Codex?
4. **Final answer**: Best synthesis across all responses
