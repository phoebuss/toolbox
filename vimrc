"=========================================================================
" Windows OS Setting
if has('win32')
    syntax on
    autocmd GUIEnter * simalt ~x
    set guifont=Consolas:h11
    set noeb vb t_vb=
    set linespace=-1
    set nobackup
    autocmd filetype text set tw=160
endif

"=========================================================================
" Vundle
if !empty(glob("~/.vim/bundle/Vundle.vim"))
    set nocompatible              " be iMproved, required
    filetype on                  " required
    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'artemkin/taglist.vim'
    Plugin 'mattn/emmet-vim'
    Plugin 'octol/vim-cpp-enhanced-highlight'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'moll/vim-node'
    Plugin 'luochen1990/rainbow'

    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
endif

"=========================================================================
" General Setting
syntax on
set ruler
colorscheme koehler
set incsearch
set hlsearch
set ignorecase
set autoread
set autowrite
set history=3000
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set number
set autoindent
set autochdir
set cino=g0,:0,j1,J1
set foldenable
set fdm=syntax
set fdls=99
set bs=2
set colorcolumn=81
set splitbelow
set splitright
set encoding=utf-8

let g:html_indent_inctags = "html,body,head,tbody,style,script"
autocmd filetype python set fdm=indent

"=========================================================================
" Hotkey mapping
let g:mapleader = "," 

"<F2> Comment <F3> Uncomment
nnoremap <F2> ^i//<esc>
nnoremap <F3> :s/\/\///<CR>:noh<CR>
inoremap <F2> <esc>$a<tab>//
inoremap <F3> <esc>/\/\/<cr>d$

"<F4>/<F5> add/remove check mark
nnoremap <F4> $a<tab>/* <== need check */<esc>
nnoremap <F5> :s/\t\/\*\ <==\ need check\ \*\///g<CR>:noh<CR>

inoremap '<space><space> ''<left>
inoremap "<space><space> ""<left>
inoremap <<space><space> <><left>
inoremap (<space><space> ()<left>
inoremap [<space><space> []<left>
inoremap {<space><space> {}<left>
inoremap /*<space><space> /*<space><space>*/<left><left><left>

inoremap {<CR> {}<left><CR><esc>O

nnoremap <space> @=((foldclosed(line('.')) <0) ? 'zc': 'zo')<CR>

"Include completion
inoremap #in #include 
nnoremap <C-@> :cs find c <C-R>=expand("<cword>")<CR><CR>
vnoremap // y/<C-R>"<CR>

"Disable autoindent for paste
nnoremap <leader>0 :setl noai nocin nosi noet inde=<CR>:imapc<CR>

"Disable record
nnoremap q <Nop>

"=========================================================================
" highlight Functions
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
hi cFunctions gui=NONE cterm=bold  ctermfg=cyan

"=========================================================================
" Taglist
if !empty(glob("~/.vim/bundle/taglist.vim"))
    let Tlist_Use_Right_Window=1
    let Tlist_Sort_Type="name"
    let Tlist_Show_One_File=1
    let Tlist_Exit_OnlyWindow=1
    let Tlist_Compact_Format=1
    let Tlist_Display_Prototype=0
    let Tlist_WinWidth=40
    let Tlist_Enable_Fold_Column=0
    let Tlist_GainFocus_On_ToggleOpen=1

    autocmd BufWritePost *.c,*.h,*.cpp :TlistUpdate 

    nnoremap <F10> :TlistToggle<CR>
endif

"=========================================================================
function! HeaderFileInit()
    let buf="__".toupper(expand("%:r"))."_".toupper(expand("%:e"))."__"
    normal ggdG
    call append(0, "#ifndef ".buf)
    call append(1, "#define ".buf)
    execute "normal o\<esc>.\<esc>"
    call append(line('$'), "#endif /*".buf."*/")
    call setpos('.', [0,4,0,0])
endfunction

autocmd BufNewFile *.h :call HeaderFileInit()

"=========================================================================
" Emmet
if !empty(glob("~/.vim/bundle/emmet-vim"))
    let g:user_emmet_leader_key='<C-j>'
endif

"=========================================================================
" Rainbow
if !empty(glob("~/.vim/bundle/rainbow"))
    let g:rainbow_active = 1
endif

"=========================================================================
" YCM
if !empty(glob("~/.vim/bundle/YouCompleteMe"))
    let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_cache_omnifunc = 0
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_seed_identifiers_with_syntax = 1

    nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
    nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
endif

