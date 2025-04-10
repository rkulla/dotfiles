-- TODO: Consider LSP-based completion IF this and/or copilot no longer does the job as well
--  Run omni-completion via TAB in insert mode. TAB again cycles forward, Shift+Tab cycles backward. ENTER selects
vim.keymap.set("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-o>"', { expr = true, silent = true })
vim.keymap.set("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true, silent = true })
vim.keymap.set("i", "<CR>", 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', { expr = true, silent = true })
