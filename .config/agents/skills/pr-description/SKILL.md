---
name: pr-description
description: How to write a GitHub pull request description. Use whenever you create or update a PR body, including the draft PR that cross-review opens.
---

# pr-description

The reader is Max skimming a list of PRs. Only the summary and any risk flag are visible. Everything else goes in a collapsed block whose toggle line names the model that wrote it.

## Layout

    <1-2 sentences: what changes and why, in plain words. No "This PR".>

    > [!WARNING]
    > **High risk: <authentication | security | data schema>.** <what exactly changes, and what breaks if it's wrong>

    <details>
    <summary>PR written by <model> (<effort>) on behalf of @maxpetretta</summary>

    ### Evidence
    ### Change
    ### Risk
    ### Follow-ups

    </details>

- Leave a blank line after the `<summary>` line and before `</details>`, or the Markdown inside won't render. The summary line is plain text, because Markdown doesn't render inside `<summary>`.
- Include the effort only if you know it. Nothing goes after `</details>`.
- Leave out empty sections, and leave out the warning when no flag applies.

## Evidence

The most important section. It is proof, observed by you in this session, that the PR does what the summary says, shown as before and after.

- UI: one MP4 recording trimmed to the changed interaction (15 s or less), plus before and after screenshots of each changed state, one per distinct flow. Put before and after side by side in a two-column table.
- Behavior and logic: the exact test or command, failing before and passing after, as trimmed output in a `console` block. Add logs when that's where the effect shows.
- Architecture, dependencies, packages: a Mermaid diagram of only the affected part, with the change highlighted:

      ```mermaid
      flowchart LR
        App --> SyncClient --> Relay
        SyncClient --> Cache:::added
        classDef added stroke:#2da44e,stroke-width:3px
        classDef removed stroke:#cf222e,stroke-dasharray:4
      ```

- No evidence possible: start the section with `No direct evidence: <reason>` and repeat it in the visible warning. Never present mocked tests as proof of UI behavior.

### Media

Upload with `gh pr create|edit --attach`. Write each reference to the local file in the body, then pass the same path to `--attach`:

    ![Settings sheet, before](./pr-media/before-settings.png)

    ![](./pr-media/pairing.mp4)

gh uploads each file and rewrites the reference in place. A video reference must sit alone in its own paragraph to render as a player. Keep each file under 10 MB. Write media to a scratch dir outside the repo and never commit it.

- Capture: iOS Simulator `xcrun simctl io <udid> screenshot <file>` and `recordVideo --codec=h264 <file>`; macOS `screencapture -x` and `screencapture -v`; web pages with the browser tool's screenshot.
- Before shots: capture them before changing the code, or from a build of the merge base.
- Trim recordings to the changed interaction, 15 s or less:
  `ffmpeg -ss <start> -to <end> -i in.mov -an -vf scale=1280:-2 -c:v libx264 -crf 28 -preset veryfast -movflags +faststart out.mp4`
- When updating a body, references already rewritten to uploaded URLs stay as they are. Attach only new files.

## Risk flags

Add the visible warning when the change touches:

- authentication: sign-in, sessions, tokens, pairing
- security: permissions, secrets, crypto, sandboxing, input crossing a trust boundary
- data schemas: migrations, stored formats, wire protocols, anything persisted

Name the category, the file or area, and what fails if it's wrong. Flag nothing else.

## Change

The smallest view that makes the change clear: a diff-style sketch of a call tree, component tree, or file tree; pseudocode; or Mermaid (required for architecture and package changes). Not a file-by-file list, since the reviewer has the diff.

## Risk

One line: **Rollback:** two-way (revert) or one-way (why). **Blast radius:** who or what is affected.

## Keep it current

Rewrite the body whenever the change moves, after review fixes and before marking the PR ready, so the evidence matches the head commit. Declined review nits go in Follow-ups.
