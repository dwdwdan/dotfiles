call plug#begin(stdpath('config').'/plugged')
Plug 'neoclide/coc.nvim',{'branch':'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'junegunn/fzf', {'do':{-> fzf#install() } } | Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'wincent/scalpel'
Plug 'preservim/nerdcommenter'
Plug 'thaerkh/vim-workspace'
call plug#end()

set termguicolors

" Roll from j to k to leave insert mode
inoremap jk <esc>
let mapleader=" "

" make it so that j and k move by visual lines rather than active lines
nnoremap j gj
nnoremap k gk

" Allow backspacing beyond the point when entered insert mode
set backspace=indent,start,eol

if has('virtualedit')
	set virtualedit=block " Allows block visual selection of empty space
endif

" Use magic search automatically
nnoremap / /\v

" Commands to add line before and after current one
nnoremap <leader>o o<Esc>k
nnoremap <leader>O O<Esc>j

""""""""""""""""""""""""""""""
"       COMMANDS             "
""""""""""""""""""""""""""""""
" Command to reload init.vim
command! Vimrc so ~/.config/nvim/init.vim

" Echo current syntax type
command! SynID echo synIDattr(synID(line("."), col("."), 1), "name")

""""""""""""""""""""""""""""""
"       MOVEMENT             "
""""""""""""""""""""""""""""""
" Easier navigation around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


"""""""""""""""""""""""""""""
"         GRUVBOX           "
"""""""""""""""""""""""""""""
let g:gruvbox_italic='1'
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_vert_split='bg3'
colorscheme gruvbox


"""""""""""""""""""""""""""""
"         AIRLINE           "
"""""""""""""""""""""""""""""
let g:airline_theme='base16_gruvbox_dark_hard'
let g:airline_powerline_fonts=1


""""""""""""""""""""""""""""""
"          SETS              "
""""""""""""""""""""""""""""""
set number
set relativenumber
set nohlsearch " Don't highlight search results
set ignorecase " By default, ignore case on searches
set incsearch " Show results as typed, rather than waiting for <CR>
set lazyredraw " Don't redraw screen while executing macros, increases speed
set nojoinspaces " Don't insert 2 spaces when joining lines after punctuation
set cursorline " Highlight the lighn the cursor is on

set tabstop=3 " Make tabs 3 spaces long
set shiftwidth=3 " when using << or >> move 3 characters

set scrolloff=3 " keep 3 lines visible below/above cursor
set sidescrolloff=3 " Similarly but horizontally
set signcolumn=yes

" Use | character to show indent levels
set list lcs=tab:\|\ "


""""""""""""""""""""""""""""""
"       COLORCOLUMN          "
""""""""""""""""""""""""""""""
let &colorcolumn=join(range(120,999),",")
hi colorcolumn guibg=black


""""""""""""""""""""""""""""""
"       WRAPPING             "
""""""""""""""""""""""""""""""
set nowrap " Turn word wrapping on
set breakindent " Indent after line wrapped
set linebreak " Only break at certain characters
set breakat -= "/" " Make it so that it doesn't break at /
set breakindentopt=shift:2 " Indent wrapped words by 2
let &showbreak='⮡ ' " Show ⮡ at the start of wrapped lines (Unicode U+2BA1)
" Toggle to turn wrap on and off
nnoremap <silent> <leader>w :set wrap! <CR>


""""""""""""""""""""""""""""""
"       COC.NVIM             "
""""""""""""""""""""""""""""""
let g:coc_global_extensions = ["coc-snippets","coc-json","coc-vimtex","coc-git","coc-explorer"]

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

"coc-snippets
	" Use <C-d> to expand snippets
	imap <C-d> <Plug>(coc-snippets-expand)
	let g:coc_snippet_next = '<C-f>' " Use <C-f> to move to next location in snippet

"coc-explorer
	nnoremap <leader>t :CocCommand explorer<CR>

""""""""""""""""""""""""""""""
"         VIMTEX             "
""""""""""""""""""""""""""""""
let g:vimtex_compiler_progname='nvr'
let g:vimtex_fold_enabled=1
let g:vimtex_indent_on_ampersands=0


""""""""""""""""""""""""""""""
"            FZF             "
""""""""""""""""""""""""""""""
" Use <C-p> to find a file in the project using fzf
nnoremap <C-p> :Files<CR>
" Use P to find text in the current file
nnoremap <leader>p :Rg<CR>
let $FZF_DEFAULT_COMMAND="find . -not -path \"*/.git/*\"" " Include dotfiles but not any files inside a .git folder

" Command to easily find TODO's in project
command! TODO Rg TODO


""""""""""""""""""""""""""""""
"       EASYALIGN            "
""""""""""""""""""""""""""""""
" use ga to use EasyAlign plugin
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


""""""""""""""""""""""""""""""
"       VIM-WORKSPACE        "
""""""""""""""""""""""""""""""
let g:workspace_session_directory = $HOME . '/.vimfiles/sessions/'
let g:workspace_undodir = $HOME . '/.vimfiles/undofiles/'
nnoremap <leader>s :ToggleWorkspace<CR>


""""""""""""""""""""""""""""""
"       AUTOCMDS             "
""""""""""""""""""""""""""""""
augroup DWDWDAN
	autocmd!
	autocmd BufWritePre * :%s/\s\+$//e " Clears white space at end of lign on save
augroup END
