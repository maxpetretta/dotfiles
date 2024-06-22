#!/bin/bash
rm -rf ./.config
rm -rf ./cursor

cp ~/.bashrc .
cp ~/.gitconfig .
cp ~/.tmux.conf .
cp -a ~/.config .

rm ./Brewfile
brew bundle dump --all

mkdir ./cursor
cursor --list-extensions >./cursor/.extensions
cp ~/Library/Application\ Support/Cursor/User/settings.json ./cursor/settings.json
