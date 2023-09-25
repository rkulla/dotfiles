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
autocmd User TelescopePreviewerLoaded setlocal number " Make file numbers work in Telescope's preview window

" So `:SE foo` finds exact word `foo`. NOTE: vim regex is \<foo\> not \bfoo\b
command! -nargs=1 SE execute 'normal! /\<' . <q-args> . '\><CR>'

""" I put some configs in plugin/ (still loads on startup) to keep this file small
" COLOR SCHEME:          plugin/colorscheme.vim
" COMPLETION:            plugin/completion.vim
" MARKDOWN:              plugin/markdown.vim
" TERMINAL:              plugin/terminal.vim

""" Keymaps - Defines my <leader> key so it MUST go above all my other lua files!
lua require('user/keymaps')

""" Plugin Initialization (requires: Packer)
" Loads ~/.config/nvim/lua/user/plugins.lua (LIST of plugins I include). Then run one of
"   :PackerInstall (just install new plugins added to user/plugins.lua)
"   :PackerUpdate (just update existing plugins)
"   :PackerSync (Install+Update plugins)
" AND run:
" :PackerCompile (regenerate plugin cache file: ~/.config/nvim/plugin/packer_compiled.lua)
lua require('user/plugins')

""" Plugin custom config files
" Comment out any `packadd` to not load that plugin
" Only plugins that have opt=true in user/plugins.lua will go to /opt (be lazyloaded)
lua require('user/lualine')
lua require('user/flash')
lua require('user/indent-blankline')
lua require('user/symbols-outline')
lua require('user/navbuddy')
lua require('user/barbecue')
lua require('user/lsp')
lua require('user/null-ls')
lua require('user/oil')
packadd telescope.nvim
lua require('user/telescope')
lua require('user/bqf')
lua require('user/goto-preview')
lua require('user/nvim-tree')
lua require('user/gitsigns')
lua require('user/inlay-hints')
lua require('user/vim-signature')
