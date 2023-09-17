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
  use("folke/flash.nvim")

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
    config = function() require("barbecue").setup() end,
  })

  use("neovim/nvim-lspconfig")
  use("jose-elias-alvarez/null-ls.nvim")
  use("simrat39/inlay-hints.nvim") -- EOL hints until nvim supports anticonceal

  use({ "stevearc/oil.nvim" })

  -- Plenary is required for certain plugins like Telescope
  use("nvim-lua/plenary.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
  })
  -- requires telescope
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  -- requires telescope and `gh` cli
  use("nvim-telescope/telescope-github.nvim")

  -- Better quickfix. Gives telescope previews to quickfix, etc
  use({ "kevinhwang91/nvim-bqf" })

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
end)
