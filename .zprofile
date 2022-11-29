#### END FIG ENV VARIABLES ####
# This file is for login shells, e.g., for GUI MacVim to set PATH
# to Vim so Vim plugins can work, etc.
# This file is ran BEFORE .zshrc.

# Set PATH. Have local node modules first, then Homebrew paths
# E.g. so "brew install diffutils" can use gnu diff's --color), etc.
PATH="/usr/local/bin:$HOME/bin:$PATH"
# Have `ls` use gnu ls, not bsd ls. (First: brew install coreutils).
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# Make node packages path the very first (global packages are bad)
export PATH="./node_modules/.bin:$PATH"


# Vim stuff
PATH="/Applications/MacVim.app/Contents/bin:$PATH"

# Node stuff
# So globally installed `prettier` can work in MacVim, etc.
PATH="$HOME/.nvm/versions/node/v14.15.4/bin:$PATH"

# Python stuff
PATH="$HOME/.pyenv/shims:$PATH"

# Golang stuff
PATH=/usr/local/go/bin/go:$PATH
PATH="$HOME/go/bin:$PATH"

# Rust stuff
PATH="$HOME/.cargo/bin:$PATH"


export PATH
