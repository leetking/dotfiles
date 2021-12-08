let s:localrc_allow_apply_filetypes = get(g:, 'localrc_allow_apply_filetypes', ['c', 'cc', 'cpp', 'h', 'hh', 'hpp'])
let s:localrc_setting_files = get(g:, 'localrc_setting_files', ['.localrc.vim'])
let s:localrc_project_marks = get(g:, 'localrc_project_marks', ['.git'] + s:localrc_setting_files)

let s:save_cpo = &cpo
set cpo&vim

" does file or directory exist?
function s:path_exists(path) abort
    return ! empty(glob(a:path))
endfunction

" enumerate files and try to load it
function s:try_load_setting(path) abort
    for file in s:localrc_setting_files
        let setting = a:path . '/' . file
        if filereadable(setting)
            execute 'source' setting
            return v:true
        endif
    endfor
    return v:false
endfunction

function s:is_allow_filetype(path) abort
    let suffix = fnamemodify(a:path, ':e')
    return index(s:localrc_allow_apply_filetypes, suffix) >= 0
endfunction

" load vim setting file in project root
function localrc#load() abort
    if ! s:is_allow_filetype(expand('%p'))
        return
    endif

    let path = expand('%p:h')
    if s:try_load_setting(path)
        return
    endif

    let prev = ''
    while path !=# prev
        for mark in s:localrc_project_marks
            if s:path_exists(path . '/' . mark)
                call s:try_load_setting(path)
                return
            endif
        endfor
        let prev = path
        let path = fnamemodify(path, ':h')
    endwhile
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
