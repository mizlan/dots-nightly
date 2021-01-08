local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

return require('packer').startup(
  function()
    use 'wbthomason/packer.nvim'

    use {'cideM/yui', branch = 'v2'} -- dark visual selection
    use 'junegunn/seoul256.vim'
    use 'jnurmine/Zenburn'
    use 'co1ncidence/sunset.vim'
    use 'olivertaylor/vacme'
    use 'arcticicestudio/nord-vim'

    use 'liuchengxu/vim-clap'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    use 'tpope/vim-commentary'
    use 'machakann/vim-sandwich'
    use '9mm/vim-closer'
    use 'romainl/vim-cool'

    use 'axvr/org.vim'

    use 'MaxMEllon/vim-jsx-pretty'
    use {'prettier/vim-prettier', run = 'yarn install', cmd = 'Prettier'}
    use 'dag/vim-fish'

    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'

    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'

    use 'editorconfig/editorconfig-vim'
    use 'mhinz/vim-signify'
    use 'tpope/vim-fugitive'

    use {'RRethy/vim-hexokinase', run = 'make hexokinase'}
    use 'lifepillar/vim-colortemplate'
    use 'bfredl/nvim-luadev'
  end
)
