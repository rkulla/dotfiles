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
# Main/default go version I have installed
PATH=/usr/local/go/bin/go:$PATH
PATH="$HOME/go/bin:$PATH"
# Switch `go version` to point to whatever newer Go version I `go install/go download`. Ex:
#   $ go install golang.org/dl/go1.24.4@latest
#   $ go1.24.4 download
#   $ ls ~/sdk # should now show go1.24.4
#   $ source ~/.zprofile
#   $ go version # should now show go 1.23.4
# Allows multiple installs. Commenting out this block will use my default go version:
GOROOT=~/sdk/go1.24.4
PATH=$GOROOT/bin:$PATH

# Rust stuff
PATH="$HOME/.cargo/bin:$PATH"

# Homebrew on M1 (apple silicon) has a different location (comment this out on x86)
if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    path+=(/opt/homebrew/bin)
fi

export PATH
