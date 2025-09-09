#!/bin/bash

set -euo pipefail

# Install Claude Code globally via npm
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "Claude Code installed successfully"
else
    echo "Claude Code is already installed"
fi
