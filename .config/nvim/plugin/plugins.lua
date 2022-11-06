-- Load this file by doing `lua require('plugins')` in init.vim
-- Run :PackerCompile after editing this file
-- Run :PackerUpdate to install/update the plugins from packer.startup below

-- Custom Packer initialization
packer = require 'packer'
packer.init {
  opt_default = true,  -- default to using opt/ (as opposed to start/)
  display = {
    open_fn = require('packer.util').float, -- Use float window, not split
    show_all_info = true, -- Show all update details automatically
  }
}
packer.reset()

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return packer.startup(function(use)
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    opt = false  -- Have packer itself go to start/ not opt/
  }

  use {
    'folke/tokyonight.nvim',
    opt = false
  }

  use {
    'shaunsingh/nord.nvim',
    opt = false
  }

  use 'tpope/vim-surround'

  use 'tpope/vim-fugitive'

  use 'vim-scripts/tComment'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- install markdown-preview without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

end)
