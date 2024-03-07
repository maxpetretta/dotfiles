# fish abbreviations
source ~/.config/fish/abbr.fish

# asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# 1Password authentication for gh command
source ~/.config/op/plugins.sh

# Blastoff
starship init fish | source

# pnpm
set -gx PNPM_HOME "/Users/max/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end