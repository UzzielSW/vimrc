"-----------------------------------------
" 1. GENERIC SETTINGS y FILE SETTINGS
"-----------------------------------------
set clipboard=unnamed " use el portapapeles del sistema para copiar y pegar texto.
set nobackup
set encoding=UTF-8
set nowritebackup
set noswapfile
set autoindent " Hace que las nuevas lineas hereden la indentacion de las lineas anteriores.
set ff=unix " Establece el formato del archivo a unix, lo que significa que las lineas terminan con un salto de linea (\n) en lugar de un retorno de carro y un salto de linea (\r\n).
autocmd FileType * setlocal formatoptions-=r formatoptions-=o " evitar crear lineas nuevas con comentario
"-----------------------------------------
" 2. UI
"-----------------------------------------
set hlsearch
set incsearch
set backspace=indent,eol,start
set showbreak=↪\
set wrap
set linebreak
"-----------------------------------------
" 3. MAPS AND FUNCTIONS
"-----------------------------------------
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv

" Configuracion de macros y atajos
let mapleader = ","
imap jk <ESC>
nnoremap <C-y> gg0vG$y
nnoremap <C-a> gg0vG$
nnoremap <C-t> :tabnew <CR>
nnoremap <C-f> /!  <CR>
nnoremap X :%s/.*\n//g<CR>:nohlsearch<CR>
nnoremap F :%s/\n/ /g <CR>:nohlsearch<CR>
nmap E o<ESC>
nmap S :%s/ /g
map p ]p
nnoremap w W
nnoremap yw yiw
nnoremap dw diw
nnoremap cw ciw
nnoremap W :w <CR>
vnoremap R y:let @/ = '\V' . escape(@", '\/')<CR>:%s///g<Left><Left>
inoremap <C-p> <C-o>]p
inoremap <C-j> <C-o>o
inoremap <C-b> <C-o>B
inoremap <C-w> <C-o>W
inoremap <C-a> <C-o>A
"--------------
"---------------
" NORMALIZAR ACENTOS, SIMBOLOS TIPOGRAFICOS, GUIONES, ESPACIOS RAROS, ETC.
function! CleanAccentsAndSymbols()
	" # Config.
	" VALIDACION PARA EVITAR EJECUTAR ESTA FUNCION EN ESTE ARCHIVO
	" let l:current_file = expand('%:t')
	let l:current_file = substitute(expand('%:p'), '/', '\\', 'g')
	let l:init_file = expand('~/.config/nvim/init.vim') " Ruta completa de tu init.vim - Linux
	" let l:init_file = expand('~/AppData/Local/nvim/init.vim') " Ruta completa de tu init.vim

	if l:current_file ==# l:init_file " Si estamos en init.vim, salir
	" if l:current_file ==# 'init.vim'
		echo "No se DEBE ejecutar este funcion en init.vim"
		return
	" else
	" 	echo "Ejecutando función en: " . l:current_file . " - init_file:" . l:init_file
	" 	return
	endif

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
	" # Config.
	" VALIDACION PARA EVITAR EJECUTAR ESTA FUNCION EN ESTE ARCHIVO
	" let l:current_file = expand('%:t')
	let l:current_file = substitute(expand('%:p'), '/', '\\', 'g')
	let l:init_file = expand('~/.config/nvim/init.vim') " Ruta completa de tu init.vim - Linux
	" let l:init_file = expand('~/AppData/Local/nvim/init.vim') " Ruta completa de tu init.vim

	if l:current_file ==# l:init_file " Si estamos en init.vim, salir
	" if l:current_file ==# 'init.vim'
		echo "No se DEBE ejecutar este funcion en init.vim"
		return
	" else
	" 	echo "Ejecutando función en: " . l:current_file . " - init_file:" . l:init_file
	" 	return
	endif

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
	" Dependencia obligatoria para telescope
	Plug 'mikavilpas/yazi.nvim'
	Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.2.1' }
	Plug 'OXY2DEV/markview.nvim'
	Plug 'kdheepak/lazygit.nvim'
	Plug '907th/vim-auto-save'
	Plug 'folke/which-key.nvim'
	Plug 'mg979/vim-visual-multi'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'lanox/lanox-vim-theme'
  Plug 'ryanoasis/vim-devicons'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
	Plug 'lewis6991/gitsigns.nvim'
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

