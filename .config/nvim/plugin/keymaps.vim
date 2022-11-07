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


""" Copying currently open file names to the clipboard
" Copy current buffer's relative path (useful to paste for CLI args)
nnoremap <leader>cp :let @+ = @%<cr>
" Copy just the current filename without path
nnoremap <leader>cn :let @+ = expand('%:t')<cr>
" Copy all currently open files' relative paths to copy/paste to reopen vim without :mks
nnoremap <leader>cl :let @+ = join(map(split(execute('ls'),"\n"),{_,x->split(x,'"')[1]}))<cr>

