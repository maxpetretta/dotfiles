# cd
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a .... cd ../../..
abbr -a ..... cd ../../../..
abbr -a ...... cd ../../../../..

# ls
abbr -a ls eza --all --classify
abbr -a ll eza --all --classify --long --header --git --icons --no-user
abbr -a lt eza --all --classify --tree --git-ignore --ignore-glob ".git" --level=2

# git
abbr -a gi git init
abbr -a gs git status
abbr -a gg git graph
abbr -a glo git pull origin
abbr -a lg lazygit

# tmux
abbr -a ta tmux attach-session
abbr -a tas tmux attach-session -t
abbr -a td tmux detach
abbr -a ts tmux list-sessions
abbr -a tns tmux new-session -s
abbr -a tks tmux kill-session -t

# custom
abbr -a vim nvim
abbr -a code cursor
abbr -a cf cloudflared tunnel run
abbr -a refresh source ~/.config/fish/config.fish
abbr -a brewdeps 'brew leaves | xargs brew deps --formula --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'