" --------------------------SETTINGS BASIC-----------------------------------
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
"cada que se hace <CR> se esta ejecutando un shell diferente
" nnoremap <leader>rj :w<CR>:!clear<CR>:!cd "%:p:h"; ls; javac "%:t" *.java; java "%:t:r"<CR>
" nnoremap <leader>ru :w<CR>:!clear<CR>:!java "%"<CR>
" nnoremap <leader>rm :!cd "%:p:h"; rm *.class<CR>
nnoremap <leader>rp :w<CR>:!clear<CR>:!python "%"<CR>
"* g++ -o nombre_del_ejecutable nombre_del_archivo.cpp */
" nnoremap <leader>rc :w<CR>:!clear<CR>:!g++ "%" && ./a<CR>

" # Config.
"Linux
nnoremap <leader>sr :source ~/.config/nvim/init.vim <CR>
nnoremap <leader>eg :e ~/.config/nvim/init.vim <CR>

"Windows
" nnoremap <leader>sr :source ~/AppData/Local/nvim/init.vim <CR>
" nnoremap <leader>eg :e ~/AppData/Local/nvim/init.vim <CR>
" nnoremap <C-o> :e ~/OneDrive/Documentos/edit.md <CR>
"--
nnoremap <silent> <C-q> :w<CR>:bd \| bw <CR>
nnoremap Q :wq <CR>
nnoremap <leader>q :bd! <CR>
nnoremap <leader>qq :q! <CR>

" setup mapping to call :LazyGit
nnoremap <silent> <leader>gg :LazyGit<CR>
nnoremap <silent> <leader>pv :Markview toggle<CR>
nnoremap <leader>y :Yazi<CR>

" --------------------------auto_save-----------------------------------
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "CompleteDone"]

"=============================CONFIG LUA==================================
lua<<EOF

--------------------------------------treesitter---------------------------------------
require'nvim-treesitter'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "sql", "python", "bash", "json", "javascript", "html", "latex", "typst", "yaml"},
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

local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "file" }, -- group
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
	{ "<leader>fb", function() print("hello he who remains :) love u") end, desc = "Foobar", hidden = true },
	{ "<leader>f1", hidden = true }, -- hide this keymap
	{ "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
	{ "<leader>b", group = "buffers", expand = function()
			return require("which-key.extras").expand.buf()
		end
	},
	{
		-- Nested mappings are allowed and can be added in any order
		-- Most attributes can be inherited or overridden on any level
		-- There's no limit to the depth of nesting
		mode = { "n", "v" }, -- NORMAL and VISUAL mode
		{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
		{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	}
})

--------------------------telescope-----------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

--------------------------telescope-fzf-----------------------------------
 require('telescope').load_extension('fzf')

--------------------------gitsigns-----------------------------------
require('gitsigns').setup()

--------------------------nvim-tree-----------------------------------
require("nvim-tree").setup({
	view = {
		side = "right",
	},
})

--------------------------toggleterm-----------------------------------
require("toggleterm").setup({
size = 15, -- Altura similar al panel inferior de VSCode

-- Atajo principal: presiona F7 para abrir/cerrar (puedes cambiarlo abajo)
open_mapping = [[<F7>]], 

hide_numbers = true,
shade_terminals = true,
shading_factor = 2,
start_in_insert = true,   -- Entra escribiendo automáticamente
insert_mappings = true,   -- Permite usar el atajo de abrir/cerrar desde el modo Insert
terminal_mappings = true, -- Permite usar el atajo para cerrar desde dentro de la terminal
persist_size = true,
direction = 'horizontal',  -- Se abre abajo tipo VSCode
close_on_exit = true,

-- Configurar PowerShell Core (pwsh) como shell
-- shell = "pwsh",
-- # Config.
shell = "bash",
})

-- Mapeos de teclas convenientes para trabajar dentro de la terminal
function _G.set_terminal_keymaps()
local opts = { buffer = 0 }

-- Presionar <Esc> te saca del modo escritura de la terminal al modo Normal de Neovim
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)

-- Atajo alternativo estilo VSCode (Ctrl + j) para mostrar/ocultar la terminal
vim.keymap.set({'n', 'i', 't'}, '<C-k>', [[<Cmd>ToggleTerm<CR>]], opts)
end

-- Aplicar los atajos cada vez que se abre la terminal
vim.api.nvim_create_autocmd("TermOpen", {
pattern = "term://*",
callback = function()
	set_terminal_keymaps()
end,
})


EOF
"=============================CONFIG LUA==================================

" --------------------------nvim-tree-----------------------------------
" Desactivar netrw (requerido por nvim-tree)
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

nmap <C-b> :NvimTreeToggle<CR>

" Habilitar colores de 24 bits (necesario para iconos)
set termguicolors

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
let g:airline_section_z = airline#section#create([""])

