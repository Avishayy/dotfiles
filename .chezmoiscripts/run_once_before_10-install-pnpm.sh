#!/bin/bash

set -eufo pipefail

echo "Installing pnpm"

# TODO: the setup is intrusive and modifies .zshrc....
# no flag to --skip-zshrc yet https://github.com/pnpm/pnpm/issues/6182
curl -fsSL https://get.pnpm.io/install.sh | sh -
