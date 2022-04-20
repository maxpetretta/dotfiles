#!/bin/bash
which -s brew
if [[ $? != 0 ]] ; then
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

cp ./bash/.bashrc ~
cp -a ./bash/functions/. ~/.config/bash/functions
cp ./ge-proxy/proxy.sh ~/.config/bash/functions

cp -a ./fish/. ~/.config/fish
cp ./ge-proxy/proxy.fish ~/.config/fish/functions

cp ./starship.toml ~/.config

cp ./.gitconfig ~
