local map = vim.keymap.set
-- NOTE: If GitHup Copilot is installed, it will override this Tab completion. `:Copilot disable` if desired.
-- TODO: Consider LSP-based completion IF this and/or copilot no longer does the job as well
--
-- TODO uncomment the following if/when nvim ever supports it natively
-- vim.opt.completepopup = { 'border:rounded', 'title:Omnifunc', 'title_pos:center' }

-- NOTE: Don't forget ^n also does built-in copmletion based on buffers/words (:h ins-completion, :set complete?)
-- To complete relative external files with just ctrl+f in insert mode
map("i", "<C-f>", "<C-x><C-f>", { noremap = true })

--  Run omni-completion via TAB in insert mode. TAB again cycles forward, Shift+Tab cycles backward. ENTER selects
map("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-o>"', { expr = true, silent = true })
map("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true, silent = true })
map("i", "<CR>", 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', { expr = true, silent = true })
