"syntax keyword <group name> <keyword list>
"定义需要高亮的关键字
syntax keyword mark NOTE MARK

"指明如何高亮
highlight link mark Todo

"对于markdown文档的行末空格进行高亮	等价于(>=\S) +$ 但是目前不知道markdown的类型
" highlight WhitespaceEOF ctermbg=cyan guibg=cyan
" match WhitespaceEOF /\(\S\)\@<=\ \+$/
if &filetype == 'markdown'
	highlight WhitespaceEOF ctermbg=cyan guibg=cyan
	2match WhitespaceEOF /\(\S\)\@<=\ \+$/
endif
