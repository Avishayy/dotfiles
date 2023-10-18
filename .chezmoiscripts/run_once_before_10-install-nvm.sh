#!/bin/bash

set -eufo pipefail

echo "Installing nvm (node version manager)"

PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
