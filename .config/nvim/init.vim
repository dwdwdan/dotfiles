call plug#begin(stdpath('config').'/plugged')
Plug 'neoclide/coc.nvim',{'branch':'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'karb94/neoscroll.nvim'
call plug#end()


inoremap jk <esc>
colorscheme onedark
let g:airline_theme='onedark'
set termguicolors

set number
set relativenumber
set nohlsearch
set ignorecase
set incsearch
set lazyredraw
set nojoinspaces
set cursorline

set list lcs=tab:\|\ "Use | character to show indent levels

" Word Wrapping
set nowrap " Turn word wrapping on
set breakindent " Indent after line wrapped
set linebreak " Only break at certain characters
set breakat -= "/" " Make it so that it doesn't break at /
set breakindentopt=shift:2 " Indent wrapped words by 2
let &showbreak='⮡ ' " Show ⮡ at the start of wrapped lines (Unicode U+2BA1)

nnoremap <silent> <leader>w :set wrap! <CR> " Toggle to turn wrap on and off

set backspace=indent,start,eol

if has('virtualedit')
	set virtualedit=block " Allows block visual selection of empty space
endif

set tabstop=3 " Make tabs 3 spaces long
set shiftwidth=3 " when using << or >> move 3 characters

nnoremap / /\v

" Commands to add line before and after current one
nnoremap <leader>o o<Esc>k
nnoremap <leader>O O<Esc>j


set scrolloff=3 " keep 3 lines visible below/above cursor
set sidescrolloff=3 " Similarly but horizontally

let NERDTreeShowHidden=1
nmap <leader>f :NERDTreeToggle <CR>

let g:coc_global_extensions = ["coc-snippets","coc-json","coc-vimtex"]

" Use tab to trigger completion and navigate
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <C-s> to expand snippets
imap <C-s> <Plug>(coc-snippets-expand)
let g:coc_snippet_next = '<C-a>' " Use <C-a> to move to next location in snippet

" Echo current syntax type
command! SynID echo synIDattr(synID(line("."), col("."), 1), "name")

" Easier navigation around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap j gj
nnoremap k gk

let g:vimtex_compiler_progname='nvr'
let g:vimtex_fold_enabled=1

augroup DWDWDAN
	autocmd!
	autocmd BufWritePre * :%s/\s\+$//e
augroup END
