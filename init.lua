require('adaptive')
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup{
  'nvim-lua/plenary.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
   --'https://github.com/vale1410/vim-minizinc',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/kylechui/nvim-surround',
  'norcalli/nvim-colorizer.lua',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/romainl/vim-cool',
  { dir = '~/Repositories/iswap.nvim' },
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/lewis6991/gitsigns.nvim',
   --'https://github.com/glepnir/lspsaga.nvim',
  'https://github.com/pechorin/any-jump.vim',
  { dir = '~/Code/longbow.nvim' },
  'https://github.com/nvim-treesitter/playground',
  'https://github.com/folke/neodev.nvim',
  'https://github.com/rose-pine/neovim',
  'https://github.com/stevearc/dressing.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
  'nvim-telescope/telescope-frecency.nvim',
  'tami5/sqlite.lua',
   --'https://github.com/JuliaEditorSupport/julia-vim',
   --'https://github.com/Nymphium/vim-koka',
  'lervag/vimtex',
  'https://github.com/folke/zen-mode.nvim',
  'https://github.com/MrcJkb/haskell-tools.nvim',
  'https://github.com/itchyny/vim-haskell-indent',
  'https://github.com/L3MON4D3/LuaSnip',
   --'https://github.com/vim-scripts/alex.vim',
   --'https://github.com/romgrk/kirby.nvim',
  'romgrk/fzy-lua-native', -- needs 'make install'
  'nvim-tree/nvim-web-devicons',
   --'romgrk/kui.nvim',
  'kevinhwang91/nvim-ufo',
  'kevinhwang91/promise-async',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-telescope/telescope-file-browser.nvim',
  'https://github.com/junegunn/vim-easy-align',
  'ruifm/gitlinker.nvim',
  'kaarmu/typst.vim',
   -- 'icedman/nvim-textmate',
  'https://github.com/ziglang/zig.vim',
  'https://github.com/dhruvasagar/vim-table-mode',
  'https://github.com/smjonas/inc-rename.nvim',
  'https://github.com/natecraddock/telescope-zf-native.nvim',
  'https://github.com/ii14/neorepl.nvim',
  'goolord/alpha-nvim',
  'https://github.com/MaximilianLloyd/ascii.nvim',
}

vim.cmd [[
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
]]

vim.g.cursorhold_updatetime = 1000

vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'

vim.g.mapleader = ' '
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

vim.opt.splitright = true
vim.opt.splitbelow = true

local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-1),
        ['<C-f>'] = cmp.mapping.scroll_docs(1),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer' },
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
    section_separators = { left = '', right = '' },
    component_separators = ''
  }
}

vim.cmd [[set ts=2 sw=2 sts=2 et]]

require('Comment').setup()

require('colorizer').setup {
  css = { rgb_fn = true, }
}

require('iswap').setup {
  debug = true,
  move_cursor = true
}

vim.opt.ignorecase = true
vim.opt.wrap = false

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>sig', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>aws', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>rws', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lws', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig')['ocamllsp'].setup {
  on_attach = on_attach
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
require('lspconfig')['clangd'].setup {
  on_attach = on_attach,
  capabilities = capabilities
}
require('lspconfig')['julials'].setup {
  on_attach = on_attach
}
require('lspconfig')['tsserver'].setup {
  on_attach = on_attach
}
require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  cmd = { "pyright-langserver", "--stdio", "-v", "/Users/ml/GlobalVenv" }
}

require('lspconfig')['lua_ls'].setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },

}

