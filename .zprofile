
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
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
PATH="$HOME/go/bin:$PATH"

export PATH

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
