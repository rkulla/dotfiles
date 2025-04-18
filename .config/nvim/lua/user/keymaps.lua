-- MISC maps (plugin-specific maps go in my plugin config files)
-- I try to group normal mode maps by "namespaces", e.g., all window mappings start with <Leader>w, etc.
-- Only <Leader>n I accept to be a single char unnamespaced, since it will have a delay.
local map = vim.keymap.set

-- Remap <Leader> to spacebar
-- Note: don't create imap's starting with <Leader> or <Space> or they'll lag
vim.g.mapleader = " "

-- Pressing X closes buffers faster,
-- pressing X again quickly quits Neovim IF only only 0 or 1 buffers are left.
local quit_pending = false
map("n", "X", function()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers > 1 then
    -- Just close the buffer, no quit logic
    vim.cmd("bd")
    return
  end
  -- Only one or zero buffers left
  if quit_pending then
    vim.cmd("qa") -- Quit Neovim
  else
    print("Press X again to quit Neovim")
    quit_pending = true
    vim.defer_fn(function() quit_pending = false end, 3000)
  end
end)

-- Escape faster
map("i", "jk", "<Esc>")
map("i", "jj", "<Esc>")
-- delete words faster
map("i", ";;", "<C-w>")

-- Close read or write buffers faster
-- Close read or write buffers faster
-- leave the buffer running in :ls! to reopen with <leader><leader>
map("n", "<leader>q", ":bd<cr>", { desc = "Close buffer" })

-- Toggle line numbers
map("n", "<leader>n", ":set invnumber<cr>", { desc = "Toggle line numbers" })

-- Disable Ctrl+A (incrementing numbers) in normal mode
vim.api.nvim_set_keymap("n", "<C-a>", "<Nop>", { noremap = true, silent = true })
-- Disable Ctrl+X (decrementing numbers) in normal mode
vim.api.nvim_set_keymap("n", "<C-x>", "<Nop>", { noremap = true, silent = true })

-- Underline the current line with dashes
map("n", "<Leader>u", [[:call append(line("."), repeat("-", len(getline("."))))<CR>]])

-- Open a floating terminal. Useful for very shortlived "Hotkey terminal" commands
map("n", "<leader>5", ':lua require"user.myfloat".open_term_in_floating_window()<CR>', { desc = "Open term in floating window" })

-- Open ~/my-shortcuts.txt in a floating / telescope fuzzy find window
map(
  "n",
  "<leader>sc",
  ':lua require"user.myfloat".open_file_in_floating_window("~/my-shortcuts.txt")<CR><cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
  { silent = true, desc = "Open file in floating window" }
)

-- Open README.rkulla in for rapid viewing/editing. Uses telescope in case there are multiple files with that name
map(
  "n",
  "<leader>R",
  ":lua require('telescope.builtin').find_files({ search_file = 'README.rkulla', prompt_title = 'Find README.rkulla', no_ignore = true })<CR>",
  { silent = true, desc = "Open README.rkulla" }
)

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

--- Copy current buffer's path (useful to paste for CLI args)
map(
  "n",
  "<leader>cp",
  ":let @+ = substitute(expand('%:p'), escape(getcwd(), ' ') . '/', '', '')<cr>",
  { desc = "Copy current file's relative path" }
)
map("n", "<leader>ca", ":let @+ = expand('%:p')<CR>", { desc = "Copy current file's absolute path" })
map("n", "<leader>cn", ":let @+ = expand('%:t')<cr>", { desc = "Copy current file's name" })
map("n", "<leader>cl", [[:let @+ = join(map(split(execute('ls'),'\n'),{_,x->split(x,'"')[1]}))<cr>]], { desc = "Copy paths of all open files" })
map("n", "<leader>cw", ":let @+ = system('pwd')<CR>", { desc = "Copy CWD to clipboard" })

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
-- After escaping terminal mode, I can reenter it with <spc>si
map("n", "<leader>si", ":startinsert<cr>", { desc = "Interact with a :term buffer" })
-- I can also type <spc>5 for a floating term, or type :term for a full-screen term
map("n", "<leader>ta", ":10split +term<cr>", { desc = "Open terminal above" })

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

-- :NavBuddy shortcut
map("n", "<leader>NB", function() require("nvim-navbuddy").open() end, { desc = "Navbuddy" })

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

-- Open Urls or Files externally
-- If the current line has a URL, open it. Otherwise, open the current file
local function open_smart()
  local line = vim.api.nvim_get_current_line()
  local url = line:match("[a-z]+://[^ >,;]*")

  if url then
    vim.cmd("silent !open " .. vim.fn.shellescape(url))
  else
    vim.cmd("silent !open %")
  end
end
map("n", "<leader>o", open_smart, { desc = "Open URL or file" })

-- Markdown
-- Open term with glow (brew install glow) in light or dark mode, to render markdown files for viewing
-- I don't use markdown-preview.nvim which can edit markdown, because I'd rather not use the terminal for that
vim.api.nvim_set_keymap("n", "<leader>ml", ':term glow -s light "' .. vim.fn.expand("%:p") .. '"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>md", ':term glow -s dark "' .. vim.fn.expand("%:p") .. '"<CR>', { noremap = true, silent = true })

-- Vimscript-based plugins ------------------------------------------------

-- Fugitive
map("n", "gst", "<cmd>G status<cr>", { desc = "Git status" })
map("n", "gsf", "<cmd>Gclog -n 1 --follow --diff-filter=A -- %<cr>", { desc = "Git [curr file] first added" })
map("n", "gsa", '<cmd>Gclog --date=short --pretty=format:"%h ┃ %cd ┃ %an ┃ %s" -- %<cr>', { desc = "Git all commits [curr file]" })
map("n", "gl", "<cmd>Glcd<cr>", { desc = ":Glcd" }) -- useful with telescope-repo.nvim to cd after opening
