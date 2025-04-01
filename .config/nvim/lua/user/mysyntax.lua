vim.api.nvim_create_augroup("TextFileHighlighting", { clear = true })

-- Match ALL CAPS words (4+ letters), optionally followed by a colon and make them bold
-- Also makes lines starting with a * bold (for my custom notes used by myfolds.lua
-- Since `glow` markdown isn't that great, this lets me keep my notes as .txt but with some syntax highlighting
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "TextFileHighlighting",
  pattern = "*.txt",
  callback = function()
    vim.schedule(
      function()
        vim.cmd([[
        syntax match BoldCaps /\v(^|[^"'])\zs<[A-Z]{4,}:?\ze([^"']|$)/
        syntax match BoldLine /^\*\S.*/

        highlight BoldCaps term=bold cterm=bold gui=bold
        highlight BoldLine term=bold cterm=bold gui=bold
      ]])
      end
    )
  end,
})
