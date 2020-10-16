let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'lightline.gitbranch'
    \ },
    \ }

function lightline.gitbranch() abort
    if exists('*gitbranch#name')
        return gitbranch#name()
    endif
    return ''
endfunction


if exists('g:loaded_tender')
    let g:lightline.colorscheme = 'tender'
endif
