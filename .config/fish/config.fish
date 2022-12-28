# Fish aliases
source ~/.config/fish/alias.fish

# Python version manager
pyenv init - | source

# Ruby version manager
status --is-interactive; and rbenv init - fish | source

# 1Password authentication for gh command
source $HOME/.config/op/plugins.sh

# Blastoff
starship init fish | source
