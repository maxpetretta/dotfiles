# fish scripts
for file in ~/.config/fish/abbr.fish ~/.config/fish/functions.fish ~/.config/fish/secrets.fish
    if test -f $file
        source $file
    end
end

# 1Password authentication for gh command
if test -f ~/.config/op/plugins.sh
    source ~/.config/op/plugins.sh
end

# OrbStack CLI shims
if test -d ~/.orbstack/bin
    if not contains -- ~/.orbstack/bin $PATH
        set -gx PATH ~/.orbstack/bin $PATH
    end
end

# Non-interactive, predictable Homebrew for agents
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

# Shell init
mise activate fish --shims | source
zoxide init fish --cmd cd | source
direnv hook fish | source

# Blastoff
if status is-interactive
    starship init fish | source
end
