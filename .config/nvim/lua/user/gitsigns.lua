require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

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
    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Gitsigns stage_buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Gitsigns stage_hunk" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Gitsigns preview_hunk" })
    map("n", "<leader>hB", function() gs.blame_line({ full = true }) end, { desc = "Gitsigns blame_line" })
    map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "Gitsigns toggle_current_line_blame" })
    map("n", "<leader>hq", gs.reset_buffer, { desc = "Gitsigns reset_buffer" }) -- delete all changes to the file
    map("n", "<leader>hd", gs.diffthis, { desc = "Gitsigns diffthis" }) -- show current changes of full file
    map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Gitsigns diffthis vs last" }) -- show changes the current file last did
    map("n", "<leader>td", gs.toggle_deleted, { desc = "Gitsigns toggle_deleted" }) -- show deleted version of changed line too

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
