#!/bin/bash
rm -rf ./.config

cp ~/.bashrc .
cp ~/.gitconfig .
cp -a ~/.config .

rm ./Brewfile
brew bundle dump

code --list-extensions > ./.vscode_extensions
cp /Users/Max/Library/Application\ Support/Code/User/settings.json .
