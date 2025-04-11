-- Set default colorscheme on startup
vim.cmd("colorscheme tokyonight-day")

-- Create some custom commands to manually change between light and dark themes
local M = {}

-- Highlight overrides
local function MyHighlights()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" }) or {}
  local cursor_bg = "#819090"

  -- Make window borders visible
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = normal.bg, bold = true })

  -- Enable cursorline
  vim.o.cursorline = true

  -- Line number on cursorline
  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#819090", -- you can change this
    bg = "NONE",
    bold = true,
    italic = false, -- cursorline won't be italic to distinguish it
  })

  -- Italic line numbers
  vim.api.nvim_set_hl(0, "LineNr", { italic = true })
end

-- Run my highlights immediately
MyHighlights()
-- run MyHighlights() after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = MyHighlights,
})

-- Apply dark theme
function M.Dark()
  vim.cmd("colorscheme catppuccin-macchiato")
  vim.o.background = "dark"
  -- setFlashDark()
  MyHighlights()
end

-- Apply light theme
function M.Light()
  vim.cmd("colorscheme tokyonight-day")
  vim.o.background = "light"
  -- setFlashLight()
  MyHighlights()
end

-- Create user commands
vim.api.nvim_create_user_command("Dark", function() M.Dark() end, {})
vim.api.nvim_create_user_command("Light", function() M.Light() end, {})

return M
