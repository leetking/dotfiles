" 不在注释符号后添加空格
let g:NERDSpaceDelims = 0
" 空白区域也要注释
let g:NERDCommentEmptyLines = 1
" 自动移除尾部空表
let g:NERDTrimTrailingWhitespace = 1
" 切换是否注释时检查已有注释
let g:NERDToggleCheckAllLines = 1
" 注释对齐到左端
let g:NERDDefaultAlign = 'left'

nmap <silent> gcc <Plug>NERDCommenterToggle
vmap <silent> gcc <Plug>NERDCommenterToggle
