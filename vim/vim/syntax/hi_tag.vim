"syntax keyword <group name> <keyword list>
"定义需要高亮的关键字
syntax keyword mytag NOTE MARK TODO

"指明如何高亮
highlight link mytag Todo

"对于markdown文档的行末空格进行高亮	等价于(>=\S) +$ 但是目前不知道markdown的类型
"if &filetype == 'md'
syntax match white_space_eof /\(\S\)\@<=\ \+$/
highlight WhitespaceEOF ctermbg=cyan guibg=cyan
highlight link white_space_eof WhitespaceEOF
"endif
