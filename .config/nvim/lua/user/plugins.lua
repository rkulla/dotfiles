-- Load this file by doing `lua require('plugins')` in init.vim
-- Run :PackerCompile after editing this file
-- Run :PackerSync to install/update the plugins from packer.startup below

-- Custom Packer initialization
packer = require("packer")
packer.init({
  opt_default = false, -- default to using start/ (as opposed to opt/)
  display = {
    open_fn = require("packer.util").float, -- Use float window, not split
    show_all_info = true, -- Show all update details automatically
  },
})
packer.reset()

return packer.startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- colorscheme should go before most plugins
  use("folke/tokyonight.nvim")
  use({ "catppuccin/nvim", as = "catppuccin" })
  use("folke/flash.nvim")
  use("NvChad/nvim-colorizer.lua")

  use("simrat39/symbols-outline.nvim")

  use({
    "SmiteshP/nvim-navbuddy",
    requires = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  })

  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {},
  })

  use("neovim/nvim-lspconfig")
  use("jose-elias-alvarez/null-ls.nvim")
  use("simrat39/inlay-hints.nvim") -- EOL hints until nvim supports anticonceal

  use({ "stevearc/oil.nvim" })

  -- Plenary is required for certain plugins like Telescope and Harpoon
  use("nvim-lua/plenary.nvim")
  -- sqlite.lua is needed for certain plugins, like telescope-bookmarks
  use({ "kkharji/sqlite.lua" })

  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
  })
  -- The following extensions all require telescope (and anything else mentioned)
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  -- requires `brew install cmake`. Makes it so I can use fzf syntax operators like ', ^, !, etc.
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
  -- requires `brew install gh`
  use("nvim-telescope/telescope-github.nvim")
  -- requires sqlite.lua (for firefox bookmarks to work)
  use({ "dhruvmanila/browser-bookmarks.nvim", tag = "*" })
  -- requires `brew install zoxide`
  use("jvgrootveld/telescope-zoxide")
  -- requires `brew install fd glow`
  use("cljoly/telescope-repo.nvim")
  -- Dependency free, aside from telescope
  use("ahmedkhalf/project.nvim")
  -- Dependency free, aside from telescope
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  -- Dependency free, aside from telescope
  use({ "nvim-telescope/telescope-live-grep-args.nvim" })

  -- Harpoon2 ("pin" frequently used buffers)
  use({
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  -- Better quickfix. Gives telescope previews to quickfix, etc
  use({ "kevinhwang91/nvim-bqf" })

  use({ "rmagatti/goto-preview" })

  use("folke/trouble.nvim")

  use({
    "folke/which-key.nvim",
    config = function() require("which-key").setup({}) end,
  })

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  })

  use("tpope/vim-commentary")

  use("tpope/vim-fugitive")
  -- rhubarb enables :GBrowse from fugitive to open GitHub
  -- (Still required setting my own :Browse command, though)
  use("tpope/vim-rhubarb")

  use("lewis6991/gitsigns.nvim")

  use("nvim-lualine/lualine.nvim")

  use("kshenoy/vim-signature")

  use("lukas-reineke/indent-blankline.nvim")

  -- install markdown-preview without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    opt = true,
  })

  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })

  use("rcarriga/nvim-notify")
  use("folke/noice.nvim")
end)
