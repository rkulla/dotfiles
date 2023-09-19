local map = vim.keymap.set

map({ "n", "o", "x" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
map("n", "<leader>tF", function() require("flash").toggle() end, { desc = "Toggle Flash" })

require("flash").setup({
  modes = {
    -- options used when flash is activated through
    -- a regular search with `/` or `?`
    search = {
      -- when `true`, flash will be activated during regular search by default.
      -- You can always toggle when searching with `require("flash").toggle()`
      -- I NEVER enable this because I hate how it escapes out of my searches
      enabled = false,
    },
  },
})

-- Default to my light highlight colors for Flash (defined in colorscheme.vim)
vim.cmd("autocmd VimEnter * SetFlashLight")
