" Have Go files always show as 4 spaces each yet still be real tabs
au BufRead,BufNewFile *.go set noet ts=4 sw=4

" Set gopls for vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Automatically add or remote import statements on save
let g:go_fmt_command = "goimports"

" Highlight methods like fmt.Println in vim-go
"let g:go_highlight_methods = 1
au FileType go nmap <Leader>gr <Plug>(go-rename)
au FileType go nmap <leader>l <Plug>(go-run)
au FileType go nmap <leader>gt <Plug>(go-test)
autocmd FileType go nmap <Leader>gc <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>gcb :GoCoverageBrowser<CR>
au FileType go nmap <Leader>gd <Plug>(go-doc)
" au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gdb <Plug>(go-doc-browser)
au FileType go nmap <Leader>gim <Plug>(go-implements)
au FileType go nmap <Leader>gin <Plug>(go-info)
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
