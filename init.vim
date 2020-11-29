call plug#begin($HOME . '/.config/xxxnvim/vim-plug')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'honza/vim-snippets'
Plug '9mm/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'sainnhe/edge'
Plug 'tweekmonster/startuptime.vim'
Plug 'mizlan/termbufm'
Plug 'mhinz/vim-signify'
Plug 'SirVer/ultisnips'

call plug#end()

set ts=2 sts=2 sw=2 et list lcs=tab:┆·,trail:·,precedes:,extends:
set hid nowrap spr sb ic scs nu rnu tgc nosmd swb=useopen scl=yes nosc noru icm=split
set udir=$XDG_DATA_HOME/nvim/undodir udf
set cot=menuone,noinsert,noselect shm+=c
set bg=dark
let g:edge_style = 'neon'
colo edge

let $V=$HOME .'/.config/xxxnvim'
so $V/xstl.vim
so $V/aesth.vim

let g:diagnostic_virtual_text_prefix = ''
let g:diagnostic_enable_virtual_text = 1

let g:completion_confirm_key = "\<C-y>"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1

:lua << EOF
  local nvim_lsp = require('lspconfig')
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
  local servers = {'jsonls', 'pyls_ms', 'vimls', 'clangd', 'tsserver', 'cssls', 'html', 'jdtls', 'sumneko_lua'}
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

let g:markdown_fenced_languages = ['sh', 'vim']

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>

com! Cp :0r /Users/michaellan/code/cp/xstemp.cpp
au FileType cpp ia <buffer> itn int

nn <silent> <leader>b :call TermBufMExecCodeScript(&filetype, 'build')<CR>
nn <silent> <leader>r :call TermBufMExecCodeScript(&filetype, 'run')<CR>
nn <silent> <leader>f :call TermBufMExec('pbpaste > input')<CR>
nn <silent> <leader><space> :call TermBufMToggle()<CR>

let g:termbufm_code_scripts = {
      \ 'python': { 'build': [''],                                     'run': ['cat input | python %s', '%'] },
      \ 'cpp':    { 'build': ['g++ -std=c++11 -DFEAST_LOCAL %s', '%'], 'run': ['cat input | ./a.out'] },
      \ 'java':   { 'build': ['javac %s', '%'],                        'run': ['cat input | java %s', '%:r'] },
      \ 'c':      { 'build': ['gcc %s', '%'],                          'run': ['cat input | ./a.out'] },
      \ }

nn <silent> <leader>j :NextDiagnosticCycle<CR>
nn <silent> <leader>k :PrevDiagnosticCycle<CR>
