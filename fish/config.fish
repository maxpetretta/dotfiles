# Update go path
set -Ux GOPATH $HOME/.go

# Configure proxy
# proxy

# Fish aliases
source ~/.config/fish/alias.fish

# asdf version manager
# source (brew --prefix asdf)/asdf.fish
# . ~/.asdf/plugins/java/set-java-home.fish

# Python version manager
pyenv init - | source

# Blastoff
starship init fish | source
