local map = vim.keymap.set

map("n", "<Leader>rr", ":!go run %<cr>", { desc = "Run current Go file" })
map("n", "<Leader>rb", ":!go build %<cr>", { desc = "Build current Go file" })
map("n", "<Leader>rT", ":!go test -coverprofile=coverage.out --count=1 -v ./...<cr>", { desc = "Test all Go test files" })
map(
  "n",
  "<Leader>rt",
  function() return "<cmd>!go test -count=1 -v -run " .. vim.call("expand", "<cword>") .. "<cr>" end,
  { expr = true, desc = "Test current Go test function" }
)
