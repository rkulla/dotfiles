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

  use 'folke/tokyonight.nvim'

  -- Plenary is required for certain plugins like Telescope
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    opt = true
  }

  use 'tpope/vim-surround'

  use 'tpope/vim-fugitive'

  use 'vim-scripts/tComment'

  use {
    'nvim-lualine/lualine.nvim',
    -- requires = { 'kyazdani42/nvim-web-devicons' },
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
