-- -------------------- `:SE` definition ---------------------------------------------------------------------------------------
-- So `:SE foo` finds exact word `foo`. NOTE: vim regex is \<foo\> not \bfoo\b
vim.api.nvim_create_user_command("SE", function(opts)
  local pattern = [[\<]] .. opts.args .. [[\>]]
  vim.api.nvim_feedkeys("/" .. pattern .. "\n", "n", false)
end, { nargs = 1 })

-- -------------------- `:GBrowse` definition -----------------------------------------------------------------------------------
-- Make :GBrowse work by setting my own :Browse command
vim.api.nvim_create_user_command("Browse", function(opts) vim.fn.system({ "open", opts.args }) end, { nargs = 1 })

-- -------------------- `:FloatingOpen` definition ------------------------------------------------------------------------------
-- Open any file in a floating window (uses my custom myfloat.lua function)
vim.api.nvim_create_user_command(
  "FloatingOpen",
  function(opts) require("user.myfloat").open_file_in_floating_window(opts.args) end,
  { nargs = 1 }
)
-- -------------------- `:TermFloat` definition ----------------------------------------------------------------------------------
-- Open a terminal in a floating window (uses my custom myfloat.lua function)
-- Mapped to <Leader>5
vim.api.nvim_create_user_command("TermFloat", function() require("user.myfloat").open_term_in_floating_window() end, {})

-- -------------------- `:HiWords` definition -----------------------------------------------------------------
-- So I can type `:HiWords foo bar baz` to highlight multiple (exact) words, all with diff colors
local match_ids = {}

-- Define highlight groups
-- Note: I don't set yellow to not conflict with my yellow highlights
vim.api.nvim_set_hl(0, "RedHighlight", { fg = "Black", bg = "Red" })
vim.api.nvim_set_hl(0, "BlueHighlight", { fg = "White", bg = "Blue" })
vim.api.nvim_set_hl(0, "GreenHighlight", { fg = "Black", bg = "Green" })
-- vim.api.nvim_set_hl(0, "YellowHighlight", { fg = "Black", bg = "Yellow" })
vim.api.nvim_set_hl(0, "MagentaHighlight", { fg = "Black", bg = "Magenta" })
vim.api.nvim_set_hl(0, "CyanHighlight", { fg = "Black", bg = "Cyan" })
vim.api.nvim_set_hl(0, "OrangeHighlight", { fg = "Black", bg = "Orange" })
vim.api.nvim_set_hl(0, "PurpleHighlight", { fg = "White", bg = "Purple" })
vim.api.nvim_set_hl(0, "PinkHighlight", { fg = "Black", bg = "Pink" })
vim.api.nvim_set_hl(0, "TealHighlight", { fg = "Black", bg = "Teal" })
vim.api.nvim_set_hl(0, "BrownHighlight", { fg = "Black", bg = "Brown" })
vim.api.nvim_set_hl(0, "GreyHighlight", { fg = "Black", bg = "Grey" })

-- Predefined list of highlight group names
local color_groups = {
  "RedHighlight",
  "BlueHighlight",
  "GreenHighlight",
  -- "YellowHighlight",
  "MagentaHighlight",
  "CyanHighlight",
  "OrangeHighlight",
  "PurpleHighlight",
  "PinkHighlight",
  "TealHighlight",
  "BrownHighlight",
  "GreyHighlight",
}

vim.api.nvim_create_user_command("HiWords", function(opts)
  for _, id in ipairs(match_ids) do
    pcall(vim.fn.matchdelete, id)
  end
  match_ids = {}

  local words_to_highlight = opts.fargs
  if #words_to_highlight == 0 then words_to_highlight = { "error", "warn", "info", "debug", "notice" } end

  for i, word in ipairs(words_to_highlight) do
    local color_idx = (i - 1) % #color_groups + 1
    local color = color_groups[color_idx]
    local pattern = [[\<]] .. word .. [[\>]]
    local id = vim.fn.matchadd(color, pattern)
    table.insert(match_ids, id)
  end
end, {
  nargs = "*",
  desc = "Highlight multiple words with different colors",
})

vim.api.nvim_create_user_command("HiWordsClear", function()
  for _, id in ipairs(match_ids) do
    pcall(vim.fn.matchdelete, id)
  end
  match_ids = {}
end, {
  desc = "Clear HiWords highlights",
})
