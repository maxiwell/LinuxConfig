set number
set title

" Request sudo password to modify root files
cmap w!! %!sudo tee % > /dev/null 

" Force the highlight from start of file (but slowest result)
autocmd BufEnter * :syntax sync fromstart

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

" HTML: You can jump a tag to the matching tag by typing %
runtime macros/matchit.vim

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
au BufWinLeave ?* mkview 1
au BufWinEnter ?* silent loadview 1

" set the ctags file name
set tags=tags,ctags,.tags,.ctags;   

"tmux tabs with name of file open in vim
autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux rename-window bash")

set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/tagbar

"shortcut to CtrlPTag
nnoremap <leader>. :CtrlPTag<cr> 

"shortcut to TabBar
nnoremap <silent> <Leader>b :TagbarToggle<CR>

"-- F1-F12 Map -----------------------------------------------------------
" <F1>   <c-x><c-L> completion: whole line
" <F2>   <c-x><c-N> completion: keywords using current file
" <F3>   <c-x><c-K> completion: keywords using dictionary
" <F4>   <c-x><c-T> completion: keywords using thesaurus
" <F5>   <c-x><c-I> completion: keywords in current and included files
" <F6>   <c-x><c-]> completion: tags
" <F7>   <c-x><c-F> completion: file names
" <F8>   <c-x><c-D> completion: definitions or macros
" <F9>   <c-x><c-V> completion: vim command line
" <F10>  <c-x><c-O> completion: omni completion
" F1, F10, F11 and F12 only works in Vim with X server (e.g) vim-gtk

ino <silent> <F1>      <c-x><c-L>
ino <silent> <F2>      <c-x><c-N>
ino <silent> <F3>      <c-x><c-K>
ino <silent> <F4>      <c-x><c-T>
ino <silent> <F5>      <c-x><c-I>
ino <silent> <F6>      <c-x><c-]>
ino <silent> <F7>      <c-x><c-F>
ino <silent> <F8>      <c-x><c-D>
ino <silent> <F9>      <c-x><c-V>
ino <silent> <F10>     <c-x><c-O>
ino <silent> <F11>     <C-O>ma<C-O>yiw<C-O>:ptag <C-R>"<CR><C-O>`a
ino <silent> <s-left>  <c-x><c-p>
ino <silent> <s-right> <c-x><c-n>
ino <silent> <F12>     <c-o>:echo 'completes[ F1:line F2:keywrd F3:dict F4:thes - F5:fromfile F6:tags F7:fname F8:defns - F9:vimcmd F10:omni ] F11:ptag-iw F12:funkey help'<CR>

"-- autocomplete with tab: priceless -------------------------------------

set dictionary+=/usr/share/dict/words
set complete=.,w,k

function AutoCompletar(direcao)
   let posicao = col(".") - 1
   if ! posicao || getline(".")[posicao - 1] !~ '\k'
      return "\<Tab>"
   elseif a:direcao == "avancar" 
      return "\<C-n>"
   else
      return "\<C-p>"
   endif
endfunction

inoremap <Tab> <C-R>=AutoCompletar("avancar")<CR>
inoremap <S-Tab> <C-R>=AutoCompletar("voltar")<CR>

"--clang_complete------------------------------------------------------------

set runtimepath^=~/.vim/bundle/clang_complete
let g:clang_library_path = '/usr/lib/llvm-3.3/lib'
let g:clang_sort_algo = 'alpha'

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"Prevent Pydoc preview window
set completeopt-=preview

highlight Pmenu ctermfg=white ctermbg=darkgray
highlight PmenuSel ctermfg=darkgray  ctermbg=white

set conceallevel=2
let g:clang_snippets=1
let g:clang_conceal_snippets=1

"--clasetag.vim-----------------------------------------------------------------

" Hitting ctrl-_ will initiate a search for the most recent open tag above 
" that is not closed in the intervening space and then insert the matching 
" close tag at the cursor.
" au Filetype html,xml,xsl source ~/.vim/plugin/closetag.vim 

" I disabled closetag. I am use omni completation, with <C-X> <C-O>, native
" support.

"--vim-latex--------------------------------------------------------------------

" set runtimepath^=~/.vim/bundle/vim-latex
"
" I disabled the vim-latex plugin for now. The tex_autoclose.vim is enough
" <C-\>c close the tex env
au Filetype tex source ~/.vim/plugin/tex_autoclose.vim 

"--eclim------------------------------------------------------------------------

set runtimepath^=~/.vim/bundle/eclim

"--supertab------------------------------------------------------------------------

"set runtimepath^=~/.vim/bundle/supertab
"let g:SuperTabDefaultCompletionType = 'context'


