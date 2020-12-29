lspconf = require('lspconfig')

local on_attach = function(_, bufnr)
  require('completion').on_attach()
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',   '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gli', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

vim.api.nvim_command([[command! Format execute 'lua vim.lsp.buf.formatting()']])

local servers = {'jsonls', 'clangd', 'tsserver', 'cssls', 'html', 'jdtls', 'pyright', 'ocamllsp'}

for _, server in ipairs(servers) do
  lspconf[server].setup {
    on_attach = on_attach
  }
end

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
}

require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

vim.cmd('runtime macros/sandwich/keymap/surround.vim')
vim.api.nvim_call_function('operator#sandwich#set', {'all', 'all', 'highlight', 1})

local opts = { silent=true }
vim.api.nvim_buf_set_keymap(0, 'x', 'im', '<Plug>(textobj-sandwich-literal-query-i)', opts)
vim.api.nvim_buf_set_keymap(0, 'x', 'am', '<Plug>(textobj-sandwich-literal-query-a)', opts)
vim.api.nvim_buf_set_keymap(0, 'o', 'im', '<Plug>(textobj-sandwich-literal-query-i)', opts)
vim.api.nvim_buf_set_keymap(0, 'o', 'am', '<Plug>(textobj-sandwich-literal-query-a)', opts)

vim.g.completion_enable_snippet = 'UltiSnips'
vim.g.completion_confirm_key = '\\<C-y>'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_matching_smart_case = 1
vim.g.completion_trigger_on_delete = 1
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.wo.signcolumn = 'yes'

