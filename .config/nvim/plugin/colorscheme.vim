
" Overrides
func! s:MyHighlights() abort
  " Make it so my window borders are visible in my colorscheme
  hi winseparator guifg=bold guibg=bg
  " Change the color of the current line number
  set cursorline | hi CursorLine gui=bold | hi CursorLineNr guifg=#819090 guibg=NONE
  " Make line numbers italic (see my terminfo notes for enabling on MacOS)
  hi LineNr gui=italic
endfunc
au ColorScheme * call s:MyHighlights()

" Flash.nvim color highlighting functions
function! s:setFlashLight()
    hi FlashMatch guibg=magenta guifg=white " distinguish from / Search colors
    hi FlashCurrent guibg=lightgreen guifg=black gui=bold " first match
    hi FlashLabel guibg=yellow guifg=black gui=bold
endfunction

function! s:setFlashDark()
    hi FlashMatch guibg=magenta guifg=white " distinguish from / Search colors
    hi FlashCurrent guibg=lightgreen guifg=black gui=bold " first match
    hi FlashLabel guibg=yellow guifg=black
endfunction

command! SetFlashLight call s:setFlashLight()
command! SetFlashDark call s:setFlashDark()

" Default colors
" colorscheme catppuccin-macchiato
colorscheme catppuccin-latte

" Make it so you can just type :Dark to use my dark theme
" And :Light to go back to my normal theme
function! Dark()
  colorscheme catppuccin-macchiato
  set background=dark
  SetFlashDark
endfunction
command! -nargs=0 Dark call Dark()
function! Light()
  color catppuccin-latte
  set background=light
  SetFlashLight

endfunction
command! -nargs=0 Light call Light()

