#!/bin/bash

set -eufo pipefail

echo "Installing i3status-rust"

DIR=/tmp/i3status-rust
[ -e $DIR ] && rm -rf $DIR
git clone https://github.com/greshake/i3status-rust /tmp/i3status-rust
cd /tmp/i3status-rust
cargo install --path . --locked
./install.sh
