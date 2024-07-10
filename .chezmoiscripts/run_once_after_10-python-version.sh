#!/bin/bash

set -eufo pipefail

# Not sure if I should really use this script, or let each machine do it,
# I did this because nvim uses 3.11 in my setup and this didn't sync with the others machines

VERSION="3.11"

pyenv install $VERSION
pyenv global $VERSION
