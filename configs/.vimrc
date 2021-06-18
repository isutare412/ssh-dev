"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dark'

" powerline symbols
" Uncomment if you want to use cooler seperator (Need powerline fonts)
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-colors-solarized setings
" set background=dark
" colorscheme solarized
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" symbol highlight on carret
let HlUnderCursor=0
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
filetype on " detect filetype
set t_Co=256 " color settings
set term=xterm-256color " 256 color settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " no compatible with VI
" set clipboard=unnamed " share clipboard with OS
set number " show row number
set rnu " show row number relatively based on carret
set scrolloff=2 " leave lines before/after carret
" set colorcolumn=79 " maximum line length
set wrap " enable word wrapping
set linebreak " wrap by word-size
set backspace=indent,eol,start " backspace can delete over inserted position
set autoindent " auto indent
set cindent " auto indent for C
set smartindent
set smarttab
set nowrapscan " do not loop back when you reach end in searching
set splitright " sp right
set splitbelow " vs below
set ruler " show carret row, column in command line
set undofile " make undo file (*.un~)
set laststatus=2 " always show status line
set expandtab " translate tab to space
set tabstop=4 " tab size
set softtabstop=4 " tab size (more generous)
set shiftwidth=4 " >>, << size
" set mouse=a  " use scroll of mouse
set showcmd " show command in status line
set showmatch " show matching parentheses (),[],{}
set incsearch " incremental search
set hlsearch " highlight search results
set linespace=5 " line space
set title " pass file name to terminal
set nobackup " do not make backup file
set nobomb " remove BOM
set fencs=ucs-bom,utf-8,default,cp949 " file encodings
set enc=utf-8
set tenc=utf-8 " terminal encodings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let @b=':set ts=2 sts=2 sw=2'
let @f=':set ts=4 sts=4 sw=4'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

