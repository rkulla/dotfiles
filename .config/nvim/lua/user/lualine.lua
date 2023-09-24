function bufferCount() return #vim.fn.getbufinfo({ buflisted = true }) end

truncated_branch = function()
  local branch = " " .. vim.fn["FugitiveHead"]()

  local maxLength = 36 -- Target length
  if #branch > maxLength then
    local firstPartLength = 28 -- Length of the starting part of the branch
    local lastPartLength = 5 -- Length of the ending part of the branch

    local firstPart = branch:sub(1, firstPartLength)
    local lastPart = branch:sub(-lastPartLength)

    return firstPart .. "…" .. lastPart
  else
    return branch
  end
end

local screenWidth = vim.o.columns
local dynamic_max_length

if screenWidth >= 200 then
  dynamic_max_length = 150
else
  dynamic_max_length = 40 + (screenWidth - 80) * (120 / 120) -- This is an example linear function. Adjust as needed.
end

require("lualine").setup({
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "%{v:lua.bufferCount()}%{v:lua.truncated_branch()}" },
    lualine_b = {
      {
        "buffers",
        show_filename_only = true, -- Shows shortened relative path when set to false.
        hide_filename_extension = false, -- Hide filename extension when set to true.
        show_modified_status = true, -- Shows indicator when the buffer is modified.
        icons_enabled = false, -- If you want to see filetype icons next to each buffer
        mode = 4,
        max_length = dynamic_max_length,

        symbols = {
          modified = " ●", -- Text to show when the buffer is modified
          alternate_file = "^", -- Text to show to identify the alternate file
          directory = "", -- Text to show when the buffer is a directory
        },
      },
    },
    lualine_c = {}, -- Don't show filename since I do in buffers
    -- lualine_x = { "encoding", "filetype" },
    lualine_x = {},
  },
  winbar = {},
})
