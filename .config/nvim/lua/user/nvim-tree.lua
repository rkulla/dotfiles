vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>nc", ":NvimTreeCollapse<cr>")

require("nvim-tree").setup({
  sort_by = "name",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
