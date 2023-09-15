local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local map = vim.keymap.set

map("n", "<leader>?", require("telescope.builtin").help_tags, { desc = "Find help tags" })
map("n", "<leader>fx", require("telescope.builtin").git_files, { desc = "Find git files" })
map("n", "<leader>x", require("telescope.builtin").git_files, { desc = "Find git files" })
map("n", "<leader>X", require("telescope.builtin").find_files, { desc = "Find all files" })
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "File expolorer" })
map("n", "<leader>fl", require("telescope.builtin").oldfiles, { desc = "Find last opened files" })
map("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Find keymaps" })
map(
  "n",
  "<leader>fb",
  '<cmd>lua require("telescope.builtin").buffers(require("telescope.themes").get_ivy { winblend = 10, previewer = true } )<CR>',
  { desc = "Find buffers" }
)
map(
  "n",
  "<leader>fc",
  "<cmd>Telescope find_files find_command=rg,--hidden,--files,/Users/rkulla/.config/nvim<cr>",
  { desc = "Find nvim configs" }
)
map(
  "n",
  "<leader>fg",
  '<cmd>lua require("telescope.builtin").live_grep({ vimgrep_arguments = {"rg", "-H", "-n", "--column", "-i"} })<CR>',
  { desc = "Find in all files" }
)
map(
  "n",
  "<leader>fG",
  '<cmd>lua require("telescope.builtin").live_grep({ vimgrep_arguments = {"rg", "-H", "-n", "--column"}, "-s" })<CR>',
  { desc = "Find in all files (case-sensitive)" }
)
map(
  "n",
  "<leader>fC",
  '<cmd>lua require("telescope.builtin").command_history(require("telescope.themes").get_dropdown { winblend = 10, previewer = true } )<CR>',
  { desc = "Command history" }
)
map(
  "n",
  "<leader>fS",
  '<cmd>lua require("telescope.builtin").search_history(require("telescope.themes").get_dropdown { winblend = 10, previewer = true } )<CR>',
  { desc = "Search history" }
)
map(
  "n",
  "<leader>fm",
  '<cmd>lua require("telescope.builtin").marks({ winblend = 10, previewer = true, layout_config = { width = 0.99, height = 0.90 } } )<CR>',
  { desc = "Find marks" }
)
map(
  "n",
  "<leader>fo",
  '<cmd>lua require("telescope.builtin").live_grep({ grep_open_files = true, vimgrep_arguments = {"rg", "-H", "-n", "--column", "-i" } })<CR>',
  { desc = "Find in open files" }
)
map(
  "n",
  "<leader>fO",
  '<cmd>lua require("telescope.builtin").live_grep({ grep_open_files = true, vimgrep_arguments = {"rg", "-H", "-n", "--column" }, "-s" })<CR>',
  { desc = "Find in open files (case-sensitive)" }
)
-- TODO: waiting for telescope to support case-sensitive matching for current_buffer_fuzzy_find
map("n", "<leader>ff", '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>', { desc = "Find in current file" })
map(
  "n",
  "<leader>*",
  '<cmd>lua require("telescope.builtin").grep_string({word_match = "-w", additional_args = function(opts) return {"--hidden", "--glob", "!.git", "-s" } end})<CR>',
  { desc = "Find word on cursor" }
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

-- Function to bind Telescope to mappings for Flash.nvim integration
local function flash(prompt_bufnr)
  require("flash").jump({
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults" end,
      },
    },
    action = function(match)
      local picker = actions_state.get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  })
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
    path_display = { "truncate" },
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
        -- ["<esc>"] = actions.close, -- Close telescope instead of escaping to NORMAL mode (breaks some shortcuts)
        ["<C-k>"] = actions.preview_scrolling_up,
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<C-l>"] = actions.preview_scrolling_right,
        ["<C-h>"] = actions.preview_scrolling_left,
        ["<C-S-L>"] = actions.results_scrolling_right,
        ["<C-S-H>"] = actions.results_scrolling_left,
      },
      n = {
        s = flash,
        ["<CR>"] = select_one_or_multi, -- TODO: My temp multi-file select workaround
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
