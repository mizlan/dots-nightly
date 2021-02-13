local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

local use = require('packer').use

return require('packer').startup(
  function()
    use 'wbthomason/packer.nvim'

    use {'cideM/yui', branch = 'v2'} -- dark visual selection
    use 'junegunn/seoul256.vim'
    use 'lifepillar/vim-gruvbox8'
    use 'neovimhaskell/haskell-vim'

    use 'tpope/vim-commentary'
    use 'machakann/vim-sandwich'
    use '9mm/vim-closer'
    use 'romainl/vim-cool'

    use 'junegunn/vim-easy-align'

    use 'dag/vim-fish'

    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'

    use 'editorconfig/editorconfig-vim'
    use 'mhinz/vim-signify'

    use {'RRethy/vim-hexokinase', run = 'make hexokinase', cmd = 'HexokinaseToggle'}

    use 'bfredl/nvim-luadev'
  end
)
