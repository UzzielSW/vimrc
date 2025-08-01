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
set autoread "Recargar archivos desde el disco automáticamente
set cul
set rs

"-----------------------------------------
" 2. FILE SETTINGS
"-----------------------------------------
set nobackup
set nowritebackup
set noswapfile

set autoindent " Hace que las nuevas líneas hereden la indentación de las líneas anteriores.
set smartindent " activa la indentación inteligente para otros lenguajes
set sw=2 " Establece el ancho del desplazamiento a 2 espacios. Esto afecta a los comandos de indentación y desindentación.
set softtabstop=2
set tabstop=2 "Establece el ancho de la tabulación a 2 columnas. Esto afecta a la visualización de las tabulaciones en el archivo.

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set scrolloff=12 "añadir un margen de unas líneas cuando haces scroll bajando o subiendo el cursor por la pantalla
set ic " Ignora las mayúsculas y minúsculas al realizar una búsqueda.
set ff=unix " Establece el formato del archivo a unix, lo que significa que las líneas terminan con un salto de línea (\n) en lugar de un retorno de carro y un salto de línea (\r\n).

"-----------------------------------------
" 3. UI
"-----------------------------------------
set fillchars+=vert:\
set number " Muestra los números de línea en el lado izquierdo de la pantalla.
set relativenumber " poner los números relativos a la posición del cursor
set hlsearch " Resalta todas las coincidencias de la búsqueda actual.
set showmatch " hace que vim muestre el paréntesis, corchete o llave que coincide con el que está bajo el cursor.
set ttyfast " indica que se tiene una terminal rápida, lo que permite a vim usar ciertas características especiales para mejorar la velocidad y la apariencia del editor.
set wildmenu " tengas un pequeño autocompletado de los comandos que escribes con los dos puntos
let &t_ut='' " la terminal dibuje mejor el color de fondo, ya que con ciertos temas de color el fondo de la terminal solo se dibuja en la línea con texto.
set showcmd " muestra el comando parcial que has introducido en la parte inferior derecha de la pantalla.
set ruler " muestra información sobre la posición del cursor y el estado del archivo en la parte inferior derecha de la pantalla
set laststatus=2 " muestre siempre la barra de estado en la parte inferior de la pantalla
set backspace=indent,eol,start

"-----------------------------------------
" 4. MAPS AND FUNCTIONS
"-----------------------------------------
set splitbelow splitright " la hora de dividir la pantalla en varios ficheros a la vez, siempre se abran a la derecha y abajo
set mouse=a " activa el uso del ratón en todos los modos de vim: normal, visual, insertar y comando. Esto te permite seleccionar texto, mover el cursor, hacer scroll y acceder a los menús con el ratón.

"ejemplo Control + l para moverme al split de la derecha, Control + k para moverme al de arriba.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" resize de los splits de manera más comoda para terminal: > (mas ancho), + mas alto
nnoremap <silent> <C-w>> 4<C-w>>
nnoremap <silent> <C-w>< 4<C-w><
nnoremap <silent> <C-w>+ 4<C-w>+
nnoremap <silent> <C-w>- 4<C-w>-

" configuracion de los buffer
nnoremap L :bnext<CR>
nnoremap H :bprev<CR>
inoremap <C-L> <Esc>:bnext<CR>a
inoremap <C-H> <Esc>:bprev<CR>a

" sirven para que al hacer búsquedas y usar la tecla n para ir navegando entre los resultados, siempre se te mantenga el cursor centrado en pantalla.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv

" Configuracion de macros y atajos
let mapleader = ","
imap jk <ESC>

nnoremap <C-y> gg0vG$y
nnoremap W gg0vG$y
nnoremap <C-t> :tabnew <CR>
nnoremap X :%s/.*\n//g <CR>
nnoremap F :%s/\n/ /g <CR>
nmap E o<ESC>
nmap S :%s/ /g
map p ]p
nnoremap w W
nnoremap yw yiw
nnoremap dw diw
nnoremap cw ciw
nnoremap W :w <CR>
nnoremap <C-f> /!  <CR>
vnoremap R y:let @/ = '\V' . escape(@", '\/')<CR>:%s///g<Left><Left>
inoremap <C-p> <C-o>]p
inoremap <C-j> <C-o>o
inoremap <C-b> <C-o>B
inoremap <C-w> <C-o>W
inoremap <C-a> <C-o>A

