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
highlight ColorColumn ctermbg=magenta
set colorcolumn=81

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
" map  <C-l> :tabn<CR>
" map  <C-h> :tabp<CR>

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

" Buffer management
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

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

" Show code indentation
Plug 'nathanaelkane/vim-indent-guides'

" Move chunks of code around easier
Plug 'zirrostig/vim-schlepp'

" Tab management
Plug 'kien/tabman.vim'

" List translation
Plug 'soulston/vim-listtrans'

" Fuzzy find plugin that also does buffer management
" Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Code completion
" Plug 'ajh17/VimCompletesMe'
" https://github.com/lifepillar/vim-mucomplete
Plug 'lifepillar/vim-mucomplete'

" Vim-jedi - python completion
Plug 'davidhalter/jedi-vim'

" XCode colour scheme
Plug 'arzg/vim-colors-xcode'

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
" Replaced by fzf's :Buffers - mapped to ctrl-space below

" Airline statusbar config
" ========================
" Show fancy gliphs
let g:airline_powerline_fonts = 1
" Show list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

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

" Fzf setup
" =========
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'


" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Hit ctrl-x ctrl-l and some text to complete a previously typed line
imap <c-x><c-l> <plug>(fzf-complete-line)

" Map finding files to ctrl-p
nnoremap <C-P> :Files<CR>
nnoremap <C-I> :Buffers<CR>
" DFW :( 
" nnoremap <C-Space> :Buffers<CR>

" Autocomplete with mu-complete config
" ------------------------------------
set completeopt+=menuone
" no prompt completion
" set completeopt+=noselect
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

" Sexier commit log coloring
let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

" Map keys for commits and bcommits commands
nnoremap <silent> <Leader>c  :Commits<CR>
nnoremap <silent> <Leader>bc :BCommits<CR>

" And for RG (RipGrep)
nnoremap <Leader>rg :Rg<Space>
nnoremap <Leader>RG :Rg!<Space>

" Someone else's fzf setup
if executable('fzf')
   "FZF {{{
   " <C-p> or <C-t> to search files
   nnoremap <silent> <C-t> :FZF -m<cr>
   nnoremap <silent> <C-p> :FZF -m<cr>

   " <M-S-p> for MRU
   nnoremap <silent> <M-S-p> :History<cr>

   " Use fuzzy completion relative filepaths across directories
   imap <expr> <c-x><c-f> fzf#vim#complete#path('git ls-files $(git rev-parse --show-toplevel)')

   " Better command history with q:
   command! CmdHist call fzf#vim#command_history({'right': '40'})
   nnoremap q: :CmdHist<CR>

   " Better search history
   command! QHist call fzf#vim#search_history({'right': '40'})
   nnoremap q/ :QHist<CR>

   command! -bang -nargs=* Ack call fzf#vim#ag(<q-args>, {'down': '40%', 'options': --no-color'})
   " }}}
else
   " CtrlP fallback
end

" Final Config
" ============
" Set the colorscheme to whatever I feel like
" colo seoul256
" colo gruvbox
colo xcodedarkhc
" colo onedark
