"nerdtree {
let g:NERDTreeIgnore = ['\~$', '\.pyc', '\.swp$', '\.o$']
nmap <leader>m :NERDTreeToggle<cr>
"}

"vim-css3-syntax {
autocmd Filetype css setlocal iskeyword+=-
"}

"vim-airline {
" TODO integrate git branch and virtualenv etc
set laststatus=2
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"}

"javascript {
let javascript_enable_domhtmlcss = 1
"}

" YouCompleteMe {
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_common_conf.py'
let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '⚠'
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_python_binary_path = 'python3'
let g:ycm_seed_identifiers_with_syntax = 1
" Remove <Tab> mapping
let g:ycm_key_list_select_completion = ['<Down>']
" Remove <S-Tab> mapping
let g:ycm_key_list_previous_completion = ['<Up>']
" unset <leader>d
let g:ycm_key_detailed_diagnostics = ''
let g:ycm_filetype_blacklist = {
    \ 'tagbar': 1, 'nerdtree': 1,
    \}
let g:ycm_collect_identifiers_from_tags_files = 1
" append triggers
"let g:ycm_semantic_triggers = {
"    \ 'c,cpp,python,lua,javascript': ['re!\w{2}'],
"    \ }
" ycm_semantic_triggers uses Default
nnoremap <leader>d :YcmCompleter GoToDefinition<cr>
nnoremap <leader>p :YcmCompleter GoToDeclaration<cr>
nnoremap <leader>f :YcmCompleter FixIt<cr>
nnoremap <leader>j :YcmCompleter GoTo<cr>
nnoremap <leader>i :YcmCompleter GetType<cr>
"}

" vimtext {
let g:tex_flavor='xelatex'
let g:vimtex_view_method='zathura'
set conceallevel=1
let g:tex_conceal='abdmg'
" }

" vim-gnutentags {
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
" }


" Asyncrun.vim {
" 自动打开 quickfix window ，高度为 6
"let g:asyncrun_open = 6
" 任务结束时候响铃提醒
"let g:asyncrun_bell = 1
" 设置 F10 打开/关闭 Quickfix 窗口
"nnoremap  <leader>c :call asyncrun#quickfix_toggle(6)<cr>
" }


" echodoc {
"let g:echodoc#type = "echo"
"set noshowmode
"let g:echodoc_enable_at_startup = 1
" }
