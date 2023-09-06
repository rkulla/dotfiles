" Make it so :term commands start in insert mode, so I can interact with TUI apps, etc.
autocmd TermOpen term://* startinsert
autocmd TermEnter term://* startinsert  

" Don't enable the following autocmd because it's annoying when switching
" buffers. When I switch back to a terminal buffer just :startinsert to
" interact again. I map that to <spc>si. And JJ to escape terminal-mode
"autocmd BufEnter term://* startinsert
