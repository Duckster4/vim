" Enable syntax highlighting
syntax on
" Enable file type detection
filetype plugin indent on
" Set the leader key for convenience
let mapleader = " "

" Use an external editor for editing files in terminal
set clipboard=unnamedplus

" Set up vim to show line numbers
set relativenumber
" set number

set mouse=
colorscheme desert

" Define the path for the Coc extension
let g:coc_global_extensions = ['coc-pyright']

" Configure indentation settings for Python
augroup python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
augroup END

"autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab

" Key mappings for Coc
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
