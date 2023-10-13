#!/bin/bash

echo "Changing shell to ZSH"
sudo -k chsh -s `which zsh` "$USER"

echo "Your default shell is now ZSH, please restart!"