require('lspconfig')['gopls'].setup {
  on_attach = on_attach
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
require('lspconfig')['cssls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require('lspconfig')['typst_lsp'].setup {
  on_attach = on_attach,
  settings = {
    exportPdf = "onSave",
  }
}

require('lspconfig')['zls'].setup {
  on_attach = on_attach,
}

require("neodev").setup()

vim.opt.signcolumn = 'yes'

vim.g.python3_host_prog = '~/GlobalVenv/bin/python3.9'

require('nvim-treesitter.configs').setup {
  highlight = { enable = true }
}

local function nc(keys, cmd)
  vim.keymap.set("n", "<leader>" .. keys, "<cmd>" .. cmd .. "<cr>")
end

local function nl(keys, func)
  vim.keymap.set("n", "<leader>" .. keys, func)
end

require('gitsigns').setup {
  on_attach = function()
    nc("sh", "Gitsigns stage_hunk")
    nc("sb", "Gitsigns stage_buffer")
    nc("rh", "Gitsigns reset_hunk")
    vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>")
    vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>")
    nc("pvh", "Gitsigns preview_hunk")
  end
}

vim.g.filetype_pl = 'perl'

vim.opt.showmode = false

vim.cmd [[au BufRead,BufNewFile *.pl setf perl]]

vim.g.neovide_cursor_vfx_mode = 'railgun'
vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h18'


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

require('nvim-surround').setup {
  indent_lines = false
}

local ht = require('haskell-tools')
local def_opts = { noremap = true, silent = true, }
ht.setup {
  tools = {
    hover = {
      disable = true
    }
  },
  hls = {
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
      vim.keymap.set('n', '<leader>cll', vim.lsp.codelens.run, opts)
      vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
    end,
  },
}

-- -- Suggested keymaps that do not depend on haskell-language-server
-- -- Toggle a GHCi repl for the current package
-- vim.keymap.set('n', '<leader>rr', ht.repl.toggle, def_opts)
-- -- Toggle a GHCi repl for the current buffer
-- vim.keymap.set('n', '<leader>rf', function()
--   ht.repl.toggle(vim.api.nvim_buf_get_name(0))
-- end, def_opts)
-- vim.keymap.set('n', '<leader>rq', ht.repl.quit, def_opts)

require("telescope").setup {
  defaults = {
    path_display = { absolute = true }
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
    },
    frecency = {
      show_scores = true,
      auto_validate = false
    }
  },
}

nc("of", "Telescope frecency theme=dropdown")
nc("oo", "Telescope oldfiles theme=dropdown")
nc(",", "Telescope buffers theme=dropdown")
nc(".", "Telescope file_browser")
nc("im", "Telescope lsp_document_symbols")
nc("rg", "Telescope live_grep")
nc("nt", "tabnew")
nc("dt", "tabclose")
nc("gg", "tab Git")
nc("hc", "!cabal run")

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

vim.opt.list = true
vim.opt.listchars = "tab:··"

vim.cmd [[
nn <Leader>s<Right> <cmd>ISwapNodeWithRight<CR>
nn <Leader>s<Left> <cmd>ISwapNodeWithLeft<CR>
nn <Leader>ss <cmd>ISwap<CR>
]]

require('ufo').setup()

vim.cmd [[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]

require("luasnip.loaders.from_snipmate").lazy_load()

vim.o.foldlevel = 10
vim.o.cursorline = true

require("oil").setup()

vim.cmd [[
au ColorScheme * hi! link NonText WinSeparator
]]

require "telescope".load_extension("frecency")
require("telescope").load_extension("zf-native")
local themes = require('telescope.themes')
vim.api.nvim_create_user_command('Recent', function()
  local Path = require "plenary.path"
  local os_home = vim.loop.os_homedir()
  require 'telescope'.extensions.frecency.frecency(themes.get_dropdown({
    path_display = function(path_opts, filename)
      if vim.startswith(filename, os_home) then
        filename = "~/" .. Path:new(filename):make_relative(os_home)
      end
      return filename
    end,
    sorter = require 'telescope.config'.values.file_sorter(),
  }))
end, {})
require("telescope").load_extension "file_browser"

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
  [[                                                                       ]],
  [[                                                                     ]],
  [[       ████ ██████           █████      ██                     ]],
  [[      ███████████             █████                             ]],
  [[      █████████ ███████████████████ ███   ███████████   ]],
  [[     █████████  ███    █████████████ █████ ██████████████   ]],
  [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
  [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
  [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
  [[                                                                       ]],
}

dashboard.section.header.val = {
  "                                   ",
  "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
  "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
  "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
  "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
  "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
  "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
  "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
  " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
  " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
  "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
  "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
}

dashboard.section.header.opts.hl = 'Tag'

local leader = "SPC"
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 4,
    width = 30,
    align_shortcut = "right",
    hl_shortcut = "LineNr",
    hl = {
        { 'DiffText', 0, 5 }, -- highlight the icon glyph
        { 'PmenuSel', 6, 17 }, -- highlight the part after the icon glyph
    },
  }
  if keybind then
    keybind_opts = keybind_opts or { noremap = true, silent = true, nowait = true }
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end

  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

-- Set menu
dashboard.section.buttons.val = {
  button("SPC o f", "    recents", ":Recent<CR>"),
  button("e",       "    new-file", ":ene <BAR> startinsert <CR>"),
  button("SPC o o", "    find-file", ":Telescope oldfiles theme=dropdown<CR>"),
}

dashboard.section.buttons.opts = {
  spacing = 0,
}

alpha.setup(dashboard.opts)

vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

vim.cmd[[
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END
]]
