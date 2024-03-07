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

# custom
abbr -a vim nvim
abbr -a code cursor
abbr -a prd pnpm run dev 
abbr -a cf cloudflared tunnel run
abbr -a refresh source ~/.config/fish/config.fish
