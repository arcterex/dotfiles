" Alan's vim config with comments
" -------------------------------
set nocompatible              " Use all the vim stuff, not vi
filetype off                  " Seems to be needed for plugin managers

" Default look
" ------------
" color default
set bg=dark
syn on
" color desert 			      " Default color scheme (will probably need to change this)

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Misc UI
" -------
set nonumber			         " line numbers off by default
set nowrap			            " don't wrap lines
set ruler 			            " show line,char in the status
set laststatus=2		         " show the statusbar all the time
set showcmd 			         " Show (partial) command in the status line
set visualbell                " don't beep
set noerrorbells              " don't beep
set modeline
set modelines=10 		         " Check for the // vim: entries at the bottom of a file (within 10 lines of top or bottom)
set hidden                    " something about buffers.  <shrug>
" set title titlestring=        " required for the read only autoswap plugin

" Search settings
" ---------------
set noincsearch			      " don't do the weird incremental search thing
set hlsearch			         " highlight search results
set ignorecase 			      " ignore the case when searching
set smartcase			         " ... but if you search for something with capitals search for that

" Indent setting preferences
" --------------------------
set smartindent			      " does smart things with spaces instead of tabs I think
set autoindent			         " automatically keep indentation
set sw=3
set ts=3			               " tabs and shifting text left/right by 3
set sts=3			            " softtabstop - I think so that backspace on spaces doesn't delete lots
set expandtab			         " convert tabs to spaces
set backspace=indent,eol,start 	" allow backspacing over indentation

" Whitespace setup
" ----------------
" when you do "show list" what shows up
set showbreak=↪\ 
set listchars=tab:→\ ,eol:↲,trail:•,extends:›,precedes:‹,nbsp:·,trail:·,eol:↲

" From https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif



" Tab completion
" --------------
set wildmenu
set wildmode=list:longest,list:full

" We don't care about autocomplete for these file types
set wildignore+=*.rbc,*.class,vendor/gems/*
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

" Syntax extras
" -------------
au BufNewFile,BufRead *.json set ft=javascript	" add json syntax highlighting

" Filetype stuff
" --------------
" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Create the directory if it doesn't exist
silent !mkdir -p ~/.vim/backup > /dev/null 2>&1

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Force Saving Files that Require Root Permission
cmap w!! %!sudo tee > /dev/null %

" Misc coding stuff for development
" ---------------------------------

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim    " % to bounce from do to end etc.
endif
set formatprg=par		" Use par (must be installed) for auto formatting of text (not code)
set omnifunc=syntaxcomplete#Complete	" syntax completion

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Highlight when a line goes over 81 characters
" Doesn't seem to work
" highlight ColorColumn ctermbg=magenta
" set colorcolumn=81

" Leader and key remapping
" Not 100% sure about a bunch of this stuff, but lets try anyway
" ------------------------
let mapleader = ","



" Search Improvements
" ===================
" EITHER blink the line containing the match...
function! HLNext (blinktime)
    set invcursorline
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    set invcursorline
    redraw
endfunction

" " OR ELSE just highlight the match in red...
" function! HLNext (blinktime)
"     let [bufnum, lnum, col, off] = getpos('.')
"     let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"     let target_pat = '\c\%#\%('.@/.'\)'
"     let ring = matchadd('WhiteOnRed', target_pat, 101)
"     redraw
"     exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"     call matchdelete(ring)
"     redraw
" endfunction

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

" Window Management
" -----------------
" switch quickly from window to window and maximize the window with ^j and ^k
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_ 

" Next and previous tab shortcut to ctrl-l/h
map  <C-l> :tabn<CR>
map  <C-h> :tabp<CR>

" Toggle line number mode to ctrl-i
" Tab for some reason changes this
" function! g:ToggleNuMode()
" 	if(&rnu == 1)
" 		set nornu
" 	else
" 		set rnu
" 	endif
" endfunc
" nnoremap <C-I> :call g:ToggleNuMode()<cr>

"Simple Window management - http://www.agillo.net/simple-vim-window-management/
" <leader>hjkl = move to the window up down left right *or* open one if there's nott one there already
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr()) "we havent moved
    if (match(a:key,'[jk]')) "were we going up/down
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

map <leader>h              :call WinMove('h')<cr>
map <leader>k              :call WinMove('k')<cr>
map <leader>l              :call WinMove('l')<cr>
map <leader>j              :call WinMove('j')<cr>

map <leader>wc :wincmd q<cr>
map <leader>wr <C-W>r

map <leader>H              :wincmd H<cr>
map <leader>K              :wincmd K<cr>
map <leader>L              :wincmd L<cr>
map <leader>J              :wincmd J<cr>

" Close the window
map <leader>wc :wincmd q<cr>  
" Rotate windows
map <leader>wr <C-W>r

" Move windows with capitals
map <leader>H              :wincmd H<cr>
map <leader>K              :wincmd K<cr>
map <leader>L              :wincmd L<cr>
map <leader>J              :wincmd J<cr>

" Keep selection when shifting 
vnoremap < <gv 
vnoremap > >gv 

" Writing stuff
" =============
" Listtranslate stuffnmap  

nmap ;l   :call ListTrans_toggle_format()<CR>
vmap ;l   :call ListTrans_toggle_format('visual')<CR>

" PLUGINS!
" Lets add some plugins bitches
" -----------------------------

" Plugins needed to look at I think
" Plug 'tpope/vim-sensible'
" https://github.com/vim-scripts/LustyJuggler
" Minibuf explorer

"  First auto-install vim-plug if it's not there already
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Alignment on = or => etc
Plug 'junegunn/vim-easy-align'

" Error checking / syntax checking
Plug 'vim-syntastic/syntastic'

" Color schemes
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'

" Statusline stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Required for airline to show git status
Plug 'tpope/vim-fugitive'

" Open buffer / open file search
Plug 'vim-ctrlspace/vim-ctrlspace'

" Show code indentation
Plug 'nathanaelkane/vim-indent-guides'

" Move chunks of code around easier
Plug 'zirrostig/vim-schlepp'

" Tab management
Plug 'kien/tabman.vim'

" List translation
Plug 'soulston/vim-listtrans'

" Initialize plugin system
call plug#end()

" --------------------------------------------------------------

" Plugin specific mappings
" ------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Syntastic setup
let g:syntastic_mode_map = { 'mode': 'passive' }   " Disable by default
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" CTRL-Space config
if has('win32')
    let s:vimfiles = '~/vimfiles'
    let s:os   = 'windows'
else
    let s:vimfiles = '~/.vim'
    if has('mac') || has('gui_macvim')
        let s:os = 'darwin'
    else
    " elseif has('gui_gtk2') || has('gui_gtk3')
        let s:os = 'linux'
    endif
endif

let g:CtrlSpaceFileEngine = s:vimfiles . '/plugged/vim-ctrlspace' . '/bin/file_engine_' . s:os . '_amd64'

" Airline statusbar config
let g:airline_powerline_fonts = 1

" Indent plugin
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" vim-schlepp setup - just use arrow keys to move things around
" Kinda fucking awesome :) 
vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight
vmap <unique> D <Plug>SchleppDup

" TabMan management
let g:tabman_toggle = '<leader>mt'
let g:tabman_focus  = '<leader>mf'
let g:tabman_width = 25
let g:tabman_side = 'left'
let g:tabman_specials = 0


" Set the colorscheme to whatever I feel like
" colo seoul256
colo gruvbox
" colo onedark
