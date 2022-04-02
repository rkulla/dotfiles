
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
# Colored prompt with user, host, abbreviated cwd, and truncated branch name
# %F{number} means foreground colors 0-255
# %2~ means truncate path to only the last 2 dirs
zstyle ':vcs_info:git:*' formats '%b'
autoload -U disambiguate  # copy this script from dotfiles repo into my $fpath
autoload -Uz vcs_info
function precmd {
    psvar=()
    vcs_info
    # only call disambiguate to abbrev dirs if $PWD is > 15 chars
    if [[ ${#${(D)PWD}} -gt 15 ]]; then disambiguate; else REPLY=${(D)PWD}; fi
    psvar[1]=( "$REPLY" )
    # If vcs_info populated $vcs_info_msg_0_ we'll truncate and access in %2v
    if [[ -n "$vcs_info_msg_0_" ]]; then
        # truncate branch name if it's > 36 chars
        branchName="$vcs_info_msg_0_"
        if [[ $#branchName -gt 36 ]]; then
            firstBN="${branchName[0,28]}"
            lastBN="${branchName[-5,-1]}"
            psvar[2]=( "$firstBN…$lastBN" )
        else
            psvar[2]=( "$branchName" )
        fi
        PS1="%F{100}%n%f@%F{100}%m %F{96}%1v %F{100}%2v %f$ "
    else
        PS1="%F{100}%n%f@%F{100}%m %F{96}%1v %f$ "
    fi
}

# 10ms for key sequences instead of 400ms (make ESC key fast in vim, etc)
KEYTIMEOUT=1

# Make comments work in the shell
set -k

# History
HISTSIZE=13000
SAVEHIST=12000
HISTFILE=~/.zsh_history
setopt incappendhistory # Immediately append history, not only when terminal is exited
setopt sharehistory # share between terminals
setopt histignorealldups
setopt histreduceblanks
setopt histignorespace # Don't store history for commands starting withe a space
# Make it so i can't accidentally "git stash clear", etc...
HISTORY_IGNORE="(git stash*|rm -rf*)"
function zshaddhistory {
  emulate -L zsh
  # make it so typing one new command will erase the HISTORY_IGNORE'd commands from the current session too
  [[ $1 != ${~HISTORY_IGNORE} ]]
}


# Make it so ^B deletes only 'baz' from /foo/bar-baz
bindkey '^B' vi-backward-kill-word

# ^W is bound to backward-kill-word which contains '/' in WORDCHARS
# I will maintain that behavior (allowing ^W to delete a whole URL)
# but will locally modify it in a function bound such that Ctrl-/
# will delete 'bar-baz' from /foo/bar-baz
# This is needed in zsh because it doesn't use gnu-readline which
# .inputrc leverages. I still use .inputrc for bash, python, etc.
function backward-kill-dir {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^_' backward-kill-dir

# syntax highlight commands (brew install zsh-syntax-highlighting)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Remind me to use the alias of a command (brew install zsh-you-should-use)
source /usr/local/share/zsh-you-should-use/you-should-use.plugin.zsh
# but exclude certain aliases where I still like to use the real form sometimes
export YSU_IGNORED_ALIASES=("g" "ll")

# Make it so typing `it <prof>` changes iterm2 profile in current
# tab. Name my Light profile `l` and Dark profile `d`. Usage:
#    $ it d  # dark mode. Go back to light mode: it l
function it {
  echo -e "\033]50;SetProfile=$1\a"
}

# Make it so up/down arrows search your history (even with nested filepaths/args)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Set PATH. Have local node modules first, then Homebrew paths
# E.g. so "brew install diffutils" can use gnu diff's --color), etc.
PATH="/usr/local/bin:$HOME/bin:$PATH"
# Have `ls` use gnu ls, not bsd ls. (First: brew install coreutils).
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# Make node packages path the very first (global packages are bad)
export PATH="./node_modules/.bin:$PATH"

# Create a `take` command
function take {
  mkdir -p $@ && cd ${@:$#}
}

# cd to a dir just by typing it's path, without cd being required
setopt autocd
# make it so typing - does cd -
alias - -='cd -'
# make it so 'dirs -v' will keep track of your cd'd dirs
setopt autopushd pushdignoredups
# Alias so i can just type `d` for the last 10 dirs then of ~# to cd to it
alias d='dirs -v | head -10'

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
fi
alias v='$EDITOR'
# Make it so 'vc' has a more VSCode looking experience. Pointless, but for demonstration purposes.
alias vc='$EDITOR -c "below term" -c "wincmd w" -c "res +11" -c "NERDTreeToggle" -c "wincmd w" -c "vert res +5"'
# alias vscode to `c`
alias c='code'

# Make it so mysql-monitor and psql will let you see output after you quit less
# Set up a separate alias for less if you want different options for less when calling it manually on the command line.
export PAGER=less
export LESS="-imFXSxR"

alias diff='diff --color' # brew install diffutils first
alias wd='pwd'
alias ls='ls --color -p'
alias la='ls --color -a'
alias ll='ls --color -lh'
alias lla='ls --color -lha'
alias lsab='fd -a -d 1' # # see absolute paths prepended to filenames!
alias lsl='ls --color -la | grep "^l"' # list symlinks in current dir
alias lslb='find . -maxdepth 1 -type l ! -exec test -e {} \; -print' # find only broken symlinks in pwd
alias lsh='ls --color -a | grep "^\."' # list only hidden files
alias ldirs='ls --color -aF | grep /' # list just directories
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cs='cd ~/repos/code-snippets/'
alias csj='cd ~/repos/code-snippets/JS'
alias csjs='cd ~/repos/code-snippets/JS/skeletons'
alias csjt='cd ~/repos/code-snippets/JS/tmp'
alias py='python'
# run the tree command with colorized output to piped programs and show / after dirs
alias tt='tree -CF'
# use `tj -d` to only show directoriees. `tj -P README*` show just dirs and README files
alias tj='tree -CF -a -I "node_modules|lcov-report|coverage|jsdoc|dist|vendor|.git"'
alias wt='watch -n 1 -d -t -c tree -CF' # watch tree.
alias wgt='watch -n 1 -d -t -c "git lolgraph --color && tree -CF"' # watch git log graph and tree at the same time.
# Use macvim for cli vim because it's better than standard vim on macs
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# Open modified staged and unstaged files (great for reopening where you left off)
alias vmod='vim $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only)'
alias cmod='code $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only)'
# Open modified files (even committed) that a branch changed (be in the branch first)
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
alias gpod='git pull origin develop'
alias g='git'
alias gb='git branch'
alias gba='git branch -a'
# Make my diff-so-fancy alias even shorter
alias dsf='git dsf'
alias gd='dsf' # brew install diff-so-fancy
alias gdc='git diff --cached --word-diff'
alias gst='git status'
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

# `vg` command that opens vim on glob/substr, e.g., `vg pack` opens
# package.json and package-lock.json, etc.  Sort's in reverse, using
# glob  qualifier (On), so package.json opens in buffer first.
function vg {
    vim *${1}*(On)
}

# Like my `vg` command but uses fd and works in subdirs. Even better.
function vfd {
    vim $(fd $1)
}

# List files in current branch that haven't been merged with specified branch yet
function notmerged {
    git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}"
}

# Open files with Vim in current branch that haven't been merged with specified branch
# $ vnotmerged main  # opens files in current branch not merged to main yet (great for PR reviews)
function vnotmerged {
    vim $(git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}")
}

# Open files with VSCode in current branch that haven't been merged with specified branch
# $ cnotmerged main  # opens files in current branch not merged to main yet (great for PR reviews)
function cnotmerged {
    code $(git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}")
}

# wraps cht.sh curl calls for faster lookup
function how { 
    curl cheat.sh/"$1"/"$2?Q" 
}

function howv { # verbose version
    curl cheat.sh/"$1"/"$2" 
}

# nnn (brew install nnn for a ncurses file explorer)
alias l='nnn -de'  # use instead of ls most of the time
# bookmarks
export NNN_BMS='b:~/Documents/books;D:~/Downloads;p:~/Pictures;r:~/repos;s:~/repos/code-snippets';

# Make it so using `n` will auto-change directory on quit. `l` won't.
export NNN_TMPFILE="/tmp/nnn"
function n()
{
    nnn -de

    if [ -f $NNN_TMPFILE ]; then
        . $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    fi
}

# autojump (brew install autojump)
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
# make completion work with autojump and the menu selection below
autoload -U compinit; compinit # load and initialize zsh's completion
# make it so pressing tab a second time lets you scroll down the menu when doing 'ls tab', etc
zstyle ':completion:*' menu select

zmodload zsh/complist
_comp_options+=(globdots)  # include hidden files
# Use vi keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit command in vim by typing ^o:
autoload edit-command-line; zle -N edit-command-line
bindkey '^o' edit-command-line

# cd to a subdir without typing full relative path
# My ^F command is better most of the time, since more visible/flexible.
function s {
    # If i wanted hidden dirs I'd do [1]D
    setopt localoptions extendedglob
    cd (^node_modules/)#$1/([1])
}

# Lets me cd to the real location of a symlink
# Examples: $ rcd ~/repos (if ~/.repos/ is a symlink)
#           # works on symlinked files, too:
#           $ rcd .vimrc (if .vimrc is in pwd)
#           $ rcd ~/.vimrc
function rcd {
    symlinkPath="$1"
    cd $(dirname $(realpath "$symlinkPath"))
}

# fzf (brew install fzf)
# Adding node_modules/ to ~/.ignore will make `fzf` ignore node_modules.
export FZF_DEFAULT_COMMAND='ag --nocolor -l -u -p ~/.ignore -g ""'
source /usr/local/opt/fzf/shell/completion.zsh
# Source keybindings like ^T will search ALL files (unlike my fzf command that uses ~/.ignore), ^R history, etc
source /usr/local/opt/fzf/shell/key-bindings.zsh
# make fzf-cd-widget work on MacOS when you type ^F (since alt+a default won't work)
bindkey "^F" fzf-cd-widget
# fcd - cd to selected directory. Showing only top-level subdirs
function fcd {
  local dir
  dir=$(fd --hidden --no-ignore --max-depth 1 --type d | fzf +m)
  cd "$dir"
}
# fshow - git commit browser
function fshow {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=never % | vim -') << 'FZF-EOF'
                {}
FZF-EOF"
}

# function that lets you type gtree to do a tree -CF command but doesn't show .gitignore'd files
function gtree {
    ignore_files=("$(git config --get core.excludesfile)" .gitignore ~/.gitignore)
    ignore="$(grep -hvE '^$|^#' "${ignore_files[@]}" 2>/dev/null|sed 's:/$::'|tr '\n' '\|')"
    if git status &> /dev/null && [[ -n "${ignore}" ]]; then
      tree -I "${ignore}" "${@}" -CF
    else
      tree "${@}" -CF
    fi
}

# function that lets you type `gshowdate <date> <filepath>' to git show a file by date
# date can be '10 days ago', '2020-05-25', 'yesterday', etc.
function gshowdate {
  date="$1"
  filepath="$2"
  git show $(git log -n1 --before "$date" | head -1 | cut -c8-):"$filepath"
}

# function to run json path on every line of a json file. Usage: $ jpath <file>.json
function jpath {
  jq -r 'paths(scalars) as $p  | [ ( [ $p[] | tostring ] | join(".") ), ( getpath($p) | tojson )] | join(": ")' "${@}"
}

# mysql
# Prompt config
case "$OSTYPE" in
  darwin*)
    # for non-readline/gnu mysql installations that use libedit
    alias my=$'/usr/local/bin/mysql --login-path=root --prompt="\\u@\\h \033[01;32m\\d\033[01;34m >\033[00m "'
    alias mysql=$'/usr/local/bin/mysql --prompt="\\u@\\h \033[01;32m\\d\033[01;34m >\033[00m "'
  ;;
  linux*)
    export MYSQL_PS1="\u@\h $fg[red]\d$reset_color> "
    alias my='mysql --login-path=root'
  ;;
esac

# Python
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Misc
# brew install asdf
. /usr/local/opt/asdf/libexec/asdf.sh

# AWS
# OPT out of SAM CLI collecting telemetry data
SAM_CLI_TELEMETRY=0

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/opt/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/opt/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
