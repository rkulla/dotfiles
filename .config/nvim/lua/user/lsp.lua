local lspconfig = require("lspconfig")
local ih = require("inlay-hints")

-- on_attach function to only do the following after lang server attaches to current buffer
local on_attach = function(client, bufnr)
  -- Note: all LSP related keymaps are in my null-ls config

  -- Disable Autoformat for anything I use null-ls formatters for
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  -- Enable the 'hints' section of gopls
  if client.name == "gopls" then ih.on_attach(client, bufnr) end
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
  callback = function() go_org_imports(1000) end,
})

-- Use lspconfig.<server>.setup() below register each lang server

lspconfig.tsserver.setup({
  on_attach = on_attach,
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  cmd = { "gopls" },
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
      hints = { -- disabling all of them by default because my `K` map is less annoying usually
        assignVariableTypes = true,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      },
      codelenses = { -- <leader>ll to enable. Currently just shows additional hints
        generate = true,
        test = true,
        gc_details = true,
        regenerate_cgo = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = false,
      },
    },
  },
})
