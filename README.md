# dotfiles
My dotfiles

Adding new files requires 3 steps:

   1. Add the file or directory to this repo
   2. Add to the root .gitignore anything I want to ignore/unignore
   3. Update install.sh to do the symlinking and optionally creating needed empty dirs

## Installing
cd to my dotfiles checkout and run:

    ./install.sh

it will backup any existing files by prepending the current datetime and then
will create symlinks from $HOME/*filename* this repo's corresponding *filename*.

## Post installation steps
After running ./install.sh to automate most things, do these manual steps.

### Zsh
#### site-functions
Copy scripts to first path in $fpath, e.g., /usr/local/share/zsh/site-functions

Enable my custom git completion for Zsh:

    $ cp zsh-site-functions/_git /usr/local/share/zsh/site-functions/

Enable script to abbreviate and disambiguate the PWD in my prompt.

    $ cp zsh-site-functions/disambiguate /usr/local/share/zsh/site-functions/

#### Misc.
Search PATH modifications in .zshrc and .zprofile `/PATH=\C` adjust accordingly.

### terminfo-sources
Most termcap files are already installed with ncurses: xterm-256color, etc.
However, my special tmux-256color.src is in this repo. Compile it manually:

    $ cd dotfiles/terminfo-sources
    $ /usr/bin/tic -xe tmux-256color tmux-256color.src

which installs the compiled binares to ~/.terminfo ready for use.

Also, enable italics, e.g., Vim's line numbers when not in tmux:

    $ /usr/bin/tic -xe xterm-256color xterm-256color.src

