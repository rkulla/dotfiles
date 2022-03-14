" Ryan's vimrc

" Stuff that has to run _before_ plugins are loaded

" Put first to ensure pathogen will work
if has("gui_running")                               " list plugins to disable if GUI Vim is running
  let g:pathogen_disabled = []
  call add(g:pathogen_disabled, 'coc')
endif
execute pathogen#infect()

let g:loaded_matchit = 1
let g:matchup_matchparen_offscreen = { 'method': 'popup', 'scrolloff': 1 }

let mapleader = ","                                 " remap <Leader> to comma so you can do: ,s instead of \s, etc.
set dir=~/.vim/swp                                  " My .swp file location
set nocompatible                                    " Prevent unexpected things your distro might make
set clipboard+=unnamed                              " So y to yank text goes to system clipboard, in tmux or otherwise
set ffs=unix,dos,mac                                " Auto-detect the filetype based off newlines used.
set history=50                                      " Keep 50 lines of command line history
set ruler                                           " Show the cursor position all the time
set showcmd                                         " Show partial vim commands in the last line of the screen
set incsearch                                       " Do incremental searching
set shortmess=filnxtToOc                            " Don't add S or you won't see search counts in status, e.g., [1/2]
set backspace=indent,eol,start                      " Allow backspacing over everything in insert mode
set path+=**                                        " Allow :find, :tabf, etc to search the pwd and its subdirs
set hidden                                          " To change buffers without having to save modified ones first
set ignorecase                                      " Allow case-insensitive /searching
set timeoutlen=1000 ttimeoutlen=0                   " Make Esc key a lot faster, e.g., closing fzf
set tabpagemax=30                                   " So :tab ball will open up to 30 tabs instead of default 10
set nobackup                                        " I don't like it triggering my file system watchers
set number                                          " Enable line numbers by default
set nostartofline                                   " So cursor doesn't jump to beginning of line when you G, GG, ^F, etc
set confirm                                         " So :q, :bd, etc. on a changed file popups a 'save file?' confirm box
set fo=t                                            " I don't want the format options that auto create comments
set enc=utf-8                                       " Causes fencs to default to ucs-bom,utf-8,default,latin1
set pastetoggle=<F3>                                " Useful when normal pasting doesn't work

" spellcheck
set spelllang=en_us
set spellfile=$HOME/.vim/spell/en.utf-8.add
autocmd BufRead,BufNewFile *.txt,*.md setlocal spell

" Make it easier to see your cursor in console vim
" tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Rename the current file with :Rename <new_name>
command! -nargs=1 -complete=dir Rename saveas <args> | call delete(expand("#"))

" Run the omni-completion by typing ,tab
imap <Leader><TAB> <C-X><C-O>

" Have ^l clear all highlighted text on the screen
nnoremap <C-l> :nohl<CR><C-l>

" So typing jj Escapes to normal mode. More ergonomic than reaching for Esc.
imap jj <esc>

" So typing ';;' in insert mode deletes the last word
imap ;; <C-w>

" So typing ';h' in insert mode to jump to start of line
imap ;h <Esc>I

" To [c to jump to next quckfix item, ]c for previous.
" Don't map things to ]c or ]c because they're already used for things like
" jumping to next change/diff item
nnoremap <End> :cnext<CR>
nnoremap <Home> :cprevious<CR>

