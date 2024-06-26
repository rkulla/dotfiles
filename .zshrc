# Apple silicon uses this fpath, e.g., for my disambiguate script. Only append/prepend to fpath, zsh sets it
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Ensure apps' name (and more) shows in title bar, of e.g., Alacritty
function set_pro_title() {
    if [[ "$1" == "precmd" ]]; then
        COMMAND="${(j: :)DIRSTACK}"
    else
        COMMAND="$1"
    fi

    # Identify the terminal emulator
    # case "$TERM_PROGRAM" in
    case "${MY_TERM_PROGRAM:-$TERM_PROGRAM}" in
        iTerm.app)
            CURR_TERMINAL="iTerm2"
            ;;
        Alacritty)
            CURR_TERMINAL="Alacritty"
            ;;
        *)
            # Fallback or unknown terminal, you can adjust this
            CURR_TERMINAL="Terminal Unknown"
            ;;
    esac

    # Disambiguate $PWD if it is longer than 15 characters
    if [[ ${#${(D)PWD}} -gt 15 ]]; then 
        disambiguate
        DISPLAY_PWD="$REPLY"
    else 
        DISPLAY_PWD="${(D)PWD}"
    fi

    # Add command to title if non-empty
    if [[ -n "$COMMAND" ]]; then
        CMD_STRING="(${COMMAND})"
    else
        CMD_STRING=""
    fi

    PRO_TITLE="\e]0;${CURR_TERMINAL} ${CMD_STRING} ${DISPLAY_PWD}\a"

    echo -ne "$PRO_TITLE"
}

function preexec() {
    set_pro_title "$1"
}


# Colored prompt with user, host, abbreviated cwd, and truncated branch name
# %F{number} means foreground colors 0-255
# %2~ means truncate path to only the last 2 dirs
zstyle ':vcs_info:git:*' formats '%b'
autoload -U disambiguate  # copy dotfiles/zsh-site-functions/disambiguate script to `echo $fpath`
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
        # %(1j.[%j].) prints [n] if there are 1+ bg jobs, else prints nothing
        PS1="%(1j.[%j].)%K{214}%F{100}%n%f%F{96}@%f%F{100}%m %F{0}%1v %F{100}%2v %f%k%F{96}$%f "
    else
        PS1="%K{214}%F{100}%n%f%F{96}@%f%F{100}%m %F{0}%1v %F{100}%2v %f%k%F{96}$%f "
    fi

    set_pro_title "precmd"
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
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Remind me to use the alias of a command (brew install zsh-you-should-use)
source $(brew --prefix)/share/zsh-you-should-use/you-should-use.plugin.zsh
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

# cd to the local iCloud Drive folder easily (Dropbox replacement)
alias icd='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs'

alias j='zi'

# alias to fd "all" files (case-insensitive/hidden)
alias fda='fd -iH'

# Useful after `fd -H foo` to open files in nvim: `fd foo | x
# Think of `x` as `xargs nvim` (and only opens if its a file not dir)
# use fdh for `fd -H` (hidden files too).
function x() {
    files=()
    while IFS= read -r line; do
        if [ -f "$line" ]; then
            files+=("$line")
        fi
    done
    ~/opt/nvim-macos/bin/nvim "${files[@]}"
}

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
fi
alias vim='$EDITOR'
alias v='~/opt/nvim-macos/bin/nvim'
alias n='~/opt/nvim-macos/bin/nvim'
alias nv='~/opt/nvim-macos/bin/nvim'
alias cn='~/.config/nvim'
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
alias fd='fd --color=never' # colors look terrible in fd, and aren't needed
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
# use `tj -d` to only show directoriees. `tj -P README*` show just dirs and README files. -P '*.ts' just dirs+typescript
alias tj='tree -CF -a -I "node_modules|lcov-report|coverage|jsdoc|dist|vendor|.git"'
alias wt='watch -n 1 -d -t -c tree -CF' # watch tree.
alias wgt='watch -n 1 -d -t -c "git lolgraph --color && tree -CF"' # watch git log graph and tree at the same time.
# Use macvim for cli vim because it's better than standard vim on macs
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# Open modified staged and unstaged files (great for reopening where you left off)
alias vmod='n $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only --ignore-submodules)'
alias nmod=vmod
alias cmod='code $(git diff --diff-filter=d --cached --name-only && git diff --diff-filter=d --name-only --ignore-submodules)'
# See my vcom and ccom functions for if I already committed
# Open modified files (even committed) that a branch changed (be in the branch first)
# find out our external IP
alias externalip='dig +short myip.opendns.com @resolver1.opendns.com'
# find files that were modified today
alias today='find . -type f -daystart -mtime 0 2>/dev/null'
# # find files that were modified yesterday
alias yesterday='find -daystart -type f -mtime 1 2>/dev/null'
# find out which computers/routers/devices are active on our LAN:
alias whatsup='sudo nmap -sP 192.168.1.1/24 | perl -pe "s/^Host.*/\e[1;31m$&\e[0m/g"'
alias lg='lazygit'
# `get` gets changes, quieting the parts I don't care about and shows the new git log 
alias get='echo "$(tput smul)WAS$(tput rmul)" && git lol | head -n 1 && echo "\n$(tput setaf 4)UPDATING...$(tput sgr0)" && git fetch -q && git rebase && echo "\n$(tput smul)NOW$(tput rmul)" && git lol | head -n 2'
# open git remote repo in browser. Requires `brew install gh`
alias grem='gh repo view --web'
# open PR in browser
alias grempr='gh pr view --web'
alias gp='git push'
alias g='git'
alias gad='git add .'
alias ga.='git add .'
# So i can just type `gcm "foo"` instead of `git ci -m "foo"`
gcm() {
  if [ -z "$1" ]; then
    echo "Please provide a commit message"
    return 1
  fi
  git commit -m "$1"
}
alias gc-='git co -'
alias gb='git branch'
alias gba='git branch -a'
# Make my diff-so-fancy alias even shorter
alias dsf='git dsf'
alias gd='dsf' # brew install diff-so-fancy
alias gdc='gd --cached'
alias gst='git status'
alias gsur='git submodule update --init --recursive' # gsur [--remote] when needed
alias pj='prettyjson'
# ag
alias ag='ag -s --path-to-ignore ~/.ignore'
# Node.js
alias nag='ag --js --ts --ignore-dir=node_modules\* --ignore=\*-min.js'
# Golang
alias gag='ag --go --ignore-dir=vendor'
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

# `agr` command that only shows the root-level directories a search pattern is in (case-insensitive)
# Useful for things like just seeing what repo's contain a string
function agr {
    ag -i "$1" -l --ignore-dir=node_modules\* --ignore-dir=vendor\* | cut -d/ -f1 | sort | uniq
}

# `vg` command that opens vim on glob/substr, e.g., `vg pack` opens
# package.json and package-lock.json, etc.  Sort's in reverse, using
# glob  qualifier (On), so package.json opens in buffer first.
function vg {
    v *${1}*(On)
}

# Like my `vg` command but uses fd and works in subdirs. Even better.
function vfd {
    v $(fd $1)
}

# List files in current branch that haven't been merged with specified branch yet
function notmerged {
    git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}"
}

# Open files with Vim in current branch that haven't been merged with specified branch
# $ vnotmerged main  # opens files in current branch not merged to main yet (great for PR reviews)
function vnotmerged {
    v $(git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}")
}

# neovim alias of vnotmerged
function nnotmerged {
    n $(git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}")
}

# Open files with VSCode in current branch that haven't been merged with specified branch
# $ cnotmerged main  # opens files in current branch not merged to main yet (great for PR reviews)
function cnotmerged {
    code $(git diff "$1"...$(git branch --show-current) --name-status | awk "/^M|^A.*/ {print \$2}")
}

# List files that were last committed. Optionally takes a commit
function lcom {
    if [[ -z "$1" ]]; then
        git show --pretty="format:" --name-only
    else
        git show --pretty="format:" --name-only "$1"
    fi
}

# Open files in Vim in current branch even if they've already been committed or merged
# $ vcom main # opens files in current branch already merged to main (great for WIP PR additions)
function vcom {
    v $(git log --name-only "$1".. --oneline | sed 1d)
}

# neovim alias of vcom
# alias lastcom='n $(git diff --name-only HEAD^ --ignore-submodules | xargs)'
function ncom {
    n $(git log --name-only "$1".. --oneline | sed 1d)
}

# Open files in VSCode in current branch that have already been committed
# $ ccom main # opens files in current branch already merged to main (great for WIP PR additions)
function ccom {
    code $(git log --name-only "$1".. --oneline | sed 1d)
}

# Find the commit/date a file was first added to git (`gsf` in neovim)
function gfadded {
    git log -n 1 --follow --diff-filter=A -- "$1"
}

# Find all the commits of a file, printed concisely (`gsa` in neovim)
function gfallcom {
    git log --pretty=reference -- "$1"
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

# Make it so using `nn` will auto-change directory on quit. `l` won't.
export NNN_TMPFILE="/tmp/nnn"
function nn()
{
    nnn -de

    if [ -f $NNN_TMPFILE ]; then
        . $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    fi
}

function fc() {
    if [ "$#" -eq 0 ]; then
        echo "fc without arguments is disabled. cd'ing to my neovim config instead."
        cd ~/.config/nvim  # see also my cn alias
    else
        builtin fc "$@"
    fi
}

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
source $(brew --prefix)/opt/fzf/shell/completion.zsh
# Source keybindings like ^T will search ALL files (unlike my fzf command that uses ~/.ignore), ^R history, etc
source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
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
      --format="%C(auto)%h%d %s [%an] %C(black)%C(bold)%cr" "$@" |
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

# Use gnu update from `brew install findutils`as my 'locate' database
# https://egeek.me/2020/04/18/enabling-locate-on-osx/
if which glocate > /dev/null; then
  alias locate="glocate -d $HOME/locatedb"

  # Using cache_list for telescope-repo.nvim requires LOCATE_PATH env var to exist
  [[ -f "$HOME/locatedb" ]] && export LOCATE_PATH="$HOME/locatedb"
fi
# Keeping locatedb small (by only loading my $HOME/repos path and ignoring node_modules, makes it load MUCH faster.
# I use `mfind` on the cli to use spotlights more extensive database
alias loaddb="gupdatedb --localpaths=$HOME/repos --prunepaths='.*node_modules.*' --output=$HOME/locatedb"
# Also run this every 5m from a cronjob. Note: On Apple Silicon based machines, use /opt/homebrew/bin/gupdatedb instead
# 0/5 * * * * /usr/local/bin/gupdatedb --localpaths=$HOME/repos --prunepaths=".*node_modules.*" --output="$HOME/locatedb" > "$HOME/cron-output-loaddb.log" 2>&1


# Python
### activate appropriate python version: shell > local > global
eval "$(pyenv init -)"
### activate virtualenv. Does nothing if not installed. Install with: brew install pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Misc
# brew install asdf
. $(brew --prefix)/opt/asdf/libexec/asdf.sh

# AWS
# OPT out of SAM CLI collecting telemetry data
SAM_CLI_TELEMETRY=0

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/opt/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/opt/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"; fi

# I use fnm instead of nvm now, since it's faster and works the same.
eval "$(fnm env --use-on-cd)"

# Load Zoxide after compinit (brew install zoxide). It's like autojump, but better
eval "$(zoxide init zsh)"
