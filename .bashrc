
### git-prompt
__git_ps1() { :;}
if [ -e ~/.bash-git-prompt.sh ]; then
  source ~/.bash-git-prompt.sh
fi
PS1="$(tput setaf 3)\]\u\[$(tput setaf 2)\] \[$(tput setaf 4)\]\w\[$(tput setaf 5)\]$(__git_ps1)\[$(tput setaf 7)\] \$ \[$(tput sgr0)"


alias d='dirs -v | head -10'

alias v='$EDITOR'
# Make it so 'vc' has a more VSCode looking experience. Pointless, but for demonstration purposes.
alias vc='$EDITOR -c "below term" -c "wincmd w" -c "res +11" -c "NERDTreeToggle" -c "wincmd w" -c "vert res +5"'
# alias vscode to `c`
alias c='code'

# Make it so mysql-monitor and psql will let you see output after you quit less
# Set up a separate alias for less if you want different options for less when calling it manually on the command line.
export PAGER=less
export LESS="-imFXSxR"

alias diff='diff --color=auto' # brew install diffutils first
alias wd='pwd'
alias ls='ls -G -p'
alias la='ls -G -a'
alias ll='ls -G -lh'
alias lla='ls -G -lha'
alias lsab='fd -a -d 1' # # see absolute paths prepended to filenames!
alias lsl='ls -G -la | grep "^l"' # list symlinks in current dir
alias lslb='find . -maxdepth 1 -type l ! -exec test -e {} \; -print' # find only broken symlinks in pwd
alias lsh='ls -G -a | grep "^\."' # list only hidden files
alias ldirs='ls -G -aF | grep /' # list just directories
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias py='python'
# run the tree command with colorized output to piped programs and show / after dirs
alias tt='tree -CF'
alias tj='tree -CF -a -I "node_modules|lcov-report|coverage|jsdoc|dist|vendor|.git|Hurley-Make|Hurley-Registry|Hurley-Dashboard-Templates"'
alias wt='watch -n 1 -d -t -c tree -CF' # watch tree.
alias wgt='watch -n 1 -d -t -c "git lolgraph -G && tree -CF"' # watch git log graph and tree at the same time.
# Use macvim for cli vim because it's better than standard vim on macs
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# Open modified staged and unstaged files (great for reopening where you left off)
alias vmod='vim $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only)'
alias cmod='code $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only)'
# find out our external IP
alias externalip='dig +short myip.opendns.com @resolver1.opendns.com'
# find files that were modified today
alias today='find . -type f -daystart -mtime 0 2>/dev/null'
# # find files that were modified yesterday
alias yesterday='find -daystart -type f -mtime 1 2>/dev/null'
# find out which computers/routers/devices are active on our LAN:
alias whatsup='sudo nmap -sP 192.168.1.1/24 | perl -pe "s/^Host.*/\e[1;31m$&\e[0m/g"'
alias get='git pull&&git lol|head'
# open git remote repo in browser. Requires `brew install gh`
alias grem='gh repo view --web'
# open PR in browser
alias grempr='gh pr view --web'
# Make my diff-so-fancy alias even shorter
alias dsf='git dsf'
alias gpod='git pull origin develop'
alias g='git'
alias gb='git branch'
alias gba='git branch -a'
alias gd='dsf'
alias gdc='git diff --cached --word-diff'
alias gst='git status'
alias gsur='git submodule update --init --recursive'
alias pj='prettyjson'
# Node.js
alias nag='ag --js --ts --ignore-dir=node_modules'
# Docker
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcl='docker-compose logs'
alias dcp='docker-compose pull'
alias dcps='docker-compose ps'
alias dps='docker ps | less -S' # so we can see wide output not wrap
alias dpsa='docker ps -a | less -S' # so we can see wide output not wrap
# tmux
alias tms='tmux new -s '
alias tma='tmux attach -t '
alias tm='tmux'
alias tl='tmux ls'
# ag
alias ag='ag -s --path-to-ignore ~/.ignore'

