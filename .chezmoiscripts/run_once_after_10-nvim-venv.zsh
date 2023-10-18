#!/bin/zsh

echo "Creating nvim venv"
python3 -mvenv $HOME/.nvim_venv

echo "Activating nvim venv"
. $HOME/.nvim_venv/bin/activate

echo "Installing nvim venv packages"
pip install pynvim
