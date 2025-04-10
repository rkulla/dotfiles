-- So `:SE foo` finds exact word `foo`. NOTE: vim regex is \<foo\> not \bfoo\b
vim.api.nvim_create_user_command("SE", function(opts)
  local pattern = [[\<]] .. opts.args .. [[\>]]
  vim.api.nvim_feedkeys("/" .. pattern .. "\n", "n", false)
end, { nargs = 1 })

-- Make :GBrowse work by setting my own :Browse command
vim.api.nvim_create_user_command("Browse", function(opts) vim.fn.system({ "open", opts.args }) end, { nargs = 1 })

-- Open any file in a floating window (uses my custom myfloat.lua function)
vim.api.nvim_create_user_command(
  "FloatingOpen",
  function(opts) require("user.myfloat").open_file_in_floating_window(opts.args) end,
  { nargs = 1 }
)

-- Open a terminal in a floating window (uses my custom myfloat.lua function)
-- Mapped to <Leader>5
vim.api.nvim_create_user_command("TermFloat", function() require("user.myfloat").open_term_in_floating_window() end, {})
