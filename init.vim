call plug#begin($XDG_DATA_HOME . '/nvim-nightly/vim-plug')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'honza/vim-snippets'
Plug '9mm/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'lifepillar/gruvbox8'
Plug 'sainnhe/edge'
Plug 'tweekmonster/startuptime.vim'
Plug 'mizlan/termbufm'

call plug#end()

set ts=2 sts=2 sw=2 et list lcs=tab:┆·,trail:·,precedes:,extends:
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$XDG_DATA_HOME/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
let &stl = ' %f %m%=%y '
let g:gruvbox_italicize_strings = 0
let g:edge_style = 'neon'
colo edge

let g:terminal_color_0="#363a4e"
let g:terminal_color_8="#363a4e"
let g:terminal_color_1="#ec7279"
let g:terminal_color_9="#ec7279"
let g:terminal_color_2="#a0c980"
let g:terminal_color_10="#a0c980"
let g:terminal_color_3="#deb974"
let g:terminal_color_11="#deb974"
let g:terminal_color_4="#6cb6eb"
let g:terminal_color_12="#6cb6eb"
let g:terminal_color_5="#d38aea"
let g:terminal_color_13="#d38aea"
let g:terminal_color_6="#5dbbc1"
let g:terminal_color_14="#5dbbc1"
let g:terminal_color_7="#c5cdd9"
let g:terminal_color_15="#c5cdd9"
let g:terminal_color_background="#2b2d3a"
let g:terminal_color_foreground="#c5cdd9"

let g:diagnostic_virtual_text_prefix = ''
let g:diagnostic_enable_virtual_text = 1
let g:completion_confirm_key = "\<C-y>"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

:lua << EOF
  local nvim_lsp = require('nvim_lsp')
  local on_attach = function(_, bufnr)
    require('diagnostic').on_attach()
    require('completion').on_attach()
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xd', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  end
  local servers = {'jsonls', 'pyls_ms', 'vimls', 'clangd', 'tsserver', 'cssls', 'html'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

command! -buffer -nargs=0 LspShowLineDiagnostics lua require'jumpLoc'.openLineDiagnostics()
nnoremap <buffer><silent> <C-h> <cmd>LspShowLineDiagnostics<CR>
command! Format execute 'lua vim.lsp.buf.formatting()'

:lua << EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
      disable = { },
    },
  }
EOF

" au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['sh', 'vim']

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
command! Cp :0r /Users/michaellan/code/cp/xstemp.cpp
nn <silent> <leader>b :call TermBufMExecCodeScript(&filetype, 'build')<CR>
nn <silent> <leader>r :call TermBufMExecCodeScript(&filetype, 'run')<CR>

let $V='$XDG_CONFIG_HOME/nvim-nightly'
so $V/xstl.vim
