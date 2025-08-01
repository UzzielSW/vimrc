#!/bin/bash

# Script de configuración de herramientas de desarrollo
# Autor: Uzziel
# Versión: 1.0

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Función para validar si un archivo existe
check_file_exists() {
    local file=$1
    if [ ! -f "$file" ]; then
        print_message $RED "Error: No se encontró el archivo $file en el directorio actual."
        return 1
    fi
    return 0
}

# Función para validar si curl está disponible
check_curl() {
    if ! command -v curl &> /dev/null; then
        print_message $RED "Error: curl no está instalado. Por favor instálalo primero."
        return 1
    fi
    return 0
}

# Función para obtener nombre de usuario de Windows de forma más robusta
get_windows_username() {
    local username=""
    while true; do
        read -p "¿Cuál es tu nombre de usuario de Windows? " username
        username=$(echo "$username" | xargs) # Elimina espacios al inicio/final

        if [ -z "$username" ]; then
            print_message $YELLOW "El nombre de usuario no puede estar vacío. Intenta de nuevo."
            continue
        fi

        local destino="/mnt/c/Users/$username"
        if [ -d "$destino" ]; then
            echo "$username"
            return 0
        else
            print_message $YELLOW "La carpeta $destino no existe. Intenta de nuevo."
        fi
    done
}

confVim() {
    print_message $BLUE "Configurando Vim..."

    if ! check_curl; then
        return 1
    fi

    print_message $YELLOW "Descargando Vim-Plug..."
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        print_message $GREEN "Vim-Plug descargado exitosamente."
    else
        print_message $RED "Error al descargar Vim-Plug."
        return 1
    fi

    if check_file_exists ".vimrc"; then
        cp ./.vimrc "$HOME/.vimrc"
        print_message $GREEN "Configuración de Vim copiada exitosamente."
    else
        return 1
    fi
}

confNvimLinux() {
    print_message $BLUE "Configurando Neovim para Linux..."

    if ! check_curl; then
        return 1
    fi

    print_message $YELLOW "Descargando Vim-Plug..."
    if sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'; then
        print_message $GREEN "Vim-Plug descargado exitosamente."
    else
        print_message $RED "Error al descargar Vim-Plug."
        return 1
    fi

    local ruta_nvim="$HOME/.config/nvim/"

    if [ ! -d "$ruta_nvim" ]; then
        print_message $YELLOW "Creando directorio $ruta_nvim..."
        mkdir -p "$ruta_nvim"
    fi

    if check_file_exists "init.vim"; then
        cp ./init.vim "$ruta_nvim/init.vim"
        print_message $GREEN "Configuración de Neovim copiada exitosamente."
    else
        return 1
    fi
}

confNvimWindows() {
    print_message $BLUE "Configurando Neovim para Windows..."

    print_message $YELLOW "Descargando Vim-Plug..."
    if pwsh.exe -c "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni $HOME/vimfiles/autoload/plug.vim -Force"; then
        print_message $GREEN "Vim-Plug descargado exitosamente."
    else
        print_message $RED "Error al descargar Vim-Plug."
        return 1
    fi

    local username=$(get_windows_username)
    local ruta_nvim="/mnt/c/Users/$username/AppData/Local/nvim"

    if [ ! -d "$ruta_nvim" ]; then
        print_message $YELLOW "Creando directorio $ruta_nvim..."
        mkdir -p "$ruta_nvim"
    fi

    if check_file_exists "init.vim"; then
        cp ./init.vim "$ruta_nvim/init.vim"
        print_message $GREEN "Configuración de Neovim copiada exitosamente."
    else
        return 1
    fi
}

confTmux() {
    print_message $BLUE "Configurando Tmux..."

    if check_file_exists ".tmux.conf"; then
        cp ./.tmux.conf "$HOME/.tmux.conf"
        print_message $GREEN "Configuración de Tmux copiada exitosamente."
    else
        return 1
    fi
}

confBash() {
    print_message $BLUE "Configurando Bash..."

    local files_copied=0

    if check_file_exists ".bashrc"; then
        cp ./.bashrc "$HOME/.bashrc"
        print_message $GREEN "Archivo .bashrc copiado exitosamente."
        ((files_copied++))
    fi

    if check_file_exists ".bash_aliases"; then
        cp ./.bash_aliases "$HOME/.bash_aliases"
        print_message $GREEN "Archivo .bash_aliases copiado exitosamente."
        ((files_copied++))
    fi

    if [ $files_copied -eq 0 ]; then
        print_message $RED "No se encontraron archivos de configuración de Bash."
        return 1
    fi

    print_message $GREEN "Configuración de Bash completada."
}

