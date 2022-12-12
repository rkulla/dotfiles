-- MISC maps (plugin-specific maps go in my plugin config files)
-- I try to group normal mode maps by "namespaces", e.g., all window mappings start with <Leader>w, etc.
-- Only <Leader>n I accept to be a single char unnamespaced, since it will have a delay.
local map = vim.keymap.set

-- Remap <Leader> to spacebar
vim.g.mapleader = " "

-- Close / escape / delete words faster
map("n", "X", ":q<cr>")
map("i", "jj", "<Esc>")
map("i", ";;", "<C-w>")

-- Close read or write buffers quicker
-- Close read or write buffers quicker
-- leave the buffer running in :ls! to reopen with <leader><leader>
map("n", "<leader>q", ":bd<cr>")

-- toggle line numbers
map("n", "<leader>n", ":set invnumber<cr>")

-- Run omni-completion by typing TAB in insert mode
map("i", "<Tab>", "<C-x><C-o>", { desc = "Omni-Completion" })

-- Keep cursor where it is after * search of current word
map("n", "*", "*``")

-- " ^n and ^p for next and prev buffer
map("n", "<C-n>", ":bn<cr>")
map("n", "<C-p>", ":bp<cr>")
map("n", "<leader><leader>", "<C-^>")

-- ^s to save file in normal or insert mode
map("n", "<C-s>", ":update!<cr>")
map("i", "<C-s>", "<C-o>:update!<cr>")

-- Auto-select text what was just pasted (gv for last selected)
map("n", "<leader>sp", "`[v`]")

-- `` to toggle last cursor position
map("n", "<LeftMouse>", "m'<LeftMouse>")

--- Copying currently open file names to the clipboard --------------------

--- Copy current buffer's relative path (useful to paste for CLI args)
map("n", "<leader>cp", ":let @+ = @%<cr>")
map("n", "<leader>cn", ":let @+ = expand('%:t')<cr>")
map("n", "<leader>cl", [[:let @+ = join(map(split(execute('ls'),'\n'),{_,x->split(x,'"')[1]}))<cr>]])

--- Quickfix window -------------------------------------------------------

-- After :0Gclog, load next/prev result while not maintaining cursor position in the file
map("n", "[q", ":let ws = winsaveview() <bar> cnext <bar> call winrestview(ws) <bar> unlet ws<cr>")
map("n", "]q", ":let ws = winsaveview() <bar> cprev <bar> call winrestview(ws) <bar> unlet ws<cr>")
map("n", "<leader>wqq", ":cclose<cr>", { desc = "Close quickfix window" })

--- Location list window --------------------------------------------------
map("n", "<leader>wql", ":lclose<cr>", { desc = "Close location list window" })

--- Split windows ---------------------------------------------------------

--- :Clear to close the current file w/o closing the split, then starts a new file
vim.cmd([[com! Clear :enew <bar> bdel #]])
-- Close the current file w/o closing the split window then jumps to the next file
map("n", "<leader>wC", ":bn <bar> bd #<cr>")
-- Toggle between split windows
map("n", "<leader>ww", "<C-w>w")

-- Move to windows by direction
map("n", "<leader>wh", "<C-w>h")
map("n", "<leader>wl", "<C-w>l")
map("n", "<leader>wk", "<C-w>k")
map("n", "<leader>wj", "<C-w>j")

-- Resize windows
map("n", "<leader>wH", ":vertical res -5<cr>")
map("n", "<leader>wL", ":vertical res +5<cr>")
map("n", "<leader>wK", ":res -5<cr>")
map("n", "<leader>wJ", ":res +5<cr>")

-- To "fullscreen" the current split window buffer. When done, :q or :tabc and get back to the previous "viewport"
-- Think of wz as standing for 'window zoom'. It just opens a new tab window split window. Close tab when finished
map("n", "<leader>wz", "<cmd>tab split<cr>")

-- Winbar toggle
map("n", "<leader>wb", function()
  if vim.o.winbar == "" then
    vim.o.winbar = "%=%m %f"
  else
    vim.o.winbar = ""
  end
end, { desc = "Winbar Toggle" })

-- Vimscript-based plugins ------------------------------------------------

-- Fugitive
map("n", "gst", "<cmd>G status<cr>", { desc = "Fugitive status" })
