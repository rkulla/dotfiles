vim.keymap.set("n", "<leader>ti", ":IndentBlanklineToggle<cr>", { desc = "Toggle vertical indentation lines" })

-- Use diff chars if indented more than 4 levels, to say "GONE TOO FAR!"
vim.g.indent_blankline_char_list = { "┃", "│", "│", "│", "┆", "┊" }

-- require("indent_blankline").setup({
-- })
