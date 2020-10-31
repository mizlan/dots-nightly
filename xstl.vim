function! xstl#lsp() abort
  let sl = ''
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let sl .= ' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Error]])")} '
    let sl .= ' %{luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")}'
  else
    let sl .= ''
  endif
  return sl
endfunction

let g:mode_dict = { 'n': '', 'no': '', 'nov': '', 'noV': '', "no\<C-v>": '', 'niI': '', 'niR': '', 'niV': '', 'v': '',
      \ 'V': '', "\<C-v>": '', 's': '', 'S': '', "\<C-s>": '', 'i': '', 'ic': '', 'ix': '', 'R': 'ﰉ', 'Rc': 'ﰉ', 'Rv': 'ﰉ',
      \ 'Rx': 'ﰉ', 'c': 'ﱕ', 'cv': 'ﱕ', 'ce': 'ﱕ', 'r': '', 'rm': '', 'r?': '', '!': '', 't': '', 'unknown': '', }

function xstl#cft() abort
  return &ft !=# '' ? &ft : ''
endfunction

function xstl#icon() abort
  return get(g:mode_dict, mode(1), g:mode_dict.unknown)
endfunction

function xstl#mod() abort
  return &mod ? '  ' : ''
endfunction

function xstl#file() abort
  return expand('%:t') ==# '' ? '' : expand('%:t')
endfunction

function xstl#astl() abort
  let &l:stl = '%#Normal# %#Directory#%#Search#%{xstl#icon()}%#Directory# %#MoreMsg#%#IncSearch#%{xstl#file()}%{xstl#mod()}%#MoreMsg#%#Normal#%=%#Title#%#TablineSel#%{xstl#cft()}%#Title# %#Red#%#debugBreakpoint#' . xstl#lsp() . '%#Red#%#Normal# '
endfunction

function xstl#istl() abort
  let &l:stl = '%#Normal# %#VertSplit#%#MatchParen#%{xstl#icon()}%#VertSplit# %#VertSplit#%#MatchParen#%{xstl#file()}%{xstl#mod()}%#VertSplit#%#VertSplit#%=%#VertSplit#%#MatchParen#%{xstl#cft()}%#VertSplit# %#VertSplit#%#MatchParen#' . xstl#lsp() . '%#VertSplit#%#VertSplit# '
endfunction

aug St
  au!
  au WinEnter,BufEnter * call xstl#astl()
  au User LspDiagnosticsChanged call xstl#astl()
  au WinLeave,BufLeave * call xstl#istl()
aug END
