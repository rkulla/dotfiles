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


""" Convenient mappings
nmap X :q<CR>
imap jj <esc>
imap ;; <C-w>
" toggle line numbers
map <Leader>n :set invnumber<CR>                    
" Keep cursor where it is after * search of current word
noremap * *``
" ^n and ^p for next and prev buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
" ^s to save file in command or insert mode
imap <C-s> <C-o>:update!<CR>
nmap <C-s> :update!<CR>
" Auto-select text that was just pasted
nmap <Leader>sp `[v`]
" `` to toggle last cursor position
noremap <LeftMouse> m'<LeftMouse>


""" Plugins (Needs Packer installed)
" Load ~/.config/nvim/lua/plugins.lua
lua require('user/plugins')
" Simply comment out any packadd lines below to disable that plugin
packadd vim-surround
packadd vim-fugitive
packadd tokyonight.nvim
packadd lualine.nvim
lua require('user/lualine')


""" Colorscheme
" Setting `termguicolors` means we'll use guifg/guibg not cterm.
" Since some colorschemes reference &termguicolors, set this first
if $TERM !~ 'rxvt\|linux' && (has("termguicolors"))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Put any colorscheme overrides in this function
func! s:MyHighlights() abort
  set termguicolors
  " Make it so my window borders are visible in my colorscheme
  hi winseparator guifg=bold guibg=bg
  " Change the color of the current line number
  set cul | hi CursorLine guibg=NONE | hi CursorLineNr guifg=#819090 guibg=NONE
  " Make line numbers italic (see my terminfo notes for enabling on MacOS)
  hi LineNr gui=italic
endfunc
au ColorScheme * call s:MyHighlights()

colorscheme tokyonight

