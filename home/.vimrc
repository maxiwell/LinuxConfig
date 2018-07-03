"--------------------------------------------------------------------------------
" General 
"--------------------------------------------------------------------------------
set number
set relativenumber
set title
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
"set mouse=a
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

" set working directory to the current file
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
set autochdir
autocmd BufEnter * lcd %:p:h

" Save marks of 1000 files
set viminfo='1000,f1

" Set this to the name of your terminal that supports mouse codes.
set ttymouse=xterm2
" Send more characters for redraws
set ttyfast

" Any buffer can be hidden (keeping its changes) without first writing 
" the buffer to a file
set hidden 

" Request sudo password to modify root files
cmap w!! %!sudo tee % > /dev/null 

" Remove ALL autocommands for the current group
autocmd!   

" Force the highlight from start of file (but slowest result)
"autocmd BufEnter * :syntax sync fromstart
syntax on

" Saving folds
au BufWinLeave *.* mkview 1
au BufWinEnter *.* silent loadview 1

" Easy of use with dead key keyboard
map ´ ''

" To navigate in lines without line break (large line)
imap <up> <esc>gk<insert><right>
imap <down> <esc>gj<insert><right>
map <up> gk
map <down> gj

" " C-PageUp and C-PageDown to navigate between buffers in Normal mode
" nnoremap <C-PageUp>     :bp<CR>
" nnoremap <C-PageDown>   :bn<CR>
" " A-PageUp and A-PageDown to navigate between tabs in Normal mode
" nnoremap <M-PageUp>   :tabn<CR>
" noremap <M-PageDown>  :tabp<CR>
" " A-Right and A-Left to jump words in Normal mode
" nnoremap <M-right>  <C-right>
" nnoremap <M-left>   <C-left>
" " A-Right and A-Left to jump words in Insert mode
" inoremap <M-right>  <C-O>W
" inoremap <M-left>   <C-O>B

" C-W and C-B to jump words in Insert mode
inoremap <C-W> <C-\><C-O>W
inoremap <C-B> <C-\><C-O>B

" C-h and C-l to navigate between buffers 
nnoremap <silent> <C-h>      :bp<CR>
nnoremap <silent> <C-l>      :bn<CR>
inoremap <silent> <C-h>      <ESC>:bp<CR>
inoremap <silent> <C-l>      <ESC>:bn<CR>


" C/C++: Fix { } indent inside 'switch' statement
set cino=l1


"-------------------------------------------------------------------------------
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
Plugin 'scrooloose/nerdtree'
"Plugin 'vim-scripts/Conque-GDB'
Plugin 'rking/ag.vim'
"Plugin 'terryma/vim-multiple-cursors'

" GIT wrapper
Plugin 'tpope/vim-fugitive'

"Scala Plugin
"Plugin 'derekwyatt/vim-scala'

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

set fillchars+=vert:│
highlight VertSplit cterm=none gui=none 

hi SpellBad cterm=NONE,undercurl gui=NONE,undercurl ctermfg=NONE guifg=NONE ctermbg=NONE


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
nnoremap <Leader>p     :CtrlP<cr>
nnoremap <Leader>o     :CtrlPBuffer<cr>
nnoremap <Leader>l     :CtrlPMRU<cr>
nnoremap <Leader>;     :CtrlPMixed<cr>
"nnoremap <Leader>ta    :CtrlPTag<cr>
"nnoremap <Leader>tb    :CtrlPBufTag<cr>

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

"nnoremap <silent>  <C-]>  :YcmCompleter GoToImprecise<CR>
nnoremap <silent>  <C-]>  :YcmCompleter GoTo<CR>
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
" let g:airline_powerline_fonts = 1

" powerline symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
	
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

"  " 'Ag.vim' plugin finds the root project. It uses 'ag' too
  let g:ag_prg="ag --nogroup --nocolor"
  let g:ag_working_path_mode="r"
  let g:ag_format="%f:%l:%m"

endif

"--------------------------------------------------------------------------------
" bind K to grep word under cursor
"--------------------------------------------------------------------------------

"Ag project uses 'ag' from the .git folder (very nice)
if executable('ag')
    nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>:cw<CR> 
else
    nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR> 
endif

" This trigger takes advantage of the fact that the quickfix window can be
" easily distinguished by its file-type, qf. The wincmd J command is
" equivalent to the Ctrl+W, Shift+J shortcut telling Vim to move a window to
" the very bottom (see :help :wincmd and :help ^WJ).
autocmd FileType qf wincmd J

"--------------------------------------------------------------------------------
" NERDTree
"--------------------------------------------------------------------------------

" Ctrl-n to open/close NERDTree
map <C-n>     :NERDTreeToggle<CR> 

" Update NERDTree path using the Buffer path
"map <Leader>f :NERDTreeFind<CR>

map <Leader>f :NERDTree %:p:h<CR>

" Shortcuts:
" s     Open a file with vsplit
" i     Open a file with hsplit

"--------------------------------------------------------------------------------
" ctags and cscope
"--------------------------------------------------------------------------------

" set the ctags file name
set tags=tags,ctags,.tags,.ctags

" Use .../tags in ancestor of source directory.
" useful when you have source tree eight fathom deep,
" an exercise in Vim loops.
let parent=1
let local_tags = ".tags/ctags"
let local_cscope = ".tags/cscope.out"
exe ":set tags+=".local_tags
exe ":cs add ".local_cscope

while parent <= 15
  let local_tags = "../". local_tags
  let local_cscope = "../". local_cscope
  exe ":set tags+=".local_tags
  exe ":cs add ".local_cscope
  let parent = parent+1
endwhile

" cscope map
" s: Find this C symbol
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
" g: Find this definition
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
" c: Find functions calling this function
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
" t: Find this text string
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
" e: Find this egrep pattern
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
" f: Find this file
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
" i: Find files #including this file
nmap <C-\>i :cs find i [/]?<C-R>=expand('%:t')<CR><CR>
" d: Find functions called by this function
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" a: Find places where this symbol is assigned a value
nmap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>

" Find the file that you type. Some projects copy the header
" files in different places (/include, /refs, /releases). So 
" with this shortcut, you can find copies of files using the 
" CSCOPE database (CtrlP fails when a project has many .git 
" repository). Use % to search the current filename 
nmap <C-\>F :cs find f 

" You can add your own expression
nmap <C-\>E :cs find e 

"--------------------------------------------------------------------------------
" Signature (marks clever) 
"--------------------------------------------------------------------------------

" Default Shortcuts:
" m,           Place the next available mark
" m-           Delete all marks from the current line
" m<Space>     Delete all marks from the current buffer
" ]`           Jump to next mark
" [`           Jump to prev mark
" m/           Open location list and display marks from current buffer
" 
" More here: github.com/kshenoy/vim-signature

"--------------------------------------------------------------------------------
" ConqueGDB
"--------------------------------------------------------------------------------

" let g:ConqueGdb_Leader = '\\'

" Default Shortcuts:
" \\r            Run program mapping 
" \\c            Continue program mapping
" \\n            Next line mapping
" \\s            Step line mapping
" \\p            Print identifier under cursor
" \\b            Toggle break point mapping
" \\d            Delete break point mapping 
" \\f            Finish mapping
" \\t            Backtrace mapping
"
" More here: https://github.com/vim-scripts/Conque-GDB

"--------------------------------------------------------------------------------
" multiple-cursors
"--------------------------------------------------------------------------------
"let g:multi_cursor_use_default_mapping=0
"
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-p>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'

