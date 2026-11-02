# Claude pull request review

`claude-review.yml` is the review workflow every repository gets. `scripts/claude-review-setup` installs it.

## Setup

1. Install the [Claude GitHub App](https://github.com/apps/claude/installations/select_target) on all repositories.
2. Make a token with `claude setup-token`.
3. Run `scripts/claude-review-setup` to see the plan, then run `scripts/claude-review-setup --apply`. It asks for the token, or reads `$CLAUDE_CODE_OAUTH_TOKEN`.

For each non-archived, non-fork repository, the script commits the workflow to the default branch and sets the `CLAUDE_CODE_OAUTH_TOKEN` secret. A repository whose `claude-review.yml` the script didn't write is skipped. Orchard is one of these: it keeps its own workflow and `pr-review` skill.

To limit a run, name repositories: `scripts/claude-review-setup --apply maxpetretta/dotfiles`.

## When to run it again

- after creating a repository;
- after editing the template, which updates every copy the script made;
- yearly, to refresh the token.

## What it does on a pull request

- Claude reviews each pull request that isn't a draft, once.
- A comment containing `@claude review` from you or a collaborator asks for another review.
- Findings are inline comments.
- With no findings, Claude posts a `## Code review` comment saying no issues were found.
- It follows each repository's `CLAUDE.md` and `AGENTS.md`.
- Reviews run on your Claude subscription, so they count toward its usage.

The prompt is adapted from the code-review command in [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official), under the Apache License 2.0 (`LICENSE-code-review`).
