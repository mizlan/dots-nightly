vim.cmd [[
function SetLuaDevOptions()
  nmap <buffer> <C-c><C-c> <Plug>(Luadev-RunLine)
  vmap <buffer> <C-c><C-c> <Plug>(Luadev-Run)
  nmap <buffer> <C-c><C-k> <Plug>(Luadev-RunWord)
  map  <buffer> <C-x><C-p> <Plug>(Luadev-Complete)
  set filetype=lua
endfunction

augroup nvim-luadev
  autocmd BufEnter \[nvim-lua\] call SetLuaDevOptions()
augroup end
	]]
