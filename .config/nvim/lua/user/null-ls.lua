local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then return end

local map = vim.keymap.set
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  debug = false,
  sources = {
    formatting.stylua.with({
      extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "138", "--collapse-simple-statement", "Always" },
    }),
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    formatting.prettierd, -- Employer likes it but at home I prefer eslint for formatting
    diagnostics.eslint_d, -- `eslint .` on large projects timesout so caching is better
    code_actions.eslint_d, -- enable code actions for eslint as well
    diagnostics.tsc, -- additional typescript-compiler typechecking
    diagnostics.jsonlint, -- json file linter
    diagnostics.vint, -- vim file linting
    diagnostics.hadolint, -- Dockerifle linter
    diagnostics.shellcheck, -- Shell script linter
    code_actions.shellcheck,
    code_actions.gitsigns, -- git action on a hunk
  },

  -- All LSP keymaps go in this file so anything null-ls related will work as well
  on_attach = function(client, bufnr)
    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP go to definition" })
    map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
    map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP implementation" })
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP hover" })
    map("n", "<leader>ld", vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP diagnostic float" })
    map("n", "<leader>lD", vim.diagnostic.setloclist, { buffer = bufnr, desc = "LSP diagnostic loclist" })
    map("n", "<leader>lh", vim.diagnostic.hide, { buffer = bufnr, desc = "LSP Diagnostic hide" })
    map("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP type definition" })
    map("n", "<leader>lR", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP rename" })
    map("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP signature help" })
    map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP code action" })
    map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Diagnostic goto_prev" })
    map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Diagnostic goto_next" })

    -- Formatting: includes range formatting as long as your LSP client allows it, e.g., tsserver does, but gopls not yet
    map({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "LSP format" })

    -- Codelens
    map("n", "<leader>ll", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "LSP Show Codelens Inlays" })
    map("n", "<leader>rc", vim.lsp.codelens.run, { buffer = bufnr, desc = "LSP Run Codelens Action" })

    -- Telescope
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { buffer = bufnr, desc = "Telescope lsp_definitions" })
    map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "Telescope lsp_references" })

    -- Trouble / Toggle
    map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { buffer = bufnr, desc = "TroubleToggle" })
    map("n", "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", { buffer = bufnr, desc = "TroubleToggle lsp_references" })

    -- Format On Save
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
