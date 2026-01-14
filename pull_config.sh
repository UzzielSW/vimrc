#!/bin/bash

# Script para actualizar los archivos de configuración del repositorio
# con los cambios realizados en la configuración local
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
        print_message $RED "Error: No se encontró el archivo $file en la configuración local."
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

# Función para copiar archivo con validación
copy_file_with_validation() {
    local source=$1
    local destination=$2
    local description=$3

    if check_file_exists "$source"; then
        if cp "$source" "$destination"; then
            print_message $GREEN "✓ $description actualizado"
            return 0
        else
            print_message $RED "✗ Error al copiar $description"
            return 1
        fi
    else
        return 1
    fi
}

pullVim() {
    print_message $BLUE "Actualizando configuración de Vim..."
    copy_file_with_validation "$HOME/.vimrc" "./.vimrc" ".vimrc"
}

pullNvimLinux() {
    print_message $BLUE "Actualizando configuración de Neovim (Linux)..."
    local ruta_nvim="$HOME/.config/nvim/"
    copy_file_with_validation "$ruta_nvim/init.vim" "./init.vim" "init.vim"
}

pullNvimWindows() {
    print_message $BLUE "Actualizando configuración de Neovim (Windows)..."

    local username=$(get_windows_username)
    local ruta_nvim="/mnt/c/Users/$username/AppData/Local/nvim"

    copy_file_with_validation "$ruta_nvim/init.vim" "./init.vim" "init.vim"
}

pullTmux() {
    print_message $BLUE "Actualizando configuración de Tmux..."
    copy_file_with_validation "$HOME/.tmux.conf" "./.tmux.conf" ".tmux.conf"
}

pullBash() {
    print_message $BLUE "Actualizando configuración de Bash..."

    local files_updated=0

    if copy_file_with_validation "$HOME/.bashrc" "./.bashrc" ".bashrc"; then
        ((files_updated++))
    fi

    if copy_file_with_validation "$HOME/.bash_aliases" "./.bash_aliases" ".bash_aliases"; then
        ((files_updated++))
    fi

    if [ $files_updated -eq 0 ]; then
        print_message $RED "No se pudo actualizar ningún archivo de configuración de Bash."
        return 1
    fi

    print_message $GREEN "Configuración de Bash actualizada exitosamente."
}

pullWezterm() {
    print_message $BLUE "Actualizando configuración de WezTerm..."

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username"

    copy_file_with_validation "$destino/.wezterm.lua" "./.wezterm.lua" ".wezterm.lua"
}

pullPowerShell() {
    print_message $BLUE "Actualizando configuración de PowerShell..."

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username/OneDrive/Documentos/PowerShell"
    local file="Microsoft.PowerShell_profile.ps1"
    copy_file_with_validation "$destino/$file" "./$file" "$file"
}

pullFish() {
    print_message $BLUE "Actualizando configuración de Fish..."
    local ruta_fish="$HOME/.config/fish"

    copy_file_with_validation "$ruta_fish/conf.fish" "./conf.fish" "conf.fish"
}

pullIntelJ() {
    print_message $BLUE "Actualizando configuración de IntelJ..."

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username"

    copy_file_with_validation "$destino/.ideavimrc" "./.ideavimrc" ".ideavimrc"
}

pullCursor() {
    print_message $BLUE "Actualizando configuración de Cursor..."

    local username=$(get_windows_username)
    local destino="/mnt/c/Users/$username"

    # Cursor settings.json
    local cursor_settings_path="$destino/AppData/Roaming/Cursor/User/settings.json"
    local cursor_keybindings_path="$destino/AppData/Roaming/Cursor/User/keybindings.json"

    local files_updated=0

    if copy_file_with_validation "$cursor_settings_path" "./cursor_settings.json" "cursor_settings.json"; then
        ((files_updated++))
    fi

    if copy_file_with_validation "$cursor_keybindings_path" "./cursor_keybindings.json" "cursor_keybindings.json"; then
        ((files_updated++))
    fi

    if [ $files_updated -eq 0 ]; then
        print_message $RED "No se pudo actualizar ningún archivo de configuración de Cursor."
        return 1
    fi

    print_message $GREEN "Configuración de Cursor actualizada exitosamente."
}

pullAll() {
    print_message $BLUE "Actualizando todas las configuraciones..."
    local failed=0
    local failures=()

    for func in pullVim pullNvimLinux pullNvimWindows pullTmux pullFish pullBash pullWezterm pullPowerShell pullIntelJ pullCursor; do
        if ! "$func"; then
            failures+=("$func")
            ((failed++))
        fi
    done

    if [ $failed -eq 0 ]; then
        print_message $GREEN "Todas las configuraciones se actualizaron correctamente. ✅"
        return 0
    else
        print_message $RED "Algunas actualizaciones fallaron ($failed). Funciones con errores: ${failures[*]}"
        return 1
    fi
}

# Función para mostrar el menú principal
show_menu() {
    echo -e "\n${BLUE}=== Script de Actualización de Configuraciones ==="
    echo -e "${YELLOW}a)${NC} Vim"
    echo -e "${YELLOW}b)${NC} Neovim (Linux)"
    echo -e "${YELLOW}c)${NC} Neovim (Windows)"
    echo -e "${YELLOW}d)${NC} Tmux"
    echo -e "${YELLOW}e)${NC} Fish"
    echo -e "${YELLOW}f)${NC} Bash"
    echo -e "${YELLOW}g)${NC} WezTerm"
    echo -e "${YELLOW}h)${NC} PowerShell"
    echo -e "${YELLOW}i)${NC} IntelJ IDEA"
    echo -e "${YELLOW}j)${NC} Cursor (Windows)"
    echo -e "${YELLOW}k)${NC} Todos (Traer todo)"
    echo -e "${YELLOW}q)${NC} Salir"
    echo -e "${BLUE}===============================================${NC}"
} 

# Función para procesar la opción seleccionada
process_option() {
    local option=$1

    case "$option" in
        a|A)
            pullVim
            ;;
        b|B)
            pullNvimLinux
            ;;
        c|C)
            pullNvimWindows
            ;;
        d|D)
            pullTmux
            ;;
        e|E)
            pullFish
            ;;
        f|F)
            pullBash
            ;;
        g|G)
            pullWezterm
            ;;
        h|H)
            pullPowerShell
            ;;
        i|I)
            pullIntelJ
            ;;
        j|J)
            pullCursor
            ;;
        k|K)
            pullAll
            ;;
        q|Q)
            print_message $GREEN "¡Hasta luego!"
            exit 0
            ;;
        *)
            print_message $RED "Opción inválida. Intenta de nuevo."
            ;;
    esac
}

# Función principal
main() {
    # Verificar que estamos en el directorio correcto
    if [ ! -f ".vimrc" ] && [ ! -f "init.vim" ] && [ ! -f ".tmux.conf" ]; then
        print_message $YELLOW "Advertencia: No se encontraron archivos de configuración en el directorio actual."
        print_message $YELLOW "Este script actualizará los archivos del repositorio con la configuración local."
    fi

    while true; do
        show_menu
        read -p "Selecciona una opción: " opc

        process_option "$opc"

        echo
        read -p "Presiona Enter para continuar..."
    done
}

#-----------------------------------------
# MAIN
#-----------------------------------------

# Ejecutar el script principal
main "$@"
