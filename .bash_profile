# Set PATH. Have local node modules first, then Homebrew paths
# E.g. so "brew install diffutils" can use gnu diff's --color), etc.
PATH="/usr/local/bin:$HOME/bin:$PATH"
# Have `ls` use gnu ls, not bsd ls. (First: brew install coreutils).
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# Have `find` use gnu find, not bsd find. (First: brew install findutils).
PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
# Make node packages path the very first (global packages are bad)
export PATH="./node_modules/.bin:$PATH"

source ~/.bashrc

