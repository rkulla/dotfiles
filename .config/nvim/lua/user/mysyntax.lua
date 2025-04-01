vim.api.nvim_create_augroup("TextFileHighlighting", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = "TextFileHighlighting",
  pattern = "*.txt",
  callback = function()
    vim.schedule(
      function()
        vim.cmd([[
        syntax match BoldCaps /\v(^|[^"'])\zs<[A-Z]{4,}:?\ze([^"']|$)/
        syntax match BoldLine /^\*\S.*/
        syntax match BacktickText /\v`([^`]+)`/  " Match text inside backticks
        syntax match URL /https\?:\/\/.*/  " Match URLs starting with http or https

        " Highlight the matched text inside the triple backticks
        syntax match TripleBackticksStart /```/
        syntax match TripleBackticksEnd /```/
        syntax region TripleBackticks matchgroup=TripleBackticksStart start=/```/ end=/```/ contains=@TripleBackticksStart,@TripleBackticksEnd
        highlight TripleBackticks guibg=NONE guifg=#808080 ctermfg=245 ctermbg=NONE cterm=bold gui=bold


        " Set BoldCaps to have light grey background and black text
        "highlight BoldCaps guifg=#00008B guibg=#A0A0A0 ctermfg=4 ctermbg=238 " Match all caps words (4+ chars) and optional colon
        highlight BoldCaps guifg=#00008B guibg=#A0A0A0 ctermfg=4 ctermbg=238 gui=bold cterm=bold" Match all caps words (4+ chars) and optional colon
        highlight BoldLine guifg=#006400 gui=bold,underline ctermfg=2 guibg=#D3D3D3 ctermbg=250 cterm=bold,underline  " Match lines starting with a * (my custom folds)
        " highlight BacktickText guifg=#FFA500 guibg=NONE ctermfg=214 ctermbg=NONE  " Match text in backticks
        highlight BacktickText gui=bold cterm=bold  " Match text in backticks
        highlight URL guifg=#0000FF gui=underline cterm=underline guibg=NONE ctermfg=33 ctermbg=NONE  " Match URLs
      ]])
      end
    )
  end,
})
