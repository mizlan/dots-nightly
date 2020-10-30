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

let g:mode_dict = { 'n': '', 'no': '', 'nov': '', 'noV': '', "no\<C-v>": '', 'niI': '', 'niR': '', 'niV': '', 'v': '',
      \ 'V': '', "\<C-v>": '', 's': '', 'S': '', "\<C-s>": '', 'i': '', 'ic': '', 'ix': '', 'R': 'ﰉ', 'Rc': 'ﰉ', 'Rv': 'ﰉ',
      \ 'Rx': 'ﰉ', 'c': 'ﱕ', 'cv': 'ﱕ', 'ce': 'ﱕ', 'r': '', 'rm': '', 'r?': '', '!': '', 't': '', 'unknown': '', }
function AStl()
  let l:m = get(g:mode_dict, mode(1), g:mode_dict.unknown)
  let l:t = &ft ==# '' ? '' : &ft
  let l:c = &mod ? ' ' : ''
  let l:f = expand('%:t') | let l:f = l:f ==# '' ? '' : l:f
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let l:d =' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Error]])")} '
    let l:d.=' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")}'
  else
    let l:d = ''
  endif
  let l:x = '%#Normal# %#Directory#%#Search#'.l:m.'%#Directory# %#MoreMsg#%#IncSearch#'.l:f.l:c.'%#MoreMsg#%#Normal#%=%#Red#%#debugBreakpoint#'.l:d.'%#Red# %#Title#%#TablineSel#'.l:t.'%#Title#%#Normal# '
  return l:x
endfunction

function IStl()
  let l:m = get(g:mode_dict, mode(1), g:mode_dict.unknown)
  let l:t = &ft ==# '' ? '' : &ft
  let l:c = &mod ? ' ' : ''
  let l:f = expand('%:t') | let l:f = l:f ==# '' ? '' : l:f
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let l:d =' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Error]])")} '
    let l:d.=' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")}'
  else
    let l:d = ''
  endif
  let l:x = '%#Normal# %#VertSplit#%#MatchParen#'.l:m.'%#VertSplit# %#VertSplit#%#MatchParen#'.l:f.l:c.'%#VertSplit#%#VertSplit#%=%#VertSplit#%#MatchParen#'.l:d.'%#VertSplit# %#VertSplit#%#MatchParen#'.l:t.'%#VertSplit#%#VertSplit# '
  return l:x
endfunction

aug St
  au!
  au VimEnter,WinEnter,BufEnter * setl stl=%!AStl()
  au VimLeave,WinLeave,BufLeave * setl statusline=%!IStl()
aug END

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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
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

let mapleader = " "
nn <silent> <leader>n :noh<CR>
tno <silent> <Esc> <C-\><C-n>
command! Cp :0r /Users/michaellan/code/cp/xstemp.cpp
