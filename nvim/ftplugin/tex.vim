map <buffer> K <Plug>(vimtex-doc-package)
set wrap

" Use <leader>& to align by &s
"
" If in a visual selection, use that
xmap <leader>& ga*&
" Use if in normal mode, assume we want inside the environment
nmap <leader>& viega*&
