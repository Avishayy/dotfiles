#!/bin/bash

echo "Changing shell to ZSH"
sudo -k chsh -s `which zsh` "$USER"

echo "Running ZSH"
zsh
