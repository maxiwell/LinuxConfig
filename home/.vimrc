"--------------------------------------------------------------------------------
" General 
"--------------------------------------------------------------------------------

set number
set title

" Request sudo password to modify root files
cmap w!! %!sudo tee % > /dev/null 

" Force the highlight from start of file (but slowest result)
autocmd BufEnter * :syntax sync fromstart

set encoding=utf-8 
" set fileencoding=utf-8 

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex 
" can be called correctly.
set shellslash

set clipboard^=unnamed

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

"inoremap { {<CR>}<Esc>ko

" To navigate in lines without line break (large line)
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

" Saving folds
au BufWinLeave ?* mkview 1
au BufWinEnter ?* silent loadview 1

" set the ctags file name
set tags=tags,ctags,.tags,.ctags;   

set clipboard^=unnamed

" set the viminfo location
set viminfo+=n~/.vim/viminfo

"--------------------------------------------------------------------------------
" Tmux Configuration
"--------------------------------------------------------------------------------

"tmux tabs with name of file open in vim
"autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
"autocmd VimLeave * call system("tmux rename-window bash")
"autocmd BufEnter * let &titlestring = ' ' . expand("%:t")

"--------------------------------------------------------------------------------
" Persistent UNDO 
"--------------------------------------------------------------------------------

" set a directory to store the undo history
set undodir=~/.vim/undo
" tell it to use an undo file
set undofile
" maximum number of changes that can be undone
"set undolevels=1000
" maximum number lines to save for undo on a buffer reload
"set undoreload=10000 

"--------------------------------------------------------------------------------
" HTML file 
"--------------------------------------------------------------------------------

" HTML: You can jump a tag to the matching tag by typing %
" runtime macros/matchit.vim

"--------------------------------------------------------------------------------
" GnuPlot file 
"--------------------------------------------------------------------------------

au BufRead,BufNewFile *.gplot set filetype=gnuplot
au BufRead,BufNewFile *.gnuplot set filetype=gnuplot
au BufRead,BufNewFile *.gnu set filetype=gnuplot

"--------------------------------------------------------------------------------
" LLVM file 
"--------------------------------------------------------------------------------

augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
augroup END

"--------------------------------------------------------------------------------
" ctrlp.vim 
"--------------------------------------------------------------------------------

set runtimepath^=~/.vim/bundle/ctrlp.vim
"shortcut to CtrlP
nnoremap <leader>. :CtrlP<cr> 

"--------------------------------------------------------------------------------
" TagBar 
"--------------------------------------------------------------------------------

set runtimepath^=~/.vim/bundle/tagbar
"shortcut to TabBar
nnoremap <silent> <Leader>b :TagbarToggle<CR>

"--------------------------------------------------------------------------------
" autocomplete with tab: priceless
"--------------------------------------------------------------------------------

" set dictionary+=/usr/share/dict/words
" set complete=.,w,k
" 
" function AutoCompletar(direcao)
"    let posicao = col(".") - 1
"    if ! posicao || getline(".")[posicao - 1] !~ '\k'
"       return "\<Tab>"
"    elseif a:direcao == "avancar" 
"       return "\<C-n>"
"    else
"       return "\<C-p>"
"    endif
" endfunction
" 
" inoremap <Tab> <C-R>=AutoCompletar("avancar")<CR>
" inoremap <S-Tab> <C-R>=AutoCompletar("voltar")<CR>

"--------------------------------------------------------------------------------
"clang_complete
"--------------------------------------------------------------------------------

"set runtimepath^=~/.vim/bundle/clang_complete
set runtimepath-=~/.vim/bundle/clang_complete

"let g:clang_library_path = '/usr/lib/llvm-3.6/lib'
"let g:clang_sort_algo = 'alpha'
"
"" If you prefer the Omni-Completion tip window to close when a selection is
"" made, these lines close it on movement in insert mode or when leaving
"" insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"
""Prevent Pydoc preview window
"set completeopt-=preview
"
"highlight Pmenu ctermfg=white ctermbg=darkgray
"highlight PmenuSel ctermfg=black  ctermbg=white
"
"set conceallevel=2
"let g:clang_snippets=1
"let g:clang_conceal_snippets=1
"let g:clang_complete_macros = 1

"--------------------------------------------------------------------------------
" clasetag.vim
"--------------------------------------------------------------------------------

" Hitting ctrl-_ will initiate a search for the most recent open tag above 
" that is not closed in the intervening space and then insert the matching 
" close tag at the cursor.
" au Filetype html,xml,xsl source ~/.vim/plugin/closetag.vim 

" I disabled closetag. I am use omni completation, with <C-X> <C-O>, native
" support.

"--------------------------------------------------------------------------------
" Latex files
"--------------------------------------------------------------------------------

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


" set runtimepath^=~/.vim/bundle/vim-latex
"
" I disabled the vim-latex plugin for now. The tex_autoclose.vim is enough
" <C-\>c close the tex env
au Filetype tex source ~/.vim/plugin/tex_autoclose.vim 

"--------------------------------------------------------------------------------
" eclim
"--------------------------------------------------------------------------------

" set runtimepath^=~/.vim/bundle/eclim

"--------------------------------------------------------------------------------
" supertab
"--------------------------------------------------------------------------------

"set runtimepath^=~/.vim/bundle/supertab
"let g:SuperTabDefaultCompletionType = 'context'

"--------------------------------------------------------------------------------
" Escape some keys in URXVT
"--------------------------------------------------------------------------------
"
" To find the vim keycode, in insert mode, press the <CTRL-K>
" Ot = NUMPED 4
" Ox = NUMPED 8
" Ov = NUMPED 6
" Or = NUMPED 2
" Ou = NUMPED 5

map Ow      <Home>
map Oq      <End>

map  Ot     <Left>
map  Ox     <Up>
map  Ov     <Right>
map  Or     <Down>
map  Ou     <Nop>

"--------------------------------------------------------------------------------
" YouCompleteMe
"--------------------------------------------------------------------------------

set runtimepath^=~/.vim/bundle/YouCompleteMe
"set runtimepath-=~/.vim/bundle/YouCompleteMe

highlight Pmenu ctermfg=white ctermbg=darkgray
highlight PmenuSel ctermfg=black  ctermbg=white

nnoremap <silent>  <C-]>  :YcmCompleter GoTo<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" Remove preview window
let g:ycm_add_preview_to_completeopt = 0
set completeopt-=preview

" Remove diagnostics: 'left side symbols'
let g:ycm_enable_diagnostic_signs = 0

" Remove diagnostics: 'text highlighting'
let g:ycm_show_diagnostics_ui = 0

"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'


