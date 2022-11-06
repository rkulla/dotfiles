" Make it so :term commands start in insert mode, so I can interact with TUI apps, etc.
autocmd TermOpen term://* startinsert
autocmd TermEnter term://* startinsert  
autocmd BufEnter term://* startinsert
