-- NOTE: If GitHup Copilot is installed, it will override this Tab completion. `:Copilot disable` if desired.
-- TODO: Consider LSP-based completion IF this and/or copilot no longer does the job as well
--
-- TODO uncomment the following if/when nvim ever supports it natively
-- vim.opt.completepopup = { 'border:rounded', 'title:Omnifunc', 'title_pos:center' }

--  Run omni-completion via TAB in insert mode. TAB again cycles forward, Shift+Tab cycles backward. ENTER selects
--  NOTE: Don't forget I can also complete based on existing words on the page with Ctrl+n
--  NOTE: Don't forget I can also complete based on relative files with Ctrl+x Ctrl+f
local map = vim.keymap.set
map("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-o>"', { expr = true, silent = true })
map("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true, silent = true })
map("i", "<CR>", 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', { expr = true, silent = true })
