" So `:SE foo` finds exact word `foo`. NOTE: vim regex is \<foo\> not \bfoo\b
command! -nargs=1 SE execute 'normal! /\<' . <q-args> . '\><CR>'

" Make :GBrowse work by setting my own :Browse command
command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)
