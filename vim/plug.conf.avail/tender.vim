function s:apply_tender()
    colorscheme tender
    if ! has('gui_running')
        " cancel background to recover transparence for terminal
        highlight Normal ctermbg=NONE guibg=NONE
    endif
endfunction

autocmd VimEnter * colorscheme tender

let g:loaded_tender = 1
