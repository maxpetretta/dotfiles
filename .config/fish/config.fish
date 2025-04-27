# fish scripts
source ~/.config/fish/abbr.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/secrets.fish

# 1Password authentication for gh command
source ~/.config/op/plugins.sh

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Blastoff
if status is-interactive
    mise activate fish | source
    starship init fish | source
else
    mise activate fish --shims | source
end
