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
set clipboard=unnamed " use el portapapeles del sistema para copiar y pegar texto.
set autoread "Recargar archivos desde el disco automáticamente
set cul
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

set scrolloff=8 "añadir un márgen de unas líneas cuando haces scroll bajando o subiendo el cursor por la pantalla
set ic " Ignora las mayúsculas y minúsculas al realizar una búsqueda.
set ff=unix " Establece el formato del archivo a unix, lo que significa que las líneas terminan con un salto de línea (\n) en lugar de un retorno de carro y un salto de línea (\r\n).

"-----------------------------------------
" 3. UI
"-----------------------------------------
set fillchars+=vert:\ 
set number " Muestra los números de línea en el lado izquierdo de la pantalla.
" set hlsearch " Resalta todas las coincidencias de la búsqueda actual.
set nohlsearch " clear highlight after a search
set showmatch " hace que vim muestre el paréntesis, corchete o llave que coincide con el que está bajo el cursor.
set tabstop=2 "Establece el ancho de la tabulación a 2 columnas. Esto afecta a la visualización de las tabulaciones en el archivo.
set wildmenu " tengas un pequeño autocompletado de los comandos que escribes con los dos puntos
set showcmd " muestra el comando parcial que has introducido en la parte inferior derecha de la pantalla.
set ruler " muestra información sobre la posición del cursor y el estado del archivo en la parte inferior derecha de la pantalla
set laststatus=2 " muestre siempre la barra de estado en la parte inferior de la pantalla
set backspace=indent,eol,start

"-----------------------------------------
" 4. MAPS AND FUNCTIONS
"-----------------------------------------
set splitbelow splitright " la hora de dividir la pantalla en varios ficheros a la vez, siempre se abran a la derecha y abajo
" set termguicolors " esto pone el fondo negro haciendo que los temas se vean mal

"ejemplo Control + l para moverme al split de la derecha, Control + k para moverme al de arriba.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" resize de los splits de manera más comoda para terminal: > (mas ancho), + mas alto
nnoremap <silent> <C-w>> 4<C-w>>
nnoremap <silent> <C-w>< 4<C-w><
nnoremap <silent> <C-w>+ 4<C-w>+
nnoremap <silent> <C-w>- 4<C-w>-

" configuracion de los buffer
map L :bnext<CR>
map H :bprev<CR>
imap <C-L> <Esc>:bnext<CR>a
imap <C-H> <Esc>:bprev<CR>a

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv

" Código a ejecutar si g:vscode no existe
if !exists('g:vscode')
  nnoremap <silent> <C-q> :bd<CR>
endif

" Configuracion de macros y atajos
let mapleader = ","
imap jk <ESC>
nmap <leader>sr :source ~/AppData/Local/nvim/init.vim <CR>
nmap <leader>eg :e ~/AppData/Local/nvim/init.vim <CR>
nmap <leader>q :wq <CR>
nmap <leader>qq :q! <CR>
nmap <leader>F :Format <CR>
map Q gg0vG$y
map D gg0vG$d
map X :%s/.*\n//g <CR>
map R :%s/\n/ /g <CR>
map E ojk
"cada que se hace <CR> se esta ejecutando un shell diferente
nmap <leader>rj :w<CR>:!clear<CR>:!cd "%:p:h"; ls; javac "%:t" *.java; java "%:t:r"<CR>
nmap <leader>ru :w<CR>:!clear<CR>:!java "%"<CR>
nmap <leader>rp :w<CR>:!clear<CR>:!python "%"<CR>
nmap <leader>rm :!cd "%:p:h"; rm *.class<CR>
"* g++ -o nombre_del_ejecutable nombre_del_archivo.cpp */
nmap <leader>rc :w<CR>:!clear<CR>:!g++ "%" && ./a<CR>


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

" Principales
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'mg979/vim-visual-multi'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'folke/which-key.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


Plug 'arminveres/md-pdf.nvim', {'branch': 'main'}
" Apariencia
Plug 'lanox/lanox-vim-theme'
Plug 'ryanoasis/vim-devicons'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'

call plug#end()


lua<<EOF

if not vim.g.vscode then
--------------------------------------treesitter---------------------------------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" },

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
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


--------------------------------------LSP---------------------------------------
require'lspconfig'.pyright.setup{}
require'lspconfig'.java_language_server.setup{}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

end
-- fin del if para validar que no sea vscode
EOF

" --------------------------Python-----------------------------------
" Para los plugins de Python necesitas el pynvim módulo. Se recomiendan Envs virtuales. Después de activar el env virtual do pip install pynvim (en ambos). Edita tu init.vim para que contenga la ruta al ejecutable de Python del env:
let g:python3_host_prog='C:/Users/USUARIO/.venv/Scripts/python.exe'

" --------------------------NERDTree-----------------------------------
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

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
let g:airline_left_sep = "\uE0c6"
let g:airline_right_sep = "\uE0b2"

" set the CN (column number) symbol:
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

"--------------------------COC-------------------------------------
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
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
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
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"UTILES
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

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

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
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