" To quickly open files in the pwd, or its subdirs, automatically by typing substrings of filenames
map <Leader>e :e **/*

"
" Quitting vim maps
"
nmap <Leader>qq :q<CR>
" Don't use Ex mode, use Q for formatting
map Q gq
" So I can just type X to do the same thing as :q (prompt to save changes first)
if has("gui_running")
  " Do :bw instead in a gui since I use tabs there
  nmap X :bw<CR>
else
  " Note: My NerdTree notes explain how to also get X to close NERDTree.
  nmap X :q<CR>
endif

" So shift+up scrolls up from current cursor position without moving cursor upward
nmap <S-up> 1<C-u>
" So shift+down scrolls down from current cursor position without moving cursor downward
nmap <S-down> 1<C-d>

" Highlight words under cursor but keep the cursor where it is
noremap * *``

" So F10 will auto-scrollbind all windows so windows scroll in sync with eachother
map <F10> :windo set scrollbind!<CR>

" Toggle the showing of line numbers
map <Leader>n :set invnumber<CR>

" Use Ctrl+n and Ctrl+p to go forward or backward through buffers.
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

" Force file to be saved when ctrl+s is hit in command or insert mode.
" put "stty -ixon" in your shell rc for this to work in unix.
imap <C-s> <C-o>:update!<CR>
nmap <C-s> :update!<CR>

" Automatically select the last text that was pasted
nmap <Leader>sp `[v`]

" So Ctrl+a does nothing instead of incrementing numbers (safer for tmux/gnu-screen)
map <c-a> <Nop>

" So if you click somewhere else on a page, you can type `` to get back to the last cursor position.
" Useful for when the cursor position changes when you click a vim window to focus the window.
noremap <LeftMouse> m'<LeftMouse>

" Make it so you can delete the contents of the first occurence of () on a line and insert there
" Useful when on nested parens lines where ci( wouldn't work.
nnoremap <Leader>( 0%ci(

""" Abbreviations (misc)
iab teh      the
iab loremx   lorem ipsum quia dolor sit amet consectetur adipisci velit, sed quia non numquam eius modi tempora incidunt.
iab fbbq     foo bar baz qux quux spam eggs

""
"" Indentation
""

set ts=4                                            " Make tabs 4 spaces
set expandtab                                       " So tab key writes spaces. (Ctrl+V<TAB> for real tabs)
set smarttab                                        " So tab key uses sw not ts at start of line and so backspace deleting
set sw=4                                            " When auto-indenting, appear as 4 <spaces>
set shiftround                                      " So > and < indenting keys snap to value of sw
" So txt files don't use shiftround (so i can paste code snippets and indent them properly)
au BufNewFile,BufRead,BufEnter *.txt set noshiftround
set autoindent " Make indents always from the start of the line above. Beats :set cindent
if has("autocmd")
  " Enable file type detection. Use the default filetype settings. 'cindent' on C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=139
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  augroup END
endif

""" Terminal window
" So ,tb opens a terminal at the bottom in its own window
nnoremap <leader>tb :below term<CR>
" So ,ta opens a terminal at the top in its own window
nnoremap <leader>ta :above term<CR>

" vim-qf plugin improves quickfix window. Make it so the plugins mappings work
let g:qf_mapping_ack_style=1

" vim-signature (use my fork)
" so typing ,mn creates a mark N and highlights line. Clear with :match
nnoremap <silent> <Leader>mn mN:execute 'match Search /\%'.line('.').'l/'<CR>

""
"" VCS / Git (note: other maps are in the coc section)
""

nnoremap gst :Gstatus<CR>
" Tooltips to show commit message and git blame of cursor position
" Uses ~/.vim/autoload/git.vim
noremap <silent> <Leader>gc :call git#show_commit(v:count)<CR>
noremap <silent> <Leader>gb :call git#blame()<CR>


""
"" Statusline
""
set laststatus=2
" Get and truncate long git branch names or not display one if window width is too short.
function! CocGitStat()
    let status = get(g:, 'coc_git_status', '')
    let ccount = strchars(get(g:, 'coc_git_status', ''))
    " truncate if branch name is too long
    if ccount > 0
        let truncatedLeast = ccount > 35 ? status[0:59] . '…' : status

        " if window is too narrow truncate even further
        let winwid = winwidth(0)
        if winwid <= 79
            let status = ccount > 10 ? status[0:20] . '…' : status
        elseif winwid >= 80 && winwid <= 89
            let status = ccount > 23 ? status[0:33] . '…' : status
        elseif winwid >= 90 && winwid <= 100
            let status = ccount > 30 ? status[0:40] . '…' : status
        else
           let status = truncatedLeast
        endif
    endif
    return status
endfunction

set statusline=%n\%{StatuslineMultiFileFlag()}\ %f\   " Num buffers, file
set statusline+=%h%m%r%w  " help, modified, readonly and preview flags , e.g. [+] if modified
set statusline+=%P\  " percent of current line in file
set statusline+=%{CocGitStat()}\  " git branch
set statusline+=%=  " start right-aligning any further set statusline+= lines below
set statusline+=%l:%c%V\  " line number, column number/virtual column number
set statusline+=%o\ \\|\  " byte number of current char
set statusline+=%{!empty(&fenc)?&enc:'none'},%{&fileformat}\ " encoding, format

" Function to add to 'set statusline', via %{StatuslineMultiFileFlag()} above,
" to see how many buffers are currently open without having to type ':ls'
autocmd bufadd,bufdelete * unlet! g:statusline_multi_file_flag
function! StatuslineMultiFileFlag()
    if !exists('g:statusline_multi_file_flag')
        let num_files = 0
        for i in range(1, bufnr("$"))
            if buflisted(i) && getbufvar(i, '&buftype') == ''
                let num_files += 1
            endif
        endfor

        if num_files > 1
            let g:statusline_multi_file_flag = '/' . num_files
        else
            let g:statusline_multi_file_flag = ''
        endif

    endif
    return g:statusline_multi_file_flag
endfunction

""
""Color Schemes and highlighting
""

" Setting termguicolors means we'll use guifg/guibg not cterm and
" since some colorschemes reference &termguicolors and not set any
" gui* colors, we'll set it before calling a color scheme.
if $TERM !~ 'rxvt\|linux' && (has("termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Put any overrides here for things my colorscheme doesn't support, such
" as italics or certain parts of misc languages
func! s:MyHighlights() abort
    set termguicolors
    " change the color of the current line number
    set cul | hi CursorLine ctermbg=NONE guibg=NONE | hi CursorLineNr ctermfg=0 guifg=#819090 guibg=NONE
    " To still see coc-tsserver auto-highlight all references under cursor
    hi cursorColumn guifg=NONE guibg=#ebdbb2
    " Make line numbers italic (see my terminfo notes for enabling on MacOS)
    hi LineNr cterm=italic
endfunc

au ColorScheme * call s:MyHighlights()
colorscheme gruvbox8

" Make it so you can just type :Dark to use my dark theme
" And :Light to go back to my normal theme
function! Dark()
  color flattened_dark
  set bg=dark
endfunction
command! -nargs=0 Dark call Dark()
function! Light()
  color gruvbox8
  set bg=light
endfunction
command! -nargs=0 Light call Light()

" Enable on rainbow brackets
let g:rainbow_active=1

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Make it so you can identify color group names of item under cursor by pressing ,$
nmap <silent> <Leader>$ :echo 'hi<' .
        \ synIDattr(synID(line('.'), col('.'), 1), 'name') .
        \ '> trans<' . synIDattr(synID(line('.'), col('.'), 0), 'name') .
        \ '> lo<' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') .
        \ '>'<CR>

""" fzf
set rtp+=/usr/local/opt/fzf
" Enable history with CTRL-N and CTRL-P
let g:fzf_history_dir = '~/.local/share/fzf-history'
nmap <Leader>x :GFiles<CR>
nmap <Leader>X :Files<CR>
nmap <Leader>bl :BLines<CR>
nmap <Leader>bL :Lines<CR>
nmap <Leader>bt :BTags<CR>
nmap <Leader>bT :Tags<CR>
nmap <Leader>bc :BCommits<CR>
nmap <Leader>bC :Commits<CR>
nmap <Leader>ls :Buffers<CR>
nmap <Leader>ag :Ag<CR>

""" Ruby
au BufNew,BufRead,BufEnter *.rb set textwidth=79 fo=t sw=2 ts=2
autocmd FileType ruby map <Leader>l :w<CR>:!ruby -c %<CR>

""" Golang
" Have Go files always show as 4 spaces each yet still be real tabs
au BufRead,BufNewFile *.go set noet ts=4 sw=4
" Automatically add or remote import statements on save
let g:go_fmt_command = "goimports"
" Highlight methods like fmt.Println in vim-go
let g:go_highlight_methods = 1
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>l <Plug>(go-run)
au FileType go nmap <leader>te <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>cb :GoCoverageBrowser<CR>
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gdb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)
nnoremap <leader>a :cclose<CR>
" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>


""" Python
au BufNew,BufRead,BufEnter *.py set textwidth=79 fo=t sw=4 ts=4
" Have ,l run :!python %
autocmd FileType python map <Leader>l :w<CR>:!python %<CR>
iab ppxx   import pprint;pprint.pprint()

""" Markdown
let g:markdown_folding = 1
if has("autocmd")
    augroup MarkdownFileFolds
    au!
    " I don't want it to show folds by default, just later when i zM
    autocmd FileType markdown set foldlevel=99
    " I want .md files to have be tw=131
    autocmd FileType markdown setlocal textwidth=131
    augroup END
endif

""" JSON
" Note: Use my <Leader>sf to toggle syntax folding to fold json files!
" Make it so ,jp runs :JsonPath
au FileType json nmap <leader>jp :JsonPath<CR>

""
"" JavaScript / Node.js
""

" Only use only 2 spaces for indentations
autocmd BufRead,BufNewFile *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html setlocal sw=2 ts=2
" Use my common map of ,l to run a language on the current file (saving " changes first)
autocmd FileType javascript map <Leader>l :w<CR>:!node %<CR>
" Syntax check current javascript file
autocmd FileType javascript map <Leader>sc :w<CR>:!node --check %<CR>

" So ,jf will list all JS functions in the file. Type :<linenumber> to jump to the definition
map <Leader>jf :g/^const\s*\(\w\+\)\s*=\s*\%(async\s*\)\?(\(\_[^)]\{-}\))\\|^function \\|^async function /<CR>
map <Leader>jfm :g/^const\s*\(\w\+\)\s*=\s*\%(async\s*\)\?(\(\_[^)]\{-}\))\\|^function \\|^async function /normal m1<CR>

" vim-dispatch
" disable default maps (:h dispatch-maps) so m? can work for my ,jfm map, etc
let g:dispatch_no_maps = 1

""" vim-javascript
" Toggle code folding. JS folding requires vim-javascript. Should work with any file type supporting syntax folding
nnoremap <leader>sf :call ToggleSyntaxFolding()<cr>
function! ToggleSyntaxFolding()
    if &foldmethod == 'marker'
        setlocal foldmethod=syntax
    else
        setlocal foldmethod=marker
    endif
endfunction


""" Typescript
" Compile/run the current file on the fly
au FileType typescript map <Leader>l :w<CR>:!npx ts-node %<CR>

""" Jest
" Make it so typing ,jt runs jest on the current file
" I use make instead of vim-dispatch because dispatch's tmux adapter strips
" colors and it's just not worth seeing tests run slower and in a split
" window, autoclose the window, etc.
" Just clear the quickfix window with my ctrl+l map after returning to vim or
" use --no-colors but I prefer colors.
set makeprg=npx\ jest\ --colors
nnoremap <leader>jt :make %<cr>
" However, running jest in vim isn't usually worth it. Instead use my ,fp map to
" copy the file path to the clip board and paste to jest on the cli

" So ,il enables :IndentLines-like vertical lines on tabs. (Toggle on/off from there with :set list!)
nnoremap <leader>il :set list lcs=tab:<bslash><bar><bslash><space><bar>hi SpecialKey ctermbg=NONE ctermfg=gray<cr>

""" Quickfix window
" So after typing something like :0Gclog, I can scroll load the next or prev result while not being focused on the
" qf window and maintain my cursor position in the file
nnoremap ]q :let ws = winsaveview() <bar> cnext <bar> call winrestview(ws) <bar> unlet ws<CR>
nnoremap [q :let ws = winsaveview() <bar> cprev <bar> call winrestview(ws) <bar> unlet ws<CR>


""" Copying currently open file(s) to the clipboard
nnoremap <leader>fp :let @+ = @%<cr>
" Copy just the filename without the directory path
nnoremap <leader>fn :let @+ = expand('%:t')<cr>
" Copy all the currently open files to copy/paste to reopen vim without :mks
nnoremap <leader>fl :let @+ = join(map(split(execute('ls'),"\n"),{_,x->split(x,'"')[1]}))<cr>


""" vim-slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

""" nnn
" Set my own mappings
let g:nnn#set_default_mappings = 0
nnoremap <silent> <leader>nn :NnnPicker<CR>
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

""
"" HTML
""

" So ,o opens urls in browser (since gx is currently broken in netrw/macvim)
function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "Dispatch open " . shellescape(s:uri)
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>o :call HandleURL()<cr>

" So typing :Dispatch on an html file opens it in the web browser
autocmd FileType html let b:dispatch = 'open %'

" So in visual mode you can do a multiline html comment <!-- -->
vnoremap <Leader>! <Esc>'<lt>O<!--<ESC>'>o--><ESC>

""
"" PHP
""

" Zend Coding Standard
au BufNew,BufRead,BufEnter *.php set textwidth=80 fo=t sw=4 ts=4
" or put 'set fo+=t' in .vim/after/indent/php.vim for tw to break the line

" phpcomplete completion:
autocmd FileType php set omnifunc=phpcomplete

" So php files are also seen as html
au BufRead,BufNewFile *.php set filetype=php.html

" PHPUnit
" So typing ":Test" will run phpunit on the current file, with good options
au FileType php com! Test :!phpunit --verbose --colors %
au FileType php nmap <Leader>tv :!phpunit --verbose --colors %<CR>
au FileType php nmap <Leader>te :!phpunit --testdox %<CR>

" So you can find all variables/objects that start with $ on the page
nmap <Leader>fv /$[a-zA-Z_][^ \t\]()?;]*<CR>
" To var_dump() a variable
au FileType php nmap <Leader>vv 0i<Space><Esc>0f$yeuovar_dump(<C-r>");<Esc>
" To wrap a var_dump around a function that's on its own line do (requires surround.vim)
au FileType php nmap <Leader>vf yssfvar_dump<Esc>f;xa;<Esc>
" To run the current script through the php linter to check for syntax errors
au FileType php map <Leader>l :w<CR>:!php -l %<CR>
" In visual mode, do a multiline /* */.
vnoremap <Leader>c <Esc>'<lt>O/*<ESC>'>o*/<ESC>
" In visual mode, do a multiline php-html comment <?php /* */ ?>
" (useful when you don't want your html comment content viewable in browser)
au FileType php vnoremap <Leader>!! <Esc>'<lt>O<?php /*<ESC>'>o*/?><ESC>
" To put inline php tags around the current line
au FileType php nmap <Leader>? I<?php <Esc>A ?>

