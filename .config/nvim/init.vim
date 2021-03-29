call plug#begin(stdpath('config').'/plugged')
Plug 'neoclide/coc.nvim',{'branch':'release'}
Plug 'itchny/lightline.vim'
Plug 'lervag/vimtex'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
call plug#end()


inoremap jk <esc>
colorscheme nord

set number
set relativenumber
set hlsearch
set ignorecase
set incsearch
set autochdir
set lazyredraw
set nojoinspaces
set cursorline

set wrap " Turn word wrapping on
set breakindent " Indent after line wrapped
set linebreak " Only break at certain characters
set breakat -= "/" " Make it so that it doesn't break at /
set breakindentopt=shift:2 " Indent wrapped words by 2
let &showbreak='~~' " Show ~~ at the start of wrapped lines

set backspace=indent,start,eol

hi visual ctermbg=yellow ctermfg=black

if has('virtualedit')
		set virtualedit=block " Allows block visual selection of empty space
endif

set tabstop=3 " Make tabs 3 spaces long
set shiftwidth=3 " when using << or >> move 3 characters

nnoremap / /\v

" Commands to add line before and after current one
nnoremap <leader>o o<Esc>k
nnoremap <leader>O O<Esc>j

" Command to clear search highlighting
 nnoremap <leader>n :noh<Cr>

set scrolloff=3 " keep 3 lines visible below/above cursor
set sidescrolloff=3 " Similarly but horizontally

let NERDTreeShowHidden=1
nmap <leader>f :NERDTreeToggle <CR>

let g:coc_global_extensions = ["coc-snippets","coc-json","coc-vimtex"]

" use tab to cycle between suggested autocompletes
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use <s-tab> to cycle backwards
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <C-s> to expand snippets
imap <C-s> <Plug>(coc-snippets-expand) 
let g:coc_snippet_next = '<C-a>' " Use <C-a> to move to next location in snippet

" Echo current syntax type
command SynID echo synIDattr(synID(line("."), col("."), 1), "name")

" Easier navigation around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


