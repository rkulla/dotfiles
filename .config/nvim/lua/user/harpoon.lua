local harpoon = require("harpoon")
local map = vim.keymap.set

-- REQUIRED
harpoon:setup()
-- REQUIRED

map("n", "<leader>ha", function() harpoon:list():append() end, { desc = "harpoon append" })
map("n", "<leader>hp", function() harpoon:list():prepend() end, { desc = "harpoon prepend" })
map("n", "<leader>hr", function() harpoon:list():remove() end, { desc = "harpoon remove current buffer" })
map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "toggle harpoon ui" })
map("n", "<leader>hc", function() harpoon:list():clear() end, { desc = "clear harpoon" })
map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "goto harpoon list 1" })
map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "goto harpoon list 2" })
map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "goto harpoon list 3" })
map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "goto harpoon list 4" })

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

map("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end, { desc = "Find harpoon files" })
