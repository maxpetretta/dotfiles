# fish scripts
source ~/.config/fish/abbr.fish
source ~/.config/fish/functions.fish

# asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# 1Password authentication for gh command
source ~/.config/op/plugins.sh

# Blastoff
starship init fish | source
