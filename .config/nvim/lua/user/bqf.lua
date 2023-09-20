require("bqf").setup({
  auto_enable = true,
  magic_window = true,
  auto_resize_height = false,
  preview = {
    auto_preview = true,
    border = "rounded",
    show_title = true,
    show_scroll_bar = true,
    delay_syntax = 50,
    win_height = 999, -- "full" mode
    win_vheight = 15,
    winblend = 9,
    wrap = false,
    buf_label = true,
    should_preview_cb = nil,
  },
  -- make `drop` and `tab drop` to become preferred
  func_map = {
    drop = "o",
    openc = "O",
    split = "<C-s>",
    tabdrop = "<C-t>",
    -- set to empty string to disable
    tabc = "",
    ptogglemode = "z,",
  },
  filter = {
    fzf = {
      action_for = {
        ["ctrl-t"] = "tabedit",
        ["ctrl-v"] = "vsplit",
        ["ctrl-x"] = "split",
        ["ctrl-q"] = "signtoggle",
        ["ctrl-c"] = "closeall",
      },
      extra_opts = { "--bind", "ctrl-o:toggle-all" },
    },
  },
})

