local lspconfig = require("lspconfig")
local map = vim.keymap.set

-- on_attach function to only map the following after lang server attaches to current buffer
local on_attach = function(client, bufnr)
  map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP go to definition" })
  map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
  map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP implementation" })
  map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP hover" })
  map("n", "<leader>lk", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP hover" })
  map("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP go to definition" })
  map("n", "<leader>lD", vim.diagnostic.setloclist, { buffer = bufnr, desc = "LSP diagnostic" })
  map("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP implementation" })
  map("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP type definition" })
  map("n", "<leader>lr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
  map("n", "<leader>lR", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP rename" })
  map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP signature help" })
  map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP code action" })
  map("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr, desc = "LSP format" })
  map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Diagnostic goto_prev" })
  map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Diagnostic goto_next" })

  -- Telescope
  map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { buffer = bufnr, desc = "Telescope lsp_definitions" })
  map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "Telescope lsp_references" })

  -- Trouble
  map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { buffer = bufnr, desc = "TroubleToggle" })
  map(
    "n",
    "<leader>tr",
    "<cmd>TroubleToggle lsp_references<cr>",
    { buffer = bufnr, desc = "TroubleToggle lsp_references" }
  )

  -- Disable Autoformat for anything I use null-ls formatters for
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
end

-- Golang: Auto-import / sort imports on save / format code
function go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } } -- use gopls' imports code action
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
  vim.lsp.buf.format({ async = true }) -- auto-format as well!
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = function()
    go_org_imports(1000)
  end,
})

-- Use lspconfig.<server>.setup() below register each lang server

lspconfig.tsserver.setup({
  on_attach = on_attach,
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        shadow = true,
        nilness = true,
        useany = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
})
