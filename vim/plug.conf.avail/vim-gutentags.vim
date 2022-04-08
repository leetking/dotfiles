" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/vim/tags/ 目录中，避免污染工程目录
let s:tags_dir = expand('~/.cache/vim/tags')
let g:gutentags_cache_dir = s:tags_dir
" 检测 ~/.cache/vim/tags/ 不存在就新建
if !isdirectory(s:tags_dir)
   silent! call mkdir(s:tags_dir, 'p')
endif

let g:gutentags_modules = []
"if executable('ctags')
"    " ,隔开各个 tags 文件，这里寻找名为 .tags 的文件作为 tags
"    " ./.tags 表明当前文件所在目录下的 .tags，分号 ; 表示递归向上寻找直到根目录
"    set tags=./.tags;,.tags
"    let g:gutentags_modules += ['ctags']
"    " TODO 配置 gtags 和 ctags 的参数
"    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
"    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
"    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"endif

if executable('gtags') && executable('gtags-cscope')
    let g:gutentags_modules += ['gtags_cscope']
    " $ENV 设置子进程的环境变量
    let $GTAGSCONF = expand('~/.vim/gtags.conf')
    " c/c++,yacc,java,php4,asm 使用 global, 其他语言使用 universal ctags + pyments
    let $GTAGSLABEL = 'native-pygments'
    "let g:gutentags_gtags_options_file = expand('~/.vim/gtags-options.txt')
    " 使用 cscope 代替 tags 跳转
    set cscopetag
    " 先使用 cstag 失败再使用 tag
    set cscopetagorder=0
    " 这些查找显示在 QuickFix 中
    set cscopequickfix=s-,c-,g-,a-
    nmap <silent> gr :cscope find s <C-R>=expand('<cword>')<CR><CR>
    nmap <silent> gd :cscope find g <C-R>=expand('<cword>')<CR><CR>
endif
