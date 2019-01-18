
" INTERFACE
" =========

" Show line numbers
set number
set numberwidth=3

" Set lines wrap
set wrap

" Highlight matching brace
set showmatch

" Always case-insensitive
set ignorecase

" Enable smart-indent
set cindent

" Enable smart-tab
set smarttab

" Number of spaces per tab
set tabstop=2
set softtabstop=2

" Number of auto-indent spaces
set shiftwidth=2

" Use spaces instead of tabs
set expandtab

" Searches for strings incrementally
set incsearch

" Highlight all search results (:noh for stop)
set hlsearch

" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Highlight position of cursor
" set cursorline

" Use visual bell (no beeping)
set visualbell

" Always show status line
" set laststatus=2

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title


" BEHAVIOR
" ========

" Enable syntax highlighting
syntax on

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*,.meteor

" Enable in all modes
set mouse=vic

" Disable error bells
set noerrorbells

" I want new splits to appear to the right and to the bottom of the current
set splitbelow
set splitright

" Vertical split when using diffsplit (show diffs side by side)
set diffopt+=vertical


" COMMANDS
" ========

" Clear highlighted search
noremap <leader><space> :set hlsearch! hlsearch?<cr>

" noremap <SPACE> <C-F>
" map <F2> :bprev<CR>
" map <F2> a<C-R>=strftime("%c")<CR><Esc>
" map <F3> :bnext<CR>
map <F5> :source ~/.vimrc


" COLORSCHEME
" ===========

colorscheme slate


" OTHER SETTINGS
" ==============

" Add automatic header for python files when starting from vim
if has("autocmd")
augroup content
autocmd BufNewFile *.py
   \ 0put = '#!/usr/bin/env python3'  |
   \ norm gg19jf]
augroup END
endif


" Return to last edit position when opening files
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Run python script from vim
com Py ! python %
