# dotfiles
My dotfiles

Adding new files requires 3 steps:

   1. Add the file or directory to this repo
   2. Add to the root .gitignore anything I want to ignore/unignore
   3. Update install.sh to do the symlinking and optionally creating needed empty dirs

## Installing

First make sure `vimogen` is cloned to ~/repos/ and then run it manually once to ensure coc.nvim is installed. Make sure node.js is installed too.

If it's a work machine, comment out the code-snippets line from install.sh

Then cd to my dotfiles checkout and run:

    ./install.sh

It will backup any existing files by prepending the current datetime and then
will create symlinks from $HOME/*filename* this repo's corresponding *filename*.

## Post installation steps
After running ./install.sh to automate most things, do these manual steps.

### Homebrew dependencies

Note all of these are required for this script to work but these are things I typically brew install:

    tig, tmux, autojump, tree, aws-sam-cli, gnu-sed, watch, coreutils, mysql,
    postgresql, pyenv, wget, ctags, diffutils, nmap, fd, nnn,
    reattach-to-user-namespace, zenity, htop, rsync, zsh-syntax-highlighting,
    screen, fzf, irssi, sqlite, jq, the_silver_searcher

### Zsh
#### site-functions
Copy scripts to first path in $fpath, e.g., /usr/local/share/zsh/site-functions

Enable my custom git completion for Zsh:

    $ cp zsh-site-functions/_git /usr/local/share/zsh/site-functions/

Enable script to abbreviate and disambiguate the PWD in my prompt.

    $ cp zsh-site-functions/disambiguate /usr/local/share/zsh/site-functions/

### Tmux
Make sure to: brew install reattach-to-user-namespace

#### Misc.
Search PATH modifications in .zshrc and .zprofile `/PATH=\C` adjust accordingly.

### Vim
Install eslint PER project, not globally:

    $ npm install eslint -D

Make sure to copy javascript/.eslintrc.json and jsconfig.json to any of **my** JavaScript projects.
Or typescript/.eslintrc.json and tsconfig.json if it's **my** TypeScript projects
(I _only_ symlink it to my code-snippets folder). Putting eslintrc in $HOME is deprecated and
jsconfig.json or tsconfig.json can't live in $HOME either.

### iterm2
Enable `mouse reporting` for each profile. Then in `General > Selection` enable 
`Applications in terminal may access clipboard`, `Copy to pasteboard on selection`,
`Double-click performs smart selection`, `Triple-click selects entire wrapped lines`.

### terminfo-sources
Most termcap files are already installed with ncurses: xterm-256color, etc.
However, my special tmux-256color.src is in this repo. Compile it manually:

    $ cd dotfiles/terminfo-sources
    $ /usr/bin/tic -xe tmux-256color tmux-256color.src

which installs the compiled binares to ~/.terminfo ready for use.

Also, enable italics, e.g., Vim's line numbers when not in tmux:

    $ /usr/bin/tic -xe xterm-256color xterm-256color.src

### Uninstalling
Simply `git rm` any files and remove linking references from install.sh. Then
use my `lslb` alias to list broken symlinks for removal. Also uninstall with vimogen
if it was a vim plugin.
