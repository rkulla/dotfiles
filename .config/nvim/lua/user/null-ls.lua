local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then return end

local map = vim.keymap.set
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Note not everything is an LSP, e.g., prettierd, sylua aren't, but gopls and tsserver are
null_ls.setup({
  debug = false,
  sources = {
    formatting.stylua.with({
      extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "145", "--collapse-simple-statement", "Always" },
    }),
    formatting.prettierd, -- Work likes using this but at home I prefer eslint for formatting. Toggle accordingly
    diagnostics.eslint_d, -- `eslint .` on large projects timesout so caching is better
    code_actions.eslint_d, -- enable code actions for eslint as well
    diagnostics.tsc, -- additional typescript-compiler typechecking
    diagnostics.jsonlint, -- json file linter
    diagnostics.yamllint, -- yaml file linter
    diagnostics.vint, -- vim file linting
    diagnostics.hadolint, -- Dockerfile linter
    diagnostics.shellcheck, -- shell file linting
    code_actions.shellcheck,
    code_actions.gitsigns, -- git action on a hunk
  },

  -- All LSP keymaps go in this file so anything null-ls related will work as well
  on_attach = function(client, bufnr)
    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP go to definition" })
    map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP hover" })
    map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP code action" })
    map("n", "<leader>lDF", vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP diagnostic float" })
    map("n", "<leader>lDL", vim.diagnostic.setloclist, { buffer = bufnr, desc = "LSP diagnostic loclist" })
    map("n", "<leader>lh", vim.diagnostic.hide, { buffer = bufnr, desc = "LSP diagnostic hide" })
    map("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP implementation" })
    map("n", "<leader>lR", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP rename" })
    map("n", "<leader>lS", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP signature help" })
    map("n", "<leader>ld", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "LSP document symbols" })
    map("n", "<leader>lw", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "LSP workspace symbols" })
    map("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP type definition" })
    map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Diagnostic goto_prev" })
    map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Diagnostic goto_next" })

    -- Formatting: includes range formatting as long as your LSP client allows it, e.g., tsserver does, but gopls not yet
    map({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "LSP format" })

    -- Codelens
    map("n", "<leader>ll", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "LSP show codelens inlays" })
    map("n", "<leader>rc", vim.lsp.codelens.run, { buffer = bufnr, desc = "LSP run codelens action" })

    -- Telescope
    map("n", "<leader>fD", "<cmd>Telescope diagnostics<cr>", { buffer = bufnr, desc = "Find LSP diagnostics" })
    map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "Find LSP references" })
    map("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = bufnr, desc = "Find LSP Document Symbols" })
    map("n", "<leader>fw", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols({
        file_ignore_patterns = { "node_modules", "vendor" },
        symbol_width = 40, -- since my work computer uses a 32" monitor this is fine
        fname_width = 40,
      })
    end, { buffer = bufnr, desc = "Find LSP Workspace Symbols" })

    -- Trouble / Toggle
    map("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { buffer = bufnr, desc = "TroubleToggle" })
    map("n", "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", { buffer = bufnr, desc = "TroubleToggle lsp_references" })

    -- Format On Save
    if client.supports_method("textDocument/formatting") then
      -- Explicitly add what I want to allow to format-on-save ("null_ls" means all attached LSP servers, the rest are by filetype
      if client.name == "null_ls" or vim.bo.filetype == "lua" then
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
    end
  end,
})
