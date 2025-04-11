-- Set default colorscheme on startup
vim.cmd("colorscheme tokyonight-day")
-- Make noice cmd line popup match tokyonight-day by default, with opaque bg for sane cursor
vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#e1e2e7", blend = 0 })

-- Create some custom commands to manually change between light and dark themes
local M = {}

-- Highlight overrides
local function MyHighlights()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" }) or {}

  -- Make window borders visible
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = normal.bg, bold = true })

  -- Enable cursorline
  vim.o.cursorline = true

  -- Cursorline Number highlighting
  vim.api.nvim_set_hl(0, "CursorLineNr", {
    italic = false,
    bold = true,
  })

  -- Italic line numbers (non-cursorline)
  vim.api.nvim_set_hl(0, "LineNr", {
    fg = "#819090", -- non-cursorline numbers will be lighter
    italic = true,
    bold = false,
  })
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
  -- re-override Noice to match catppuccin-macchiato
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#24273A", blend = 0 })
  MyHighlights()
end

-- Apply light theme
function M.Light()
  vim.cmd("colorscheme tokyonight-day")
  vim.o.background = "light"
  -- re-override Noice
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#e1e2e7", blend = 0 })
  MyHighlights()
end

-- Create user commands
vim.api.nvim_create_user_command("Dark", function() M.Dark() end, {})
vim.api.nvim_create_user_command("Light", function() M.Light() end, {})

return M
