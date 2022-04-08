" 禁用默认按键映射
let g:gutentags_plus_nomap = 1
" 直接聚焦到 QuickFix 窗口
let g:gutentags_plus_switch = 1
" 禁止 gutentags 自动添加 cscope db
"let g:gutentags_auto_add_gtags_cscope = 0

set cscopequickfix=s-,c-,g-,a-

nmap <silent> gr :GscopeFind s <C-R>=expand('<cword>')<CR><CR>
nmap <silent> gd :GscopeFind g <C-R>=expand('<cword>')<CR><CR>
