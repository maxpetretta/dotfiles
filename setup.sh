#!/bin/bash
which -s brew
if [[ $? != 0 ]] ; then
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

cp ./.bashrc ~
cp ./.gitconfig ~
cp -a ./.config ~/.
