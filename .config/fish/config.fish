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

# Unlock Keychain for SSH sessions (enables gh, claude, etc.)
if set -q SSH_CONNECTION
    security list-keychains -d user -s ~/Library/Keychains/login.keychain-db /Library/Keychains/System.keychain 2>/dev/null
    security default-keychain -d user -s ~/Library/Keychains/login.keychain-db 2>/dev/null
    security unlock-keychain ~/Library/Keychains/login.keychain-db
end

# Shell init
mise activate fish --shims | source
zoxide init fish --cmd cd | source

# Blastoff
if status is-interactive
    starship init fish | source
end