" NORMALIZAR ACENTOS, SIMBOLOS TIPOGRAFICOS, GUIONES, ESPACIOS RAROS, ETC.
function! CleanAccentsAndSymbols()
  let replacements = {
        \ 'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
        \ 'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U',
        \ 'ü': 'u', 'Ü': 'U',
        \ '"': '"', '"': '"',
        \ ''': "'", ''': "'",
        \ '—': '-', '–': '-',
        \ '…': '...',
        \ ' ': ' ',
        \ "\u200b": '',
        \ }

  for [search, replace] in items(replacements)
    " Usamos 'e' al final del comando :s para no dar error si no se encuentra el patrón
    let cmd = 'silent! %s/' . escape(search, '/\') . '/' . escape(replace, '/\') . '/ge'
    execute cmd
  endfor

  echo "Caracteres problematicos limpiados."
endfunction

nnoremap <silent> t :call CleanAccentsAndSymbols()<CR>

" ELIMINAR CARACTERES BASURA
function! DeepCleanGarbage()
  let replacements = {
        \ '\r': '',
        \ '\x00': '',
        \ '[\x01-\x1F\x7F]': '',
        \ ' ': ' ',
        \ '\u00AD': '',
        \ '\u200B': '',
        \ '': '',
        \ '': ''
        \ }

  for [pattern, replace] in items(replacements)
    let cmd = 'silent! %s/' . pattern . '/' . replace . '/g'
    silent execute cmd
  endfor

  echo "Caracteres raros limpiados."
endfunction

nnoremap <silent> M :call DeepCleanGarbage()<CR>

" MAPEOS para ejecutar
nnoremap <leader>rj :w<CR>:!clear<CR>:!cd "%:p:h"; ls; javac "%:t" *.java; java "%:t:r"<CR>
nnoremap <leader>ru :w<CR>:!clear<CR>:!java "%"<CR>
nnoremap <leader>rp :w<CR>:!clear<CR>:!python "%"<CR>
nnoremap <leader>rm :!cd "%:p:h"; rm *.class<CR>
"* g++ -o nombre_del_ejecutable nombre_del_archivo.cpp */
nnoremap <leader>rc :w<CR>:!clear<CR>:!g++ "%" && ./a<CR>

nnoremap <leader>sr :source ~/.vimrc <CR>
nnoremap <leader>eg :e ~/.vimrc <CR>
nnoremap <C-o> :e ~/Videos/edit.md <CR>

nnoremap <silent> <C-q> :w<CR>:bd \| bw <CR>
nnoremap Q :wq <CR>
nnoremap <leader>q :bd! <CR>
nnoremap <leader>qq :q! <CR>

" ---------------------------------surround---------------------------------------
    " Old text                    Command         New text
" --------------------------------------------------------------------------------
    " surr*ound_words             ysiw)           (surround_words)
    " *make strings               ys$"            "make strings"
    " [delete ar*ound me!]        ds]             delete around me!
    " remove <b>HTML t*ags</b>    dst             remove HTML tags
    " 'change quot*es'            cs'"            "change quotes"
    " <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    " delete(functi*on calls)     dsf             function calls

"-----------------------------------------
" 5. PLUGINS
"-----------------------------------------
call plug#begin('~/.vim/plugged')

" Principales
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'mg979/vim-visual-multi'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-surround'

" Apariencia
Plug 'lanox/lanox-vim-theme'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'
Plug 'Yggdroot/indentLine'

" Sintaxis
Plug 'uiiaoo/java-syntax.vim'
Plug 'vim-python/python-syntax'

call plug#end()

" --------------------------Python-----------------------------------
" Para los plugins de Python necesitas el pynvim módulo. Se recomiendan Envs virtuales. Después de activar el env virtual do pip install pynvim (en ambos). Edita tu init.vim para que contenga la ruta al ejecutable de Python del env:
let g:python3_host_prog='C:/Users/USUARIO/.venv/Scripts/python.exe'

" --------------------------highlight-----------------------------------
let g:python_highlight_all = 1

" --------------------------auto_save-----------------------------------
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "CompleteDone"]

" --------------------------easymotion-----------------------------------
let g:EasyMotion_do_mapping = 0 " Disable default mappings

nmap f <Plug>(easymotion-overwin-f)
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

" --------------------------NERDTree-----------------------------------
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

let g:NERDTreeWinSize = 50
let g:NERDTreeWinPos = "right"
nmap <C-b> :NERDTreeToggle<CR>

" --------------------------theme-----------------------------------
set background=dark
colorscheme lanox

" --------------------------airline_theme-----------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='simple'

" testing rounded separators (extra-powerline-symbols):
let g:airline_left_sep = "\uE0c6"
let g:airline_right_sep = "\uE0b2"

" set the CN (column number) symbol:
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])
