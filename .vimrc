set nocompatible              " be iMproved, required
filetype off                  " required
set encoding=utf-8

"" Plugins {{{1
" Use vim.plug to manage plugins
call plug#begin('~/.vim/plugged') " required

" Vim enhancement
Plug 'vim-scripts/IndexedSearch'
Plug 'andymass/vim-matchup'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'itchyny/vim-cursorword'
Plug 'flazz/vim-colorschemes'
Plug 'bling/vim-bufferline'
Plug 'kshenoy/vim-signature'
Plug 'elsdrium/vim-sleuth'

silent! Plug 'vim-scripts/YankRing.vim'
Plug 't9md/vim-choosewin'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/tabman.vim'
Plug 'vim-airline/vim-airline-themes' | Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'osyo-manga/vim-over'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Development
"Plug 'elsdrium/Conque-Shell'
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }
Plug 'matze/vim-move'
Plug 'godlygeek/tabular', { 'on': 'Tab' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'jistr/vim-nerdtree-tabs' | Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind'] }
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
"Plug 'jeaye/color_coded', { 'do': 'cmake . && make && make install', 'for': ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'junegunn/vim-easy-align'
Plug 'christoomey/vim-tmux-navigator'

if v:version > 704 || (v:version == 704 && has('patch1578'))
  Plug 'elsdrium/YouCompleteMe', { 'do': './install.py --clang-completer', 'for': 'cpp' }
endif

if v:version >= 800
  Plug 'w0rp/ale', { 'on': 'ALEEnable' }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  Plug 'ludovicchabant/vim-gutentags'
  if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
else
  Plug 'Shougo/neocomplete.vim'
endif

" Git
Plug 'tpope/vim-fugitive'

" Python
"Plug 'elsdrium/vim-debug'  " It's awesome, but shortcut keys conflict to other plugins
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" Markdown
Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
"Plug 'suan/vim-instant-markdown', { 'do': 'npm -g install instant-markdown-d', 'for': 'markdown' }

" Javascript
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" Elixir
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }

" Scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

" LaTeX
"Plug 'LaTeX-Box-Team/LaTeX-Box'
"Plug 'gerw/vim-latex-suite'
"Plug 'xuhdev/vim-latex-live-preview'

call plug#end() " required
" }}}

"" Plugins' Settings
""" YankRing.vim {{{1
nnoremap <silent> ,y :YRShow<CR>
let g:yankring_history_dir = '~/.vim/dirs/'
" Useless, just for avoiding conflicts
let g:yankring_replace_n_nkey = '<m-f>'
let g:yankring_replace_n_pkey = '<m-r>'

""" vim-choosewin {{{1
nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1

""" auto-pairs {{{1
" let g:AutoPairsFlyMode = 1

""" tabman.vim {{{1
" mappings to toggle display, and to focus on it
let g:tabman_toggle = 'tm'
let g:tabman_focus  = 'tf'

""" vim-airline {{{1
let g:airline_powerline_fonts = 0
let g:airline_theme = 'kalisi'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#gutentags#enabled = 1

""" vim-easymotion {{{1
let g:EasyMotion_leader_key = '\'
nmap <Leader>v <Plug>(easymotion-bd-w)

""" fzf.vim {{{1
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
" Quickfix window for quick navigation
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" This is the default extra key bindings
let g:fzf_action = {
      \ 'ctrl-t': function('s:build_quickfix_list')
      \ }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In neovim, set up fzf window using a Vim command
if has('nvim')
  let g:fzf_layout = { 'window': 'enew' }
  let g:fzf_layout = { 'window': '-tabnew' }
  let g:fzf_layout = { 'window': '10split enew' }
end

" Customize fzf colors to match your color scheme
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
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

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.vim/dirs/fzf-history'
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" [Commands] --expect expression for directly executing the command
"let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Mapping selecting mappings
nmap <Leader><TAB> <plug>(fzf-maps-n)
xmap <Leader><TAB> <plug>(fzf-maps-x)
omap <Leader><TAB> <plug>(fzf-maps-o)

" commands shortcut
nnoremap ,b :Buffers<CR>
nnoremap ,c :Commits<CR>
nnoremap ,f :Files<CR>
nnoremap ,g :Tags<CR>
nnoremap ,h :History:<CR>
nnoremap ,H :History/<CR>
nnoremap ,l :BLines<CR>
nnoremap ,L :Lines<CR>
nnoremap ,s :Snippets<CR>
nnoremap ,w :Windows<CR>

command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)

""" vim-over {{{1
let g:over#command_line#search#enable_move_cursor = 1
nnoremap ,r :OverCommandLine<CR>%s/

""" undotree {{{1
nnoremap U :UndotreeToggle<CR>

""" vim-rooter {{{1
let g:rooter_patterns = ['.project_root', '.git/']
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1

""" vim-move {{{1
let g:move_map_keys = 0
vmap <C-p> <Plug>MoveBlockUp
vmap <C-n> <Plug>MoveBlockDown

""" tabular {{{1
let mapleader=','
if exists(':Tabularize')
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> ,tb <Bar><Esc>:call <SID>align()<CR>a 
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

""" tagbar {{{1
" toggle tagbar display
nmap <silent> tb :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1
let tagbar_map_closefold = ['zc']
let tagbar_map_openfold = ['zo']

let g:tagbar_type_typescript = {
      \ 'ctagstype': 'typescript',
      \ 'kinds': [
      \ 'c:classes',
      \ 'n:modules',
      \ 'f:functions',
      \ 'v:variables',
      \ 'v:varlambdas',
      \ 'm:members',
      \ 'i:interfaces',
      \ 'e:enums',
      \ ]
      \ }

let g:tagbar_type_elixir = {
      \ 'ctagstype' : 'elixir',
      \ 'kinds' : [
      \ 'f:functions',
      \ 'functions:functions',
      \ 'c:callbacks',
      \ 'd:delegates',
      \ 'e:exceptions',
      \ 'i:implementations',
      \ 'a:macros',
      \ 'o:operators',
      \ 'm:modules',
      \ 'p:protocols',
      \ 'r:records',
      \ 't:tests'
      \ ]
      \ }

""" vim-nerdtree-tabs / nerdtree {{{1
function! NERDTreeFindToggle()
  if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
    NERDTreeTabsClose
  else
    NERDTreeFind
    " if not found
    if !exists('t:NERDTreeBufName') || bufwinnr(t:NERDTreeBufName) == -1
      NERDTree
    endif
  endif
endfunction
" toggle nerdtree tab with the current file selected
nmap <silent> ,t :call NERDTreeFindToggle()<CR>
" don;t show these file types
"let NERDTreeIgnore = ['\.pyc$', '\.pyo$']
let NERDTreeShowHidden = 1
let NERDTreeDirArrows = 1
let NERDTreeMouseMode = 2

""" NERDCommenter {{{1
let g:NERDSpaceDelims = 1

""" indentLine {{{1
let g:indentLine_color_term = 239

""" vim-easy-align {{{1
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""" vim-tmux-navigator {{{1
let g:tmux_navigator_disable_when_zoomed = 1

""" YouCompleteMe {{{1
"check syntax with other plugins instead
let g:ycm_show_diagnostics_ui = 0

let g:ycm_auto_trigger = 1
let g:ycm_global_ycm_extra_conf = '~/.unix_settings/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_cache_omnifunc = 1
let g:ycm_disable_for_files_larger_than_kb = 50000
let g:ycm_key_list_select_completion = ['<TAB>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<C-k>']
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1,
      \ 'mundo': 1,
      \ 'fzf': 1,
      \ 'ctrlp' : 1
      \}

" Go to Definition variable
nnoremap <Leader>gd :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

""" ale {{{1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_open_list = 0
let g:ale_fixers = {
      \   'c': ['clang'],
      \   'cpp': ['clang'],
      \   'python': ['flake8'],
      \   'javascript': ['eslint'],
      \}
let g:ale_cpp_clang_options = '-std=c++14 -Wall'

""" deoplete.nvim {{{1
let g:deoplete#enable_at_startup = 1
augroup MyDeoplete
  autocmd!
  autocmd CompleteDone * silent! pclose!
augroup END

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

""" UltiSnips {{{1
let g:UltiSnipsExpandTrigger='<Leader><TAB>'
let g:UltiSnipsJumpForwardTrigger='<C-g>'
let g:UltiSnipsJumpBackwardTrigger='<C-t>'
let g:UltiSnipsListSnippets=',ls'

""" vim-gutentags {{{1
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'
nnoremap gu :GutentagsUpdate<CR>
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_ctags_executable = 'ctags'
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_project_root = ['.project_root']
let g:gutentags_resolve_symlinks = 1
let gutentags_define_advanced_commands = 1

let g:gutentags_modules = []
if executable('ctags')
  let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
  let g:gutentags_modules += ['gtags_cscope']
  " Use gtags-cscope instead of classic cscope, if possible
  silent! set cscopeprg=gtags-cscope
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--c++-kinds=+px', '--c-kinds=+px']
" for universal ctags
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

""" vim-fugitive {{{1
nnoremap <silent> gb :Gblame<CR>
" diff with HEAD (overrided default behavior for starting select mode)
nnoremap gh :Gdiff HEAD

""" jedi-vim {{{1
"let g:jedi#force_py_version = 3
let g:jedi#completions_command = '<TAB>'
let g:jedi#show_call_signatures = 1
let g:jedi#show_call_signatures_delay = 50
if has('python3')
  let g:jedi#force_py_version = 3
endif

""" vim-instant-markdown {{{1
let g:instant_markdown_autostart = 0
let g:instant_markdown_allow_unsafe_content = 1

""" tern_for_vim {{{1
let g:tern#is_show_argument_hints_enabled = 1
nnoremap <silent> td :TernDoc<CR>

""" typescript-vim {{{1
let g:typescript_indent_disable = 1

""" alchemist.vim
let g:alchemist_tag_disable = 1

" End of plugins' settings -------------------------- }}}

"" Enviroment Settings
" tabs and spaces {{{1
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" indicate tab characters and trailing spaces
set list lcs=tab:\|\ ,trail:\|

" filetype-specific settings {{{1
augroup FileTypeStuff
  autocmd!
  autocmd FileType markdown nnoremap <C-m> :InstantMarkdownPreview<CR>
  autocmd FileType nerdtree setlocal nolist
  autocmd FileType nerdtree highlight Directory ctermfg=darkred
  autocmd FileType gitcommit let g:gutentags_enabled = 0
  autocmd FileType gitrebase let g:gutentags_enabled = 0

  " file types with tab length exceptions
  autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

" cscope settings
if has("cscope")
  set csverb
  " Use quickfix window to show cscope results
  " no 'g-' here for preventing disable tag stack
  set cscopequickfix=s-,c-,d-,i-,t-,e-
  " Use both cscope and ctag
  set cscopetag
  " Use tags for definition search first
  set cscopetagorder=1
  " Use absolute path
  set nocsre

  function! CscopeQueryQF(qtype)
    if &ft == 'qf'
      cclose
      return
    endif
    call setqflist([])
    let wview = winsaveview()
    let fname = @%
    exe "normal! mY"
    silent! keepjumps exe "cs find " . a:qtype . " " . expand("<cword>")
    if fname != @%
      exe "normal! `Y"
      bd #
    endif
    call winrestview(wview)
    botright cw
  endfunction

  nnoremap ;s :call CscopeQueryQF("s")<CR>
  nnoremap ;g :call CscopeQueryQF("g")<CR>
  nnoremap ;c :call CscopeQueryQF("c")<CR>
  nnoremap ;d :call CscopeQueryQF("d")<CR>
endif

" todo / fixme list {{{1
command! TODOList noautocmd silent! vimgrep /TODO\|FIXME/j % | cw
function! ToggleTODOList()
  let old_last_winnr = winnr('$')
  cclose
  if old_last_winnr == winnr('$')
    " Nothing was closed, open syntastic error location panel
    TODOList
  endif
endfunction
nmap <silent> tt :call ToggleTODOList()<CR>

" toggle list of errors and warnings on the current file
function! ToggleErrors()
  let old_last_winnr = winnr('$')
  let g:ale_open_list = 0
  lclose
  if old_last_winnr == winnr('$')
    " Nothing was closed, open syntastic/ale error location panel
    if exists(":Errors")
      Errors
    else
      let g:ale_open_list = 1
      let g:ale_keep_list_window_open = 1
      lw
    endif
  endif
endfunction
nmap <silent> ,e :call ToggleErrors()<CR>

" native search {{{1
" incremental search
set incsearch
" highlighted search results
set hlsearch
" case insensitive search
set ignorecase
set smartcase

" mouse support {{{1
set ttyfast
set mousehide
if has('mouse')
  set mouse=a
endif

" clipboard support {{{1
if has('clipboard')
  set clipboard=unnamed
endif

" folding settings {{{1
" set foldenable
" set foldmethod=marker
" set foldcolumn=1

" search ctags file upward
set tags=./tags;

" nvim vs vim stuffs {{{1
if has('nvim')
  set viminfo+='10,"1000,:20,%,n~/.vim/dirs/nviminfo
  tnoremap ;; <C-\><C-n>
else
  set viminfo+='10,"1000,:20,%,n~/.vim/dirs/viminfo
  set ttymouse=xterm2
endif


" general settings
syntax on
colo molokai2
set cul
"set cuc
set history=100
set wrap
set nu
set autoindent
"set cursorline
set showcmd
set nojoinspaces
set wildmenu
set lazyredraw
" better detection for shortmess c
if has('patch-7.4.314')
  set shortmess+=c
endif

" miscellaneous {{{1
augroup MyMiscStuff
  autocmd!
  autocmd! Syntax python :syn keyword Keyword self
  autocmd VimResized * wincmd =
  " auto-close quickfix window if it's the last one
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
  " Restore cursor position in previous editing session
  autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
  autocmd BufWritePost *.exs silent :!mix format --check-equivalent %
  autocmd BufWritePost *.ex silent :!mix format --check-equivalent %
augroup END

" always show status bar
set ls=2

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" better backup, swap and undos storage
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos

" create needed directories if they don't exist
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif
if !isdirectory(&directory)
  call mkdir(&directory, 'p')
endif
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif

" allow searching file recursively
set path=.,;,/usr/include,/usr/local/include,**

" no annoying beeps anymore...
set vb
set t_vb=

" make backspace works
set backspace=2

" support 256 colors
set t_Co=256 "

" list of menu_flags specifying which commands wrap to another line
set whichwrap=b,h,l,<,>,[,]

" use F2 as pastetoggle
set pastetoggle=<F2>

" do not change directory
set noautochdir

" spelling check
set spelllang=en
" set spell

"" Personal Key Mappings {{{1
function! Conditional(cond, if, else)
  if a:cond
    silent! exe ":" . a:if
  else
    silent! exe ":" . a:else
  endif
endfunction
nnoremap <silent> <F3> :call Conditional(&spell, 'set nospell', 'set spell')<CR>
nnoremap <silent> <C-p> :call Conditional(&diff, 'normal! [c', 'cprevious')<CR>
nnoremap <silent> <C-n> :call Conditional(&diff, 'normal! ]c', 'cnext')<CR>
noremap <silent> <M-l> <Esc>:call Conditional(tabpagenr('$') > 1, 'tabnext', 'bnext')<CR>
noremap <silent> <M-h> <Esc>:call Conditional(tabpagenr('$') > 1, 'tabprevious', 'bprevious')<CR>

nmap <CR><CR> o<Esc>
imap <C-]> <C-o>l
nmap ;vl :vertical res +10<CR>
nmap ;vs :vertical res -10 <CR>
nnoremap <M-j> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>
nnoremap <M-k> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
noremap <silent> ,, <Esc>:bnext<CR>
noremap <silent> <M-,> <Esc>:bnext<CR>
noremap <silent> ,. <Esc>:bprevious<CR>
noremap <silent> <M-.> <Esc>:bprevious<CR>
noremap <silent> ,<Space> <Esc>:e#<CR>
nnoremap <silent> <C-g> :tag<CR>
noremap <C-s> <Esc>:e!<CR>
inoremap <C-s> <Esc>:e!<CR>
inoremap ;; <Esc>
inoremap ;, ;<Esc>
vnoremap ;; <Esc>
inoremap ,, <End>
inoremap ,. <Esc>I
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>
vnoremap // y/<C-R>"<CR> 
vnoremap <C-c> "+y
nnoremap <F4> :call deoplete#toggle()<CR>
nnoremap gV `[v`]
" formatting html
nnoremap ,= :s/<[^>]*>/\r&\r/g<CR>:g/^$/d<CR>gg=G
nnoremap <C-f> :Ag 

" vim: foldenable foldmethod=marker foldcolumn=1
