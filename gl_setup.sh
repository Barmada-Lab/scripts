#!/bin/bash

set -e

TURBO=/nfs/turbo/umms-sbarmada
SCRATCH=/scratch/sbarmada_root/sbarmada0/$USER

if [ ! -e $HOME/turbo ]; then
    ln -s $TURBO $HOME/turbo
fi    

if [ ! -e $HOME/scratch ]; then
    ln -s $SCRATCH $HOME/scratch
fi    

if [ ! -e $HOME/Desktop/turbo ]; then
    ln -s $TURBO $HOME/Desktop/turbo
fi    

if [ ! -e $HOME/Desktop/scratch ]; then
    ln -s $SCRATCH $HOME/Desktop/scratch
fi    

if [ -d $HOME/.pyenv ]; then
    rm $HOME/.pyenv -rf
fi

git clone https://github.com/pyenv/pyenv $HOME/.pyenv

idem_patch_bashrc() {
    # idempotently modifies the user's bashrc with the passed string.
    PROFILE=$HOME/.bashrc
    if ! grep -Fxq "$1" $PROFILE; then
        echo "$1" >> $PROFILE
    fi
}

if [ ! -f $HOME/.bashrc ]; then
    touch $HOME/.bashrc
fi

idem_patch_bashrc 'export PATH=$PATH:$HOME/.local/bin:$HOME/bin'
idem_patch_bashrc 'export PATH=$HOME/.pyenv/shims:$PATH'
idem_patch_bashrc 'export PATH=$HOME/.pyenv/bin:$PATH'
idem_patch_bashrc 'eval "$(pyenv init -)"'
source ~/.bashrc

pyenv install 3.11
pyenv global 3.11
pip install pipx
pipx ensurepath
