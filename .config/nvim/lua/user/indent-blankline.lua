local enabled = false

vim.g.indent_blankline_char_list = { "┃", "│", "│", "┆", "┆", "┊" }

local function toggle_indent_blankline()
  if enabled then
    vim.cmd("IBLDisable")
  else
    require("ibl").setup({
      indent = {
        char = vim.g.indent_blankline_char_list,
      },
      scope = {
        enabled = false,
      },
    })
    vim.cmd("IBLEnable")
  end
  enabled = not enabled
end

vim.keymap.set("n", "<leader>ti", toggle_indent_blankline, { desc = "Toggle vertical indentation lines" })
