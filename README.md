# dotfiles

My dotfiles and configuration files in general!

[Summary](#summary) | [Installing](#installing) | [iCloud Drive](#icloud-drive) | [Spotlight](#spotlight) | [Shortcuts](#shortcuts) | [Zsh](#zsh) | [Keyboard speed](#keyboard-speed) | [~/bin scripts](#bin-scripts) | [Vim](#vim) | [Git](#git) | [Go](#golang) | [NodeJS](#nodejs) | [Rust](#rust) | [Neovim](#neovim) | [Alacritty](#alacritty) | [Iterm2](#iterm2) | [Terminfo](#terminfo-sources) | [VSCode](#vscode) | [Uninstalling](#uninstalling) | [ESLint](#eslint) | [Tmux](#tmux) | [irssi](#irssi) | [Finder](#finder)

## Summary

Adding new files requires 3 steps:

1.  Add the file or directory to this repo
2.  Add to the root .gitignore anything I want to ignore/unignore
    Add anything I don't want in the committed .gitignore file my global ~/.gitignore such as README.rkulla
3.  Update install.sh to do the symlinking and optionally creating needed empty dirs

## Installing

Clone my `code-snippets` repo to ~/repos unless it's a work machine, in which case comment out the code-snippets line from install.sh

Install `Firefox`

Install `Homebrew` and if it's an m-chip mac, add the following to ~/.zprofile so brew and brew installed commands show in my $PATH

Note: Homebrew on apple silicon has a different location (don't do this step on x86):

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/rkulla/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

The `realpath` command from coreutils is required to run install.sh. I typically brew install:

    # Note: don't forget to periodically `brew upgrade <name` from these installed tools
    $ brew tap aws/tap
    $ brew install cmake gh tig tmux zoxide tree aws-sam-cli gnu-sed watch coreutils moreutils findutils diffutils \
      mysql postgresql ssh-copy-id pyenv wget ctags nmap fd nnn reattach-to-user-namespace zenity htop ncdu rsync \
      screen zsh-syntax-highlighting zsh-you-should-use shellcheck jsonlint fzf irssi sqlite jq yq \
      asdf the_silver_searcher ripgrep yamllint httpie diff-so-fancy fnm glow bat lazygit lazydocker \
      lsd vint hadolint groff alacritty alt-tab amethyst

### Run the dotfiles install script

After doing the above steps, cd to my dotfiles checkout and run:

    $ sudo chown -R $USER /Applications/Firefox.app
    $ ./install.sh

It will backup any existing files by prepending the current datetime and then
will create symlinks from $HOME/_filename_ this repo's corresponding _filename_.

### Post installation steps

After running ./install.sh to automate most things, do these manual steps.

## iCloud-Drive

I prefer this over Dropbox since it's native and works better.

- In Finder's preferences, go to 'sidebar' and enable 'iCloud Drive' to see it in finder
- Simply create folders in it and they will appear in ~/Library/Mobile\ Documents/com\~apple\~CloudDocs
  - I alias `icd` to cd to this folder by typing

NOTE: If spotlight stops loading things, make sure I don't check too many things in spotlight AND then make sure to rebuild the Spotlight index by going to Spotlight's preferences > Click on "Spotlight Privacy" to see a list of locations excluded from Spotlight searches > Then temporarily + add my iCloud Drive to the exclusions list but then immediately remove it from there, and that will trigger a rebuild of the index.

## Spotlight

I prefer this over Alfred since it's native and works better.

Make alt+space open it (instead of the default cmd+space) in `System Preferences > Spotlight > Shortcuts`

Tell it what NOT to search in `System Preferences > Spotlight > Search Results`. Uncheck things like 'bookmarks & history, 'developer' 'siri suggestions', 'Music', 'Mail and Messages', 'Other'.  I uncheck everything but `Applications`, `Calculator`, `Documents`, `Folders` and `System Settings` to avoid conflicts.

Leave everything else checked: 'Applications', 'calculator', 'definition', 'Documents', 'events and reminders', 'conversion', 'folders', 'movies', 'PDF', 'system preferences', etc.

The 'Documents' one is how it finds .txt files.

In finder, don't forget to set .txt files to open in MacVim or it will open in TextEdit by default

Make sure to click the `privacy` tab and add any dirs you to ignore, such as a backup drive (so it doesn't try to load your backups instead of the main file). Checking the statusbar in MacVim will help confirm the path!

TROUBLESHOOTING: 
  - If Spotlight isn't finding or opening things anymore, rebuild the index for the FOLDER in question, e.g., /Applications if it stops finding apps, or add your iCloud Drive folder if files in that stop being indexd, etc. THEN make sure to immediately remove that folder before clicking Done to trigger a rebuild of the index.
  - If Spotlight search still finds things but won't OPEN them, do: `$ sudo killall Spotlight` # this restarts it and rebuilds the index
  - If you don't see anything indexed, you can usually add/remove from the 'privacy' section of the spotlight UI settings OR do: `sudo mdutil -i off <dir>` && `sudo mdutil -i on <dir>` but try it through the UI first.

## Shortcuts

See also ~/my-shortcuts.txt for a quick reference of all my favorite shortcuts for MacOS and specific apps like Neovim, Firefox and more. (`<spc>sc`)

To launch apps I prefer Spotlight over Karabiner Elements/Automator.app/Shortcuts.app/BetterTouchTool for keyboard shortcuts because none of those work proprerly with Sharemouse, Barrier or other Virtual KVM's because those vKVM tools don't respect shortcuts on anything but the primary device (whatever machine the keyboard is plugged into) and/or they will get intercepted by applications that also look for similar shortcuts. I've yet to find a single native or 3rd party app that supports this and it's just as good to use spotlight than remember more shortcuts anyway. So just open/switch to firefox with spolight `alt+space f[ire]` and once it's open use FF's browser search keyboard shortcuts:

    %  # Search for an open tab
    *  # Search bookmarks
    ^  # Search history

To switch between open apps use `cmd+tab` to see all apps but I also `brew install alt-tab` to use alt+tab and blacklist certain apps from showing up. Can optionally enable screen recording for it to show window previews. Works better than Ctrl+Up to Mission Control because that doesn't support keyboard movements to select windows once it's open (but does support window hiding with Cmd+h). I prefer this to `Witch` since it's free and open-source.

To disable caps lock:

- Go to System Preferences > Keyboard shortcuts > keyboard shortcuts > Modifier Keys
- In the dropdown menu next to `Caps Lock Key`, choose "No Action" to disable it

To switch between headphones and speakers with keyboard shortcut:

- Get the 'Instant Audio Switcher' app for free from the Apple store
- In the preferences set a keyboard shortcut cmd+alt+1 to toggle between headphones and speakers
- Might also have to go into the device tab in the app's preferences and enable a secondary device first (choosing speaker for one and headphones for the primary)

Things NOT to bother with (already tried and didn't like or work well):

- App launchers: Automator.app, Shortcuts.App, Karabiner Elements, BetterTouchTool (none work with virtual KVM software like Sharemouse. Alfred works but just use Spotlight)
  (I still use Karabiner for certain additional shortcuts on my personal computer)
- App shortcuts: Google Chrome app shortcuts don't work well for UI elements. Use native apps and/or dedicated Firefox window for site + Fullscreen workspace
- Bookmark/history search from Spotlight/Alfred. Not consistent. Just use firefox's \* search in address bar to search bookmarks and ^ for history

## Zsh

#### site-functions

Copy scripts to first path in $fpath, e.g., /usr/local/share/zsh/site-functions (intel) or /opt/homebrew/share/zsh/site-functions
(Apple Silicon). "echo $fpath[1]" to find out.

Enable script to abbreviate and disambiguate the PWD in my prompt.

    $ cp zsh-site-functions/disambiguate "$fpath[1]"

Enable my custom git completion for Zsh:

    $ cp zsh-site-functions/_git "$fpath[1]"

Search PATH modifications in .zshrc and .zprofile `/PATH=\C` adjust accordingly.

## Keyboard speed

Increase the speed of typing by going into `System Preferences -> Keyboard`.

I like to slide Key Repeat all the way to the right (Fast) and slide Delay Until Repeat all to the right (Short)

## bin scripts

my ~/bin directory is in my PATH and has misc. scripts

Backup to/fro manually from ~/Dropbox/pf/code/my-bin-dir-scripts/

## Vim

Install MacVim and then install my plugins by cloning vimogen to ~/repos and running:

     $ vimogen
     1 # install

## Alacritty

Brew install `alacritty` and it will use my config file automatically. No further setup required!
Optionally use with Tiling Window manager `amethyst`, ideally, so windows will auto-title.

To change configs, such as the color of the background dynamically, just:

    alacritty msg config "colors.primary.background='#eff6ef'"

which means it's all script-able! To change tmux's status bar dynamically:

    tmux source-file ~/.tmux/themes/tokyonight_day.tmux


## iterm2

NOTE: I don't use iterm2 anymore, just alacritty

Install `Hack Nerd Font` so I can see file-type logos in my terminal:

    # Install Hack Nerd Font v3+ either manually from nerdfonts.com or with brew
    # Must be v3 for certain fonts won't work in NeoVim even with nvim-web-devicons
    $ brew tap homebrew/cask-fonts
    $ brew install --cask font-hack-nerd-font

`Cmd+i`>`Colors` and import tokyonight\_\*.itermcolors from
~/.local/share/nvim/site/pack/packer/start/tokyonight.nvim/extras/iterm. First `Cmd+Shift+.` to have the file dialog show hidden
files first.

Make sure to do this from `Cmd+,` not `Cmd+i` or the changes will not stick.

Then create a light profile called `l` and a dark profile called `d` with `cmd+, > Profiles > +` and use `tokyonight-day` for `l`
and `tokyonight-storm` for `d`. I'll want the iterm2 background to match whatever vim color scheme I use.

Do the following for all the profiles I'll use.

Under `General` > `Title` check `Job` and `Applications in terminal may change the title`

My zshrc already has config to set the title to the app, pwd and even which terminal program is being used (iterm2 or alacritty) but since iterm2 tries to force at least job name, I have logic to handle that in zshrc as well.

Under `Text` enable `Box` and `Blinking cursor`.
Change font to `Hack Nerd Font` / regular / 32. Uncheck 'Use ligatures'. By having the same size font in each profile, you'll
prevent the window resizing when you see profiles.

Under `Terminal` enable `unlimited scrollback` and `mouse reporting`

Right click 'Other actions' and make `d` the default profile.

By default, new split panes reset back to $HOME but I want pwd:

- `[profile name]` > `Working directory` > `Advanced Config` > `Edit` ><br>
  Under `Working Directory for New Split Panes` select `Reuse previous sessions's directory`.

In `General > Selection` (the gear icon not the general tab) enable
`Applications in terminal may access clipboard`, `Copy to pasteboard on selection`,
`Double-click performs smart selection`, `Triple-click selects entire wrapped lines`.

Add the following maps for ergonomics/convenience in each profile: `Keys > Key Mappings` click `+` to a new key map for and search for **Send Text with "Vim" Special Chars** and create maps:

    Alt+k  to  \u001b[A   (arrow up)
    Alt+j  to  \u001b[B   (arrow down)
    Alt+l  to  \u001b[C   (arrow right)
    Alt+h  to  \u001b[D   (arrow left)

With `\u001b[A` the `\u001b` means ESC and `[A` means `up` arrow
Similarly `[B` means down, `[C` means right and `[D` means left.

Also create the following but mapped to **Send Escape Sequence**:

    Alt+b  to  b          (move left 1 word at a time)
    Alt+w  to  f          (move right 1 word at a time)

And finally, create the ability to undo by typing cmd+z by mapping it in **Send Hex Code**:

    Cmd+z  to  0x1f       (undo)

## terminfo-sources

Most termcap files are already installed with ncurses: xterm-256color, etc.
However, my special tmux-256color.src is in this repo. Compile it manually:

    $ cd dotfiles/terminfo-sources
    $ /usr/bin/tic -xe tmux-256color tmux-256color.src

Which installs the compiled binaries to ~/.terminfo ready for use.

Also, enable italics, e.g., Vim's line numbers when not in tmux:

    $ /usr/bin/tic -xe xterm-256color xterm-256color.src

## Git

On a work machine with a personal github account, edit ~/.gitconfig and update my [user] section. E.g.,

    name = Ryan Kulla
    email = <work github email>
    login = <work github username>

Do not add tokens here, use a real credential store for privacy.

## Golang

Make sure Golang is installed first. E.g., get the pkg installer from the Go website.

## NodeJS

Node.js comes with MacOS but rather than using the system node.js first install a 'virtual' version through `fnm`:

    $ fnm install v18.13.0  # or whatever version you want
    $ fnm default v18.13.0  # make default to avoid using the system node that comes w/ MacOS

## Rust

Make sure Rust is installed first (`curl https://sh.rustup.rs -sSf | sh` or whatever is currently recommended)
I already have pathing set up for it in ~/.zprofile

## Neovim

#### Install nvim

Download NeoVim from https://github.com/neovim/neovim/releases/ and scroll to the bottom of the release you want and click 'Assets'
and download nvim-macos.tar.gz and run:

    $ mkdir ~/opt
    $ mv ~/Downloads/nvim-macos.tar.gz ~/opt
    $ cd ~/opt
    $ xattr -c ./nvim-macos.tar.gz   # avoids "unknown developer"
    $ tar xzvf nvim-macos.tar.gz

I then have aliases `n`, etc in .zshrc already that point to ~/opt/nvim-macos/bin/nvim

#### Install neovim plugins

Install Packer:

    $ git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

Then do this from ~/.config/nvim/init.vim instead of this dotfiles checkout, since not everything is symlinked:

    Open nvim and run `:PackerSync` then `:PackerCompile`

Install (or update) LSP servers and Linters I integrate with:

    $ go install golang.org/x/tools/gopls@latest
    $ go install honnef.co/go/tools/cmd/staticcheck@latest
    $ cargo install stylua
    $ npm i -g typescript-language-server typescript (tsserver LSP wrapper; when not in package.json)
    $ npm i -g eslint_d
    $ brew install fsouza/prettierd/prettierd  # if needed for work

## VSCode

For now manually copy my settings from vscode/settings.json into ~/Library/Application\ Support/Code/User/settings.json

## Uninstalling

Simply `git rm` any files and remove linking references from install.sh. Then
use my `lslb` alias to list broken symlinks for removal. Also uninstall with vimogen
and/or packer if it was a vim or neovim plugin, respectively.

## ESLint

Install eslint PER project, not globally:

    $ npm install eslint -D

Make sure to copy javascript/.eslintrc.json and jsconfig.json to any of **my** JavaScript projects.
Or typescript/.eslintrc.json and tsconfig.json if it's **my** TypeScript projects
(I ONLY symlink it to my code-snippets folder). Putting eslintrc in $HOME is deprecated and
jsconfig.json or tsconfig.json can't live in $HOME either.

See also typescript/README.md in this repo.

## Irssi

`find` or `locate` the `default.theme` file, and change:

    sb_background = "%4%k";

to something more readable if needed, such as:

    sb_background = "%5%w";

I prefer this over installing 'themes' since usually I just use my default background color and change the statusbar

## Tmux

See also: [terminfo-sources section of this README](#terminfo-sources)

Make sure to first: brew install reattach-to-user-namespace

Install plugins:

    $ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Open tmux and type `Ctrl+a I` to install the plugins listed in .tmux.conf

Install themes:

    # First `mkdir ~/.tmux/themes`
    # and install copy these there https://github.com/folke/tokyonight.nvim/tree/main/extras/tmux
    # then source it in ~/.tmux.conf like
    source-file ~/.tmux/themes/tokyonight_storm.tmux

## Finder

Optionally run the following in a terminal to show full file paths in Finder:

    $ defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES;
