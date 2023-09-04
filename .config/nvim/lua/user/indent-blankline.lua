vim.keymap.set("n", "<leader>ti", ":IndentBlanklineToggle<cr>", { desc = "Toggle vertical indentation lines" })

-- Use diff chars if indented more than 3 levels, to warn if "GONE TOO FAR!"
-- I make exceptions if it's an object literal, but this is still a good guideline
vim.g.indent_blankline_char_list = { "┃", "│", "│", "┆", "┆", "┊" }

-- require("indent_blankline").setup({
-- })
