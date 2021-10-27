# This file is for login shells, e.g., for GUI MacVim to set PATH
# to Vim so Vim plugins can work, etc.
# This file is ran BEFORE .zshrc.

# Vim stuff
PATH="/Applications/MacVim.app/Contents/bin:$PATH"

# Node stuff
# So globally installed `prettier` can work in MacVim, etc.
PATH="$HOME/.nvm/versions/node/v14.15.4/bin:$PATH"

# Python
PATH="$HOME/.pyenv/shims:$PATH"

# Golang stuff
PATH=/usr/local/go/bin/go:$PATH

export PATH
