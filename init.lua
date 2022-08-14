P = require('neopm')

P 'nvim-lua/plenary.nvim'
P 'https://github.com/romainl/Apprentice'
P 'https://github.com/nvim-lualine/lualine.nvim'
-- P 'https://github.com/vale1410/vim-minizinc'
P 'https://github.com/numToStr/Comment.nvim'
P 'https://github.com/tpope/vim-surround'
P 'norcalli/nvim-colorizer.lua'
P 'https://github.com/neovim/nvim-lspconfig'
P 'https://github.com/romainl/vim-cool'
P '~/Repositories/iswap.nvim'
P 'https://github.com/nvim-treesitter/nvim-treesitter'
P 'https://github.com/nvim-telescope/telescope.nvim'
P 'https://github.com/TimUntersberger/neogit'
-- P 'https://github.com/nvim-treesitter/nvim-treesitter-context'
P 'https://github.com/catppuccin/nvim'
P 'https://github.com/lewis6991/gitsigns.nvim'
P 'https://github.com/glepnir/lspsaga.nvim'
P 'https://github.com/phaazon/hop.nvim'
P 'https://github.com/ggandor/leap.nvim'
P 'https://github.com/pechorin/any-jump.vim'
P '~/Code/longbow.nvim'
P 'https://github.com/nvim-treesitter/playground'
P 'https://github.com/folke/lua-dev.nvim'
P 'rktjmp/lush.nvim'
P 'https://github.com/rose-pine/neovim'
P 'karb94/neoscroll.nvim'

P.autoinstall(true)
P.load()

vim.g.mapleader = ' '

require('hop').setup {}
require('neoscroll').setup{
  easing_function = "quadratic"
}

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup {
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
vim.opt.background = 'light'
vim.cmd [[colorscheme rose-pine]]

vim.cmd [[set ts=2 sw=2 sts=2 et]]

require('lualine').setup {
  options = {
    theme = 'rose-pine',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = ''},
  }
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

-- local saga = require 'lspsaga'
-- saga.init_lsp_saga({
--   max_preview_lines = 15,
--   code_action_icon = "",
-- })

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>scd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local action = require("lspsaga.action")
  -- scroll down hover doc or scroll in definition preview
  vim.keymap.set("n", "<C-f>", function()
    action.smart_scroll_with_saga(1)
  end, { silent = true })
  -- scroll up hover doc
  vim.keymap.set("n", "<C-b>", function()
    action.smart_scroll_with_saga(-1)
  end, { silent = true })

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>pvd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>sig', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>aws', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>rws', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lws', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', "<cmd>Lspsaga rename<CR>", bufopts)
  vim.keymap.set('n', '<leader>ca', "<cmd>Lspsaga code_action<CR>", bufopts)
  vim.keymap.set('n', '<leader>gr', "<cmd>Lspsaga lsp_finder<CR>", bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig')['ocamllsp'].setup {
  on_attach = on_attach
}
require('lspconfig')['clangd'].setup {
  on_attach = on_attach
}
require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  cmd = { "pyright-langserver", "--stdio", "-v", "/Users/ml/GlobalVenv" }
}
require('lspconfig')['hls'].setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    if client.server_capabilities.codeLensProvider ~= false then
      vim.keymap.set('n', '<leader>cll', vim.lsp.codelens.run, { buffer = bufnr })
      vim.keymap.set('n', '<leader>clr', vim.lsp.codelens.refresh, { buffer = bufnr})
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('haskell-codelens', {}),
        pattern = { '*.hs' },
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end
  end,
}
require('lspconfig')['sumneko_lua'].setup(require("lua-dev").setup {
  lspconfig = {
    on_attach = on_attach,
  }
})

vim.opt.signcolumn = 'yes'

vim.cmd [[
if executable('opam')
  let g:opamshare=substitute(system('opam var share'),'\n$','','''')
  if isdirectory(g:opamshare."/merlin/vim")
    execute "set rtp+=" . g:opamshare."/merlin/vim"
  endif
endif
]]

vim.g.python3_host_prog = '~/GlobalVenv/bin/python3.9'

require('nvim-treesitter.configs').setup {
  highlight = { enable = true }
}

-- require('treesitter-context').setup{
--   enable = true
-- }

local function nc(keys, cmd)
  vim.keymap.set("n", "<leader>" .. keys, "<cmd>" .. cmd .. "<cr>")
end

local function nl(keys, func)
  vim.keymap.set("n", "<leader>" .. keys, func)
end

require('gitsigns').setup {
  on_attach = function()
    nc("sh", "Gitsigns stage_hunk")
    nc("rh", "Gitsigns reset_hunk")
    nc("nh", "Gitsigns next_hunk")
    nc("ph", "Gitsigns prev_hunk")
    nc("pvh", "Gitsigns preview_hunk")
  end
}

vim.g.filetype_pl = 'perl'

vim.cmd [[au BufRead,BufNewFile *.pl setf perl]]

require('leap').set_default_keymaps()

require('neogit').setup {
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  use_magit_keybindings = true,
  signs = {
    section = { "", "" },
    item = { "", "" },
    hunk = { "", "" },
  },
}

vim.g.neovide_cursor_vfx_mode = 'railgun'
vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h22'

nc("of", "Telescope oldfiles theme=ivy")
nc("nt", "tabnew")
nc("dt", "tabclose")
nc("gg", "Neogit")
