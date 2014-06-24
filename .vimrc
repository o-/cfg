set expandtab
set shiftwidth=2
set softtabstop=2
set wildmode=longest:full
set wildmenu
set ruler
set number
set hls

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

set ttyfast
set bg=dark

set undolevels=300      " Number of undo levels.

setlocal nowrap
set linebreak

function! TextMode()
  set wrap linebreak nolist
endfunction

" arrow mapping
" arrows shouldn't jump over wrapped lines
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <buffer> <silent> <Home> g<Home>
nnoremap <buffer> <silent> <End>  g<End>
vnoremap <Down> gj
vnoremap <Up> gk
vnoremap <buffer> <silent> <Home> g<Home>
vnoremap <buffer> <silent> <End>  g<End>
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End> <C-o>g<End>

function! CodeMode()
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  match OverLength /\%81v.\+/
endfunction

au BufRead,BufNewFile *.cc setfiletype cpp
au FileType javascript,c,c++,ruby,python,c,cpp,java,puppet,html,js,css,go call CodeMode()
au FileType tex call TextMode()

function! UpdateTags()
  execute ":!ctags-exuberant -R --sort=1 --languages=C++ --c++-kinds=+p --fields=+liaS --extra=+q ./"
  echohl StatusLine | echo "C/C++ tag updated" | echohl None
endfunction
nnoremap <F4> :call UpdateTags()

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

nmap <silent> <c-s-k> <C-W>k
nmap <silent> <c-s-j> <C-W>j
nmap <silent> <c-s-h> <C-W>h
nmap <silent> <c-s-l> <C-W>l

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

call ToggleWrap()

set bg=dark

set scrolloff=5

set nocompatible

" Turn on the verboseness to see everything vim is doing.
"set verbose=9

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Always  set auto indenting on
set autoindent

" set the commandheight
set cmdheight=2

" keep 50 lines of command line history
set history=50

" show the cursor position all the time
set ruler

" show (partial) commands
set showcmd

" do incremental searches (annoying but handy);
set incsearch

" Show  tab characters. Visual Whitespace.
set list

set listchars=tab:>-,trail:·

" Set ignorecase on
set ignorecase

" smart search (override 'ic' when pattern has uppers)

set scs

" Set 'g' substitute flag on
" set gdefault

" Set status line
set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*


" Always display a status line at the bottom of the window
set laststatus=2

" Set vim to use 'short messages'.
" set shortmess=a

" Insert two spaces after a period with every joining of lines.

" I like this as it makes reading texts easier (for me, at least).
set joinspaces

" showmatch: Show the matching bracket for the last ')'?
set showmatch

" allow tilde (~) to act as an operator -- ~w, etc.

set notildeop


" highlight strings inside C comments
let c_comment_strings=1

syntax on
set hlsearch

" pressing < or > will let you indent/unident selected lines
vnoremap < <gv
vnoremap > >gv

filetype plugin on
filetype plugin indent on

highlight   clear
highlight   Pmenu         ctermfg=0 ctermbg=2
highlight   PmenuSel      ctermfg=0 ctermbg=7
highlight   PmenuSbar     ctermfg=7 ctermbg=0
highlight   PmenuThumb    ctermfg=0 ctermbg=7

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler

" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Normally don't automatically format 'text' as it is typed, only do this
" with comments, at 79 characters.
au BufNewFile,BufEnter *.c,*.cc,*.h,*.java,*.jsp set formatoptions-=t tw=79


" add an autocommand to update an existing time stamp when writing the file 
" It uses the functions above to replace the time stamp and restores cursor 
" position afterwards (this is from the FAQ) 
autocmd BufWritePre,FileWritePre *   ks|call UpdateTimeStamp()|'s

" first add a function that returns a time stamp in the desired format 
if !exists("*TimeStamp")
    fun TimeStamp()

        return "Last-modified: " . strftime("%d %b %Y %X")
    endfun
endif

" searches the first ten lines for the timestamp and updates using the
" TimeStamp function
if !exists("*UpdateTimeStamp")
function! UpdateTimeStamp()

   " Do the updation only if the current buffer is modified 
   if &modified == 1
       " go to the first line
       exec "1"

      " Search for Last modified: 
      let modified_line_no = search("Last-modified:")
      if modified_line_no != 0 && modified_line_no < 10

         " There is a match in first 10 lines 
         " Go to the : in modified: 
         exe "s/Last-modified: .*/" . TimeStamp()
     endif

 endif
 endfunction
endif

let Tex_FoldedSections=""
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

set guioptions-=m " turn off menu bar
set guioptions-=T " turn off toolbar

set whichwrap=<,>,h,l,[,]

setlocal spell spelllang=en_us
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
hi SpellRare cterm=underline
hi SpellLocal cterm=underline
hi SpellBad cterm=underline
hi SpellCap cterm=underline
