#!/bin/bash
cp ~/.bash_profile ./bash
cp -a ~/.config/bash/functions/. ./bash/functions
rm ./bash/functions/proxy.sh

cp ~/.config/fish/config.fish ./fish
cp ~/.config/fish/alias.fish ./fish
cp ~/.config/fish/colors.fish ./fish
cp -a ~/.config/fish/functions/. ./fish/functions
cp -a ~/.config/fish/completions ./fish/completions
rm ./fish/functions/proxy.fish

cp ~/.config/starship.toml .

cp ~/.gitconfig .

rm ./packages/Brewfile
brew bundle dump
mv Brewfile ./packages

code --list-extensions > ./packages/.vscode_extensions
