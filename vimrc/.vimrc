" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" TODO: Load plugins here (pathogen or vundle)
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Bundle 'dbeniamine/cheat.sh-vim'

let g:ycm_global_ycm_extra_conf = '/Users/alexanderlytchier/.vim/.ycm_extra_conf.py'
Plugin 'Valloric/YouCompleteMe'
Plugin 'dracula/vim'
Plugin 'jelera/vim-javascript-syntax'
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

call vundle#end()            " required
filetype plugin indent on    " required

" Turn on syntax highlighting
syntax enable

" For plugins to load correctly
filetype plugin indent on

" Remap escape to jk
:imap jk <Esc>

" Space as leader
let mapleader = "\<Space>"

" Fast Saving
nmap <leader>w :w!<cr>

""""""""""""""""""""""""
" VIM user interface
""""""""""""""""""""""""

" Use dracula theme, with fix for iTerm2 gray color background
let g:dracula_italic = 0
colorscheme dracula
highlight Normal ctermbg=None

" Set 7 lines to the cursor when moving vertically, j/k
set so=7

" Set height of command bar
set cmdheight=2

" Configure backspace so it acts as expected
set backspace=eol,start,indent
set whichwrap+=<,>,h,l 

" Hybrid numbers
set number
set relativenumber

" Blink cursor on error instead of beeping (grr)
set visualbell

" Blink cursor on error instead of beeping (grr)
set visualbell

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

""""""""""""""""""""""""
" Text, tab, indents
""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Be smart with tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

""""""""""""""""""""""""
" Moving around, tabs, windows, buffers
""""""""""""""""""""""""

" More natural window split
set splitbelow
set splitright

" Disable higlight when <leader> <cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move as if every line is virtual, to easily move along virtual lines
nnoremap k gk
nnoremap j gj

" Let 'tl' toggle between this and last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/


" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
