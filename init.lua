P = require('neopm')

P 'nvim-lua/plenary.nvim'
P 'https://github.com/romainl/Apprentice'
P 'https://github.com/nvim-lualine/lualine.nvim'
P 'https://github.com/vale1410/vim-minizinc'
P 'https://github.com/numToStr/Comment.nvim'
P 'https://github.com/tpope/vim-surround'
P 'norcalli/nvim-colorizer.lua'
P 'https://github.com/neovim/nvim-lspconfig'
P 'https://github.com/romainl/vim-cool'
P '~/Repositories/iswap.nvim'
P 'https://github.com/nvim-treesitter/nvim-treesitter'
P 'https://github.com/nvim-telescope/telescope.nvim'
P 'https://github.com/TimUntersberger/neogit'
P 'https://github.com/nvim-treesitter/nvim-treesitter-context'
P 'https://github.com/catppuccin/nvim'
P 'https://github.com/lewis6991/gitsigns.nvim'
P 'https://github.com/glepnir/lspsaga.nvim'
P 'https://github.com/phaazon/hop.nvim'
P 'https://github.com/ggandor/leap.nvim'
P 'https://github.com/pechorin/any-jump.vim'
P 'https://github.com/savq/melange'
P 'https://github.com/aktersnurra/no-clown-fiesta.nvim'
P 'https://github.com/folke/tokyonight.nvim'
P '~/Code/longbow.nvim'
P 'https://github.com/nvim-treesitter/playground'
P 'https://github.com/folke/lua-dev.nvim'

P.autoinstall(true)
P.load()

require('hop').setup{}

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
require("catppuccin").setup{
  integrations = {
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    neogit = true,
    gitsigns = true,
  }
}
vim.cmd [[colorscheme catppuccin]]
-- vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme apprentice]]

vim.cmd [[set ts=2 sw=2 sts=2 et]]

require('lualine').setup{
  options = { theme = 'catppuccin' }
}
require('Comment').setup()
require('colorizer').setup {
  css = { rgb_fn = true; }
}
require('iswap').setup {
  debug = true
}

vim.opt.ignorecase = true
vim.opt.wrap = false

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

require('lspconfig')['ocamllsp'].setup{
  on_attach = on_attach
}
require('lspconfig')['clangd'].setup{
  on_attach = on_attach
}
require('lspconfig')['pyright'].setup{
  on_attach = on_attach,
  cmd = { "pyright-langserver", "--stdio", "-v", "/Users/ml/GlobalVenv" }
}
require('lspconfig')['hls'].setup{
  on_attach = on_attach,
}
require('lspconfig')['sumneko_lua'].setup(require("lua-dev").setup{
  lspconfig = {
    on_attach = on_attach,
  }
})

vim.opt.signcolumn = 'yes'

local saga = require 'lspsaga'
saga.init_lsp_saga()

vim.cmd [[
if executable('opam')
  let g:opamshare=substitute(system('opam var share'),'\n$','','''')
  if isdirectory(g:opamshare."/merlin/vim")
    execute "set rtp+=" . g:opamshare."/merlin/vim"
  endif
endif
]]

vim.g.python3_host_prog = '~/GlobalVenv/bin/python3.9'

require('nvim-treesitter.configs').setup{
  highlight = { enable = true }
}

require('treesitter-context').setup{
  enable = true
}

require('gitsigns').setup()

vim.g.filetype_pl = 'perl'

vim.cmd [[au BufRead,BufNewFile *.pl setf perl]]

require('leap').set_default_keymaps()

require('neogit').setup{
  disable_commit_confirmation = true,
  use_magit_keybindings = true,
  signs = {
    -- { CLOSED, OPENED }
    section = { "", "" },
    item = { "", "" },
    hunk = { "", "" },
  },
}
