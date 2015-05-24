set nocompatible		"不兼容vi
"colorscheme desert

set ruler
"set textwidth=80

set matchtime=5		"高亮的时间
set incsearch		"逐字高亮搜索

set nu
"set list listchars=tab:>-	"可视化tab键
set tabstop=4 shiftwidth=4	"shiftwidth自动tab宽度
set noexpandtab		"不用空格替代tab,(%retab!空格转换为tab)
autocmd filetype xhtml set tabstop=2 shiftwidth=2
autocmd filetype html set tabstop=2 shiftwidth=2
"autocmd filetype c set tabstop=4 shiftwidth=4
"autocmd filetype h set tabstop=4 shiftwidth=4
"autocmd filetype c++ set tabstop=4 shiftwidth=4
"autocmd filetype py set noexpandtab tabstop=4 shiftwidth=4

autocmd filetype txt set spell			"对txt文档的英文进行语法检查

"set spell			"开启拼写检查
"set lines=28  "columns=200

set nocompatible	" 关闭兼容模式
syntax enable		" 语法高亮
"set shortmess=atI	" 去掉欢迎界面
set go=
set autoindent		"继承上一缩进
set si				" 智能缩进
set cindent			" C/C++风格缩进
set wildmenu		
set nofen
set fdl=10
set history=400  " vim记住的历史操作的数量，默认的是20
"从系统剪切板中复制，剪切，粘贴
"set guifont=Consolas:h12		"字体中有空格用\来转意,这条是win下的写法
" 状态条，显示字节数，列数，行数，当前行等信息	
"  
"set statusline=%F%m%r%h%w/ [FORMAT=%{&ff}]/ [TYPE=%Y]/ [ASCII=/%03.3b]/ [HEX=/%02.2B]/ [POS=%04l,%04v][%p%%]/ [LEN=%L]  
"set laststatus=2 " always show the status line  
"

"字符编码
set fileencodings=utf-8,gbk,gb2312,cp936
set fileencoding=utf-8		"可以不用设置
set encoding=utf-8			"设置状态栏的编码

"长行中移动,加前缀g

"===========================================================
"gvim的设置在.gvimrc中
"===========================================================

"<F3>实现sdcv快捷查询
function! Mydict()
	let expl=system('sdcv -n ' .
	\  expand("<cword>"))
	windo if
	\ expand("%")=="diCt-tmp" |
	\ q!|endif
	30vsp diCt-tmp
	setlocal buftype=nofile bufhidden=hide noswapfile
	1s/^/\=expl/
	1
endfunction
nmap <F3> :call Mydict()<CR>

"<F4>编译"
map <F4> : call Compile()<CR>
func! Compile()
exec "w"
exec "!clear"
exec "!gcc -o %< % -ansi -Wall -lm"
endfunc


"<F5>编译运行"
map <F5> : call CompileRun()<CR>
func! CompileRun()
exec "w"
if &filetype == 'xhtml' || &filetype == 'html'
	exec "!clear"
	exec "!firefox %"
elseif &filetype == 'c'

	exec "!clear"
	exec "!gcc -o %< % -Wall -ansi -lm"
	exec "! ./%<"
else
	exec ""
endif
endfunc

"<F6>运行"
map <F6> : call Run()<CR>
func! Run()
	exec "w"
	exec "!clear"
	exec "!./%<"
endfunc

"C语言调试"
map <F7> : call GDB()<CR>
func! GDB()
exec "w"
exec "!clear"
exec "!gcc -o %< % -g -ansi -lm"
exec "!gdb %<"
endfunc

"filetype on		"侦测文件类型
filetype off

"使用 vundle来管理插件
filetype plugin indent on     " required!  
set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  

" let Vundle manage Vundle  
" required!   
Bundle 'gmarik/vundle'  

"original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
"vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
"non github repos
"Bundle 'git://git.wincent.com/command-t.git'
"powerline
"Bundle 'https://github.com/Lokaltog/vim-powerline.git'
"vim-airline 一个简化的powerline
Bundle 'bling/vim-airline'
Bundle 'https://github.com/oplatek/Conque-Shell'
"...
"下面是vundle使用命令
":BundleList			--list configured bundles
":BundleInstall(!)		--install(update) bundles
":BundleSearch(!) foo	--search(or refresh cache first) for foo
":BundleClean(!)		--confirm(or auto-approve) removal of unused bundles
"
"see :h vundle for more details or wiki for FAQ
"NOTE: comment after Bundle command are not allowed..
"==========================end vundle================


"taglist插件
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=2
"====end taglist插件===

"使用winmanager把TagList和netrw整合起来
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>
"在普通模式下输入 vm
"===end 配置==

"cscope配置
set cscopequickfix=s-,c-,d-,i-,t-,e-
"使用同ctags，cscope -Rbq
"添加数据库
if filereadable("cscope.out")
	cs add cscope.out
elseif "$CSCOPE_DB" != ""
	cs add "$CSCOPE_DB"
endif
"cscope快捷键
"nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>f :cs find f <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>i :cs find i ^<C-R>=expand("<cword>")<CR>$<CR>
"nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
""===end cscope===

"补全
"要先打开 filetype plugin indent on 
"关闭预览
set completeopt=longest,menu
"下面是使用了supertab插件来优化补全
"let g:SuperTabRetainCompletionType=2
" 0 - 不记录上次的补全方式
" 1 - 记住上次的补全方式,直到用其他的补全命令改变它
" 2 - 记住上次的补全方式,直到按ESC退出插入模式为止

"let g:SuperTabDefaultCompletionType="<C-X><C-O>"
" 设置按下<Tab>后默认的补全方式, 默认是<C-P>,
" 现在改为<C-X><C-O>. 关于<C-P>的补全方式,
" 还有其他的补全方式, 你可以看看下面的一些帮助:
" :help ins-completion
" :help compl-omni
"===end 补全===

"下面是powerline-status配置
"set laststatus=2
"set t_Co=256
"let g:Powerline_symbols = 'unicode'
""let g:Powerline_symbols = 'fancy'

"下面是vim-airline的配置
if !exists('g:airlne_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
set laststatus=2
set t_Co=256

"ConqueTerm控制台
"下面是一些快捷键
"<F9> 将选中文本发送到Conque-Shell
"<F10> 将当前所有文本发送到Conque-Shell中
"<F11> 如果当前编辑文件可执行，则打开新的Conque-Shell并运行
"		但是会有快捷键冲突

"c语言模板插入
iab chead #include <stdio.h><CR><CR>int main(int argc, char **argv)<CR>{<CR>return 0;<CR>}<CR>
