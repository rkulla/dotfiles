-- .txt file ONLY highlights.
-- NOTE: This is based on using tokyonight-day colorscheme, so if I change it adjust hex colors
-- NOTE: Use "Digital Color Meter" app in MacOS to find color info of any color on screen
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
        " Highlight lines starting with a * (see myfolds.lua for how I custom fold, while they're unfolded)
        syntax match BoldLine /^\*\S.*/
        highlight BoldLine guifg=#000000 guibg=#A9AEC8 ctermfg=0 ctermbg=238 gui=bold,underline cterm=bold,underline

        " Highlight folds while folded
        highlight Folded guifg=#000000 guibg=#A9AEC8 ctermfg=0 ctermbg=252

        " Highlight words of at least 2 chars if the line starts with a `- bullet`. E.g., `SPAM` in `- SPAM`
        " or highlights all the way up to the first colon `- Foo bar baz:`
        syntax match BulletSection /\v^-\s\zs[^:\n]+(\s[^:\n]+)*\ze:|^-\s\zs\S+/
        highlight BulletSection guifg=#006400 gui=bold cterm=bold ctermfg=2 guibg=#D3D3D3 ctermbg=250

        syntax match DollarCLI /\$\s\{1,2}.*$/ containedin=ALL
        highlight DollarCLI guifg=#D3D3D3 gui=bold cterm=bold ctermfg=250 guibg=#0000FF ctermbg=4

        " Highlight text inside of single back ticks like `foo`
        syntax match BacktickText /`[^`]\{-}`/hs=s+1,he=e-1
        highlight BacktickText guifg=#444444 ctermfg=0 guibg=#D3D3D3 ctermbg=250 " Match text in backticks

        " Highlight backticks themselves to be a lighter color to look more seamless like markdown
        syntax region BacktickMatch start=/`/ end=/`/ keepend contains=BacktickText,BacktickDelimiter
        syntax match BacktickText /[^`]\+/ contained
        syntax match BacktickDelimiter /`/ contained
        highlight BacktickDelimiter guifg=#e1e2e7 ctermfg=15 guibg=NONE ctermbg=NONE

        " Highlight text inside of single underscore like _foo_
        syntax match UnderscoreText /\v_([^_`]+)_/
        highlight UnderscoreText guifg=#00008B gui=bold cterm=bold ctermfg=0 guibg=#NONE ctermbg=NONE

        " Highlight Single underscores themselves to be a lighter color to look more seamless like markdown
        syntax region UnderscoreMatch start=/_/ end=/_/ keepend contains=UnderscoreText,UnderscoreDelimiter
        syntax match UnderscoreText /[^_]\+/ contained
        syntax match UnderscoreDelimiter /_/ contained
        highlight UnderscoreDelimiter guifg=#e1e2e7 ctermfg=15 guibg=NONE ctermbg=NONE

        " Highlight the matched text inside the triple backticks
        syntax match TripleBackticksStart /```/
        syntax match TripleBackticksEnd /```/
        syntax region TripleBackticks matchgroup=TripleBackticksStart start=/```/ end=/```/ contains=@TripleBackticksStart,@TripleBackticksEnd
        highlight TripleBackticks guibg=NONE guifg=#000000 ctermfg=0 guibg=NONE ctermbg=NONE gui=italic cterm=italic

        " Match the triple backtick delimiters separately
        syntax match TripleBackticksStart /```/
        syntax match TripleBackticksEnd /```/
        " Define the region for the content inside the triple backticks, keeping the delimiters separate
        syntax region TripleBackticks matchgroup=TripleBackticksStart start=/```/ end=/```/ contains=@TripleBackticksStart,@TripleBackticksEnd
        " Highlight the delimiters themselves
        highlight TripleBackticksStart guifg=#e1e2e7 ctermfg=15 guibg=NONE ctermbg=NONE
        highlight TripleBackticksEnd guifg=#e1e2e7 ctermfg=15 guibg=NONE ctermbg=NONE
        " Highlight the content inside the triple backtick block, without overriding internal syntax highlighting
        highlight link TripleBackticks TripleBackticks

        " Match any text inside of double quotes, located anywhere on the line, not including the quotes
        " Don't do single quotes, as they're used alone for apostrophes in English and 2 on 1 line is common
        syntax match DoubleQuotedText /"[^"]\{-}"/hs=s+1,he=e-1
        highlight DoubleQuotedText gui=bold,italic cterm=bold,italic

        " Highlight URLs to look like hyperlinks (use my <leader>o map to open)
        syntax match URL /https\?:\/\/.*/  " Match URLs starting with http or https
        highlight URL guifg=#808080 guibg=NONE ctermfg=33 ctermbg=NONE

        " Highlight {} () [] and comments like // or #
        syntax match SimpleBraces /[{}]/
        highlight SimpleBraces guifg=#800080 ctermfg=129 cterm=bold gui=bold
        syntax match SimpleParens /[()]/
        highlight SimpleParens cterm=bold gui=bold
        syntax match SimpleBrackets /\[\|\]/
        highlight SimpleBrackets guifg=#000000 ctermfg=0 cterm=bold gui=bold
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
