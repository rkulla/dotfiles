let mapleader = ","                                   " Remap <Leader> to comma
set dir=~/.config/nvim/swp                            " .swp file location
set clipboard+=unnamed                                " Yank to system clipboard, in tmux or otherwise
set path+=**                                          " Allow :find, :tabf, etc., to search the pwd and its subdirs
set ignorecase                                        " Case-insensitive search
"set timeoutlen=1000 ttimeoutlen=0                    " Make Esc key a lot faster, e.g., closing fzf
set number                                            " Enable line numbers
set confirm                                           " :q, :bd, etc., on a changed file popups a `save file?` confirmation
"set fo=t                                             " I don't want the format options that auto create comments
set enc=utf-8                                         " Default fencs to ucs-bom,utf-8,default,latin1
set pastetoggle=<F3>                                  " If normal pasting doesn't work
set expandtab                                         " So tab key writes spaces. (Ctrl+V<TAB> for real tabs)
set tabstop=4                                         " Make tabs 4 spaces
set shiftwidth=4                                      " Appear as 4 spaces when auto-indenting
set shiftround                                        " So > and < indenting snap to value of shiftwidth
set spelllang=en_us                                   " Spellcheck language
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add   " Spellfile location
autocmd BufRead,BufNewFile *.txt,*.md setlocal spell  " File types to enable spell checking on


""" I put some configs in plugin/ (still loads on startup) to keep this file small
" COLOR SCHEME:          plugin/colorscheme.vim
" KEYMAPS:               plugin/keymaps.vim  (all maps for easy reference)
" TERMINAL:              plugin/terminal.vim

""" Plugin Initialization (requirements: Packer)
" Load ~/.config/nvim/lua/user/plugins.lua
" Simply comment out any `packadd` to a plugin
lua require('user/plugins')

" I put plugin/ files that also `packadd` below
" MARKDOWN:              plugin/markdown.vim

""" Load Misc. plugins
packadd plenary.nvim
packadd telescope.nvim
packadd nvim-tree.lua
lua require('user/nvim-tree')
