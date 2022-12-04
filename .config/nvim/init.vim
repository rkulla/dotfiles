set dir=~/.config/nvim/swp                            " .swp file location
set clipboard+=unnamed                                " Yank to system clipboard, in tmux or otherwise
set path+=**                                          " Allow :find, :tabf, etc., to search the pwd and its subdirs
set ignorecase                                        " Case-insensitive search
"set timeoutlen=1000 ttimeoutlen=0                    " Make Esc key a lot faster, e.g., closing fzf
set number                                            " Enable line numbers
set confirm                                           " :q, :bd, etc., on a changed file popups a `save file?` confirmation
"set fo=t                                             " I don't want the format options that auto create comments
set enc=utf-8                                         " Default fencs to ucs-bom,utf-8,default,latin1
set pastetoggle=<F10>                                 " If normal pasting doesn't work
set expandtab                                         " So tab key writes spaces. (Ctrl+V<TAB> for real tabs)
set tabstop=4                                         " Make tabs 4 spaces
set shiftwidth=4                                      " Appear as 4 spaces when auto-indenting
set shiftround                                        " So > and < indenting snap to value of shiftwidth
set spelllang=en_us                                   " Spellcheck language
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add   " Spellfile location
autocmd BufRead,BufNewFile *.txt,*.md setlocal spell  " File types to enable spell checking on

""" I put some configs in plugin/ (still loads on startup) to keep this file small
" COLOR SCHEME:          plugin/colorscheme.vim
" COMPLETION:            plugin/completion.vim
" MARKDOWN:              plugin/markdown.vim
" TERMINAL:              plugin/terminal.vim


" Keymaps defines my <leader> key so it MUST go above all my other lua files!
lua require('user/keymaps')

""" Plugin Initialization (requirements: Packer)
" Load ~/.config/nvim/lua/user/plugins.lua
lua require('user/plugins')
" Comment out any `packadd` to not (lazy) load that plugin
lua require('user/lualine')
lua require('user/dashboard')
""" Load Misc. plugins / config
lua require('user/lsp')
lua require('user/null-ls')
lua require('user/inlay-hints')
packadd plenary.nvim
packadd telescope.nvim
lua require('user/telescope')
packadd nvim-tree.lua
lua require('user/nvim-tree')
lua require('user/gitsigns')
