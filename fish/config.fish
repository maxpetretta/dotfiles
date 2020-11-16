# Update go path
set -Ux GOPATH $HOME/.go
eval (direnv hook fish)

# Set Terraform provider cache
set -Ux TF_PLUGIN_CACHE_DIR /Users/212569001/.terraform.d/providers

# Configure proxy
proxy

# Fish aliases
source ~/.config/fish/alias.fish

# asdf version manager
source /usr/local/opt/asdf/asdf.fish
# . ~/.asdf/plugins/java/set-java-home.fish

# Blastoff
starship init fish | source
