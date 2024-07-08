# fish scripts
source ~/.config/fish/abbr.fish
source ~/.config/fish/functions.fish

# 1Password authentication for gh command
source ~/.config/op/plugins.sh

# Blastoff
if status is-interactive
    mise activate fish | source
    starship init fish | source
else
    mise activate fish --shims | source
end
