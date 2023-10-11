vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>nc", ":NvimTreeCollapse<cr>")

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc) return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true } end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
  sort_by = "name",
  view = {
    width = 32, -- If need wider, drag window
  },

  on_attach = my_on_attach,

  update_cwd = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,

  -- Use my <spc>nc if i want to collapse everything after and <spc>nf to launch current only
  update_focused_file = {
    enable = true, -- automatically focus on the current file when changing buffers
    update_root = true, -- Update root dir if focused file is outside of CWD (useful for zoxide)
    ignore_list = {},
  },

  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
