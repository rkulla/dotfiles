local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local map = vim.keymap.set

map("n", "<leader>fx", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>x", require("telescope.builtin").git_files, { desc = "Telescope git_files" })
map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
map("n", "<leader>X", require("telescope.builtin").find_files, { desc = "Telescope find_files" })
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
map(
  "n",
  "<leader>fg",
  '<cmd>lua require("telescope.builtin").live_grep({ vimgrep_arguments = {"rg", "-H", "-n", "--column", "-i"} })<CR>',
  { desc = "Telescope file grep case-insensitive" }
)
map(
  "n",
  "<leader>fG",
  '<cmd>lua require("telescope.builtin").live_grep({ vimgrep_arguments = {"rg", "-H", "-n", "--column"}, "-s" })<CR>',
  { desc = "Telescope file grep case-sensitive" }
)

--- Some stuff I don't bother mapping and can just run :Telescope such as:
--- :Tel[tab] git[tab]  (commits, branches, etc)

-- TODO: TEMPORARY WORKAROUND UNTIL THE OFFICIAL PR #807 IS MERGED TO OPEN MULTIPLE SECTIONS:
-- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/1048
local select_one_or_multi = function(prompt_bufnr)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    actions.close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
    end
  else
    actions.select_default(prompt_bufnr)
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
    layout_config = {
      width = 0.99, -- This will set the width to 90% of the screen width
      height = 0.99, -- This will set the height to 80% of the screen height
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = function(_, cols, _)
          return math.floor(cols * 0.50) -- Adjust as needed
        end,
      },
    },

    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi, -- TODO: My temp multi-file select workaround
        ["<esc>"] = actions.close, -- Close telescope instead of escaping to NORMAL mode
        ["<C-k>"] = actions.preview_scrolling_up,
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<C-l>"] = actions.preview_scrolling_right,
        ["<C-h>"] = actions.preview_scrolling_left,
        ["<C-S-L>"] = actions.results_scrolling_right,
        ["<C-S-H>"] = actions.results_scrolling_left,
      },
    },
  },
})

-- Enable Downloaded Extensions
require("telescope").load_extension("file_browser")
