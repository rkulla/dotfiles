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

# Function we can bind to do delete to the previous forward slash (/)
# will delete 'bar-baz' from /foo/bar-baz
# This is needed in zsh because it doesn't use gnu-readline which
# .inputrc leverages. I still use .inputrc for bash, python, etc.
function backward-kill-dir {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir

# Function we can bind to to jump cursor back to the previous forward slash (/)
function backward-jump-dir {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-word
}
zle -N backward-jump-dir

function forward-jump-dir {
    local WORDCHARS=${WORDCHARS/\/}
    zle forward-word
}
zle -N forward-jump-dir

function backward-kill-line {
    zle kill-region -n $CURSOR
}
zle -N backward-kill-line

# Note: run `cat` and type key shortcuts to see which characters it outputs to use
# Also note that these will vary from terminal to terminal, made for Alacritty NOT iterm2
bindkey '^W' vi-backward-kill-word # So ^W deletes words like vi: 'baz' in /foo/bar-baz
bindkey '^X' backward-kill-word  # So ^X deletes to previous space, great for deleting a url
bindkey "^[[1;3D" backward-jump-dir # So Option+< jumps to the previous / or word
bindkey "^[[1;3C" forward-jump-dir # So Option+> jumps to the next / or word
bindkey "^[[1;4D" backward-kill-dir # So Shift+Option+<  deletes to previous / or word
bindkey '^U' backward-kill-line  # So ^U only deletes backwards to start of line from cursor pos

# syntax highlight commands (brew install zsh-syntax-highlighting)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Override default command / alias / path colors as I'm typing them
ZSH_HIGHLIGHT_STYLES[command]=fg='#218c09,bold'  # External commands in PATH
ZSH_HIGHLIGHT_STYLES[alias]=fg='#1f3fe0'
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold

ZSH_HIGHLIGHT_STYLES[path]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=fg='#b41fe0'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=fg='#b41fe0'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=black
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=black
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=black
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[redirection]=fg='#2ee01f'



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

# So ^A jumps to the beginning of the line in tmux
bindkey "^A" beginning-of-line
# So ^E jumps to end of the line in tmux
bindkey "^E" end-of-line

# Make it so up/down arrows search your history (even with nested filepaths/args)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# So ^P inserts the last word (or arg) from the previous command into the current line
bindkey '^P' insert-last-word  

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

# Note: use my ~/bin/ns script to get current timestamp AND nanoseconds in
# a grpc google.protobuf.Timestamp format
alias ds='date +%s' # get current unix timestamp on MacOS

# Usage: $ <cmd> | firstcol
firstcol() { awk '{print $1}'; }

# Usage: $ <cmd> | lastcol
lastcol() { awk '{print $NF}'; }

# ff - filfer files in current dir (case-insensitive)
# lists files by just their name on separately lines
# It takes 0 to 4 args and each arg will further grep things down
# Usage: $ ff [<arg1>] [<arg2>] [<arg3>] [<arg4>
# Ex:
#    $ ff   # list all files in current dir
# Use it to list files match env and/or market and/or region and/or AZ:
#    $ ff prd
#    $ ff LATAM
#    $ ff prd LATAM
#    $ ff prd LATAM east
#    $ ff prd LATAM east 1
# Because it only lists the filenames, you can then open them too:
#    $ vim $(ff prd latam)
# or open them afterward and in any editor, such as VSCode
#    $ ff prd latam
#    $ code ($!!)
# Unlike fuzzyfinding (e.g., fzf) this also lets you pass things in any order:
#    $ ff 1 east prd latam
#    prd-any-latam-us-east-1.tfvars
#    $ ff latam east 1 prd
#    prd-any-latam-us-east-1.tfvars
# IMPORTANT: 'us' can be harder to filter because it can show up in other regions that use it
#   $ ff prd us | ag -v latam   # if latam files were also showing up
# Also, not all repos use the same naming convention for market, just env, so check first:
#   $ ff prd
#   prd-ap-northeast-1.tfvars
#   prd-eu-central-1.tfvars
ff() {
  cmd="ls -l | tail -n +2 | awk '{print \$NF}'"
  [ -n "$1" ] && cmd="$cmd | grep -i '$1'"
  [ -n "$2" ] && cmd="$cmd | grep -i '$2'"
  [ -n "$3" ] && cmd="$cmd | grep -i '$3'"
  [ -n "$4" ] && cmd="$cmd | grep -i '$4'"
  bash -c "$cmd"
}

# alias to fd "all" files (case-insensitive/hidden)
alias fda='fd -iH'

# Useful after `fd -H foo` to open files in nvim: `fd foo | x
# Think of `x` as `xargs nvim` (and only opens if its a file not dir)
function x() {
    files=()
    while IFS= read -r line; do
        if [ -f "$line" ]; then
            files+=("$line")
        fi
    done
    ~/opt/nvim-macos/bin/nvim "${files[@]}"
}

# Like regular fd, but also shows the contents of the files
# Use `fd <foo> | x` to open in nvim instead of cat
fdc() {
    fda "$1" --color=never -x sh -c 'printf "==== %s ====\n" "$1"; cat "$1"; echo' _ {}
}

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export VISUAL=~/opt/nvim-macos/bin/nvim # so bindkey ^o opens in nvim
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

alias diff='diff --color=always' # brew install diffutils first
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
# Make my diff-so-fancy alias even shorter. Diff specific file like: dsf <branch> -- path/to/file
alias dsf='git dsf'
alias gd='dsf' # brew install diff-so-fancy
alias gdc='gd --cached'
alias gst='git status'
alias gsur='git submodule update --init --recursive' # gsur [--remote] when needed
alias pj='prettyjson'
# git grep
# gg is the git grep equivalent of rg -g "<search pattern in filename>" "<search pattern in those matching files>"
# Usage: gg <filename-pattern> <word-in-file-pattern>. Greps using git for the files matching the pattern for the word matching pattern. Ex:
# $ gg httpserver.go AppName # searches files matching httpserver.go for AppName.
# $ gg "function foo" "*.js"  # searches for "function foo" in all .js files
gg() {
  git grep "$2" -- "*$1*"
}
# ag
alias ag='ag -s --path-to-ignore ~/.ignore'
# Node.js
alias nag='ag --js --ts --ignore-dir=node_modules\* --ignore=\*-min.js'
# Golang
alias gag='echo deprecated. Use rggo instead.'
# ripgrep search go files but ignore test/mock files and vendor
rggo() {
  rg --glob '*.go' --glob '!*_test.go' --glob '!*mock*' --glob '!*vendor*' "$@"
}
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

# Command that only shows the root-level directories a search pattern is in (case-insensitive)
# Useful for things like just seeing what repo's contain a string somewhere. Respects .gitignore
function rgr {
    rg -i "$1" --count --hidden --glob '!node_modules/*' --glob '!vendor/*' | cut -d/ -f1 | sort | uniq -c | sort -k1,1nr
}
# Like rgr but uses ag and doesn't print the counts of matches
function agr {
    ag -iH "$1" -l --ignore-dir=node_modules\* --ignore-dir=vendor\* | cut -d/ -f1 | sort | uniq
}

# Searches for the specified term in the current directory using `git grep`,
# then shows `git blame` results for matching lines.
# Usage: rgb "<search_term>"
rgb() {
  local search_term="$1"
  local base_dir='.'

  # Define colors using tput
  local commit_color=$(tput setaf 1)    # Red for commit hash
  local file_color=$(tput setaf 2)      # Green for file path
  local line_color=$(tput setaf 6)      # Cyan for line number
  local author_color=$(tput setaf 4)    # Blue for author
  local date_color=$(tput setaf 5)      # Magenta for date
  # local text_color=$(tput setaf 7)      # White for text
  local reset_color=$(tput sgr0)        # Reset color to default

  # Ensure git always outputs colors, regardless of whether it's piped
  export GIT_PAGER=cat
  export GIT_TERMINAL_PROMPT=1

  # Loop through all subdirectories in ~/repos
  for repo in "$base_dir"/*/; do
    # Ensure the directory is a Git repository
    if [ -d "$repo/.git" ]; then
      # Find files that contain the search term, then for each file, show git blame for the matching lines
      (cd "$repo" && git grep -n --color=never "$search_term" | while read -r line; do
        # Extract the filename and line number from the grep result
        local file=$(echo "$line" | cut -d: -f1)
        local lineno=$(echo "$line" | cut -d: -f2)

        # Run git blame for that specific line
        local blame_output=$(git blame "$file" -L "$lineno,+1")

        # Extract the components from the blame output using awk
        local commit_hash=$(echo "$blame_output" | awk '{print $1}')
        local author=$(echo "$blame_output" | awk '{print $2 " " $3}')
        local date=$(echo "$blame_output" | awk '{print $4 " " $5 " " $6}')
        local text=$(echo "$blame_output" | awk '{for(i=7;i<=NF;i++) printf "%s ", $i; print ""}')

        # Print the result with custom colors, ensuring correct formatting
        echo -e "${file_color}$file${reset_color} ${commit_color}$commit_hash${reset_color} ${author_color}$author${reset_color} ${date_color}$date${reset_color} $text$"
      done)
    fi
  done

  # Reset GIT_PAGER to its default value after the function completes
  unset GIT_PAGER
  unset GIT_TERMINAL_PROMPT
}

#: Search for a main term with ripgrep and highlight up to three additional words.
#: It's important to remember that it further filters the first match like piping to rg up to 4 times
#: Usage: rgh [rg-flags] <main-term> <highlight-1> [highlight-2] [highlight-3] [highlight-4]
#: - <main-term> (red) is the primary search term.
#: - <highlight-1> is required; [highlight-2], [highlight-3], [highlight-4] are optional.
#: - Additional `ripgrep` flags (e.g., `-i`, `-w`) can be passed before the main term.
#: You can also pipe other commands to it:
#:   - <cmd> | rgh -i "foo" "bar" "baz" "qux"
#: Note: If you want it to have the same sort order add e.g., --sort=path
rgh() {
  # Usage guard
  if [[ $# -lt 2 || $# -gt 6 ]]; then
    echo "Usage: rgh [rg-flags] <main-term> <highlight-1> [highlight-2] [highlight-3] [highlight-4]"
    return 1
  fi

  # Collect rg flags (before main term)
  local rg_flags=()
  while [[ "$1" == -* && $# -gt 2 ]]; do
    rg_flags+=("$1")
    shift
  done

  local main_term=$1
  local highlight1=$2
  local highlight2=${3:-}
  local highlight3=${4:-}
  local highlight4=${5:-}

  # Build each stage as its own argv array
  local base=(rg --color=always --colors 'match:fg:red' "${rg_flags[@]}" -e "$main_term")
  local s1=() s2=() s3=() s4=()
  [[ -n $highlight1 ]] && s1=(rg --color=always --colors 'match:fg:green'   "${rg_flags[@]}" --passthru -e "$highlight1")
  [[ -n $highlight2 ]] && s2=(rg --color=always --colors 'match:fg:blue'    "${rg_flags[@]}" --passthru -e "$highlight2")
  [[ -n $highlight3 ]] && s3=(rg --color=always --colors 'match:fg:cyan'    "${rg_flags[@]}" --passthru -e "$highlight3")
  [[ -n $highlight4 ]] && s4=(rg --color=always --colors 'match:fg:magenta' "${rg_flags[@]}" --passthru -e "$highlight4")

  # Execute the right-length pipeline without eval
  if [[ -n $highlight4 ]]; then
    "${base[@]}" | "${s1[@]}" | "${s2[@]}" | "${s3[@]}" | "${s4[@]}"
  elif [[ -n $highlight3 ]]; then
    "${base[@]}" | "${s1[@]}" | "${s2[@]}" | "${s3[@]}"
  elif [[ -n $highlight2 ]]; then
    "${base[@]}" | "${s1[@]}" | "${s2[@]}"
  else
    "${base[@]}" | "${s1[@]}"
  fi
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
# Use ^F if i want to go into subdirs as well. Both are extremely useful
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
