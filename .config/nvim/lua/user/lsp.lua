-- Note: see go.lua, typescript.lua, etc for language specific configuration
local lspconfig = require'lspconfig'
local lsp_util = require "lspconfig/util"

-- lspconfig --------------------------------

-- add more servers to this table as needed
local servers = { 'tsserver', 'gopls' } 

-- on_attach function to only map the following after lang server attaches to current buffer
local on_attach  = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '<space>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<space>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<space>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', '<space>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', '<space>ldf', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.keymap.set('n', '<space>ldl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.keymap.set('n', '<space>lf', function() vim.lsp.buf.format { async = true } end, opts)

  -- Disable Autoformat
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
end

-- Register the LSP key mappings above, for all language servers
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach
  }
end

-- Golang: Auto-import / sort imports on save
function go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
	for _, r in pairs(res.result or {}) do
	  if r.edit then
		local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
		vim.lsp.util.apply_workspace_edit(r.edit, enc)
	  end
	end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.go"},
  callback = function() go_org_imports(1000) end,
})

lspconfig.gopls.setup {
  cmd = {"gopls"},
  filetypes = {"go", "gomod"},
  root_dir = lsp_util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- end lspconfig -----------------------------

