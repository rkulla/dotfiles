-- this is in ftplugin/ to only lazyload these keymaps when files are loaded, and just .go files
local map = vim.keymap.set

map(
  "n",
  "<Leader>rr",
  function() vim.cmd("botright new | setlocal nobuflisted | terminal clear && go run " .. vim.fn.expand("%")) end,
  { desc = "Run current Go file in fresh terminal" }
)

map("n", "<Leader>rb", ":!go build %<cr>", { desc = "Build current Go file" })
map("n", "<Leader>rT", ":!go test -coverprofile=coverage.out --count=1 -v ./...<cr>", { desc = "Test all Go test files" })
map(
  "n",
  "<Leader>rt",
  function() return "<cmd>!go test -count=1 -v -run " .. vim.call("expand", "<cword>") .. "<cr>" end,
  { expr = true, desc = "Test current Go test function" }
)
