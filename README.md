# dotfiles

My dotfiles and configuration files in general!

[Summary](#summary) | [Installing](#installing) | [Zsh](#zsh) | [Iterm2](#iterm2) | [Git](#git) | [Finder](#finder) | [Tmux](#tmux) | [~/bin scripts](#bin-scripts) | [irssi](#irssi) | [ESLint](#eslint) | [Neovim](#neovim) | [VSCode](#vscode) | [Uninstalling](#uninstalling)

## Summary
Adding new files requires 3 steps:

   1. Add the file or directory to this repo
   2. Add to the root .gitignore anything I want to ignore/unignore
      Add anything I don't want in the committed .gitignore file my global ~/.gitignore such as README.rkulla
   3. Update install.sh to do the symlinking and optionally creating needed empty dirs

## Installing

First make sure `vimogen` is cloned to ~/repos/ and then run it manually once to ensure coc.nvim is installed. Make sure node.js is installed too. Note that if you only have node installed via `nvm`, I may have to add the following to ~/.vimrc:

    let g:coc_node_path = '/path/to/node'

and if using `fnm`, I symlink that node path to ~/bin and set g:coc_node_path to ~/bin.

Make sure 'vim' is running properly, if CoC is complaining about needing to 'yarn install', it's because my vimogen script only clones with a depth of 3, so I need to **manually delete that checkout** and install it fully so I can switch to its release branch which doesn't have that issue:

    $ cd ~/.vim/bundle
    $ rm -rf coc
    $ git clone https://github.com/neoclide/coc.nvim.git coc
    $ cd coc && git checkout origin/release

If it's a work machine, comment out the code-snippets line from install.sh

The `realpath` command from coreutils is required to run install.sh. I typically brew install:

    $ brew tap aws/tap
    $ brew install gh tig tmux autojump tree aws-sam-cli gnu-sed watch coreutils mysql postgresql \
      pyenv wget ctags diffutils nmap fd nnn reattach-to-user-namespace zenity htop rsync screen \
      zsh-syntax-highlighting zsh-you-should-use shellcheck jsonlint fzf irssi sqlite jq asdf \
      the_silver_searcher ripgrep yamllint httpie diff-so-fancy fnm glow lazygit lazydocker lsd

### Run the dotfiles install script

After doing the above steps, cd to my dotfiles checkout and run:

    $ sudo chown -R $USER /Applications/Firefox.app
    $ ./install.sh

It will backup any existing files by prepending the current datetime and then
will create symlinks from $HOME/*filename* this repo's corresponding *filename*.

### Post installation steps
After running ./install.sh to automate most things, do these manual steps.


## Zsh
#### site-functions
Copy scripts to first path in $fpath, e.g., /usr/local/share/zsh/site-functions

Enable my custom git completion for Zsh:

    $ cp zsh-site-functions/_git /usr/local/share/zsh/site-functions/

Enable script to abbreviate and disambiguate the PWD in my prompt.

    $ cp zsh-site-functions/disambiguate /usr/local/share/zsh/site-functions/

Search PATH modifications in .zshrc and .zprofile `/PATH=\C` adjust accordingly.

## iterm2

Enable `mouse reporting` for each profile. Then in `General > Selection` enable 
`Applications in terminal may access clipboard`, `Copy to pasteboard on selection`,
`Double-click performs smart selection`, `Triple-click selects entire wrapped lines`.

Add the following maps for ergonomics/convenience. Under `Cmd+, > Profiles > select each profile > Keys > Key Mappings` click `+` to a new key map for and search for **Send Text with "Vim" Special Chars** and create maps:

    Alt+k  to  \u001b[A   (arrow down)
    Alt+j  to  \u001b[B   (arrow down)
    Alt+l  to  \u001b[C   (arrow right)
    Alt+h  to  \u001b[D   (arrow left)

With `\u001b[A` the `\u001b` means ESC and `[A` means `up` arrow
Similarly `[B` means down, `[C` means right and `[D` means left.

Also create the following but mapped to **Send Escape Sequence**:

    Alt+b  to  b          (move left 1 word at a time)
    Alt+f  to  f          (move right 1 word at a time)

And finally, create the ability to undo by typing cmd+z by mapping it in **Send Hex Code**:

    Cmd+z  to  0x1f       (undo)

Install `Hack Nerd Font` so I can see file-type logos in my terminal:

    $ brew tap homebrew/cask-fonts
    $ brew install --cask font-hack-nerd-font

Under `Cmd+i` > `Colors` tab import tokyonight_*.itermcolors by downloading them from
[here](https://github.com/folke/tokyonight.nvim/tree/main/extras/iterm)

Then create a light profile called `l` and a dark profile called `d` with `cmd+, > Profiles > +` and use `tokyonight-day` for `l`
and `tokyonight-storm` for `d`.  You'll want the iterm2 background to match whatever vim color scheme I use

Under `General` > `Title` check `Job name` and `PWD`, so I can see things like the tab is vim and the directory name its in.
   
Under `Text` enable `Box` and `Blinking cursor`. Change font to `Hack Nerd Font` / regular / 32. Uncheck 'Use ligatures'

Under `Terminal` enable `unlimited scrollback`

Make sure to do this from `Cmd+,` not `cmd+i` or the changes will not stick.

Right click 'Other actions' and make `l` the default profile.

By default, new split panes reset back to $HOME but I want pwd:

- `Cmd+,` > `Profiles` > `[profile name]` > `Working directory` > `Advanced Config` > `Edit` ><br>
   Under `Working Directory for New Split Panes` select `Reuse previous sessions's directory`.

### terminfo-sources
Most termcap files are already installed with ncurses: xterm-256color, etc.
However, my special tmux-256color.src is in this repo. Compile it manually:

    $ cd dotfiles/terminfo-sources
    $ /usr/bin/tic -xe tmux-256color tmux-256color.src

which installs the compiled binaries to ~/.terminfo ready for use.

Also, enable italics, e.g., Vim's line numbers when not in tmux:

    $ /usr/bin/tic -xe xterm-256color xterm-256color.src

## Git
On a work machine with a personal github account, edit ~/.gitconfig and update my [user] section. E.g.,

	name = Ryan Kulla
	email = <work github email>
	login = <work github username>

Do not add tokens here, use a real credential store for privacy.

## Finder

Run the following in a terminal to show full file paths in Finder:

    $ defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES;

## Tmux
Make sure to: brew install reattach-to-user-namespace

Install plugins:

    $ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Open tmux and type `Ctrl+a I` to install the plugins listed in .tmux.conf

## Irssi

`find` or `locate` the `default.theme` file, and change:

    sb_background = "%4%k";

to something more readable if needed, such as:

    sb_background = "%5%w";

I prefer this over installing 'themes' since usually I just use my default background color and change the statusbar

## ESLint
Install eslint PER project, not globally:

    $ npm install eslint -D

Make sure to copy javascript/.eslintrc.json and jsconfig.json to any of **my** JavaScript projects.
Or typescript/.eslintrc.json and tsconfig.json if it's **my** TypeScript projects
(I ONLY symlink it to my code-snippets folder). Putting eslintrc in $HOME is deprecated and
jsconfig.json or tsconfig.json can't live in $HOME either.

Don't forget to look at my .vim/coc-settings.json as well and **make sure** at least coc-eslint and coc-tsserver are installed
   $ ls ~/.config/coc/extensions/node_modules  # install.sh should have installed them

See also typescript/README.md in this repo.

## bin scripts
my ~/bin directory is in my PATH and has misc. scripts

Backup to/fro manually from ~/Dropbox/pf/code/my-bin-dir-scripts/

## Neovim

Do this from ~/.config/nvim/init.vim instead of this dotfiles checkout, since not everything is symlinked

Install Packer then run `:PackerSync`

Install (or update) LSP servers and Linters I integrate with:

   $ go install golang.org/x/tools/gopls@latest
   $ go install honnef.co/go/tools/cmd/staticcheck@latest
   $ cargo install stylua
   $ npm i -g typescript-language-server  (tsserver LSP wrapper; when not in package.json)
   $ npm i -g eslint_d


## VSCode
For now manually copy my settings from vscode/settings.json into ~/Library/Application\ Support/Code/User/settings.json

## Uninstalling
Simply `git rm` any files and remove linking references from install.sh. Then
use my `lslb` alias to list broken symlinks for removal. Also uninstall with vimogen
if it was a vim plugin.
