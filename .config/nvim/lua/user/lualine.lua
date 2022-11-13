require('lualine').setup({
  options = {
    theme = 'tokyonight',
    component_separators = '',
    section_separators = '',
    globalstatus = true
  },
  sections = {
    lualine_a = { 'branch' },              -- https://github.com/nvim-lualine/lualine.nvim/issues/888
    lualine_b = {
      {
        'buffers',
        show_filename_only = true,         -- Shows shortened relative path when set to false.
        hide_filename_extension = false,   -- Hide filename extension when set to true.
        show_modified_status = true,       -- Shows indicator when the buffer is modified.
        max_length = vim.o.columns * 2 / 3,
        mode = 4, 

        symbols = {
          modified = ' ●',                 -- Text to show when the buffer is modified
          alternate_file = '^',            -- Text to show to identify the alternate file
          directory =  '',                -- Text to show when the buffer is a directory
        }, 
      }
    },
    lualine_c = {},                        -- Don't show filename since I do in buffers
    lualine_x = {'encoding', 'fileformat'} -- Don't show filetype since I use icons
  },
  winbar = {}
})
