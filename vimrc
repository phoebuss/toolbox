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
    Plugin 'octol/vim-cpp-enhanced-highlight'
    Plugin 'luochen1990/rainbow'
    Plugin 'andymass/vim-matchup'
    Plugin 'craigmac/vim-mermaid'
"    Plugin 'tpope/vim-fugitive'

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
set cino=l0,g0,t0,+2,:0,j1,(0
set foldenable
set fdm=syntax
set fdls=99
set bs=2
set colorcolumn=81
set splitbelow
set splitright
set encoding=utf-8
set wildmenu
set wildmode=longest,full
set formatoptions=croql

" Forward clipboard to X11
"set mouse=a clipboard=autoselect

let g:html_indent_inctags = "html,body,head,tbody,style,script"
autocmd filetype python,yaml set fdm=indent
autocmd filetype make set noexpandtab
autocmd FileType sh let g:sh_fold_enabled=7

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
inoremap /**<CR> /**<CR><CR>/<left><up><space>

inoremap {<CR> {}<left><CR><esc>O

nnoremap <space> @=((foldclosed(line('.')) <0) ? 'zc': 'zo')<CR>

"Include completion
inoremap #in #include 
vnoremap // y/<C-R>"<CR>

"Disable autoindent for paste
nnoremap <leader>0 :mkexrc! $HOME/.vimrc.tmp<CR>:setl noai nocin nosi noet inde=<CR>:imapc<CR>
nnoremap <leader>1 :source $HOME/.vimrc.tmp<CR>

nnoremap <leader>fk :setl ts=8 sts=8 sw=8 noet<CR>
nnoremap <leader>fn :setl ts=4 sts=4 sw=4 et<CR>

"Disable record
nnoremap q <Nop>

"Git merge
"next conflict
nnoremap <leader>gn ]c
"previous conflict
nnoremap <leader>gN [c
"pick local
nnoremap <leader>g1 :diffget LOCAL<CR>
"pick base
nnoremap <leader>g2 :diffget BASE<CR>
"pick remote
nnoremap <leader>g3 :diffget REMOTE<CR>
"save and quit
nnoremap <leader>gw :wqa<CR>
"abort quit
nnoremap <leader>gq :cq<CR>

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

    autocmd BufWritePost *.c,*.h,*.cpp,*.hpp,*.cc :TlistUpdate

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

autocmd BufNewFile *.h,*.hpp :call HeaderFileInit()

function! EscapePairs()
    let opairs = {'(':')', '{':'}', '[':']', '"':'"', "'":"'", '<':'>'}
    let cpairs = {'"':'"', "'":"'", ')':'(', '}':'{', ']':'[', '>':'<'}
    let pos = getpos('.')
    let s = getline(pos[1])

    let stack = []
    let n_stack = 0
    for c in split(s[:pos[2]-1], '\zs')
        if has_key(cpairs, c)
            let i = n_stack - 1
            let found = 0
            while i >= 0
                if stack[i] == c
                    let found = 1
                    call remove(stack, i)
                    let n_stack -= 1
                    break
                endif
                let i -= 1
            endwhile
            if found == 1
                continue
            endif
        endif

        if has_key(opairs, c)
            let stack += [opairs[c]]
            let n_stack += 1
        endif
    endfor

    if n_stack > 0
        let target = stack[-1]
        let i = pos[2]
        while i < strchars(s)
            if s[i] == target
                let pos[2] = i + 1
                call setpos('.', pos)
                break
            endif
            let i += 1
        endwhile
    endif
endfunction

"execute "set <M-n>=\en"
inoremap <silent> <C-L> <ESC>:call EscapePairs()<CR>a
nnoremap <silent> <C-L> :call EscapePairs()<CR>
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
if !empty(glob("~/.vim/bundle/YouCompleteMe")) || !empty(glob("/usr/share/vim-youcompleteme"))
    let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_auto_hover=''

    nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
    nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
    nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
endif

if has("cscope")
    let s:path = expand("%:p:h")
    while s:path != "/"
        if !empty(glob(s:path . "/cscope.out"))
            exec "cscope add " . s:path
            break
        endif
        let s:path = fnamemodify(s:path, ":h")
    endwhile

    set csre
    nnoremap <leader>gc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\> :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-]> :cs find g <C-R>=expand("<cword>")<CR><CR>
endif
