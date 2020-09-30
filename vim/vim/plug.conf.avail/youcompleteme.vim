let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_common_conf.py'
let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '⚠'
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
"let g:ycm_python_binary_path = 'python3'
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
"let g:ycm_language_server =
"    \[
"    \   {
"    \       'name': 'bash',
"    \       'filetypes': ['sh', 'bash'],
"    \       'cmdline': ['bash-language-server', 'start'],
"    \       'project_root_files': ['.git'],
"    \   },
"    \   {
"    \       'name': 'lua',
"    \       'filetypes': ['lua'],
"    \       'cmdline': ['lua-language-server'],
"    \       'project_root_files': ['.git'],
"    \   },
"    \]
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
