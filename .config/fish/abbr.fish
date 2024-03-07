# cd
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a .... cd ../../..
abbr -a ..... cd ../../../..
abbr -a ...... cd ../../../../..

# ls
abbr -a ls exa --all --classify
abbr -a ll exa --all --classify --long --header --git --icons --no-user
abbr -a lt exa --all --classify --tree --git-ignore --ignore-glob ".git" --level=2

# git
abbr -a gi git init
abbr -a gs git status
abbr -a gg git graph
abbr -a glo git pull origin

# custom
abbr -a refresh source ~/.config/fish/config.fish
abbr -a prd pnpm run dev 
abbr -a cf cloudflared tunnel run
