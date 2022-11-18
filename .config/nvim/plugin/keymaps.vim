""" MISC maps (See the plugin section below for plugin-specific maps)
" Try to group things by "namespaces", e.g., all window mappings start with <Leader>w, etc.
" Only <Leader>n I accept to be a single char unnamespaced, since it will have a  delay.

" Remap <Leader> to spacebar
" Note: I sometimes use , as a secondary or fallback key
let mapleader = " "                                  
nnoremap <SPACE> <Nop>

" Close / escape / delete words faster
nmap X :q<CR>
imap jj <esc>
imap ;; <C-w>

" Close read or write buffers quicker 
nnoremap <Leader>q :bw<CR>

" toggle line numbers
map <Leader>n :set invnumber<CR>                    

" Keep cursor where it is after * search of current word
noremap * *``

" ^n and ^p for next and prev buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
nmap <Leader><Leader> <c-^>

" ^s to save file in command or insert mode
imap <C-s> <C-o>:update!<CR>
nmap <C-s> :update!<CR>

" Auto-select text what was just pasted (gv for last selected)
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


""" Split windows
" :Clear to close the current file w/o closing the split, then starts a new file
com! Clear :enew <bar> bdel #
" F2 to close the current file w/o closing the split, then jumps to the next file
nmap <F2> :bn <bar> bd #<CR>
" Toggle between splits
nnoremap <Leader>ww <C-w>w
" Move windows
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wj <C-w>j
" Resize windows 
nmap <Leader>wH :vertical res -5<CR>
nmap <Leader>wL :vertical res +5<CR>
nmap <Leader>wK :res -5<CR>
nmap <Leader>wJ :res +5<CR>

" To "fullscreen" the current split window buffer. When done, :q or :tabc and get back to the previous "viewport"
" Think of wz as standing for 'window zoom'. It just opens a new tab window split window. Close tab when finished
nnoremap <Leader>wz <cmd>tab split<cr>

"""""""""""""""""""""""" PLUGIN SPECICIC MAPS """""""""""""""""""

""" Nvim-tree
nnoremap <Leader>e :NvimTreeFindFileToggle<CR>
nnoremap <Leader>nf :NvimTreeFindFile<CR>
nnoremap <Leader>nc :NvimTreeCollapse<CR>


""" Fugitive
nnoremap gst :G status<CR>


""" Gitsigns
" These maps are in my gitsigns.lua


""" Telescope
nnoremap <leader>fx <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>x <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap ,x <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fX <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>X <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap ,X <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>ag <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fk <cmd>lua require('telescope.builtin').keymaps()<cr>
""" Some stuff I don't bother mapping and can just run :Telescope such as:
" :Tel[tab] git[tab]  (commits, branches, etc)


