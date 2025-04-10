-- Case-insensitive search
vim.opt.ignorecase = true

-- Line numbers
vim.opt.number = true

-- :q, :bd, etc., on changed file pops up a `save file?` confirmation
vim.opt.confirm = true

-- Encoding
vim.opt.encoding = "utf-8"

-- Tabs: Use spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- Set .swp file location
vim.opt.dir = vim.fn.expand("~/.config/nvim/swp")

-- Yank to system clipboard (in tmux or otherwise)
vim.opt.clipboard:append("unnamed")

-- Allow :find, :tabf, etc., to search the pwd and its subdirs
vim.opt.path:append("**")

-- Spellcheck
vim.opt.spelllang = "en_us"
vim.opt.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

-- File-specific autocmds
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function() vim.opt_local.spell = true end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  callback = function() vim.opt_local.textwidth = 139 end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function() vim.opt_local.number = true end,
})

-- Cursor appearance
vim.opt.guicursor = table.concat({
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}, ",")

-- Load custom Lua modules

-- Must define <leader> first! Also includes universal keymaps (not plugin/filetype specific)
require("user.keymaps")

-- Plugin initialization
require("user.lazy")
require("user.plugins")

-- Custom behavior
require("user.myfolds")
require("user.mysyntax")

-- Plugin configurations (plus additional keymaps)
require("user.colorscheme")
require("user.treesitter")
require("user.lualine")
require("user.notify")
require("user.noice")
require("user.nvim-colorizer")
require("user.indent-blankline")
require("user.completion")
require("user.commands")
require("user.navbuddy")
require("user.barbecue")
require("user.lsp")
require("user.null-ls")
require("user.oil")
require("user.telescope")
require("user.bqf")
require("user.goto-preview")
require("user.nvim-tree")
require("user.gitsigns")
require("user.vim-signature")
require("user.browser-bookmarks")
require("user.harpoon")
