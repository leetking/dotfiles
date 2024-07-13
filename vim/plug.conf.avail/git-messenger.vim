let g:git_messenger_no_default_mappings = 0

nnoremap <silent> <Leader>b <Plug>(git-messenger)
"nmap <silent> <Leader>b :call setbufvar(winbufnr(popup_atcursor(split(system("git log -n 1 -L " . line(".") . ",+1:" . expand("%:p")), "\n"), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR>
