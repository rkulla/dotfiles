-- Load this file by doing `lua require('plugins')` in init.vim
-- Run :PackerCompile after editing this file
-- Run :PackerSync to install/update the plugins from packer.startup below

-- Custom Packer initialization
packer = require 'packer'
packer.init {
  opt_default = false,  -- default to using start/ (as opposed to opt/)
  display = {
    open_fn = require('packer.util').float, -- Use float window, not split
    show_all_info = true, -- Show all update details automatically
  }
}
packer.reset()

return packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use 'folke/tokyonight.nvim'

  -- Plenary is required for certain plugins like Telescope
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    opt = true
  }
  
  -- requires telescope and `gh` cli
  use 'nvim-telescope/telescope-github.nvim'

  -- Lua
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      }
    end
  }

  use 'tpope/vim-surround'

  use 'tpope/vim-fugitive'
  -- rhubarb enables :GBrowse from fugitive to open GitHub
  use 'tpope/vim-rhubarb'

  use 'lewis6991/gitsigns.nvim'

  use 'vim-scripts/tComment'

  use {
    'nvim-lualine/lualine.nvim',
  }

  -- install markdown-preview without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    opt = true
  })

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', 
    }
  }

end)
