source $VIMRUNTIME/vimrc_example.vim

cd C:\Users\adama\vimfiles

"----------SEARCH----------"

" Ignore casing when searching
set ignorecase
set smartcase " ...unless the pattern contains something uppercase

" Highlight search results
set hlsearch

"----------PLUGINS----------"

call plug#begin()
Plug 'bfrg/vim-cpp-modern'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'frazrepo/vim-rainbow'
Plug 'tpope/vim-fugitive'
call plug#end()

"----------MAPPINGS----------"

" Curly bracket indentation mappings without recursion (insert-mode)
inoremap { {}<Left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {{ {
inoremap {} {}

" Quit insert mode with "jk" / "JK"
inoremap jk <ESC>
inoremap JK <ESC>

" Select all with "Ctrl + a"
map <C-a> <ESC>ggVG<CR>

" Compilation of cpp-files
autocmd filetype cpp nnoremap <F7> :w <bar> !g++ -std=c++17 % -o %:r -Wl,--stack,268435456<CR>
autocmd filetype cpp nnoremap <F8> :!%:r<CR>

" Switch between windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Nerdtree
map <F9> :NERDTreeToggle<CR>

" Comment current line in normal-mode
autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

"----------GRAPHICAL----------"

" Gvim stuff
au GUIEnter * simalt ~x

" Set font and size
set gfn=Fixedsys:h14

" Add line numbers
set number

" Show current command-inputs
set showcmd

" Provide some space between cursor and edges
set scrolloff=2
set sidescrolloff=5

" Add relative line numbers in cmd-mode
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

" Highlight en spaces, em spaces, non-breaking spaces and soft hyphens with
" a strong red color.
au BufNewFile,BufReadPost * match ExtraWhitespace /\(\%u2002\|\%u2003\|\%xa0\|\%xad\)/
highlight ExtraWhitespace ctermbg=red guibg=red
highlight clear SignColumn

" Do not use bells on errors
set noerrorbells
set novisualbell

" Smoother redrawing with no downside, apparently.
set ttyfast

" Show current position in file
set ruler

" Disable vim intro 
set shm+=I

" Show matching brackets when the cursor is over one 
set showmatch

"----------EDITOR----------"

" Enable copy pasting
set cb=unnamed

" Enable plugins based on filetype
filetype plugin on
filetype indent on

" Enable syntax highlighting
syntax enable

" Enable mouse
set mouse=a

" Use spaces instead of tabs
set expandtab

" Make tabs be 4 spaces
set shiftwidth=4
set tabstop=2

" Indentation
set autoindent " Use indentation from last line
set smartindent " Automatically add indendation after e.g. { 
set cindent " Use C-indentation

" Namespaces and visibility labels should not increase indentation
set cino=N-sg0

" Use unix line endings by default
set fileformats=unix,dos,mac

" Disable backups and swaps 
set nobackup 
set noswapfile
set nowritebackup

" Persistent undos 
try 
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Highlights the word under the cursor
noremap <silent> & :let @/ = "\\<<c-r><c-w>\\>"<cr>:set hlsearch<cr>

" Increase the edit history 
set history=1000

" Reload files when changed outside
set autoread

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Disable annoying netrwhist history
let g:netrw_dirhistmax = 0

" Insert long template to contest-files [1, 2, 3, ...].cpp
autocmd BufNewFile *.cpp 0r $HOME/vimfiles/Code/contest/library/longtemplate.cpp

"----------WINDOWS STUFF----------"

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
