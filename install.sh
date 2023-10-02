#!/bin/bash
# Author: Ryan Kulla
# Script to bootstrap and maintain my dotfiles
# Usage: Run this from the repo and it will create symlinks in $HOME

FFMacOS="/Applications/Firefox.app/Contents/Resources"

linkdot() {
    local dateStr=$(date +%Y-%m-%d-%H%M)
    local src="$1"
    local dest="$2"

    local orig="${dest#$HOME/}/$(basename $src)"
    if [[ "$dest" != "$HOME" ]]; then
        # prepend the home dir back
        orig="$HOME/$orig"
    fi

    # Local dirs we want to recreate since we gitignore their contents
    # This beats having to create a ton of .gitignore files with * ; !.gitignore
    mkdir -p "$HOME/.vim/bundle"
    mkdir -p "$HOME/.vim/swp"
    mkdir -p "$HOME/.local/share/fzf-history"
    mkdir -p "$HOME/bin"
    if [[ "$OSTYPE" == darwin* && -e "$FFMacOS" ]]; then
        mkdir -p "$FFMacOS/distribution"
    fi

    # dest should always be the dir we're linking to, check if exists
    # If this message happens, add the dir to the mkdir section above.
    if [[ ! -e "$dest" || ! -d "$dest" ]]; then
        echo "Dest [$dest] does not exist or is not a directory. Aborting."
        exit 1
    fi

    # Backup existing stuff before overwriting with symlinks
    if [[ -f "$orig" && ! -L "$orig" ]]; then
        echo "Backing up existing file: ${orig} to ${orig}.${dateStr}"
        mv ${orig}{,.${dateStr}}

    elif [[ -d "$orig" && ! -L "$orig" ]]; then
        echo "Backing up existing dir: ${orig} to ${orig}.${dateStr}"
        mv ${orig}{,.${dateStr}}
    fi

    # Create symlinks
    if [[ -d "$src" ]]; then
        /bin/ln -sFv -- $(realpath "$src") "$dest"
    elif [[ -f "$src" ]]; then
        /bin/ln -sfv -- $(realpath "$src") "$dest"
    else
        echo "ERROR: $src does not exist in dotfiles repo"
    fi
}

main() {
    # explicitly symlink all desired dotfiles
    linkdot ".config" "$HOME"
    linkdot ".ctags" "$HOME"
    linkdot ".gitconfig" "$HOME"
    linkdot ".ignore" "$HOME"
    linkdot ".inputrc" "$HOME"
    linkdot ".irbrc" "$HOME"
    linkdot ".npmrc" "$HOME"
    linkdot ".prettierrc" "$HOME"
    linkdot ".pryrc" "$HOME"
    linkdot ".psqlrc" "$HOME"
    linkdot ".screenrc" "$HOME"
    linkdot ".tmux.conf" "$HOME"
    linkdot ".vim" "$HOME"
    linkdot ".vimrc" "$HOME"
    linkdot ".vimogen_repos" "$HOME"
    linkdot ".zprofile" "$HOME"
    linkdot ".zshrc" "$HOME"

    # anything else I want to symlink
    linkdot "my-shortcuts.txt" "$HOME"

    # symlinks outside of root of $HOME
    linkdot "$HOME/repos/vimogen/vimogen" "$HOME/bin"
    linkdot "javascript/.eslintrc.json" "$HOME/repos/code-snippets/JS"
    if [[ "$OSTYPE" == darwin* && -e "$FFMacOS/distribution" ]]; then
        linkdot "firefox/policies.json" "$FFMacOS/distribution"
    fi
}

main
