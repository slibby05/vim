set nocp

filetype indent plugin on

syntax on

" better tab completion?
set wildmenu

" hilight searches
set hlsearch

" ignore case when searching
"set ignorecase
" don't ignore case if an uppercase letter is used
"set smartcase

" autoindent
set autoindent
set smartindent

" stop actions from moving the cursor to the start of the line
set nostartofline

" line numbers
set number

set shiftwidth=4
set softtabstop=4
set expandtab

" Map Y to act like D and C, i.e.
" to yank until EOL, rather than act as yy,
" which is the default
map Y y$

"use system clipboard
set clipboard+=unnamedplus

" automaticall open init.vim
nmap <leader>v :tabnew ~/.config/nvim/init.vim<CR>

" get out of terminal mode
:tnoremap <Esc> <C-\><C-n>

colo contrast

"set filetype
au BufNewFile,BufRead *.curry set filetype=curry


au BufNewFile,BufRead *.tex nmap <leader>c :!latexmk -pdf<CR>:!latexmk -c<CR>
au BufNewFile,BufRead *.tex nmap <leader>r :!chromium-browser %:r.pdf &<CR>

au BufNewFile,BufRead *.curry nmap <leader>r :term pakcs :l %<CR>
au BufNewFile,BufRead *.hs nmap <leader>r :term ghci %<CR>
au BufNewFile,BufRead *.lhs nmap <leader>r :term ghci %<CR>
au BufNewFile,BufRead *.py nmap <leader>r :term python3 -i %<CR>
au BufNewFile,BufRead *.rb nmap <leader>r :term ruby %<CR>
