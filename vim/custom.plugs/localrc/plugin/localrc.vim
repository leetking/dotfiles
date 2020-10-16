if exists('g:loaded_localrc')
    finish
endif
let g:loaded_localrc = 1

let s:save_cpo = &cpo
set cpo&vim

augroup LocalRc
    autocmd!
    autocmd BufEnter * call localrc#load()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
