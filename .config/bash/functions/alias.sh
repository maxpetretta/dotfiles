# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls
alias ls='ls -a'
alias li='ls -lh' # Display files in directory as a list w/ human readable filesizes
alias la='ls -alh' # li + hidden files
alias lr='ls -lhR' # li recursively
alias lar='ls -lhaR' # All of the above

# git
alias gi='git init'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb="git checkout -b"
alias ga='git add .'
alias gd='git diff'
alias gc='git commit -m'
alias gp='git push'
alias gpo='git push origin'
alias gl='git pull'
alias glo='git pull origin'
alias gf='git fetch'
alias gg='git graph'

# custom
alias refresh='source ~/.bashrc'
alias virtualenv='python -m virtualenv venv'
alias venv='source ./venv/bin/activate'
alias brew_tree="brew leaves | xargs brew deps --installed --for-each | sed \"s/^.*:/$(tput setaf 6)&$(tput sgr0)/\""
alias ip="printf 'Private: ' && ipconfig getifaddr en0
printf 'Public: ' && curl -s ifconfig.me && printf '\n'"
