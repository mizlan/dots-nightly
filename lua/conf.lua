lspconf = require('lspconfig')

function root_pattern_prefer(...)
  local patterns = vim.tbl_flatten {...}
  return function(startpath)
    for _, pattern in ipairs(patterns) do
      path = lspconf.util.root_pattern(pattern)(startpath)
      if path then return path end
    end
  end
end

local on_attach = function(_, bufnr)
  require('completion').on_attach()
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gla', '<cmd>lua vim.lsp.buf.code_action()                               <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glD', '<cmd>lua vim.lsp.buf.declaration()                               <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gld', '<cmd>lua vim.lsp.buf.definition()                                <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',   '<cmd>lua vim.lsp.buf.hover()                                     <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gli', '<cmd>lua vim.lsp.buf.implementation()                            <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gls', '<cmd>lua vim.lsp.buf.signature_help()                            <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glt', '<cmd>lua vim.lsp.buf.type_definition()                           <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glr', '<cmd>lua vim.lsp.buf.rename()                                    <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glR', '<cmd>lua vim.lsp.buf.references()                                <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gl?', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()              <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glq', '<cmd>lua vim.lsp.diagnostic.set_loclist()                        <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[e',  '<cmd>lua vim.lsp.diagnostic.goto_prev()                          <CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']e',  '<cmd>lua vim.lsp.diagnostic.goto_next()                          <CR>', opts)
end

vim.api.nvim_command([[command! Format execute 'lua vim.lsp.buf.formatting()']])

local servers = {'jsonls', 'clangd', 'cssls', 'html', 'jdtls', 'pyright', 'ocamllsp', 'hls'}

for _, server in ipairs(servers) do
  lspconf[server].setup {
    on_attach = on_attach,
  }
end

lspconf.tsserver.setup {
  on_attach = on_attach,
  root_dir = root_pattern_prefer("tsconfig.json", "package.json", ".git")
}

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = '/Users/michaellan/util/lua-language-server/'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lspconf.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
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
vim.g.completion_confirm_key = '<C-y>'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_matching_smart_case = 1
vim.g.completion_trigger_on_delete = 1
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.wo.signcolumn = 'yes'

vim.o.inccommand = 'nosplit'

vim.g.signify_sign_add               = '│'
vim.g.signify_sign_delete            = '│'
vim.g.signify_sign_delete_first_line = '│'
vim.g.signify_sign_change            = '│'

