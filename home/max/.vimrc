set number
set title


cmap w!! %!sudo tee % > /dev/null 

"VIM-LatexSuite

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.

set grepprg=grep\ -nH\ $*


" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

imap <up> <esc>gk<insert><right>
imap <down> <esc>gj<insert><right>
map <up> gk
map <down> gj

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=a

"set hlsearch
set incsearch

" TabComplete like bash
set wildmode=longest,list,full
set wildmenu


map ´ ''

au BufRead,BufNewFile *.gplot set filetype=gnuplot
au BufRead,BufNewFile *.gnuplot set filetype=gnuplot
au BufRead,BufNewFile *.gnu set filetype=gnuplot


" Saving folds
au BufWinLeave * mkview
au BufWinEnter * silent loadview


"tmux tabs with name of file open in vim
autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))

set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/tagbar

"shortcut to CtrlPTag
nnoremap <leader>. :CtrlPTag<cr> 

"shortcut to TabBar
nnoremap <silent> <Leader>b :TagbarToggle<CR>


