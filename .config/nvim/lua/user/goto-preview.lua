local map = vim.keymap.set

require("goto-preview").setup({
  border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
  default_mappings = true, -- Bind default mappings
  debug = false, -- Print debug information
  opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  references = { -- Configure the telescope UI for slowing the references cycling window.
    telescope = require("telescope.themes").get_dropdown({
      hide_preview = false,
      layout_strategy = "vertical",
      prompt_position = "bottom",
      prompt_prefix = " ",
      winblend = 9,
      layout_config = {
        width = 0.60,
        height = 0.99,
        vertical = {
          width_padding = 0.1,
          height_padding = 0.1,
          preview_height = function(_, _, rows)
            return math.floor(rows * 0.75) -- % the Preview window should consume
          end,
        },
      },
    }),
  },
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true, -- Focus the floating window when opening it.
  dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true, -- Whether to nest floating windows
  preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
})

map("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "Preview definition [works]" })
map("n", "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { desc = "Preview declaration" })
map("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { desc = "Preview references [works]" })
map("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", { desc = "Preview type definition" })
map("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { desc = "Preview implementation" })
map("n", "gpc", "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "Preview close [works]" })
