" Note: Neovim 0.8 auto-enables lua.vim.lsp.omnifunc
" I also <C-x><C-o> mapped to <Tab> in insert mode. See keymaps.lua

" If Omni-Completion preview window is enabled, auto-close it after completion
autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Make it so hitting ENTER accepts the selected completion item
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Make completion insert the completion item as you go, rather than just select it
set completeopt=longest,menuone

" Toggle preview window when omni-completing
nnoremap <leader>tp :call ToggleCompletionPreview()<cr>
function! ToggleCompletionPreview()
  if stridx(&completeopt, "preview") >= 0
    set completeopt-=preview
  else
    set completeopt+=preview
  endif
endfunction
