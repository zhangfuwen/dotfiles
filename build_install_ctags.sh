#!/bin/bash

OLD_PWD=`pwd`

mkdir -p ~/mybuilds
cd ~/mybuilds

git clone https://github.com/universal-ctags/ctags
cd ctags

./autogen.sh
if [[ $? == 1 ]]; then
    echo "autoreconf is not present, try installing"
    sudo apt install autoconf pkg-config
    ./autogen.sh
fi

./configure
make
sudo make install

