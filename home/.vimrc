"--------------------------------------------------------------------------------
" General 
"--------------------------------------------------------------------------------
set number
set title
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
"set hlsearch
set incsearch
set nobackup
set clipboard^=unnamed
set viminfo+=n~/.vim/viminfo    " set the viminfo location
set t_Co=256                    " Use 256 colours
let g:netrw_home='~/.vim'
filetype indent on
filetype plugin on
set encoding=utf-8 
"set fileencoding=utf-8 

" TabComplete like bash
set wildmode=longest,list,full
set wildmenu

" Set this to the name of your terminal that supports mouse codes.
set ttymouse=xterm2
" Send more characters for redraws
set ttyfast

" Any buffer can be hidden (keeping its changes) without first writing 
" the buffer to a file
set hidden 

" Request sudo password to modify root files
cmap w!! %!sudo tee % > /dev/null 

" Force the highlight from start of file (but slowest result)
autocmd BufEnter * :syntax sync fromstart

" Saving folds
au BufWinLeave *.* mkview 1
au BufWinEnter *.* silent loadview 1

" set the ctags file name
set tags=tags,ctags,.tags,.ctags;   

" Easy of use with dead key keyboard
map ´ ''

" To navigate in lines without line break (large line)
imap <up> <esc>gk<insert><right>
imap <down> <esc>gj<insert><right>
map <up> gk
map <down> gj

" C-PageUp and C-PageDown to navigate between buffers in Normal mode
nnoremap <C-PageUp>     :bp<CR>
nnoremap <C-PageDown>   :bn<CR>
" A-PageUp and A-PageDown to navigate between tabs in Normal mode
nnoremap <M-PageUp>   :tabn<CR>
noremap <M-PageDown> :tabp<CR>
" A-Right and A-Left to jump words in Normal mode
nnoremap <M-right>  <C-right>
nnoremap <M-left>   <C-left>
" A-Right and A-Left to jump words in Insert mode
inoremap <M-right>  <C-O>W
inoremap <M-left>   <C-O>B
" C-L and C-H to jump words in Insert mode
inoremap <C-L> <C-\><C-O>W
inoremap <C-H> <C-\><C-O>B

"--------------------------------------------------------------------------------
" Vundle: Plugin Manager
"--------------------------------------------------------------------------------

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin on GitHub
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar.git'
"Plugin 'jcf/vim-latex'
Plugin 'Valloric/YouCompleteMe.git'
Plugin 'bling/vim-airline.git'
Plugin 'kshenoy/vim-signature.git'
Plugin 'tomasr/molokai.git'
"Plugin 'Rip-Rip/clang_complete.git'
Plugin 'rhysd/vim-clang-format'
Plugin 'will133/vim-dirdiff'

"Scala Plugin
Plugin 'derekwyatt/vim-scala'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"--------------------------------------------------------------------------------
" Colors scheme
"--------------------------------------------------------------------------------

" set the default color scheme
colorscheme peachpuff           
" colorscheme molokai

hi Visual cterm=reverse ctermfg=NONE ctermbg=NONE
hi Search cterm=bold,reverse ctermfg=NONE ctermbg=NONE

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

"shortcut to CtrlP
nnoremap <leader>. :CtrlP<cr> 

"--------------------------------------------------------------------------------
" TagBar 
"--------------------------------------------------------------------------------

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
" Latex files
"--------------------------------------------------------------------------------

"" I disabled the vim-latex plugin for now. Using omni completion (native)
"au Filetype tex source ~/.vim/plugin/tex_autoclose.vim 

"--------------------------------------------------------------------------------
" eclim
"--------------------------------------------------------------------------------


"--------------------------------------------------------------------------------
" supertab
"--------------------------------------------------------------------------------

"let g:SuperTabDefaultCompletionType = 'context'

"--------------------------------------------------------------------------------
" Map keys to work with URXVT+TMUX+SSH
"--------------------------------------------------------------------------------
"
" To find the vim keycode, in insert mode, press the <CTRL-K>
" Ot = NUMPED 4
" Ox = NUMPED 8
" Ov = NUMPED 6
" Or = NUMPED 2
" Ou = NUMPED 5

map  Ow     <Home>
map  Oq     <End>
map  Ot     <Left>
map  Ox     <Up>
map  Ov     <Right>
map  Or     <Down>
map  Ou     <Nop>

" Special cases to handler inside urxvt+ssh+tmux
" This strange codes is picked with Ctrl-K

" C-Right and C-Left fixed
map [1;5C   <C-right>
map [1;5D   <C-left>
" M-up and M-down fixed
map [1;3A  <M-UP>
map [1;3B  <M-DOWN>
"M-Right and M-Left fixed
map [1;3C  <M-Right>
map [1;3D  <M-Left>
"M-PageUp and M-PageDown fixed
map [5;3~  <M-PageUp>
map [6;3~  <M-PageDown>
"C-PageUp and C-PageDown fixed
map [5;5~  <C-PageUp>
map [6;5~  <C-PageDown>

"--------------------------------------------------------------------------------
" YouCompleteMe
"--------------------------------------------------------------------------------

highlight Pmenu ctermfg=white ctermbg=darkgray
highlight PmenuSel ctermfg=black  ctermbg=white
highlight clear SignColumn      

nnoremap <silent>  <C-]>  :YcmCompleter GoToImprecise<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

let g:ycm_global_ycm_extra_conf = '~/.ycm/ycm_extra_conf.py'
let g:ycm_path_to_python_interpreter = '/usr/bin/python'

" Remove preview window
let g:ycm_add_preview_to_completeopt = 0
set completeopt-=preview

" Remove diagnostics: 'left side symbols'
let g:ycm_enable_diagnostic_signs = 0

" Remove diagnostics: 'text highlighting'
let g:ycm_show_diagnostics_ui = 0

"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'

let g:ycm_confirm_extra_conf = 0
"let g:loaded_youcompleteme = 1

"--------------------------------------------------------------------------------
" vim-airline
"--------------------------------------------------------------------------------

set laststatus=2 

" set the symbol dictionary as the one of powerline
let g:airline_powerline_fonts = 1

"" powerline symbols
"if !exists('g:airline_symbols')
"	let g:airline_symbols = {}
"endif
"
""let g:airline_left_sep = ''
""let g:airline_left_alt_sep = ''
""let g:airline_right_sep = ''
""let g:airline_right_alt_sep = ''
""let g:airline_symbols.branch = ''
""let g:airline_symbols.readonly = ''
""let g:airline_symbols.linenr = ''
	
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"--------------------------------------------------------------------------------
" clang-format
"--------------------------------------------------------------------------------

let g:clang_format#code_style = 'llvm'

"--------------------------------------------------------------------------------
" Using Silver Searcher AG: https://github.com/ggreer/the_silver_searcher
" or 'sudo apt-get install silversearcher-ag'
"--------------------------------------------------------------------------------

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif

"--------------------------------------------------------------------------------
" bind K to grep word under cursor ('grep' is replaced by 'ag', if possible)
"--------------------------------------------------------------------------------

nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
autocmd FileType qf wincmd J

