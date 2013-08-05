set nocompatible
execute pathogen#infect()

" Jump to line start/end
imap <C-e> <esc>$i<right>
imap <C-w> <esc>^i

" Toggle paste!
set pastetoggle=<F2>

" Taglist
nmap <C-t> :TlistToggle<CR>

" For the stupid iso-8859-2 encoding
set fileencodings=utf-8,iso-8859-2

" Switch tabs
map <C-h> :tabp<CR>
map <C-l> :tabn<CR>

" To get rid of search hilight
nmap <silent> ,/ :nohlsearch<CR>

" I like case-insensitive search :)
nmap / /\c

set backspace=indent,eol,start
set incsearch

" Hilight current search
set hlsearch
set showmatch

" Increase undo and command history levels
set history=1000
set undolevels=1000

" Title of terminal
set title titlelen=120 titlestring="%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)"

" Ignore these
set wildignore=*.swp,*.bak,*.pyc,*.class
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg

" Show me white chars
set listchars=tab:>-,trail:.,extends:>,precedes:<

" Tab suggestionet sidescrolloff=999
set list

" Show me, what I've pressed
set showcmd

" Ensure the visibility of the statusline.
" Required for vim-powerline.
set laststatus=2

" Indentation
set tabstop=4
set shiftwidth=4

" Ensure that indentation for newly inserted text
" copies the style of that used already.
set autoindent

" Same as tabstop, setting this to 2 ensures that
" the tab stop is the same while I'm editing.
set softtabstop=4

" Dont want tabs really
set expandtab

" Clickable menu
set mouse=a

set wildmenu
set background=dark
set nobackup
set noswapfile
set nowritebackup
set number
filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
