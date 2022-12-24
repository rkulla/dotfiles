local map = vim.keymap.set
map("n", "<leader>fx", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>x", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
map("n", "<leader>X", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
map("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope live_grep" })
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "Telescope file_browser" })
map("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
map("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "Telescope oldfiles" })
map("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Telescope help_tags" })
map("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Telescope keymaps" })
map(
  "n",
  "<leader>fc",
  "<cmd>Telescope find_files find_command=rg,--hidden,--files,/Users/rkulla/.config/nvim<cr>",
  { desc = "Telescope search nvim configs" }
)
--- Some stuff I don't bother mapping and can just run :Telescope such as:
--- :Tel[tab] git[tab]  (commits, branches, etc)

require("telescope").setup({
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "-H" },
    },
  },
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
  },
})

-- Enable Downloaded Extensions
require("telescope").load_extension("file_browser")
