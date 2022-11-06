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
