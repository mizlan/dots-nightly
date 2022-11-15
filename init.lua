-- {{{ adaptive theme
vim.opt.foldmethod = 'marker'
local uv = vim.loop

-- trim function, taken from http://lua-users.org/wiki/StringTrim
function trim6(s)
  return s:match '^()%s*$' and '' or s:match '^%s*(.*%S)'
end

-- taken from https://github.com/nvim-lua/plenary.nvim
local read_file = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          callback(data)
        end)
      end)
    end)
  end)
end

local themepath = "/Users/ml/theme"
function adjust_theme()
  read_file(themepath, vim.schedule_wrap(function(data)
    if trim6(data) == 'light' then
      vim.opt.background = 'light'
    else
      vim.opt.background = 'dark'
    end
  end))
end

adjust_theme()

local fse = vim.loop.new_fs_event()
vim.loop.fs_event_start(fse, themepath, {}, function(err, fname, status)
  if (err) then
    print("Error " .. err)
  else
    adjust_theme()
  end
end)
-- }}}

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
P 'https://github.com/tpope/vim-fugitive'
P 'https://github.com/nvim-treesitter/nvim-treesitter-context'
P 'https://github.com/catppuccin/nvim'
P 'https://github.com/lewis6991/gitsigns.nvim'
P 'https://github.com/glepnir/lspsaga.nvim'
P 'https://github.com/pechorin/any-jump.vim'
P '~/Code/longbow.nvim'
P 'https://github.com/nvim-treesitter/playground'
P 'https://github.com/folke/lua-dev.nvim'
P 'https://github.com/rose-pine/neovim'
P 'https://github.com/stevearc/dressing.nvim'
P 'https://github.com/hrsh7th/nvim-cmp'
P 'hrsh7th/cmp-nvim-lsp'
P 'https://github.com/antoinemadec/FixCursorHold.nvim'
P 'nvim-telescope/telescope-frecency.nvim'
P 'tami5/sqlite.lua'
P 'https://github.com/JuliaEditorSupport/julia-vim'
P 'https://github.com/Nymphium/vim-koka'
P 'lervag/vimtex'
P 'https://github.com/folke/zen-mode.nvim'

P.autoinstall(true)
P.load()

vim.g.cursorhold_updatetime = 1000

vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'


vim.g.mapleader = ' '
vim.opt.cmdheight = 1
vim.opt.laststatus = 3

local cmp = require 'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-1),
    ['<C-f>'] = cmp.mapping.scroll_docs(1),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
})

vim.opt.termguicolors = true
require('rose-pine').setup({
  dark_variant = 'moon',
})
vim.cmd [[colorscheme rose-pine]]

require('lualine').setup {
  options = {
    theme = 'rose-pine',
  }
}

vim.cmd [[set ts=2 sw=2 sts=2 et]]

require('Comment').setup()

require('colorizer').setup {
  css = { rgb_fn = true; }
}

require('iswap').setup {
  debug = true,
  move_cursor = true
}

vim.opt.ignorecase = true
vim.opt.wrap = false

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

local saga = require 'lspsaga'
saga.init_lsp_saga({
  max_preview_lines = 15,
  code_action_icon = "",
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>scd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>gr', "<cmd>Lspsaga lsp_finder<CR>", bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig')['ocamllsp'].setup {
  on_attach = on_attach
}
require('lspconfig')['clangd'].setup {
  on_attach = on_attach
}
require('lspconfig')['julials'].setup {
  on_attach = on_attach
}
require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  cmd = { "pyright-langserver", "--stdio", "-v", "/Users/ml/GlobalVenv" }
}
require('lspconfig')['hls'].setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    if client.server_capabilities.codeLensProvider ~= nil then
      vim.keymap.set('n', '<leader>cll', vim.lsp.codelens.run, { buffer = bufnr })
      vim.keymap.set('n', '<leader>clr', vim.lsp.codelens.refresh, { buffer = bufnr })
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

vim.opt.showmode = false

vim.cmd [[au BufRead,BufNewFile *.pl setf perl]]

vim.g.neovide_cursor_vfx_mode = 'railgun'
vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h22'

require "telescope".load_extension("frecency")

vim.cmd [[
command! -range=% SP <line1>,<line2>w !curl -F 'sprunge=<-' http://sprunge.us | tr -d '\n' | pbcopy
command! -range=% CL <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | pbcopy
command! -range=% VP <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | pbcopy
command! -range=% PB <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/?u=1 | tr -d '\n' | pbcopy
command! -range=% IX <line1>,<line2>w !curl -F 'f:1=<-' http://ix.io | tr -d '\n' | pbcopy
command! -range=% EN <line1>,<line2>w !curl -F 'file=@-;' https://envs.sh | tr -d '\n' | pbcopy
command! -range=% TB <line1>,<line2>w !nc termbin.com 9999 | tr -d '\n' | pbcopy
]]

vim.cmd [[set formatoptions-=cro]]

require("zen-mode").setup {
  window = {
    backdrop = 0.95,
    width = 80,
    height = 1,
    options = {
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false,
      showcmd = false,
    },
    twilight = { enabled = true },
    gitsigns = { enabled = false },
    tmux = { enabled = false },
    kitty = {
      enabled = true,
      font = "+4", -- font size increment
    },
  },
  on_open = function(win)
  end,
  on_close = function()
  end,
}

nc("of", "Telescope frecency theme=dropdown")
nc(",", "Telescope buffers theme=dropdown")
nc("ff", "Telescope find_files theme=dropdown")
nc("nt", "tabnew")
nc("dt", "tabclose")
nc("gg", "Git")

vim.cmd [[au FileType tex iabbrev Vr \vec{r}]]
vim.cmd [[au FileType tex iabbrev Vs \vec{s}]]
vim.cmd [[au FileType tex iabbrev Va \vec{a}]]
vim.cmd [[au FileType tex iabbrev Vb \vec{b}]]
vim.cmd [[au FileType tex iabbrev Vv \vec{v}]]
vim.cmd [[au FileType tex iabbrev Vu \vec{u}]]
vim.cmd [[au FileType tex iabbrev Vw \vec{w}]]
vim.cmd [[au FileType tex iabbrev V0 \vec{0}]]
vim.cmd [[au FileType tex iabbrev R2 $\RR^2$]]
vim.cmd [[au FileType tex iabbrev R3 $\RR^3$]]
vim.cmd [[au FileType tex imap <> \tuple*{}<Left>]]
vim.cmd [[au FileType tex imap () \parens*{}<Left>]]
