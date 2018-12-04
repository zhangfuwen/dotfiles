call plug#begin('~/.vim/plugged')
"Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'NLKNguyen/papercolor-theme'

Plug 'scrooloose/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'Yggdroot/LeaderF',{'do':'./install.sh'}

Plug 'ludovicchabant/vim-gutentags'

if(has('python3'))
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'Shougo/denite.nvim'
endif

" remember to run
" pip3 install --user neovim
"
Plug 'dyng/ctrlsf.vim'
Plug 'scrooloose/nerdcommenter'



Plug 'flazz/vim-colorschemes'

Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'itchyny/vim-cursorword'
Plug 'Yggdroot/indentLine'
Plug 'derekwyatt/vim-fswitch',{'for':['c','cpp']}
"Plug 'derekwyatt/vim-protodef',{'for':['c','cpp']}
"Plug 'dbgx/lldb.nvim',{'on':'LLsession','do':':UpdateRemotePlugins'}
Plug 'vim-scripts/DoxygenToolkit.vim',{'on':'Dox'}
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'Townk/vim-autoclose'


call plug#end()

set mouse=a
filetype plugin on
set nocompatible
filetype on
syntax enable
set backspace=indent,eol,start
set cursorline

" folding {{{
set nofoldenable
autocmd FileType c,cpp,perl set foldmethod=syntax
autocmd FileType python set foldmethod=indent
autocmd FileType vim set foldmethod=marker
autocmd FileType vim set nowrap
" }}}


" indentation {{{
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent
set smartindent
" }}}

" scrolling {{{
set scrolloff=4
set sidescrolloff=7
" }}}


" encoding {{{
set helplang=cn
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,gb18030,latin1
set fileencoding=utf-8
set fileformat=unix
"language messages zh_CN.utf-8
" }}}

" searching {{{
set hlsearch
set incsearch
set ignorecase
" }}}

" {{{ completion
inoremap <expr> <silent> <Tab> pumvisible()?"\<C-n>":"\<TAB>"
inoremap <expr> <silent> <S-TAB> pumvisible()?"\<C-p>":"\<S-TAB>"
" }}}

set number
set autoread
set showmatch " show bracket matches
set laststatus=2 " last window will always has status line
filetype plugin on
filetype indent on
set t_Co=256 " 256 colors

set completeopt=menu,menuone
set background=light

set wildmenu " vim 自身命令行模式智能补全
set mouse=a

if(has('python3'))
	set pyx=3
	set pyxversion=3
endif

" 自动化 {{{
" }}}


" deoplete {{{
if(has('python3'))
	let g:deoplete#enable_at_startup=1
	call deoplete#custom#option({
			\'auto_complete_delay':200,
			\'smart_case':v:true,
			\})
endif
" }}}

" Leaderf {{{
let g:Lf_RootMarkers  = ['.preject','.root','.svn','.git']
let g:Lf_WorkingDirectoryMode='Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory=expand('~/.vim/cache')
let g:Lf_ShowRelativePath=0
let g:Lf_HideHelp=1
let g:Lf_StlColorscheme='powerline'
let g:Lf_PreviewResult={'Function':0,'BufTag':0}
" }}}

" CtrlSF {{{
let g:ctrlsf_extra_root_markers = ['.root','.project','.svn','.git']
let g:ctrlsf_search_mode='async'
let g:ctrlsf_default_view_mode='compact' " compact for quickfix style, normal for CtrlSF style
let g:ctrlsf_auto_focus={
            \"at":"start"
            \}
let g:ctrlsf_context='-A 0 -B 0'
" }}}


" myscripts {{{
command FindAllHere :call FindAll()
function! FindAll()
    call inputsave()
    let p=input('Enter pattern to search in this file:')
    call inputrestore()
    try
        execute 'vimgrep "'.p.'" %|copen'
        execute 'cope'
    catch a:exception
        echo "not anything found"
    endtry
endfunction

command GREP :execute 'vimgrep '.expand('<cword>').' '.expand('%')|:copen|:cc
" }}}
" ctags {{{
set tags=./.tags;,.tags
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
" }}}

" KeyMaps {{{
nmap tt :NERDTreeToggle<CR>
nmap tb :TagbarToggle<CR>
nmap tl :TagbarToggle<CR>
nmap tp :Leaderf --fullscreen file<CR>
nmap t@ :Leaderf --fullscreen function<CR>
nmap tf :CtrlSF
nmap t/ :silent! FindAllHere<CR>
nmap ta :FSHere<CR> "头文件切换
"namp td :Doc<CR> " 函数生成注释
":set foldenable
" }}}

" help {{{
" :h ctrlsf
" :h nerdtree
" :h tagbar
" :h leaderf
" :h denite
" :h deoplete
"
" # folding and unfolding
" set fen
" set fde
"
" zo unfold under cursor
" zO unfold recursively under cursor
" zc fold under cursor
" zC fold under cursor recursively
"
" zM fold all
" zR unfold all
"
" # DoxygenToolKit
" :Dox
"
" # CtrlSF
" Press M to switch to quickfix window
" }}}






colo PaperColor 
let laststatus=2 "永远显示状态栏 
let g:airline_powerline_fonts = 0 " 支持 powerline 字体 
let g:airline#extensions#tabline#enabled = 1 "显示窗口tab和buffer
" let g:airline_theme="badcat"
"AirlineTheme badcat

" nerdcommenter{{{ 
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
nmap <C-_>  <leader>c<space>
" }}}
