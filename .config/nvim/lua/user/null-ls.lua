local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then return end

local map = vim.keymap.set
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  debug = false,
  sources = {
    formatting.stylua.with({
      extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "138", "--collapse-simple-statement", "Always" },
    }),
    formatting.prettier,
    diagnostics.eslint,
  },

  -- Format On Save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      map("n", "<leader>tf", require("user.utils").toggle_autoformat, { buffer = bufnr, desc = "Toggle Null-ls Format On Save" })

      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if AUTOFORMAT_ACTIVE then -- global var defined in utils.lua
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end,
})
