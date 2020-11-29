let g:terminal_color_0 = "#363a4e"
let g:terminal_color_1 = "#ec7279"
let g:terminal_color_2 = "#a0c980"
let g:terminal_color_3 = "#deb974"
let g:terminal_color_4 = "#6cb6eb"
let g:terminal_color_5 = "#d38aea"
let g:terminal_color_6 = "#5dbbc1"
let g:terminal_color_7 = "#c5cdd9"
let g:terminal_color_8 = "#363a4e"
let g:terminal_color_9 = "#ec7279"
let g:terminal_color_10 = "#a0c980"
let g:terminal_color_11 = "#deb974"
let g:terminal_color_12 = "#6cb6eb"
let g:terminal_color_13 = "#d38aea"
let g:terminal_color_14 = "#5dbbc1"
let g:terminal_color_15 = "#c5cdd9"
let g:terminal_color_background = "#2b2d3a"
let g:terminal_color_foreground = "#c5cdd9"

let g:signify_sign_add = '▎'
let g:signify_sign_delete = '▎'
let g:signify_sign_delete_first_line = '▎'
let g:signify_sign_change = '▎'

call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})
