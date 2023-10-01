require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    gs.toggle_current_line_blame() -- enable current line blame by default

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map("n", "<leader>gsf", gs.stage_buffer, { desc = "Git stage file" })
    map({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
    map("n", "<leader>guh", gs.undo_stage_hunk, { desc = "Git unstage hunk" })
    map("n", "<leader>guf", "<cmd>G restore --staged %<cr>", { desc = "Git unstage file" })
    map({ "n", "v" }, "<leader>gRh", ":Gitsigns reset_hunk<CR>", { desc = "Git reset HUNK's modifications!" })
    map("n", "<leader>gRf", gs.reset_buffer, { desc = "Git reset FULL FILE's modifications!" })
    map("n", "<leader>gbd", function() gs.blame_line({ full = true }) end, { desc = "Git blame line w/diff" })
    map("n", "<leader>gbl", gs.toggle_current_line_blame, { desc = "Git toggle current line blame" })
    map("n", "<leader>gbf", "<cmd>G blame<cr>", { desc = "Git blame file" })
    map("n", "<leader>gdc", gs.diffthis, { desc = "Git diff current changes to this file" })
    map("n", "<leader>gdl", function() gs.diffthis("~") end, { desc = "Git diff last changes to this file" })
    map("n", "<leader>gdP", gs.toggle_deleted, { desc = "Git diff preview file" })
    map("n", "<leader>gdp", gs.preview_hunk, { desc = "Git diff preview hunk" })

    -- Note: Telescope keymaps for git signs are in telescope.lua (git_files, git_branches, etc)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
