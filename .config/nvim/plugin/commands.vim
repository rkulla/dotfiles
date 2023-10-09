" So `:SE foo` finds exact word `foo`. NOTE: vim regex is \<foo\> not \bfoo\b
command! -nargs=1 SE execute 'normal! /\<' . <q-args> . '\><CR>'

" Make :GBrowse work by setting my own :Browse command
command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)

" Open any file in a floating window (uses my custom myfloat.lua function)
command! -nargs=1 FloatingOpen :lua require'user.myfloat'.open_file_in_floating_window(<q-args>)<CR>

" Open a terminal in a floating window (uses my custom myfloat.lua function).
" Mapped to <Leader>5
command! TermFloat lua require'user.myfloat'.open_term_in_floating_window()
