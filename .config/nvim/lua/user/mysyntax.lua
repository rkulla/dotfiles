vim.api.nvim_create_augroup("TextFileHighlighting", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = "TextFileHighlighting",
  pattern = "*.txt",
  callback = function()
    -- Disable line numbers by default for .txt files
    vim.opt_local.number = false

    vim.schedule(
      function()
        vim.cmd([[
        " Highlight lines starting with a * (see myfolds.lua for how I custom fold)
        syntax match BoldLine /^\*\S.*/
        highlight BoldLine guifg=#00008B guibg=#A0A0A0 ctermfg=4 ctermbg=238 gui=bold,underline cterm=bold,underline

        " Highlight words of at least 2 chars if the line starts with a `- bullet`. E.g., `SPAM` in `- SPAM`
        " or highlights all the way up to the first colon `- Foo bar baz:`
        syntax match BulletSection /\v^-\s\zs\S+(\s\S+)*:\ze|^-\s\zs\S+/
        highlight BulletSection guifg=#006400 gui=bold cterm=bold ctermfg=2 guibg=#D3D3D3 ctermbg=250

        " Highlight text inside of single back ticks like `foo`
        syntax match BacktickText /\v`([^`]+)`/
        highlight BacktickText gui=bold cterm=bold  " Match text in backticks

        " Highlight URLs to look like hyperlinks (use my <leader>o map to open)
        syntax match URL /https\?:\/\/.*/  " Match URLs starting with http or https
        highlight URL guifg=#0000FF gui=underline cterm=underline guibg=NONE ctermfg=33 ctermbg=NONE

        " Highlight the matched text inside the triple backticks
        syntax match TripleBackticksStart /```/
        syntax match TripleBackticksEnd /```/
        syntax region TripleBackticks matchgroup=TripleBackticksStart start=/```/ end=/```/ contains=@TripleBackticksStart,@TripleBackticksEnd
        highlight TripleBackticks guibg=NONE guifg=#808080 ctermfg=245 ctermbg=NONE cterm=bold gui=bold

        " Highlight {} () [] "" and comments like // or #
        syntax match SimpleBraces /[{}]/
        highlight SimpleBraces guifg=#800080 ctermfg=129 cterm=bold gui=bold
        syntax match SimpleParens /[()]/
        highlight SimpleParens cterm=bold gui=bold
        syntax match SimpleBrackets /\[\|\]/
        highlight SimpleBrackets guifg=#000000 ctermfg=0 cterm=bold gui=bold
        syntax match SimpleQuotes /["]/ 
        highlight SimpleQuotes guifg=#0000FF ctermfg=33 cterm=bold gui=bold
        syntax match SimpleComment /\/\/.*/ contains=NONE
        syntax match SimpleComment /#.*/ contains=NONE
        highlight link SimpleComment Comment

        " Highlight lines containing with 'tickets/' and ending with '.txt'
        syntax match TicketLine /tickets\/.*\.txt$/
        highlight TicketLine gui=underline,bold,italic cterm=underline,bold,italic 

      ]])
      end
    )
  end,
})
