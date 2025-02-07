call plug#begin(stdpath('config').'/plugged')
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'dracula/vim'
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
Plug 'nvim-lua/completion-nvim'
Plug 'sirver/ultisnips'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/completion-treesitter'
Plug 'albertoCaroM/completion-tmux'
Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'
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
" Make Y behave similarly to C and D
nnoremap Y y$

"Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Centre on search
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z


" Add to jump list if do relative motion over size
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : ""). 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : ""). 'j'

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

colorscheme dracula
highlight CursorLineNr guibg=#44475a
highlight CursorLine guibg=#282a36


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
"         COMPE              "
""""""""""""""""""""""""""""""
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_chain_complete_list = [{'complete_items': ['lsp', 'snippet', 'ts', 'tmux']}]
let g:completion_enable_auto_hover = 1
imap <silent> <C-tab> <Plug>(completion_trigger)

""""""""""""""""""""""""""""""
"         ULTISNIPS          "
""""""""""""""""""""""""""""""
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger="<nop>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"


""""""""""""""""""""""""""""""
"         NERDTREE           "
""""""""""""""""""""""""""""""
nnoremap <leader>t <cmd>NERDTreeToggle<cr>


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
"          LSP               "
""""""""""""""""""""""""""""""
lua require("lspConfig")


""""""""""""""""""""""""""""""
"          neogit            "
""""""""""""""""""""""""""""""
nnoremap <leader>gg <cmd>Neogit<cr>
lua << EOF
require("neogit").setup {
	disable_signs = false,
	disable_context_highlighting = false,
	disable_commit_confirmation = false,
	-- customize displayed signs
	signs = {
		-- { CLOSED, OPENED }
		section = { ">", "v" },
		item = { ">", "v" },
		hunk = { "", "" },
		},
	integrations = {
		diffview = true
		},
	}
EOF


""""""""""""""""""""""""""""""
"          diffview          "
""""""""""""""""""""""""""""""
lua << EOF
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
	diff_binaries = false,    -- Show diffs for binaries
	file_panel = {
		width = 35,
		use_icons = true        -- Requires nvim-web-devicons
		},
	key_bindings = {
		disable_defaults = false,                   -- Disable the default key bindings
		-- The `view` bindings are active in the diff buffers, only when the current
		-- tabpage is a Diffview.
		view = {
			["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file
			["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
			["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
			["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
			},
		file_panel = {
			["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
			["<down>"]        = cb("next_entry"),
			["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
			["<up>"]          = cb("prev_entry"),
			["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
			["o"]             = cb("select_entry"),
			["<2-LeftMouse>"] = cb("select_entry"),
			["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
			["S"]             = cb("stage_all"),          -- Stage all entries.
			["U"]             = cb("unstage_all"),        -- Unstage all entries.
			["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
			["<tab>"]         = cb("select_next_entry"),
			["<s-tab>"]       = cb("select_prev_entry"),
			["<leader>e"]     = cb("focus_files"),
			["<leader>b"]     = cb("toggle_files"),
			["q"]             = ":DiffviewClose",
			}
		}
	}
EOF


""""""""""""""""""""""""""""""
"       AUTOCMDS             "
""""""""""""""""""""""""""""""
augroup DWDWDAN
	autocmd!
	autocmd BufWritePre * :%s/\s\+$//e " Clears white space at end of lign on save
	autocmd InsertEnter * :norm zz " centre cursor when enter insert mode
	autocmd VimEnter * :GitGutterEnable "Enable git gutter by default
	autocmd BufEnter * :lua require'completion'.on_attach()
augroup END
