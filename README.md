# dotfiles

This repo contains configuration files that match my current Mac setup. Packages are managed using [homebrew](https://brew.sh/), and the primary shell is [fish](https://fishshell.com/). bash is installed as well.

## Installation

Clone this repo to `~/dev/dotfiles` (Ghostty's startup command expects that path), install the packages, then link everything:

```
brew bundle --file=.config/homebrew/Brewfile
./install
```

## Updating

`./install` runs [dotbot](https://github.com/anishathalye/dotbot). It links each path in `install.conf.yaml` into place, then saves fresh snapshots of the Homebrew packages, Cursor settings and extensions, and Codex computer-use approvals back into this repo. Run it again after changing the setup, and commit the snapshot.
