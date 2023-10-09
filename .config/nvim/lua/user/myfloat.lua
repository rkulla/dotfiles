-- Floating window functions
local M = {}

-- Function to open a file in a floating window
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

-- Function to open term in a floating window (similar to iterm2 Hotkey Terminal)
M.open_term_in_floating_window = function()
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
    border = "single"
  }

  vim.api.nvim_open_win(bufnr, true, win_opts)

  -- Start terminal in the created buffer
  vim.cmd("term")

  -- Add autocmd to close the terminal buffer/window when exiting terminal mode
  vim.cmd(string.format("autocmd TermClose <buffer=%s> bwipeout!", bufnr))

  -- Set buffer to wipeout if hidden (this is good for terminal buffers)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
end

return M

