-- Start terminal in insert mode. Avoid doing on "BufEnter" or it's annoying
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
  pattern = "term://*",
  command = "startinsert",
})
