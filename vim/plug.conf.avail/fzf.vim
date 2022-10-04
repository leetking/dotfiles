let s:project_marks = ['.git', '.root', '.svn']

" 通过环境变量设置 fzf 的 finder
" 这里使用 find 不寻找 symbolic (-P)，只寻找文件
let $FZF_DEFAULT_COMMAND = 'find -P -type f'

" Use gitfiles in .git project
let s:fzf_use_gitfiles = 1
" TODO use_gitfiles and read submodule files

" does file or directory exist?
function s:path_exists(path) abort
    return ! empty(glob(a:path))
endfunction

function s:detect_project()
    let project_marks = get(g:, 'project_marks', s:project_marks)
    let orig_path = expand('%:p:h')
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
    call fzf#vim#grep(rgcmd . shellescape(pats), 1, {'dir': path}, full)
endfunction

function RipgrepProto(...)
    let saved_fzf_default_command = $FZF_DEFAULT_COMMAND
    let $FZF_DEFAULT_COMMAND = 'find -P -type f -and -name "*.proto"'
    " forward args
    "call Ripgrep(...)
    let $FZF_DEFAULT_COMMAND = saved_fzf_default_command
endfunction

nmap <silent> <C-p> :call FzfFiles()<CR>
command! -bang -nargs=+ -complete=file Rg call Ripgrep(<f-args>, <bang>0)

" TODO gp only search proto file
nmap <silent> gf :Rg <C-R>='\b' . expand('<cword>') . '\b'<CR><CR>
nmap <silent> g. :Rg <C-R>='\b' . expand('<cword>') . '\b'<CR> .<CR>
nmap <silent> g@ :Rg <C-R>='\b' . expand('<cword>') . '\b'<CR> @<CR>
nmap <silent> gp :Rg <C-R>='(message\|enum)\s+' . expand('<cword>') . '\b'<CR><CR>
