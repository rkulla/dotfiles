local lspconfig = require("lspconfig")
local ih = require("inlay-hints")
local navbuddy = require("nvim-navbuddy")

-- Hide virtual text but keep the signs for lower severity things. View as float with LSP Diagnostic Float or TroubleToggle maps
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity_limit = "Hint",
  },
  virtual_text = {
    severity_limit = "Warning",
  },
})

-- on_attach function to only do the following after lang server attaches to current buffer
local on_attach = function(client, bufnr)
  -- Note: all LSP related keymaps are in my null-ls config

  navbuddy.attach(client, bufnr)

  -- Disable Autoformat for anything I use null-ls formatters for
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  -- Enable the 'hints' section of gopls
  if client.name == "gopls" then ih.on_attach(client, bufnr) end

  -- Highlight symbol under cursor everywhere
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! LspReferenceRead cterm=bold ctermbg=235 guibg=LightYellow
      hi! LspReferenceText cterm=bold ctermbg=235 guibg=LightYellow
      hi! LspReferenceWrite cterm=bold ctermbg=235 guibg=LightYellow
    ]])
    vim.api.nvim_create_augroup("lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = 0,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = 0,
      callback = vim.lsp.buf.clear_references,
    })
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
  callback = function() go_org_imports(1000) end,
})

-- Use lspconfig.<server>.setup() below register each lang server

lspconfig.tsserver.setup({
  on_attach = on_attach,
  -- TODO get auto-imports working. (null-ls was abanandoed so may wait for native ability)
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
        assignVariableTypes = false,
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
