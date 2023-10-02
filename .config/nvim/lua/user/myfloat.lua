-- Function to open a file in a floating window
local M = {}

M.open_file_in_floating_window = function(filepath)
  -- Define the window size
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local bufnr = vim.api.nvim_create_buf(false, true)
  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
  }

  -- `:h api-floatwin` is the key to floating windows
  vim.api.nvim_open_win(bufnr, true, win_opts)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.cmd(string.format("edit %s", filepath))

  -- auto-close the floating window when it loses focus
  vim.cmd(string.format("autocmd WinLeave <buffer=%s> close", bufnr))

  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.cmd(string.format("edit %s", filepath))
end

return M

