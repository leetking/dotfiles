let s:project_marks = ['.git', '.root', '.svn']

" 通过环境变量设置 fzf 的 finder
" 这里使用 find 不寻找 symbolic (-P)，只寻找文件
"let $FZF_DEFAULT_COMMAND = 'find -P -type f'
let $FZF_DEFAULT_COMMAND = 'fd --type f'
let $FZF_DEFAULT_OPTS = '--no-separator'

" Use gitfiles in .git project
let s:fzf_use_gitfiles = 1
" TODO use_gitfiles and read submodule files

" :Buffers 自动跳转到buffer
let g:fzf_buffers_jump = 1
" :help drop
let g:fzf_action = {
    \ 'ctrl-t': 'tab drop',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

" does file or directory exist?
function s:path_exists(path) abort
    return ! empty(glob(a:path))
endfunction

function s:detect_project()
    let project_marks = get(g:, 'project_marks', s:project_marks)
    let orig_path = expand('%:p:~:h')
    let path = orig_path
    let prev = ''
    while path !=# prev
        if s:fzf_use_gitfiles && s:path_exists(path . '/.git')
            return {'type': 'git', 'root': path}
        endif
        for mark in project_marks
            if s:path_exists(path . '/' . mark)
                return {'type': 'other', 'root': path}
            endif
        endfor
        let prev = path
        let path = fnamemodify(path, ':h')
    endwhile
    return {'type': 'none', 'root': orig_path}
endfunction

" 如果在 .git 下使用 GFiles 否则使用 Files
function FzfFiles()
    let project = s:detect_project()
    if project['type'] == 'git'
        call fzf#vim#gitfiles(project['root'], fzf#vim#with_preview(), 0)
    else
        call fzf#vim#files(project['root'], fzf#vim#with_preview(), 0)
    endif
endfunction

function Ripgrep(...)
    let argc = a:0
    let argv = a:000
    let full = argv[-1]
    if argc < 3
        let pats = argv[0]
        let path = s:detect_project()['root']
    elseif '@' != argv[-2] && ! s:path_exists(argv[-2])
        let pats = join(argv[:-2], ' ')
        let path = s:detect_project()['root']
    else
        let pats = join(argv[:-3], ' ')
        " is a file, use its absolute directory
        if filereadable(argv[-2]) || filewritable(argv[-2])
            let path = fnamemodify(argv[-2], ':p:h')
        " :Rg pats @
        elseif '@' == argv[-2]
            let path = expand('%:p:h')
        " normal directory, support relative path
        else
            let path = argv[-2]
        endif
    endif
    let rgcmd = "rg --column --line-number --no-heading --color=always --smart-case "
    call fzf#vim#grep(rgcmd . shellescape(pats), 1, fzf#vim#with_preview({'dir': path}), full)
endfunction

function RipgrepProto(pat, full)
    let path = s:detect_project()['root']
    let rgcmd = "rg --column --line-number --no-heading --color=always --smart-case --type protobuf "
    call fzf#vim#grep(rgcmd . shellescape(a:pat), 1, fzf#vim#with_preview({'dir': path}), a:full)
endfunction

" TODO: buffers, most recent used files in the project, other files
" fzf 支持 sourcelist
" 显示最近打开文件和 Buffer
function! s:mru_and_buffers()
    return extend(
            \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'),
            \ filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"))
endfunction

command! -bang -nargs=0 Mru call fzf#run(fzf#wrap({'source':  s:mru_and_buffers()}, <bang>0))

nmap <silent> <C-p> :call FzfFiles()<CR>
" <C-m> == Enter
"nmap <silent> <C-m> :Mru<CR>
command! -bang -nargs=+ -complete=file Rg call Ripgrep(<f-args>, <bang>0)
command! -bang -nargs=+ -complete=file Rp call RipgrepProto(<f-args>, <bang>0)

nmap <silent> gf :Rg <C-r>='\b' . expand('<cword>') . '\b'<CR><CR>
nmap <silent> g. :Rg <C-r>='\b' . expand('<cword>') . '\b'<CR> .<CR>
nmap <silent> g@ :Rg <C-r>='\b' . expand('<cword>') . '\b'<CR> @<CR>
nmap <silent> gp :Rp <C-r>='(message\|enum)\s+' . expand('<cword>') . '\b'<CR><CR>
