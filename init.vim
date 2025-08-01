" TABLE OF CONTENTS:

" 1. Generic settings
" 2. File settings
" 3. UI
" 4. Maps and functions
" 5. Plugins and setting plugins

"-----------------------------------------
" 1. GENERIC SETTINGS
"-----------------------------------------
set shell=powershell.exe
set shellcmdflag=-NoLogo\ -ExecutionPolicy\ Bypass\ -Command
set shellquote=""
set shellxquote=""
set clipboard=unnamed " use el portapapeles del sistema para copiar y pegar texto.
"-----------------------------------------
" 2. FILE SETTINGS
"-----------------------------------------
set nobackup
set nowritebackup
set noswapfile
" set signcolumn=no
set autoindent " Hace que las nuevas lineas hereden la indentacion de las lineas anteriores.
set ff=unix " Establece el formato del archivo a unix, lo que significa que las lineas terminan con un salto de linea (\n) en lugar de un retorno de carro y un salto de linea (\r\n).

"-----------------------------------------
" 3. UI
"-----------------------------------------
set hlsearch " Resalta todas las coincidencias de la busqueda actual.
set backspace=indent,eol,start

"-----------------------------------------
" 4. MAPS AND FUNCTIONS
"-----------------------------------------
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

"cada que se hace <CR> se esta ejecutando un shell diferente

" Reemplazo de acentos
" Forma 1: (funciona pero se vueve tediosa al ampliarlo)
" nnoremap <silent> t :silent! %s/a/a/g \| silent! %s/e/e/g \| silent! %s/i/i/g \| silent! %s/o/o/g \| silent! %s/u/u/g<CR>

" Forma 2: escalable
" NORMALIZAR ACENTOS, SIMBOLOS TIPOGRAFICOS, GUIONES, ESPACIOS RAROS, ETC.
function! CleanAccentsAndSymbols()
  let replacements = {
        \ 'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
        \ 'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U',
        \ 'ü': 'u', 'Ü': 'U',
        \ '“': '"', '”': '"',
        \ '‘': "'", '’': "'",
        \ '—': '-', '–': '-',
        \ '…': '...',
        \ ' ': ' ',
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

call plug#begin('~/.vim/plugged')

" Plugins que funcionan en VSCode
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'

" Plugins SOLO para Neovim standalone
if !exists('g:vscode')
	Plug '907th/vim-auto-save'
	Plug 'mg979/vim-visual-multi'
  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'folke/which-key.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'lanox/lanox-vim-theme'
  Plug 'ryanoasis/vim-devicons'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

call plug#end()


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


"-------------------------------------------------------------------------NO VSCODE CONFIG--------------------------------------------------------------------------
if exists('g:vscode')
  " ¡Detiene la ejecucion! No carga el resto del archivo
  finish
endif

" --------------------------config. basica-----------------------------------
set autoread "Recargar archivos desde el disco automaticamente
set cul
set scrolloff=12 "añadir un margen de unas lineas cuando haces scroll bajando o subiendo el cursor por la pantalla
set sw=2 " Establece el ancho del desplazamiento a 2 espacios. Esto afecta a los comandos de indentacion y desindentacion.
set softtabstop=2
set tabstop=2 "Establece el ancho de la tabulacion a 2 columnas. Esto afecta a la visualizacion de las tabulaciones en el archivo.
set fillchars+=vert:\
set number " Muestra los numeros de linea en el lado izquierdo de la pantalla.
set relativenumber " poner los numeros relativos a la posicion del cursor
set showmatch " hace que vim muestre el parentesis, corchete o llave que coincide con el que esta bajo el cursor.
set wildmenu " tengas un pequeño autocompletado de los comandos que escribes con los dos puntos
set showcmd " muestra el comando parcial que has introducido en la parte inferior derecha de la pantalla.
set splitbelow splitright " la hora de dividir la pantalla en varios ficheros a la vez, siempre se abran a la derecha y abajo

"ejemplo Control + l para moverme al split de la derecha, Control + k para moverme al de arriba.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" resize de los splits de manera mas comoda para terminal: > (mas ancho), + mas alto
nnoremap <silent> <C-w>> 4<C-w>>
nnoremap <silent> <C-w>< 4<C-w><
nnoremap <silent> <C-w>+ 4<C-w>+
nnoremap <silent> <C-w>- 4<C-w>-

" configuracion de los buffer
nnoremap L :bnext<CR>
nnoremap H :bprev<CR>
inoremap <C-L> <Esc>:bnext<CR>a
inoremap <C-H> <Esc>:bprev<CR>a


" MAPEOS para ejecutar
nnoremap <leader>rj :w<CR>:!clear<CR>:!cd "%:p:h"; ls; javac "%:t" *.java; java "%:t:r"<CR>
nnoremap <leader>ru :w<CR>:!clear<CR>:!java "%"<CR>
nnoremap <leader>rp :w<CR>:!clear<CR>:!python "%"<CR>
nnoremap <leader>rm :!cd "%:p:h"; rm *.class<CR>
"* g++ -o nombre_del_ejecutable nombre_del_archivo.cpp */
nnoremap <leader>rc :w<CR>:!clear<CR>:!g++ "%" && ./a<CR>
"-- Configuraciones
"Linux
" nnoremap <leader>sr :source ~/.config/nvim/init.vim <CR>
" nnoremap <leader>eg :e ~/.config/nvim/init.vim <CR>
"Windows
nnoremap <leader>sr :source ~/AppData/Local/nvim/init.vim <CR>
nnoremap <leader>eg :e ~/AppData/Local/nvim/init.vim <CR>
nnoremap <C-o> :e ~/Videos/edit.md <CR>
"--
nnoremap <silent> <C-q> :w<CR>:bd \| bw <CR>
nnoremap Q :wq <CR>
nnoremap <leader>q :bd! <CR>
nnoremap <leader>qq :q! <CR>

nnoremap <leader>F :Format <CR>

" --------------------------auto_save-----------------------------------
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "CompleteDone"]

" --------------------------Python-----------------------------------
" Para los plugins de Python necesitas el pynvim modulo. Se recomiendan Envs virtuales. Despues de activar el env virtual do pip install pynvim (en ambos).
" Edita tu init.vim para que contenga la ruta al ejecutable de Python del env:
let g:python3_host_prog='C:/Users/USUARIO/.venv/Scripts/python.exe'

"-------------------------------------------------------------------------CONFIG LUA--------------------------------------------------------------------------------
lua<<EOF
--------------------------------------treesitter---------------------------------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "sql", "python", "bash", "json", "javascript"},

  sync_install = false,
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" },

  highlight = {
    enable = true,

    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--------------------------------------indent-blankline---------------------------------------
  local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
  }

  local hooks = require "ibl.hooks"
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  require("ibl").setup { indent = { highlight = highlight } }
EOF
"-------------------------------------------------------------------------CONFIG LUA--------------------------------------------------------------------------------

" --------------------------NERDTree-----------------------------------
let g:NERDTreeWinSize = 50
" let g:NERDTreeShowHidden = 1
" let g:NERDTreeQuitOnOpen = 0
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

"--------------------------COC-------------------------------------
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

set signcolumn=number
