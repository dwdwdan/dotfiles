call plug#begin(stdpath('config').'/plugged')
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'dracula/vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'wincent/scalpel'
Plug 'preservim/nerdcommenter'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'numkil/ag.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'nvim-treesitter/nvim-treesitter',{'do':':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'hoob3rt/lualine.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'plasticboy/vim-markdown'
Plug 'mhinz/vim-startify'
Plug 'tjdevries/cyclist.vim'
Plug 'hrsh7th/nvim-compe'
Plug 'sirver/ultisnips'
call plug#end()

set termguicolors

" Roll from j to k to leave insert mode
"inoremap jk <esc>
let mapleader=" "


" Allow backspacing beyond the point when entered insert mode
set backspace=indent,start,eol

if has('virtualedit')
	set virtualedit=block " Allows block visual selection of empty space
endif

" Use magic search automatically
nnoremap / /\v
nnoremap ZA <cmd>w<cr>

colorscheme dracula

""""""""""""""""""""""""""""""
"       COMMANDS             "
""""""""""""""""""""""""""""""
" Command to reload init.vim
command! Vimrc so ~/.config/nvim/init.vim

" Echo current syntax type
command! SynID echo synIDattr(synID(line("."), col("."), 1), "name")


"""""""""""""""""""""""""""""
"         AIRLINE           "
"""""""""""""""""""""""""""""
let g:airline_theme='dracula'
let g:airline_powerline_fonts=1


"""""""""""""""""""""""""""""
"         LUALINE           "
"""""""""""""""""""""""""""""
lua require('lualineConfig')

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
set cursorline " Highlight the line the cursor is on

set tabstop=3 " Make tabs 3 spaces long
set shiftwidth=3 " when using << or >> move 3 characters

set scrolloff=3 " keep 3 lines visible below/above cursor
set sidescrolloff=3 " Similarly but horizontally
set signcolumn=yes
set mouse=a

set inccommand=split

" Use | character to show indent levels
set list lcs=tab:\|\ "


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
"let g:coc_global_extensions = ["coc-snippets","coc-json","coc-vimtex","coc-git","coc-explorer"]

"" Use tab to trigger completion and navigate
"inoremap <silent><expr> <TAB>
	"\ pumvisible() ? "\<C-n>" :
	"\ <SID>check_back_space() ? "\<TAB>" :
	"\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
	"let col = col('.') - 1
	"return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

""coc-snippets
	"" Use <C-d> to expand snippets
	"imap <C-d> <Plug>(coc-snippets-expand)
	"let g:coc_snippet_next = '<C-f>' " Use <C-f> to move to next location in snippet

""coc-explorer
	"nnoremap <leader>t :CocCommand explorer<CR>


""""""""""""""""""""""""""""""
"         COMPE              "
""""""""""""""""""""""""""""""
set completeopt=menuone,noselect
lua require('compeConfig')
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')


""""""""""""""""""""""""""""""
"         ULTISNIPS          "
""""""""""""""""""""""""""""""
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-s>"
let g:UltiSnipsJumpBackwardTrigger="<c-d>"


""""""""""""""""""""""""""""""
"         VIMTEX             "
""""""""""""""""""""""""""""""
let g:vimtex_compiler_progname='nvr'
let g:vimtex_fold_enabled=1
let g:vimtex_indent_on_ampersands=0
let g:vimtex_view_general_viewer='zathura'


""""""""""""""""""""""""""""""
"         TELESCOPE          "
""""""""""""""""""""""""""""""
nnoremap <C-p> <cmd>Telescope git_files<CR>
nnoremap g<C-p> <cmd>Telescope find_files hidden=true<CR>
nnoremap <A-p> <cmd>Telescope live_grep<CR>
nnoremap <leader>gb <cmd>Telescope git_branches<CR>
nnoremap <leader>gc <cmd>Telescope git_commits<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
lua require('telescopeConfig')

command! Gissues Telescope gh issues
command! GPR Telescope gh pull_request


""""""""""""""""""""""""""""""
"       Tree Sitter          "
""""""""""""""""""""""""""""""
lua require('treesitter')


""""""""""""""""""""""""""""""
"           Colorizer        "
""""""""""""""""""""""""""""""
lua require('colorizer').setup()


""""""""""""""""""""""""""""""
"           TODO             "
""""""""""""""""""""""""""""""
lua require('todoConfig')
nnoremap <c-t> <cmd>TodoTelescope<cr>
nnoremap <c-T> <cmd>TodoTrouble<cr>


""""""""""""""""""""""""""""""
"           Trouble          "
""""""""""""""""""""""""""""""
lua require('troubleConfig')


""""""""""""""""""""""""""""""
"           Org-Mode         "
""""""""""""""""""""""""""""""
lua require('orgConfig')


""""""""""""""""""""""""""""""
"          neoscroll         "
""""""""""""""""""""""""""""""
lua require('neoscroll').setup()


""""""""""""""""""""""""""""""
"          markdown          "
""""""""""""""""""""""""""""""
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1


""""""""""""""""""""""""""""""
"       AUTOCMDS             "
""""""""""""""""""""""""""""""
augroup DWDWDAN
	autocmd!
	autocmd BufWritePre * :%s/\s\+$//e " Clears white space at end of lign on save
	autocmd InsertEnter * :norm zz " centre cursor when enter insert mode
augroup END
