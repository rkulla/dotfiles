packadd markdown-preview.nvim
" Start/close browser tab with `,md` but manually `:MarkdownPreviewStop` after toggling off, to stop server
nmap <leader>md <Plug>MarkdownPreviewToggle
let g:mkdp_port = '6969'

" I only like markdown-preview for editing, but for reading I mostly use `glow` (brew install glow)
nmap <leader>gl :term glow %<CR>
nmap <leader>gld :term glow -s dark %<CR>
