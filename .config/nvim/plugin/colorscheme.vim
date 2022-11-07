" Setting `termguicolors` means we'll use guifg/guibg not cterm.
" Since some colorschemes reference &termguicolors, set this first
if $TERM !~ 'rxvt\|linux' && (has("termguicolors"))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Overrides
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

" Default colors
colorscheme tokyonight
" Explicitly default to the light version to avoid flickering on nvim startup
" Automatic/default configs don't, so I run `:Dark` when needed
colorscheme tokyonight-day

" Make it so you can just type :Dark to use my dark theme
" And :Light to go back to my normal theme
function! Dark()
  colorscheme tokyonight-storm
  set bg=dark
endfunction
command! -nargs=0 Dark call Dark()
function! Light()
  color tokyonight-day
  set bg=light
endfunction
command! -nargs=0 Light call Light()
