-- lua/nvim equivalent of my custom notes folding (folds on lines starting with a `*`)
vim.opt.foldenable = true
vim.opt.foldmethod = "marker"

-- Define the fold expression function in Lua
local function fold_expr(lnum)
  local line = vim.fn.getline(lnum)
  if line:match("^%*") then return ">1" end
  return "="
end

-- Set up an autocommand to apply the fold expression to .txt files
vim.api.nvim_create_augroup("TextFileFolds", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.fold_expr(v:lnum)"
  end,
  group = "TextFileFolds",
})

-- Make the function accessible in the global Lua environment
_G.fold_expr = fold_expr
