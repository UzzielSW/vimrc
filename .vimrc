" TABLE OF CONTENTS:

" 1. Generic settings
" 2. File settings
" 3. UI
" 4. Maps and functions
" 5. Plugins and setting plugins

"-----------------------------------------
" 1. GENERIC SETTINGS
"-----------------------------------------
set hidden " desactivo un warning molesto al abrir un fichero y tener el actual sin guardar
set nocompatible " disable vi compatibility mode
set history=50
syntax on " Activa el resaltado de sintaxis para el tipo de archivo detectado. 
set clipboard=unnamed " use el portapapeles del sistema para copiar y pegar texto.
set autoread
set cul
set rs

"-----------------------------------------
" 2. FILE SETTINGS
"-----------------------------------------
set nobackup
set nowritebackup
set noswapfile

set autoindent " Hace que las nuevas l?neas hereden la indentaci?n de las l?neas anteriores.
set smartindent " activa la indentaci?n inteligente para otros lenguajes
set sw=2 " Establece el ancho del desplazamiento a 2 espacios. Esto afecta a los comandos de indentaci?n y desindentaci?n.
set softtabstop=2

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set scrolloff=8 "a?adir un m?rgen de unas l?neas cuando haces scroll bajando o subiendo el cursor por la pantalla
set ic " Ignora las may?sculas y min?sculas al realizar una b?squeda.
set ff=unix " Establece el formato del archivo a unix, lo que significa que las l?neas terminan con un salto de l?nea (\n) en lugar de un retorno de carro y un salto de l?nea (\r\n).

set fillchars+=vert:\ 
set number " Muestra los n?meros de l?nea en el lado izquierdo de la pantalla.
set relativenumber " poner los numeros relativos a la posicion del cursor
" set hlsearch " Resalta todas las coincidencias de la b?squeda actual.
set nohlsearch " clear highlight after a search
set showmatch " hace que vim muestre el par?ntesis, corchete o llave que coincide con el que est? bajo el cursor.
set ttyfast " indica que se tiene una terminal r?pida, lo que permite a vim usar ciertas caracter?sticas especiales para mejorar la velocidad y la apariencia del editor.
set tabstop=2 "Establece el ancho de la tabulaci?n a 2 columnas. Esto afecta a la visualizaci?n de las tabulaciones en el archivo.
set wildmenu " tengas un peque?o autocompletado de los comandos que escribes con los dos puntos,
let &t_ut='' " la terminal dibuje mejor el color de fondo, ya que con ciertos temas de color el fondo de la terminal solo se dibuja en la l?nea con texto.
set showcmd " muestra el comando parcial que has introducido en la parte inferior derecha de la pantalla.
set ruler " muestra informaci?n sobre la posici?n del cursor y el estado del archivo en la parte inferior derecha de la pantalla
set laststatus=2 " muestre siempre la barra de estado en la parte inferior de la pantalla
"set backspace=2 " permita borrar con la tecla retroceso m?s all? del inicio de la inserci?n, el inicio de la l?nea o los saltos de l?nea anteriores.
set backspace=indent,eol,start

"-----------------------------------------
" 4. MAPS AND FUNCTIONS
"-----------------------------------------
set splitbelow splitright " la hora de dividir la pantalla en varios ficheros a la vez, siempre se abran a la derecha y abajo
set mouse=a " activa el uso del rat?n en todos los modos de vim: normal, visual, insertar y comando. Esto te permite seleccionar texto, mover el cursor, hacer scroll y acceder a los men?s con el rat?n.

"ejemplo Control + l para moverme al split de la derecha, Control + k para moverme al de arriba.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" resize de los splits de manera m?s comoda: > (mas ancho)
nnoremap <silent> <C-w>> 4<C-w>>
nnoremap <silent> <C-w>< 4<C-w><
nnoremap <silent> <C-w>+ 4<C-w>+
nnoremap <silent> <C-w>- 4<C-w>-

map L :bnext<CR>
map H :bprev<CR>
imap <C-L> <Esc>:bnext<CR>a
imap <C-H> <Esc>:bprev<CR>a

" sirven para que al hacer b?squedas y usar la tecla n para ir nevegando entre los resultados, siempre se te mantenga el cursor centrado en pantalla.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv

nnoremap <silent> <C-q> :bd <CR>

let mapleader = ","
imap jk <ESC>
nmap <leader>sr :source ~/.vimrc <CR>
nmap <leader>eg :e ~/.vimrc <CR>
nmap <leader>q :wq <CR>
nmap <leader>qq :q! <CR>
map Q gg0vG$y
map D gg0vG$d
map X :%s/.*\n//g <CR>
map R :%s/\n/ /g <CR>
map E ojk

nmap <leader>rp :w<CR>:!clear<CR>:!python "%"<CR>

"-----------------------------------------
" 5. PLUGINS
"-----------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'mg979/vim-visual-multi'
Plug '907th/vim-auto-save'

Plug 'lanox/lanox-vim-theme'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'
Plug 'Yggdroot/indentLine'

Plug 'uiiaoo/java-syntax.vim'
Plug 'vim-python/python-syntax'

call plug#end()

" --------------------------Python-----------------------------------
" Para los plugins de Python necesitas el pynvim módulo. Se recomiendan Envs virtuales. Después de activar el env virtual do pip install pynvim (en ambos). Edita tu init.vim para que contenga la ruta al ejecutable de Python del env:
let g:python3_host_prog='C:/Users/USUARIO/.venv/Scripts/python.exe'

" --------------------------highlight-----------------------------------
let g:python_highlight_all = 1

" --------------------------NERDTree-----------------------------------
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" let g:NERDTreeChDirMode=2
" let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', '\.dat.$', '\.DAT']
" let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
" let g:NERDTreeShowBookmarks=1
" let g:nerdtree_tabs_focus_on_files=1
" let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 35
" let g:NERDTreeShowHidden = 1
" let g:NERDTreeQuitOnOpen = 0
"autocmd BufEnter * NERDTreeFind
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,*.class

nmap <Leader>nt :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>

" --------------------------easymotion-----------------------------------
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" basicos
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" --------------------------auto_save-----------------------------------
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]
"let g:auto_save_silent = 1

" --------------------------theme-----------------------------------
set background=dark
colorscheme lanox 

" --------------------------airline_theme-----------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='simple'

" set guifont=ProFontWindows\ Nerd\ Font:h15
" set guifont=Terminess\ Nerd\ Font:h15
" set guifont=Terminess\ Nerd\ Font\ Mono:h15

" testing rounded separators (extra-powerline-symbols):
" let g:airline_left_sep = "\uE0c6"
" let g:airline_right_sep = "\uE0b2"

" set the CN (column number) symbol:
" let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])
