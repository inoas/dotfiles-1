set nocompatible
syntax on
set laststatus=2
set autoindent
set autowrite
set autoread
set nu
set tabstop=2
set shiftwidth=2
set shiftround
set ttyfast
set lazyredraw
set expandtab
set hlsearch
set incsearch
set encoding=utf-8
set bs=2
set nojoinspaces
filetype plugin on
" set colorcolumn=100

" Stop breaking our darned editor!
" https://www.reddit.com/r/vim/comments/5w2rom/paste_escape_sequences_in_vim_8/
set t_BE=

" Disable Background Color Erase (BCE) so that color schemes work properly
" when Vim is used inside tmux and GNU screen.
" https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling/588243
" if &term =~ '256color'
    set t_ut=
" endif

""" vim-plug (https://github.com/junegunn/vim-plug)
" To install plugins: ':PlugInstall'
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go'
Plug 'vim-scripts/paredit.vim'
Plug 'vim-scripts/VimClojure'
call plug#end()

" 100ms delay (or: let's me hit O and not need to wait around)
set ttimeoutlen=100

let mapleader = "-"
let maplocalleader = "_"

colorscheme badwolf
set background=dark

" Backups
set undofile
set undodir=~/.vim/tmp/undo/
set undolevels=1000
set undoreload=10000
set backupdir=~/.vim/tmp/backup/
set directory=~/.vim/tmp/swap/
set backup
set noswapfile

nnoremap ; :
nnoremap ;; ;
nnoremap <Leader>n :set nu!<CR>
nnoremap <Leader>l :noh<CR>

" who even uses substitute?
nnoremap s <esc>:w<cr>

" jk for escape. none of that system-wide capslock crap.
inoremap jk <esc>
inoremap <esc> <nop>

map <tab> %

" Have */# highlight matches, but not move the cursor.
nnoremap * *<C-o>
nnoremap # #<C-o>

" Format paragraph. I never use register q.
nnoremap qq gqip

" Pipe the output of a command into a new buffer.
nnoremap \| :tabnew \| 0r !

" Write as sudo. (Thanks, Losh!)
cnoremap w!! w !sudo tee % >/dev/null

nnoremap <CR> o<ESC>k

" Buffer navigation shortcuts.
nnoremap <C-k> :bprev<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <Leader>d :bdel<CR>

" Better history scrolling.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Easier splits.
nnoremap <C-w>\| :vsplit<CR>
nnoremap <C-w>- :split<CR>

" vimrc management
nnoremap <Leader>ev :e $MYVIMRC<CR>
nnoremap <Leader>evg :e ${MYVIMRC}_google<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Filetype auto groups ----------------------------------------------------- {{{

" vimscript
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" git-commit
augroup git_commit
  au!
  autocmd FileType gitcommit setlocal textwidth=80
augroup END

" Perform spell checking when composing mail or markdown.
augroup spell_check
  au!
  autocmd FileType mail setlocal textwidth=72

  " Ignore URLs
  autocmd FileType markdown syn match UrlNoSpell "\w\+:\/\/[^[:space:]]\+" contains=@NoSpell
  autocmd FileType mail syn match UrlNoSpell "\w\+:\/\/[^[:space:]]\+" contains=@NoSpell
augroup END

" Markdown.
augroup markdown
  au!
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd FileType markdown setlocal textwidth=80
  "autocmd FileType markdown nnoremap <Leader>v :w !vmd<CR><CR>
  "autocmd FileType markdown colorscheme badwolf

  " quickly turn author/repo into a github markdown link
  autocmd FileType markdown nnoremap <Leader>gh ByWi[<ESC>Ea](https://github.com/<ESC>pi)<ESC>
augroup END

  " turn a npm module name into a link
  :nnoremap <leader>L EByWE:r!npm info <C-R>" homepage<CR>0i(<ESC>A)<ESC>k$Bi[<ESC>Ea]<ESC>Jx$
" vim-task
augroup tasks
  autocmd FileType task nnoremap <silent> <buffer> <cr> :call Toggle_task_status()<CR><CR>
augroup END

" Use Javascript syntax highlighting for JSON.
augroup javascript
  au!
  autocmd BufNewFile,BufRead *.json set ft=javascript
  nnoremap <Leader>S :!standard %<CR>
  nnoremap <Leader>T :!ltape %<CR>

  autocmd BufNewFile,BufRead *.wisp set ft=clojure
  autocmd FileType clojure call PareditInitBuffer()

  autocmd FileType javascript inoremap <leader>cl console.log()<ESC>i
  autocmd FileType javascript inoremap <leader>ce console.error()<ESC>i
  autocmd FileType javascript inoremap <leader>ct console.trace()<ESC>i
  autocmd FileType javascript inoremap <leader>cd console.dir(, {depth:null})<ESC>Bba

  autocmd FileType javascript inoremap <leader>v //------------------------------------------------------------------------------
augroup END

augroup golang
  au!
  autocmd FileType go nnoremap <C-]> :GoDef<CR>
  autocmd FileType go nnoremap <Leader>[ :GoDoc<CR>
augroup END

" }}}
" Gvim options ------------------------------------------------------------- {{{
set guioptions-=r
set guioptions-=m
set guioptions-=T
set guioptions-=L
set guioptions-=B
" }}}
" Folds -------------------------------------------------------------------- {{{

set foldmethod=marker
set foldlevelstart=0

" Space to toggle.
nnoremap <space> zA
vnoremap <space> zA

" Open current fold fully.
nnoremap z0 zcz0

" 'Focus' the current line. (Thanks, Losh!)
nnoremap z<space> zMzA

" }}}
" Formatting aides --------------------------------------------------------- {{{

" Removes comment leaders when joining lines.
set formatoptions+=j

" Highlight trailing whitespace.
hi link localWhitespaceError Error
augroup trailing_whitespace
  au!
  au Syntax * syn match localWhitespaceError /\(zs\%#|\s\)\+$/ display
  au Syntax * syn match localWhitespaceError / \+\ze\t/ display
  " au Syntax * syn match localWhitespaceError /\%>100v.\+/ display
augroup END

" Highlight trailing whitespace.
" XXX: Wait, what? Again?
highlight ExtraWhitespace ctermbg=red guibg=red
augroup trailing_whitespace2
  au!
  au ColorScheme * highlight ExtraWhitespace guibg=red
  au BufEnter * match ExtraWhitespace /\s\+$/
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhiteSpace /\s\+$/
augroup END

" Highlight VCS conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}

nnoremap s <esc>:w<cr>

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

inoremap <leader>N <ESC>:r!date<CR>i<BS><ESC>A

nnoremap ) 10j
nnoremap ( 10k

nnoremap <leader>md :set filetype=markdown<CR>
