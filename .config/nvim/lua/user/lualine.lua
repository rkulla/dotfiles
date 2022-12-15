function bufferCount() return #vim.fn.getbufinfo({ buflisted = true }) end

require("lualine").setup({
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "%{v:lua.bufferCount()}", "branch" }, -- https://github.com/nvim-lualine/lualine.nvim/issues/888
    lualine_b = {
      {
        "buffers",
        show_filename_only = true, -- Shows shortened relative path when set to false.
        hide_filename_extension = false, -- Hide filename extension when set to true.
        show_modified_status = true, -- Shows indicator when the buffer is modified.
        icons_enabled = false, -- If you want to see filetype icons next to each buffer
        mode = 4,
        -- max_length = 40, -- uncomment if on a smaller laptop screen

        symbols = {
          modified = " ●", -- Text to show when the buffer is modified
          alternate_file = "^", -- Text to show to identify the alternate file
          directory = "", -- Text to show when the buffer is a directory
        },
      },
    },
    lualine_c = {}, -- Don't show filename since I do in buffers
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { "encoding" },
  },
  winbar = {},
})
