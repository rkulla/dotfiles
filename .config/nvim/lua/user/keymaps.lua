-- MISC maps (plugin-specific maps go in my plugin config files)
-- I try to group normal mode maps by "namespaces", e.g., all window mappings start with <Leader>w, etc.
-- Only <Leader>n I accept to be a single char unnamespaced, since it will have a delay.
local map = vim.keymap.set

-- Remap <Leader> to spacebar
vim.g.mapleader = " "

-- Close / escape / delete words faster
map("n", "X", ":q<cr>")
map("i", "jk", "<Esc>")
map("i", "jj", "<Esc>")
map("i", ";;", "<C-w>")

-- Close read or write buffers quicker
-- Close read or write buffers quicker
-- leave the buffer running in :ls! to reopen with <leader><leader>
map("n", "<leader>q", ":bd<cr>", { desc = "Close buffer" })

-- Toggle line numbers
map("n", "<leader>n", ":set invnumber<cr>", { desc = "Toggle line numbers" })

-- Open/Switch to README.rkulla in a split window for rapid viewing/editing
map("n", "<leader>R", ":10sp README.rkulla<cr><cmd>set number!<cr>", { silent = true, desc = "Open README.rkulla" })

-- Run omni-completion by typing TAB in insert mode
map("i", "<Tab>", "<C-x><C-o>", { desc = "Omni-Completion" })

-- Keep cursor where it is after * search of current word
map("n", "*", "*``")

-- " ^n and ^p for next and prev buffer
map("n", "<C-n>", ":bn<cr>")
map("n", "<C-p>", ":bp<cr>")
map("n", "<leader><leader>", "<C-^>", { desc = "Toggle last buffer" })

-- ^s to save file in normal or insert mode
map("n", "<C-s>", ":update!<cr>")
map("i", "<C-s>", "<C-o>:update!<cr>")

map("n", "<leader>sp", "`[v`]", { desc = "Select last pasted text" })

-- `` to toggle last cursor position
map("n", "<LeftMouse>", "m'<LeftMouse>")

--- Copying currently open file names to the clipboard --------------------

--- Copy current buffer's relative path (useful to paste for CLI args)
map("n", "<leader>cp", ":let @+ = @%<cr>", { desc = "copy current file's relative path" })
map("n", "<leader>cn", ":let @+ = expand('%:t')<cr>", { desc = "copy current file's name" })
map("n", "<leader>cl", [[:let @+ = join(map(split(execute('ls'),'\n'),{_,x->split(x,'"')[1]}))<cr>]], { desc = "Copy paths of all open files" })

--- Quickfix window -------------------------------------------------------

-- After :0Gclog, load next/prev result while not maintaining cursor position in the file
map("n", "[q", ":let ws = winsaveview() <bar> cprev <bar> call winrestview(ws) <bar> unlet ws<cr>", { desc = "cprev but maintain cursor pos" })
map("n", "]q", ":let ws = winsaveview() <bar> cnext <bar> call winrestview(ws) <bar> unlet ws<cr>", { desc = "cnext but maintain cursor pos" })

map("n", "<leader>wqq", ":cclose<cr>", { desc = "Close quickfix window" })

-- Don't map things to [c or ]c as they're already used for jumping next change/diff item, etc.
map("n", "<End>", ":cnext<cr>")
map("n", "<Home>", ":cprev<cr>")

--- Location list window --------------------------------------------------
map("n", "<leader>wql", ":lclose<cr>", { desc = "Close location list window" })

--- Terminal --------------------------------------------------------------
-- lowercase j is used for navigation in many TUI apps, so map to uppercase JJ
map("t", "JJ", "<C-\\><C-n><cr>", { desc = "ESC in terminal mode" })
map("t", "JK", "<C-\\><C-n><cr>", { desc = "ESC in terminal mode" })
-- Most of the time I just type :term to use a full-screen terminal
map("n", "<leader>ta", "10split +term", { desc = "Open terminal above" })

--- Split windows ---------------------------------------------------------

--- :Clear to close the current file w/o closing the split, then starts a new file
vim.cmd([[com! Clear :enew <bar> bdel #]])
map("n", "<leader>wC", ":bn <bar> bd #<cr>", { desc = "Close file but keep split open" })
map("n", "<leader>ww", "<C-w>w", { desc = "Toggle between split windows" })

map("n", "<leader>wh", "<C-w>h", { desc = "Switch to left window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Switch to right window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Switch to top window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Switch to bottom window" })

map("n", "<leader>wH", ":vertical res -5<cr>", { desc = "Resize split (smaller/vertical)" })
map("n", "<leader>wL", ":vertical res +5<cr>", { desc = "Resize split (larger/vertical)" })
map("n", "<leader>wK", ":res -5<cr>", { desc = "Resize split (smaller/horiz)" })
map("n", "<leader>wJ", ":res +5<cr>", { desc = "Resize split (larger/horiz)" })

-- To "fullscreen" the current split window buffer. When done, :q or :tabc and get back to the previous "viewport"
-- Think of wz as standing for 'window zoom'. It just opens a new tab window split window. Close tab when finished
map("n", "<leader>wz", "<cmd>tab split<cr>", { desc = "Zoom current split to full-screen" })

-- Winbar toggles
vim.o.winbar = "%=%m %f" -- Default to on

map("n", "<leader>wb", function()
  if vim.o.winbar == "" then
    vim.o.winbar = "%=%m %f"
  else
    require("barbecue.ui").toggle()
  end
end, { desc = "Winbar Toggle Between Barbecue" })

map("n", "<leader>wB", function()
  require("barbecue.ui").toggle(false)
  vim.o.winbar = ""
end, { desc = "Winbar Hide" })

-- Vimscript-based plugins ------------------------------------------------

-- Fugitive
map("n", "gst", "<cmd>G status<cr>", { desc = "Fugitive status" })
