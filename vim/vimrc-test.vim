call plug#begin('~/.local/share/vim/plugged')
    Plug 'ludovicchabant/vim-gutentags'
    "Plug 'skywind3000/gutentags_plus'
    "Plug 'skywind3000/vim-auto-popmenu'
call plug#end()

source $HOME/.vim/plug.conf.d/vim-gutentags.vim
"source $HOME/.vim/plug.conf.d/gutentags-plus.vim
