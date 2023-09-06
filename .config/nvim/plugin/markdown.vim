packadd markdown-preview.nvim
" Start/close browser tab with `<spc>mp` but manually `:MarkdownPreviewStop` after toggling off, to stop server
nmap <leader>mp <Plug>MarkdownPreviewToggle
let g:mkdp_port = '6969'

" I only like markdown-preview for editing, but for reading I mostly use `glow` (brew install glow)
nmap <leader>ml :term glow -s light %<CR>
nmap <leader>md :term glow -s dark %<CR>
