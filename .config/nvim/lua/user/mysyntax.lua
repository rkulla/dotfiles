-- .txt file ONLY highlights
vim.api.nvim_create_augroup("TextFileHighlighting", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "TextFileHighlighting",
  pattern = "*.txt",
  callback = function()
    -- Disable line numbers by default for .txt files
    vim.opt_local.number = false
    -- vim.cmd("Copilot disable")

    vim.schedule(
      function()
        vim.cmd([[

        " Highlight lines starting with a * (see myfolds.lua for how I custom fold)
        syntax match BoldLine /^\*\S.*/
        highlight BoldLine guifg=#00008B guibg=#A0A0A0 ctermfg=4 ctermbg=238 gui=bold,underline cterm=bold,underline

        " Highlight words of at least 2 chars if the line starts with a `- bullet`. E.g., `SPAM` in `- SPAM`
        " or highlights all the way up to the first colon `- Foo bar baz:`
        syntax match BulletSection /\v^-\s\zs[^:\n]+(\s[^:\n]+)*\ze:|^-\s\zs\S+/
        highlight BulletSection guifg=#006400 gui=bold cterm=bold ctermfg=2 guibg=#D3D3D3 ctermbg=250

        "syntax match DollarCLI /\s\+\$\s\{1,2}.*$/ containedin=ALL
        syntax match DollarCLI /\$\s\{1,2}.*$/ containedin=ALL
        highlight DollarCLI guifg=#00008B gui=bold cterm=bold ctermfg=33 guibg=#D3D3D3 ctermbg=250

        " Highlight text inside of single back ticks like `foo`
        syntax match BacktickText /\v`([^`]+)`/
        highlight BacktickText guifg=#444444 ctermfg=0 guibg=#D3D3D3 ctermbg=250 " Match text in backticks

        " Highlight text inside of double back ticks like ``foo``
        syntax match DoubleBacktickText /\v``([^`]+)``/
        highlight DoubleBacktickText guifg=#000000 gui=bold cterm=bold ctermfg=0 guibg=#D3D3D3 ctermbg=250

        " Highlight URLs to look like hyperlinks (use my <leader>o map to open)
        syntax match URL /https\?:\/\/.*/  " Match URLs starting with http or https
        highlight URL guifg=#808080 guibg=NONE ctermfg=33 ctermbg=NONE

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

        " Highlight empty brackets [] with bold text after them UP to the last optional ` - `
        match BoldAfterEmptyBrackets /\v\[\]\s\zs.*\ze\s-\s|\[\]\s\zs.*$/
        highlight BoldAfterEmptyBrackets cterm=bold gui=bold

        " Highlight references to files ending in '.txt'
        syntax match TxtFileRef /\S\+\.txt/
        highlight TxtFileRef guifg=#808080 guibg=NONE ctermfg=33 ctermbg=NONE

      ]])
      end
    )
  end,
})
