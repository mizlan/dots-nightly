require 'plugins'
require 'conf'

-- autocommands to hijack color schemes
require('hijackc')

mapk = vim.api.nvim_set_keymap

vim.g.yui_comments = 'fade'
vim.g.yui_visual = 'dark'
vim.cmd 'colo nord'

vim.o.guicursor = ''
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. 'F'
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true

local opts = {noremap = true, silent = true}

mapk('t', '<Esc>', '<C-\\><C-n>', opts)
mapk('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
mapk('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

vim.cmd 'au FileType fzf tno <Esc> <C-c>'

vim.o.stl = ' %f %m%=%y '
vim.wo.wrap = false

vim.o.background = 'dark'
-- vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
-- vim.o.t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"
vim.o.termguicolors = true

vim.cmd 'let g:sneak#label = 1'

vim.cmd [[command! Cdir execute 'lcd %:p:h']]
vim.cmd 'command! TSRehighlight :write | edit | TSBufEnable highlight'
vim.cmd 'command! Sync PackerSync'
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

-- google search from vim
-- require 'gsearch'

mapk('n', 'j', 'gj', opts)
mapk('n', 'k', 'gk', opts)

vim.cmd 'autocmd FileType markdown set wrap linebreak'

vim.cmd 'command! Template r ~/code/cp/xstemp.cpp'

-- development tools
-- require('dev')
