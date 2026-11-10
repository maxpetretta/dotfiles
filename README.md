# dotfiles

This repo contains configuration files that match my current Mac setup. Packages are managed using [homebrew](https://brew.sh/), the terminal is Rex, and the primary shell is [fish](https://fishshell.com/). bash is installed as well.

## Installation

Clone this repo to `~/dev/dotfiles` (Rex's home LaunchAgent expects that path), install [Homebrew](https://brew.sh/), then run:

```
./install
```

`./install` runs [dotbot](https://github.com/anishathalye/dotbot). It links each path in `install.conf.yaml` into place, sets up the git filters that keep app-written state out of commits, installs any missing Homebrew packages from `.config/homebrew/Brewfile`, and installs the LaunchAgents in `.config/launchd` that aren't there yet. It's safe to run again. The ac-nosleep agent, which keeps the Mac awake on AC power so local services keep running with the lid closed, runs a Swift helper built from `.config/launchd/ac-nosleep-helper.swift`. `./install` builds it into `~/.local/bin` when it's missing; after changing the source, run `scripts/build-ac-nosleep-helper`, then `launchctl kickstart -k gui/$(id -u)/com.max.ac-nosleep`. Memo's own installer manages its LaunchAgents. The Cursor worker agent registers each git checkout directly under `~/dev`. It needs `cursor-agent login` once before it stays up. The first start installs Cursor Computer Use; grant it Accessibility and Screen Recording in System Settings → Privacy & Security (Cursor Computer Use, not Terminal). The display-blackout agent dims the Studio Display to black after 10 idle minutes and restores it on the next input, so the Mac never locks and computer use keeps running; it needs BetterDisplay running, so turn on BetterDisplay's Launch at login. Change `BLACKOUT_IDLE_SECONDS` in its plist to change the delay.

## Updating

`./snapshot` saves the Homebrew package list, Cursor settings and extensions, and Codex computer-use approvals back into this repo. Run it after changing the setup, and commit the result.
