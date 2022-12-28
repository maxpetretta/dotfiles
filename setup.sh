#!/usr/bin/env bash
which -s brew
if [[ $? != 0 ]] ; then
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

cp ./.bashrc ~
cp ./.gitconfig ~
cp ./.tmux.conf ~
cp -a ./.config ~/.
