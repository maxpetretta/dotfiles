#!/bin/bash
cp ./bash/.bashrc ~
cp -a ./bash/functions/. ~/.config/bash/functions
cp ./ge-proxy/proxy.sh ~/.config/bash/functions

cp -a ./fish/. ~/.config/fish
cp ./ge-proxy/proxy.fish ~/.config/fish/functions

cp ./starship.toml ~/.config

cp ./.gitconfig ~
