let s:project_marks = ['.git', '.root', '.svn']

" does file or directory exist?
function s:path_exists(path) abort
    return ! empty(glob(a:path))
endfunction

function s:project_type_and_root()
    let project_marks = get(g:, 'project_marks', s:project_marks)
    let orig_path = expand('%:p:h')
    let path = orig_path
    let prev = ''
    while path !=# prev
        if s:path_exists(path . '/.git')
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
    let project = s:project_type_and_root()
    if project['type'] == 'git'
        call fzf#vim#gitfiles(project['root'], fzf#vim#with_preview(), 0)
    else
        call fzf#vim#files(project['root'], fzf#vim#with_preview(), 0)
    endif
endfunction

nmap <C-p> :call FzfFiles()<CR>
