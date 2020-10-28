call plug#begin($XDG_CONFIG_HOME . '/nvim-nightly/vim-plug')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'honza/vim-snippets'
Plug '9mm/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'tweekmonster/startuptime.vim'
Plug 'lifepillar/gruvbox8'

call plug#end()

set ts=2 sts=2 sw=2 et list lcs=tab:┆·,trail:·,precedes:,extends:
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$XDG_CONFIG_HOME/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
let &stl = " %f %m"
let g:gruvbox_italicize_strings = 1
colo gruvbox8

let g:diagnostic_enable_virtual_text = 1
let g:completion_confirm_key = "\<C-y>"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

command! Format execute 'lua vim.lsp.buf.formatting()'

:lua << EOF
  local lsp = require('nvim_lsp')
  local on_attach = function(_, bufnr)
    require('diagnostic').on_attach()
    require('completion').on_attach()
  end
  lsp.pyls_ms.setup{ on_attach = on_attach }
  lsp.vimls.setup{ on_attach = on_attach }
  lsp.clangd.setup{ on_attach = on_attach }
EOF

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
command! Cp :0r /Users/michaellan/code/cp/xstemp.cpp
