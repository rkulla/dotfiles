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
  if client.name == "ts_ls" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

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
local function go_org_imports(wait_ms)
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then return end

  -- Prefer gopls, fallback to any client
  local client = vim.tbl_filter(function(c) return c.name == "gopls" end, clients)[1] or clients[1]

  if not client then return end

  -- Pass the encoding explicitly to avoid the warning
  local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
  params.context = { only = { "source.organizeImports" } }

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  if not result then return end

  for client_id, res in pairs(result) do
    if res.result then
      for _, action in ipairs(res.result) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        elseif action.command then
          local cmd = action.command
          if cmd.arguments and not vim.tbl_islist(cmd.arguments) then cmd.arguments = { cmd.arguments } end
          if cmd.command and type(cmd.command) == "string" then vim.lsp.buf.execute_command(cmd) end
        end
      end
    end
  end

  -- Format after imports
  vim.defer_fn(function() vim.lsp.buf.format({ async = true }) end, 100)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function() go_org_imports(1000) end,
})

-- Golang LSP configuration using vim.lsp
vim.lsp.config["gopls"] = {
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
      hints = { -- Enable all hints by default but use my inlay-hint toggle keymap to see
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
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
      buildFlags = { "-tags=integration" }, -- work with integration tests that do //go:build integration
    },
  },
}

-- TypeScript LSP configuration using vim.lsp
vim.lsp.config["ts_ls"] = {
  on_attach = on_attach,
  -- TODO get auto-imports working. (null-ls was abanandoed check if none-ls can now)
}

-- After defining the LSP configurations, you need to manually enable them
vim.lsp.enable("gopls")
vim.lsp.enable("ts_ls")
