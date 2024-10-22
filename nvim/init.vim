let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" nvim
Plug 'rcarriga/nvim-notify'
Plug 'sainnhe/gruvbox-material'
Plug 'nvim-lualine/lualine.nvim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'lewis6991/gitsigns.nvim'

" If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons'

" vim
Plug 'tpope/vim-eunuch'
Plug 'yegappan/mru'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'yianwillis/vimcdoc'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'mg979/vim-visual-multi'
Plug 'easymotion/vim-easymotion'
if has('mac')
  Plug 'ybian/smartim'
endif
Plug 'preservim/nerdcommenter'
call plug#end()

lua require('lualine').setup({options = { theme  = 'gruvbox-material' }})
lua require("neo-tree").setup()
lua require('gitsigns').setup()

filetype on
syntax enable
set encoding=utf-8
set number
set relativenumber
set cursorline
set nobackup
set nocompatible
set foldmethod=syntax
set foldlevel=99
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-go', 'coc-vimlsp', 'coc-json', 'coc-yaml']
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 0

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set statusline+=%{get(b:,'gitsigns_status','')}

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

colorscheme gruvbox-material

let g:go_gopls_enabled = 1
let g:go_gopls_options = ['-remote=auto']
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_referrers_mode = 'gopls'

if has('termguicolors') && ($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  " enable true color
  set termguicolors
endif


function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" GoTo code navigation
nmap <silent>K :call ShowDocumentation()<CR>
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <leader>ac <Plug>(coc-codeaction)

nnoremap <leader>nt :Neotree toggle<CR>
nnoremap <leader>nf :Neotree focus<CR>
nnoremap <F5> :UndotreeToggle<CR>
nnoremap <F8> :Vista!!<CR>

let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"]      = '<C-j>'
let g:VM_maps["Add Cursor Up"]        = '<C-k>'

command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=? Format :call CocAction('format', <f-args>)
autocmd BufEnter *.png,*.jpg,*gif,*pdf exec "! imgcat ".expand("%") | :bw
autocmd BufEnter * if winnr('$') == 1 && bufname() == "__vista__" | execute "normal! :q!\<CR>" | endif

let g:smartim_default = 'com.apple.keylayout.ABC'

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undodir
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
endif

if has('mouse')
  if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
    set mouse=a
  else
    set mouse=nvi
  endif
endif

