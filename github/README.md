# Claude on GitHub

Every repository gets one workflow, which `scripts/claude-review-setup` installs:

- `claude.yml` is the `@claude` assistant: it answers questions and pushes commits.

Pull request review (`claude-review.yml`) is paused. Its template stays in this folder, the script no longer installs it, and the copies it had installed were removed. To bring it back, add `claude-review.yml` and its subject to `names` and `subjects` in the script and run it again.

## Setup

1. Install the [Claude GitHub App](https://github.com/apps/claude/installations/select_target) on all repositories.
2. Make a token with `claude setup-token`.
3. Run `scripts/claude-review-setup` to see the plan, then run `scripts/claude-review-setup --apply`. It asks for the token, or reads `$CLAUDE_CODE_OAUTH_TOKEN`.

For each non-archived, non-fork repository, the script commits the workflow to the default branch and sets the `CLAUDE_CODE_OAUTH_TOKEN` secret. A workflow file the script didn't write is skipped, and a repository with no file of the script's own keeps its secret. Orchard is one of these: it keeps its own workflow.

To limit a run, name repositories: `scripts/claude-review-setup --apply maxpetretta/dotfiles`.

## When to run it again

- after creating a repository;
- after editing a template, which updates every copy the script made. `--apply --keep-secret` skips the token;
- yearly, to refresh the token.

## Review

Paused. This is what the review workflow does when it is installed.

- Claude reviews each pull request that isn't a draft or from a fork, once. Forks get no secrets, so a fork's pull request needs the comment below.
- A comment containing `@claude review` from you or a collaborator asks for another review.
- Findings are inline comments.
- With no findings, Claude posts a `## Code review` comment saying no issues were found.
- It follows each repository's `CLAUDE.md` and `AGENTS.md`.

The prompt is adapted from the code-review command in [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official), under the Apache License 2.0 (`LICENSE-code-review`).

## Assistant

- Any other `@claude` mention from you or a collaborator starts Claude Code: in a pull request or issue comment, a review or review comment, or an issue's title or body when it's opened or assigned.
- It replies in a comment and can push commits to the pull request's branch, or to a new branch for an issue.
- `@claude review` on a pull request goes to the review workflow instead, so while review is paused that comment does nothing.

The workflows run on your Claude subscription, so they count toward its usage.
