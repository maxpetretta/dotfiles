# dotfiles

This repo contains configuration files that match my current Mac setup. Packages are managed using [homebrew](https://brew.sh/), the terminal is Rex, and the primary shell is [fish](https://fishshell.com/). bash is installed as well.

## Installation

Clone this repo to `~/dev/dotfiles` (Rex's home LaunchAgent expects that path), install [Homebrew](https://brew.sh/), then run:

```
./install
```

`./install` runs [dotbot](https://github.com/anishathalye/dotbot). It links each path in `install.conf.yaml` into place, sets up the git filters that keep app-written state out of commits, installs any missing Homebrew packages from `.config/homebrew/Brewfile`, and installs the LaunchAgents in `.config/launchd` that aren't there yet. It's safe to run again. Memo's own installer manages its LaunchAgents. The Cursor worker agent needs `cursor-agent login` once before it stays up.

## Updating

`./snapshot` saves the Homebrew package list, Cursor settings and extensions, and Codex computer-use approvals back into this repo. Run it after changing the setup, and commit the result.
