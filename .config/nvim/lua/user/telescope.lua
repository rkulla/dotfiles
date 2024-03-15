local telescope = require("telescope")
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local actions_state = require("telescope.actions.state")
local map = vim.keymap.set

map("n", "<leader>?", require("telescope.builtin").help_tags, { desc = "Find help tags" })
map("n", "<leader>fx", require("telescope.builtin").git_files, { desc = "Find git files" }) -- git_signs
map("n", "<leader>x", require("telescope.builtin").git_files, { desc = "Find git files" }) -- git_signs
map("n", "<leader>X", require("telescope.builtin").find_files, { desc = "Find all files" })
map("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "File expolorer" })
map("n", "<leader>fl", require("telescope.builtin").oldfiles, { desc = "Find last opened files" })
map("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Find keymaps" })
map("n", "<leader>fn", require("telescope").extensions.notify.notify, { desc = "Find notifications" })
map("n", "<leader>gtb", require("telescope.builtin").git_branches, { desc = "Git Telescope branches" }) -- git_signs
map("n", "<leader>gtl", require("telescope.builtin").git_commits, { desc = "Git Telescope log" }) -- git_signs
map("n", "<leader>gts", require("telescope.builtin").git_status, { desc = "Git Telescope status" }) -- git_signs
map(
  "n",
  "<leader>fb",
  '<cmd>lua require("telescope.builtin").buffers(require("telescope.themes").get_ivy { winblend = 10, previewer = true } )<CR>',
  { desc = "Find buffers" }
)
map("n", "<space>fB", [[<Cmd>lua require('telescope').extensions.bookmarks.bookmarks()<CR>]], { desc = "Find Firefox Bookmarks" })
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
  '<cmd>lua require("telescope.builtin").marks({ layout_strategy = "vertical", winblend = 10, previewer = true, layout_config = { width = 0.99, height = 0.99 } } )<CR>',
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
-- Open Zoxide list
map(
  "n",
  "<leader>fz",
  ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<CR>",
  { desc = "Zoxide List" }
)
-- Open `:Telescope projects` (ahmedkhalf/project.nvim extension). Like WebStorm's "recent project" list but better since it's fuzzy
map("n", "<leader>p", ":lua require'telescope'.extensions.projects.projects()<CR>", { desc = "Find Recent Projects" })
-- Use telescope-repo extension's cached version (which uses my locatedb set up in .zshrc. I ignore files here since I may want them index for the cli still
-- Keep the cache up-to-date hourly by creating this cronjob (on Apple Silicon use /opt/homebrew/bin/gupdatedb instead):
-- 0 * * * * /usr/local/bin/gupdatedb --localpaths=$HOME/repos --prunepaths=".*node_modules.*" --output="$HOME/locatedb" > "$HOME/cron-output-loaddb.log" 2>&1
-- To filter out unwanted dirs, add file_ignore_patterns={'foo'}
map("n", "<leader>fp", ":lua require'telescope'.extensions.repo.cached_list({results_title='Projects'})<CR>", { desc = "Find Projects (repos)" })

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

local M = {
  telescope_display_mode = "truncate",
}

local function toggle_path(prompt_bufnr)
  if M.telescope_display_mode == "truncate" then
    telescope.setup({ defaults = { path_display = { "absolute" } } })
    M.telescope_display_mode = "absolute"
  else
    telescope.setup({ defaults = { path_display = { "truncate" } } })
    M.telescope_display_mode = "truncate"
  end

  actions_state.get_current_picker(prompt_bufnr):refresh()
end

-- Define a named function to handle <C-r> mapping
-- allows me to grep in telescope on selected files to further filter
-- See: https://stackoverflow.com/questions/77980402/is-there-a-way-to-grep-on-files-that-are-returned-by-telescopes-live-grep
local function send_to_qflist_handler(p_bufnr)
  -- send results to quick fix list
  require("telescope.actions").send_to_qflist(p_bufnr)
  local qflist = vim.fn.getqflist()
  local paths = {}
  local hash = {}
  for k in pairs(qflist) do
    local path = vim.fn.bufname(qflist[k]["bufnr"]) -- extract path from quick fix list
    if not hash[path] then -- add to paths table, if not already appeared
      paths[#paths + 1] = path
      hash[path] = true -- remember existing paths
    end
  end
  -- show search scope with message
  vim.notify("find in ...\n  " .. table.concat(paths, "\n  "))
  -- execute live_grep_args with search scope
  require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = paths })
end

telescope.setup({
  pickers = {
    live_grep = {
      layout_strategy = "horizontal",
      prompt_title = " Grep ",
      prompt_prefix = "󰙔 ",
      results_title = "󰱽 Ripgrep Results",
    },
    git_files = {
      layout_strategy = "horizontal",
      prompt_title = " Repo Files",
      prompt_prefix = "  ",
      results_title = " Results",
    },
    find_files = {
      find_command = { "fd", "--type", "f", "-H" },
      layout_strategy = "horizontal",
      prompt_title = " All Files",
      prompt_prefix = " ",
    },
  },
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
  },
  defaults = {
    -- This path_display/dynamic_preview_title/layout_config combo allows me to avoid wanting a 43" monitor!
    path_display = { "truncate" },
    dynamic_preview_title = true,
    results_title = false,
    layout_config = {
      width = 0.99, -- 0.99 will set the width to 99% of the screen width
      height = 0.99, -- % of screen height
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = function(_, cols, _)
          return math.floor(cols * 0.60) -- % the Preview window should consume
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
        ["<C-p>"] = actions_layout.toggle_preview,
        ["<C-S-P>"] = toggle_path,
        ["<C-n>"] = actions_layout.cycle_layout_next,
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
        ["<C-p>"] = actions_layout.toggle_preview,
        ["<C-S-P>"] = toggle_path,
        ["<C-n>"] = actions_layout.cycle_layout_next,
        ["<C-r>"] = send_to_qflist_handler,
      },
    },
  },
})

-- Enable Downloaded Extensions (install these plugins first, after telescope)
require("telescope").load_extension("file_browser")
-- telescope-fzf-native.nvim (Let's me use fzf syntax)
require("telescope").load_extension("fzf")
require("telescope").load_extension("gh")
require("telescope").load_extension("bookmarks")
require("telescope").load_extension("notify")
require("telescope").load_extension("zoxide")
require("telescope").load_extension("repo")
require("telescope").load_extension("projects")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("live_grep_args")
