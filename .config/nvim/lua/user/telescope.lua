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

-- TODO: TEMPORARY WORKAROUND UNTIL THE OFFICIAL PR #807 IS MERGED TO OPEN MULTIPLE SECTIONS:
-- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/1048
local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

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
  defaults = { -- TODO: TEMP WORKAROUND from https://github.com/nvim-telescope/telescope.nvim/issues/1048
    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
  },
})

-- Enable Downloaded Extensions
require("telescope").load_extension("file_browser")
