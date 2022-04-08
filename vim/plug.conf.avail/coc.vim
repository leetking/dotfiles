let g:coc_global_extensions = ['coc-json', 'coc-vimlsp']
"let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-tsserver']

"set updatetime=1000
set updatetime=500
if has('patch8.1.1068')
    " Use `complete_info` if your (Neo)Vim version supports it.
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>j <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>r <Plug>(coc-references)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>f <Plug>(coc-fix-current)
nmap <silent> <leader>x <Plug>(coc-rename)

inoremap <silent><expr> <C-Space> coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if index(['vim', 'help'], &filetype) >= 0
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
