require("lazy").setup({
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "NvChad/nvim-colorizer.lua" },

  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  },

  { "utilyre/barbecue.nvim", version = "*" },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },

  { "stevearc/oil.nvim" },

  { "nvim-lua/plenary.nvim" },
  { "kkharji/sqlite.lua" },

  { "nvim-telescope/telescope.nvim" },

  { "nvim-telescope/telescope-file-browser.nvim" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  { "nvim-telescope/telescope-github.nvim" },
  { "dhruvmanila/browser-bookmarks.nvim", version = "*" },
  { "jvgrootveld/telescope-zoxide" },
  { "cljoly/telescope-repo.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { "kevinhwang91/nvim-bqf" },
  { "rmagatti/goto-preview" },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tr",
        "<cmd>Trouble lsp_references focus=false win.position=right<cr>",
        desc = "LSP references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>td",
        function() vim.diagnostic.open_float(nil, { focus = false }) end,
        desc = "Preview diagnostic message on current line",
      },
    },
  },

  {
    "folke/which-key.nvim",
    config = true,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    config = true,
  },

  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },

  { "lewis6991/gitsigns.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "kshenoy/vim-signature" },
  { "lukas-reineke/indent-blankline.nvim" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  { "rcarriga/nvim-notify" },
  { "folke/noice.nvim" },
})
