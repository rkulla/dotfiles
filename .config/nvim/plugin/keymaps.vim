""" MISC maps (See the plugin section below for plugin-specific maps)

" Remap <Leader> to spacebar
let mapleader = " "                                  
nnoremap <SPACE> <Nop>

" Close / escape / delete words faster
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

" Toggle winbar on/off - mainly while split window editing
nnoremap <leader>wb :call ToggleWinbar()<cr>
function! ToggleWinbar()
    if &winbar == ''
        set winbar=%=%m\ %f
    else
        set winbar=
    endif
endfunction


""" Copying currently open file names to the clipboard
" Copy current buffer's relative path (useful to paste for CLI args)
nnoremap <leader>cp :let @+ = @%<cr>
" Copy just the current filename without path
nnoremap <leader>cn :let @+ = expand('%:t')<cr>
" Copy all currently open files' relative paths to copy/paste to reopen vim without :mks
nnoremap <leader>cl :let @+ = join(map(split(execute('ls'),"\n"),{_,x->split(x,'"')[1]}))<cr>

"""""""""""""""""""""""" PLUGIN SPECICIC MAPS """""""""""""""""""

""" Telescope
nnoremap <leader>fx <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>x <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fX <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>X <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>ag <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fk <cmd>lua require('telescope.builtin').keymaps()<cr>
""" Some stuff I don't bother mapping and can just run :Telescope such as:
" :Telescope git_[tab]  (commits, branches, etc)


""" Nvim-tree
nnoremap <Leader>e :NvimTreeFindFileToggle<CR>
nnoremap <Leader>nf :NvimTreeFindFile<CR>
nnoremap <Leader>nc :NvimTreeCollapse<CR>