" Time and date insertion mappings. Super convenient!
noremap! <expr> ,t strftime("%H:%M")  " e.g., 11:25
noremap! <expr> ,ts strftime("%H:%M:%S")  " includes seconds
noremap! <expr> ,td strftime("%Y-%m-%d")  " e,g., 2019-03-29
" ,tf for first of this month, e.g., 2019-03-01
noremap! <expr> ,tf
          \ strftime("%Y") + strftime("%m") / 12 . "-" .
          \ repeat('0', 2-len(strftime("%m") % 12)) .
          \ strftime("%m") % 12 .
          \ "-01"
" Evernote style date and time insertion. Inserts date format: 10/01/2009 12:08 AM
nmap <Leader>et i<C-R>=strftime('%m/%d/%Y %I:%M %p')<Esc>

""" Grep
" Use ag for :grep in vim, eg ':grep -i --py foo'
" Use ":grep!" to avoid opening files.
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

""" :Sex
" Make :Sex window take up most of the screen so you can see more files at once
let g:netrw_winsize=35
" Sort case-insensitively (so Program Files appears next to pf, etc)
let g:netrw_sort_options="i"

""" TagBar (https://majutsushi.github.io/tagbar/)
nmap <F8> :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/usr/local/Cellar/ctags/5.8_1/bin/ctags'
" Make it so ,wf shows the name of the function you're currently in
nmap <Leader>wf :TagbarCurrentTag<CR>

""" vim-gutentags
" By default it only looks for SCM projects (.git, .svn, .hg, etc) to generate
" tags, but since i might have nested JS projects or only tmp files that have
" index.js I'll make my own files to look for to dictate a project:
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', 'index.js', 'app.js', '.git', '.svn', '.hg' .'project']
" Store 'tags' files in ~/.cache/vim/ctags/ instead of the project's root
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
" See "ctags" show up in statusline whenever tags are generating
set statusline+=%{gutentags#statusline()}

""" Fonts
if has('unix') && has('gui')
    " Type: ":set gfn=<tab>" which will fill in the current font so you can
    " just change the size or gfn=* to open a font dialog.
    " Note that iTerm2's font will override the MacVim CLI vim I use. So in my
    " iTerm2 profile set a good font like Hack Nerd Font.
    if system('uname')=~'Darwin'
      " All vims, including Gvim and Macvim, only support Monospaced Fonts.
      " I use MacVim GUI for reading text files, so use Monaco
      set gfn=Monaco:h16
    elseif has('x11')
      set gfn=Droid\ Sans\ Mono\ 11
    endif
endif

""" GUI
" turn certain gui options on/off.  += turns on -= turns off
set go-=m "no menubar (File, Edit, Tools, Syntax, Buffers, Window, Help)
set go-=T "no toolbar
set go-=t "no tearoff menus
set go-=r "no right hand scrollbar always present
set go-=l "no left hand scrollbar always present
set go-=R "no right hand scrollbar when windows are split vertically
set go-=L "no left hand scrollbar when windows are split vertically
set go-=b "no bottom (horizontal) scrollbar present

""" Menus
" allow a console based menu system by hitting F4:
source $VIMRUNTIME/menu.vim
set wildmenu " makes command-line completion operate in an enhanced mode
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

""" Tree(1)
" Make it so ,pt sets path to the value of line #1 header. Useful for my fd -tree.txt files
nmap <Leader>pt :let &path=getline(1)<CR>

""" NERDTree
" auto-start NerdTree when you run vim with no command line arguments
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" make ctrl+e start NerdTree if it's closed, and again will toggle it off.
nmap <C-e> :NERDTreeToggle<CR>
" ignore the following diretories and files
let NERDTreeIgnore = ['node_modules', 'coverage', '\.git$', '\.yardoc', 'jsdoc', 'tags.*', 'log', '\.DS_Store$', '\.so$', '\.date$', '\.pyc$']
" Make it so ,nf loads the current file i'm on in nerdtree
nnoremap <silent> <Leader>nf :NERDTreeFind<CR>
" get rid of crap at the top
let NERDTreeMinimalUI = 1

" Mouse  (Make sure to enable "Mouse Reporting" in iTerm2 profiles
" For dragging split windows or double-clicking files in NerdTree
if exists("+mouse")
    set mouse=a
    set ttymouse=sgr
endif

""
"" Split windows
""

" So ,H resizes a split vertical window to be smaller. ,L for larger, etc. ,K for smaller horizontal, ,J for larger horizontal
nmap <Leader>H :vertical res -5<CR>
nmap <Leader>L :vertical res +5<CR>
nmap <Leader>K :res -5<CR>
nmap <Leader>J :res +5<CR>

" Close the current file by typing :Clear w/o closing the split window and starts a new file
com! Clear :enew <bar> bdel #
" Close the current file by typing F2 w/o closing the split window then jumps to the next file
nmap <F2> :bn <bar> bd #<CR>
" So Wh moves to the window to the left and Wl moves to the right, etc.
" Note that ^ww already toggles between split windows
nmap Wh <C-w>h
nmap Wl <C-w>l
nmap Wk <C-w>k
nmap Wj <C-w>j

" To "fullscreen" the current split window buffer. When done, :q or :tabc and get back to the previous "viewport"
" Think of gz as standing for 'go zoom'. It just opens a new tab window split window. Close tab when finished
nnoremap gz <cmd>tab split<cr>


""
"" My custom .txt notes format settings
""
set foldenable
set foldmethod=marker
" Fold expression that auto folds any lines starting with '*' until the next line that starts with a '*' is found
" Useful for my custom .txt Notes format
function! FoldExpr(lnum)
    let line = getline(a:lnum)
    if line =~ '^\*'
        return '>1'
    endif
    return '='
endfunction

if has("autocmd")
    augroup TextFileFolds
    au!
    " use fold expressions on our FoldExpr function
    autocmd BufRead,BufNewFile *.txt setlocal foldmethod=expr foldexpr=FoldExpr(v:lnum)
    augroup END
endif

" So you can underline any line of text you are on with dashes
nmap <Leader>u :call append(line("."), repeat("-", len(getline("."))))<CR>

" So ,<space> Moves all text behind cursor one space forward (w/o moving text in front),
" useful for aligning text to the cursor position
nmap <Leader><Space> d0p

" In insert mode, typing 2 commas will insert 30 spaces. 3 commas inserts 50.
imap ,, <Space><Esc>30i<Space><Esc>i
imap ,,, <Space><Esc>50i<Space><Esc>i

" So typing ':Beg foo' search for the string foo occuring within the first 30 chars of a line
function! BegSearch(strtofind)
  call search(a:strtofind.'\%<31c')
endfunction
command! -nargs=1 Beg call BegSearch(<f-args>)

""" So hitting <enter> on filename jump to the pattern after # comment:
" For example: Hitting enter on the following line jumps to foo.txt's line
" containing bar:
"   foo.txt # bar
" Make sure to hit enter on the filename itself. Also allows gf to still work.
function! GotoPattern() abort
  let file = expand('<cfile>')
  if ! getline('.') =~ '/'..file..'\s\+#\s+'..'/'
    return execute('normal gf')
  endif
  let pattern = split(substitute(getline('.'),'.*#\s*','',''),' ')[0]
  return execute('vimgrep ' .. pattern .. ' ' .. file)
endfunction

nnoremap <enter> <cmd>call GotoPattern()<cr>

""" Misc folding settings
" To toggle '#' comments as folds (useful for config files and ruby/python/bash especially)
function HideComments()
  set fdm=expr
  set fde=getline(v:lnum)=~'^\\s*#'?1:getline(prevnonblank(v:lnum))=~'^\\s*#'?1:getline(nextnonblank(v:lnum))=~'^\\s*#'?1:0
endfunction
map <Leader>h :call HideComments()<CR>

" Make it so searches don't open folds automatically
set foldopen-=search
" Make it so ,fs folds the current file based on its syntax
nmap <Leader>fs :set foldmethod=syntax<CR>
" Make it so ,fc folds the // style comments
nmap <Leader>fc :set foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*//'<CR>

""" DBext
" Kata profiles.  Uses ~/.pgpass for password
let g:dbext_default_profile_kata_PG = 'type=PGSQL:user=dev_db_user:dbname=kata'
let g:dbext_default_profile_kata_MYSQL = 'type=MYSQL:user=dev_db_user:passwd=p4ssw0rd:dbname=kata'

""" Automatically leave insert mode after 'updatetime' milliseconds of inaction
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=90000
au InsertLeave * let &updatetime=updaterestore

" indentLine plugin config
" disable by default. Enable with :IndentLinesToggle
let g:indentLine_enabled = 0
" Disable quote concealing in JSON files or it strips quotes
let g:vim_json_conceal=0
let g:indentLine_char_list = ['|', '¦', '┆', '┊', '┊']

""" Elm-lang
" Auto-format code. Requires ElmCast/elm.vim and elm-oracle
let g:elm_format_autosave=1
" disable keybindings since they use <Leader> maps i already have
let g:elm_setup_keybindings = 0

""
"" coc.vim
""

if !has("gui_running") " Since we do NOT run coc.vim if the GUI vim (see top of file)
  " Some servers have issues with backup files, see #649
  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[C` and `]C` to navigate diagnostics. Lowercase [c is already in vimdiff
  nmap <silent> [C <Plug>(coc-diagnostic-prev)
  nmap <silent> ]C <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  " Don't map to <tab> because <C-i> is an alias and will break and can't be mapped to other things 
  " So map coc-range-select to anything but <TAB>. I like <vr> since it sounds like selecting a range
  nmap <silent> vr <Plug>(coc-range-select)
  xmap <silent> vr <Plug>(coc-range-select)
  " I don't map VR to coc-range-select-backword since it won't work right and I don't use it any way

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-git mappings (uninstall vim-gitgutter first since this does that and more)
"
" so typing gs on a modified line will show just that diff in a floating window
nmap gs <Plug>(coc-git-chunkinfo)
" stage the chunk with ,gs
nmap <Leader>gs :CocCommand git.chunkStage<CR>
" after staging with ,gs see the changes with with ,gsd
nmap <Leader>gsd :CocCommand git.diffCached<CR>
" Undo modifications for the chunk with ,gX
nmap <Leader>gX :CocCommand git.chunkUndo<CR>
" so typing gC shows the most recent commit of the (unmodified) line
nmap gC <Plug>(coc-git-commit)
" jump to next change and prev change with gn and gp (instead of ]c and [c)
nmap gn <Plug>(coc-git-nextchunk)
nmap gp <Plug>(coc-git-prevchunk)
" fold all unchanged parts of the file so you can just see modifications
nmap <Leader>gu :CocCommand git.foldUnchanged<CR>
" Show branches in fuzzyfinder to switch branches by typing ,gB
nmap <Leader>gB :CocList branches<CR>
endif