confWezterm() {
    print_message $BLUE "Configurando WezTerm..."

    if ! check_file_exists ".wezterm.lua"; then
        return 1
    fi

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username"

    if cp ./.wezterm.lua "$destino/.wezterm.lua"; then
        print_message $GREEN "Configuración de WezTerm copiada exitosamente a $destino/"
    else
        print_message $RED "Error al copiar el archivo de WezTerm."
        return 1
    fi
}

confPowerShell() {
    print_message $BLUE "Configurando PowerShell..."

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username/Documents/PowerShell"
    local file="Microsoft.PowerShell_profile.ps1"

    if [ ! -d "$destino" ]; then
        print_message $YELLOW "Creando directorio $destino..."
        mkdir -p "$destino"
    fi

    if check_file_exists "$file"; then
        cp "./$file" "$destino/$file"
        print_message $GREEN "Configuración de PowerShell copiada exitosamente."
    else
        return 1
    fi
}

confFish() {
    print_message $BLUE "Configurando Fish..."

    local ruta_fish="$HOME/.config/fish/"

    if [ ! -d "$ruta_fish" ]; then
        print_message $YELLOW "Creando directorio $ruta_fish..."
        mkdir -p "$ruta_fish"
    fi

    if check_file_exists "conf.fish"; then
        cp conf.fish "$ruta_fish/conf.fish"
        print_message $GREEN "Configuración de Fish copiada exitosamente."
    else
        return 1
    fi
}

resetConfigNvim() {
    print_message $YELLOW "Reseteando configuración de Neovim..."

    local dirs=(
        "$HOME/.config/nvim"
        "$HOME/.local/state/nvim"
        "$HOME/.local/share/nvim"
        "$HOME/.cache/nvim"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            print_message $GREEN "Eliminado: $dir"
        fi
    done

    print_message $GREEN "Configuración de Neovim reseteada exitosamente."
}

show_menu() {
    echo -e "\n${BLUE}=== Configurador de Herramientas de Desarrollo ===${NC}"
    echo -e "${YELLOW}a)${NC} Vim"
    echo -e "${YELLOW}b)${NC} Neovim (Linux)"
    echo -e "${YELLOW}c)${NC} Neovim (Windows)"
    echo -e "${YELLOW}d)${NC} Tmux"
    echo -e "${YELLOW}e)${NC} Fish"
    echo -e "${YELLOW}f)${NC} Bash"
    echo -e "${YELLOW}g)${NC} WezTerm"
    echo -e "${YELLOW}h)${NC} PowerShell"
    echo -e "${YELLOW}i)${NC} Reset Neovim"
    echo -e "${YELLOW}q)${NC} Salir"
    echo -e "${BLUE}===============================================${NC}"
}

#-----------------------------------------
# MAIN
#-----------------------------------------

main() {
    # Verificar que estamos en el directorio correcto
    if [ ! -f ".vimrc" ] && [ ! -f "init.vim" ] && [ ! -f ".tmux.conf" ]; then
        print_message $RED "Error: No se encontraron archivos de configuración en el directorio actual."
        print_message $YELLOW "Asegúrate de ejecutar este script desde el directorio que contiene los archivos de configuración."
        exit 1
    fi

    while true; do
        show_menu
        read -p "Selecciona una opción: " opc

        case "$opc" in
            a|A)
                confVim
                ;;
            b|B)
                confNvimLinux
                ;;
            c|C)
                confNvimWindows
                ;;
            d|D)
                confTmux
                ;;
            e|E)
                confFish
                ;;
            f|F)
                confBash
                ;;
            g|G)
                confWezterm
                ;;
            h|H)
                confPowerShell
                ;;
            i|I)
                resetConfigNvim
                ;;
            q|Q)
                print_message $GREEN "¡Hasta luego!"
                exit 0
                ;;
            *)
                print_message $RED "Opción inválida. Intenta de nuevo."
                ;;
        esac

        echo
        read -p "Presiona Enter para continuar..."
    done
}

# Ejecutar el script principal
main "$@"
