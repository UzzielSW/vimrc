# Documentación de primera configuración de Vim

Este documento proporciona una descripción general del archivo `.vimrc`, detallando su estructura y configuraciones principales.

## Tabla de Contenidos
- [Documentación de primera configuración de Vim](#documentación-de-primera-configuración-de-vim)
  - [Tabla de Contenidos](#tabla-de-contenidos)
    - [1. Configuraciones Generales](#1-configuraciones-generales)
    - [2. Configuraciones de Archivos](#2-configuraciones-de-archivos)
    - [3. Configuraciones de Interfaz](#3-configuraciones-de-interfaz)
    - [4. Mapeos y Funciones](#4-mapeos-y-funciones)
    - [5. Plugins](#5-plugins)
      - [Destacados de Configuración de Plugins:](#destacados-de-configuración-de-plugins)
    - [6. Integración con Python](#6-integración-con-python)
    - [7. Temas y Apariencia](#7-temas-y-apariencia)

---

### 1. Configuraciones Generales
Estas configuraciones ajustan el comportamiento general de Vim:
- `set hidden`: Permite cambiar entre buffers sin guardar.
- `set nocompatible`: Desactiva la compatibilidad con versiones antiguas de Vi.
- `syntax on`: Activa el resaltado de sintaxis.
- `set clipboard=unnamed`: Usa el portapapeles del sistema para copiar y pegar.
- `set autoread`: Recarga automáticamente archivos modificados fuera de Vim.
- `set cul`: Resalta la línea actual.
- `set rs`: Activa el soporte de regla.

---

### 2. Configuraciones de Archivos
Estas configuraciones controlan el manejo de archivos e indentación:
- `set nobackup`, `set nowritebackup`, `set noswapfile`: Desactiva archivos de respaldo y swap.
- `set autoindent`, `set smartindent`: Activa la indentación automática e inteligente.
- `set sw=2`, `set softtabstop=2`, `set tabstop=2`: Configura el ancho de tabulación a 2 espacios.
- `set encoding=utf-8`: Establece la codificación de archivos en UTF-8.
- `set scrolloff=8`: Mantiene un margen de 8 líneas al hacer scroll.
- `set ff=unix`: Establece el formato de archivo a Unix.

---

### 3. Configuraciones de Interfaz
Estas configuraciones mejoran la interfaz de usuario:
- `set number`, `set relativenumber`: Muestra números de línea absolutos y relativos.
- `set nohlsearch`: Desactiva el resaltado de búsqueda.
- `set showmatch`: Resalta paréntesis coincidentes.
- `set wildmenu`: Activa el autocompletado en la línea de comandos.
- `set laststatus=2`: Siempre muestra la barra de estado.

---

### 4. Mapeos y Funciones
Mapeos personalizados para mejorar la navegación y funcionalidad:
- Navegación entre splits: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`.
- Redimensionar splits: `<C-w>>`, `<C-w><`, `<C-w>+`, `<C-w>-`.
- Navegación entre buffers: `L` (siguiente), `H` (anterior).
- Centrado en búsquedas: `n`, `N`, `*` mantienen el cursor centrado.
- Tecla líder: `,` (usada para comandos personalizados como guardar, salir, etc.).

---

### 5. Plugins
Los plugins se gestionan con `vim-plug`. Plugins clave incluyen:
- **Navegación**: `vim-easymotion`, `NERDTree`.
- **Edición**: `vim-commentary`, `vim-visual-multi`, `vim-auto-save`.
- **Apariencia**: `lanox-vim-theme`, `vim-airline`, `vim-devicons`.
- **Soporte de Lenguajes**: `python-syntax`, `java-syntax.vim`.

#### Destacados de Configuración de Plugins:
- **NERDTree**: Alternar con `<Leader>nt`, encontrar archivo actual con `<Leader>nf`.
- **EasyMotion**: Mapeos personalizados para navegación rápida.
- **Auto Save**: Guarda automáticamente los archivos en eventos específicos.

---

### 6. Integración con Python
- Los plugins de Python requieren `pynvim`. Configura la ruta al ejecutable de Python:
  ```viml
  let g:python3_host_prog='C:/Users/USUARIO/.venv/Scripts/python.exe'
  ```

---

### 7. Temas y Apariencia
- **Tema**: `lanox` con fondo oscuro.
- **Airline**: Configurado con el tema `simple` y tabline habilitado.
