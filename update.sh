#!/bin/bash
rm -rf ./.config

cp ~/.bashrc .
cp ~/.gitconfig .
cp ~/.tmux.conf .
cp -a ~/.config .

rm ./Brewfile
brew bundle dump --all

code --list-extensions > ./.vscode_extensions
cp ~/Library/Application\ Support/Code/User/settings.json .
