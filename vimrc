set nocompatible 
set encoding=utf-8
set guifont=Source\ Code\ Pro\ for\ Powerline
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'raimondi/delimitmate'
Plugin 'dbmrq/vim-ditto'
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'lervag/vimtex'
Plugin 'valloric/youcompleteme'
Plugin 'ervandew/supertab'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'jceb/vim-orgmode'
Plugin 'tpope/vim-speeddating'

" C++ Plugins
Plugin 'vim-jp/cpp-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'drmikehenry/vim-headerguard'

" Web Development Plugins
Plugin 'mattn/emmet-vim'

call vundle#end()

set background=dark
colorscheme PaperColor
syntax on
filetype plugin indent on

" NERDTree 
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <F2> :NERDTreeToggle<CR>

" Airline
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#non_zero_only = 1

" Delimitate
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1

" YCM

" UltiSnips
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/snippets/"

" Vim Latex Preview
let g:livepreview_previewer = "zathura"

" Tex Files Fold
autocmd BufEnter *.tex set foldmethod=expr
autocmd BufEnter *.tex set foldexpr=vimtex#fold#level(v:lnum)
autocmd BufEnter *.tex set foldtext=vimtex#fold#text()

" Ctrlp
let g:ctrlp_map = '<leader>p'

" Easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" General
set nu
set exrc
set secure
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab 

let mapleader=","
set backspace=indent,eol,start
set wrap
set linebreak
set nolist
set relativenumber
set clipboard=unnamedplus


" Remaps
inoremap <Space><Space>     <Esc>/<++><Enter>"_c4l
nnoremap <Tab>            za
