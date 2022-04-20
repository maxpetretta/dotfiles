# dotfiles
This repo contains configuration files that match my current Mac setup.  Packages are managed using [homebrew](https://brew.sh/), and the primary shell is [fish](https://fishshell.com/).  bash is installed as well.

## Installation
To install all packages, simply run the following command:
```
. setup.sh
```

## Updating Packages
To save a snapshot of the current machine, run the following command:
```
. update.sh
```

## Proxy Script
A custom network proxy script is installed as a submodule, and will only be configured if connected to the business network.  Otherwise, it can be ignored.
