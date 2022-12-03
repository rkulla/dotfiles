local map = vim.keymap.set
map("n", "<leader>fx", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>x", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
map("n", "<leader>fX", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
map("n", "<leader>fw", require("telescope.builtin").live_grep, { desc = "Telescope live_grep" })
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "Telescope file_browser" })
map("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
map("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "Telescope oldfiles" })
map("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Telescope help_tags" })
map("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Telescope keymaps" })
map(
  "n",
  "<leader>fc",
  "<cmd>Telescope find_files find_command=rg,--hidden,--files,/Users/rkulla/.config/nvim<cr>",
  { desc = "Telescope search nvim/" }
)

require("telescope").setup({
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "-H" },
    },
  },
})
