vim.g.yui_comments = 'fade'
vim.g.yui_visual = 'dark'

require 'plugins'
require 'conf'

vim.cmd([[
augroup Color
  autocmd ColorScheme * hi clear SignColumn 
augroup END
]])

vim.cmd('colo zenburn')

-- require 'aesth'

-- vim.cmd('hi clear LspDiagnosticsDefaultError')
-- vim.cmd('hi clear LspDiagnosticsDefaultWarning')
-- vim.cmd('hi clear LspDiagnosticsDefaultHint')
-- vim.cmd('hi clear LspDiagnosticsDefaultInformation')
-- vim.cmd('hi link LspDiagnosticsDefaultError DiffDelete')
-- vim.cmd('hi link LspDiagnosticsDefaultWarning DiffChange')
-- vim.cmd('hi link LspDiagnosticsDefaultHint Folded')
-- vim.cmd('hi link LspDiagnosticsDefaultInformation DiffText')

vim.o.guicursor = ''
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. 'F'
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true

local opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
vim.cmd('au FileType fzf tno <Esc> <C-c>')

vim.o.stl = ' %f %m%=%y '
vim.wo.wrap = false

vim.o.background = 'dark'
vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
vim.o.t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"
vim.o.termguicolors = true

vim.cmd('let g:sneak#label = 1')

vim.api.nvim_command([[command! Cdir execute 'lcd %:p:h']])
vim.api.nvim_command('command! TSRehighlight :write | edit | TSBufEnable highlight')
vim.cmd('au FileType cpp ia <buffer> itn int')
