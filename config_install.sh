#!/bin/bash

# Script de configuración inicial para Ubuntu
# Autor: UzzielSW
# Versión: 1.0
# Descripción: Automatiza la configuración inicial de Ubuntu después de una instalación limpia

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
USERNAME=$(whoami)
HOME_DIR="/home/$USERNAME"

# Función para imprimir mensajes con colores
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Función para imprimir títulos de sección
print_section() {
    local title=$1
    echo -e "\n${PURPLE}=== $title ===${NC}"
}

# Función para confirmar instalación
confirm_install() {
    local package=$1
    read -p "¿Deseas instalar $package? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para validar si una herramienta está instalada (verde si está, omite instalación)
is_installed() {
    local name=$1
    local cmd=$2

    if command_exists "$cmd"; then
        print_message $GREEN "✓ $name ya está instalado."
        return 0
    fi
    return 1
}

# Función para actualizar el sistema
update_system() {
    print_section "ACTUALIZANDO SISTEMA"

    print_message $BLUE "Actualizando lista de paquetes..."
    sudo apt update

    print_message $BLUE "Actualizando paquetes del sistema..."
    sudo apt upgrade -y

    print_message $GREEN "✓ Sistema actualizado correctamente"
}

# Función para instalar paquetes básicos del sistema
install_basic_packages() {
    print_section "INSTALANDO PAQUETES BÁSICOS"

    local packages=(
        "build-essential"
        "unzip"
        "sqlite3"
        "curl"
        "wget"
        "git"
        "htop"
        "tree"
        "fzf"
        "ripgrep"
        "fd-find"
        "zathura"
				"git-delta"
				"jq" # JSON processor. Permite filtrar, transformar y manipular JSON.
				"yq" # YAML processor. Permite filtrar, transformar y manipular YAML.
				"bat" # Cat clone. Permite ver archivos de forma mas legible.
    )

    local to_install=()
    for pkg in "${packages[@]}"; do
        if dpkg -s "$pkg" &>/dev/null; then
            print_message $GREEN "✓ $pkg ya está instalado"
        else
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        print_message $BLUE "Instalando paquetes básicos pendientes..."
        sudo apt install -y "${to_install[@]}"
        print_message $GREEN "✓ Paquetes básicos instalados correctamente"
    else
        print_message $GREEN "✓ Todos los paquetes básicos ya estaban instalados"
    fi
}

# Función para configurar Git
setup_git() {
    print_section "CONFIGURANDO GIT"

    if is_installed "Git" "git"; then
        return
    fi

    if confirm_install "configuración de Git"; then
        print_message $BLUE "Configurando Git..."

        git config --global user.name "UzzielSW"
        git config --global user.email "brayanpuyol@gmail.com"
        git config --global init.defaultBranch main
        git config --global pull.rebase false
        git config --global core.editor "nvim"

				# Configuración de delta:
				git config --global core.pager "delta"
				git config --global interactive.singlekey true
				git config --global delta.navigate true
				git config --global delta.light false
				git config --global delta.line-numbers true
				git config --global delta.side-by-side false

        print_message $GREEN "✓ Git configurado correctamente"
    else
        print_message $YELLOW "Configuración de Git omitida"
    fi
}

# Función para instalar y configurar FNM
setup_fnm() {
    print_section "INSTALANDO FNM (Fast Node Manager)"

    if is_installed "FNM" "fnm"; then
        return
    fi

    if confirm_install "FNM (Fast Node Manager)"; then
        print_message $BLUE "Instalando FNM..."

        curl -fsSL https://fnm.vercel.app/install | bash

        print_message $GREEN "✓ FNM instalado correctamente"
    else
        print_message $YELLOW "Instalación de FNM omitida"
    fi
}

# Función para instalar Fish, Oh My Fish y plugin pj
setup_fish() {
    print_section "INSTALANDO FISH SHELL Y OH MY FISH"

    if is_installed "Fish" "fish"; then
        return
    fi

    if confirm_install "Fish shell con Oh My Fish y plugin pj"; then
        print_message $BLUE "Instalando Fish..."
        sudo apt install -y fish

        print_message $BLUE "Instalando Oh My Fish (modo no interactivo, sin abrir Fish)..."
        local omf_install
        omf_install=$(mktemp)
        curl -sL -o "$omf_install" https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
        fish "$omf_install" --noninteractive --yes
        rm -f "$omf_install"

        print_message $BLUE "Instalando plugin pj..."
        fish -c "omf install pj"

        print_message $GREEN "✓ Fish shell con Oh My Fish y plugin pj instalados correctamente"
    else
        print_message $YELLOW "Instalación de Fish omitida"
    fi
}

# Función para instalar Lazygit
install_lazygit() {
    print_section "INSTALANDO LAZYGIT"

    if is_installed "Lazygit" "lazygit"; then
        return
    fi

    if confirm_install "Lazygit (cliente TUI para Git)"; then
        print_message $BLUE "Descargando Lazygit..."

        local tmp_lazygit=$(mktemp -d)
        local lazygit_version
        lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed -n 's/.*"v\([^"]*\)".*/\1/p')

        if [ -z "$lazygit_version" ]; then
            print_message $RED "✗ No se pudo obtener la versión de Lazygit"
            return 1
        fi

        curl -sLo "$tmp_lazygit/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
        tar -xzf "$tmp_lazygit/lazygit.tar.gz" -C "$tmp_lazygit" lazygit
        sudo install "$tmp_lazygit/lazygit" -D -t /usr/local/bin/
        rm -rf "$tmp_lazygit"

        print_message $GREEN "✓ Lazygit instalado correctamente"
    else
        print_message $YELLOW "Instalación de Lazygit omitida"
    fi
}

# Función para instalar Yazi
install_yazi() {
    print_section "INSTALANDO YAZI"

    if is_installed "Yazi" "yazi"; then
        return
    fi

    if confirm_install "Yazi (terminal file manager)"; then
        print_message $BLUE "Descargando Yazi..."

        local tmp_yazi=$(mktemp -d)
        local yazi_version
        yazi_version=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | grep '"tag_name"' | sed -n 's/.*"v\([^"]*\)".*/\1/p')

        if [ -z "$yazi_version" ]; then
            print_message $RED "✗ No se pudo obtener la versión de Yazi"
            return 1
        fi

        curl -sLo "$tmp_yazi/yazi.zip" "https://github.com/sxyazi/yazi/releases/download/v${yazi_version}/yazi-x86_64-unknown-linux-gnu.zip"
        unzip -q "$tmp_yazi/yazi.zip" -d "$tmp_yazi"

        sudo mv "$tmp_yazi/yazi-x86_64-unknown-linux-gnu/yazi" /usr/local/bin/
        sudo mv "$tmp_yazi/yazi-x86_64-unknown-linux-gnu/ya" /usr/local/bin/

        rm -rf "$tmp_yazi"

        print_message $GREEN "✓ Yazi instalado correctamente"
    else
        print_message $YELLOW "Instalación de Yazi omitida"
    fi
}

# Función para instalar Homebrew
setup_homebrew() {
    print_section "INSTALANDO HOMEBREW"

    if is_installed "Homebrew" "brew"; then
        return
    fi

    if confirm_install "Homebrew (gestor de paquetes)"; then
        print_message $BLUE "Instalando Homebrew..."

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Configurar Homebrew en el shell actual
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # Agregar configuración al .bashrc
        if ! grep -q "Homebrew" "$HOME_DIR/.bashrc"; then
            echo "" >> "$HOME_DIR/.bashrc"
            echo "# Homebrew Configuration" >> "$HOME_DIR/.bashrc"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME_DIR/.bashrc"
        fi

        print_message $GREEN "✓ Homebrew instalado correctamente"

        # Instalar Neovim con Homebrew
        if is_installed "Neovim" "nvim"; then
            :
        elif confirm_install "Neovim desde Homebrew"; then
            print_message $BLUE "Instalando Neovim..."
            brew install neovim
            print_message $GREEN "✓ Neovim instalado correctamente"
        fi

        if is_installed "pnpm" "pnpm"; then
            :
        elif confirm_install "pnpm desde Homebrew"; then
            print_message $BLUE "Instalando pnpm..."
            brew install pnpm
            print_message $GREEN "✓ pnpm instalado correctamente"
        fi

    else
        print_message $YELLOW "Instalación de Homebrew omitida"
    fi
}

# Función para configuración Full Linux (solo aplicable en SO Linux nativo, no WSL)
setup_full_linux() {
    print_section "CONFIGURACIÓN FULL LINUX"

    if is_installed "Docker" "docker"; then
        return
    fi

    if confirm_install "configuración Full Linux (instalación de Docker)"; then
        print_message $BLUE "Set up Docker's apt repository..."

        print_message $BLUE "Añadiendo la clave GPG oficial de Docker..."
        sudo apt update
        sudo apt install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        print_message $BLUE "Añadiendo el repositorio a las fuentes de Apt..."
        sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

        sudo apt update

        print_message $BLUE "Instalando los paquetes de Docker..."
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        print_message $GREEN "✓ Docker instalado correctamente"

        print_message $BLUE "Verificando que Docker está en ejecución..."
        sudo systemctl status docker

        # Añadir usuario al grupo docker para usar Docker sin sudo
        sudo usermod -aG docker "$USERNAME"
        print_message $GREEN "✓ Usuario $USERNAME añadido al grupo docker"
        print_message $YELLOW "Para aplicar cambios de Docker: newgrp docker (o cierra sesión y vuelve a entrar)"
    else
        print_message $YELLOW "Configuración Full Linux omitida"
    fi
}

# Función para crear directorios de desarrollo
setup_dev_directories() {
    print_section "CREANDO DIRECTORIOS DE DESARROLLO"

    local dev_dirs=(
        "$HOME_DIR/Documents"
        "$HOME_DIR/.config"
    )

    for dir in "${dev_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_message $GREEN "✓ Directorio creado: $dir"
        else
            print_message $BLUE "✓ Directorio ya existe: $dir"
        fi
    done
}

# Función para limpieza final del sistema
cleanup_system() {
    print_section "LIMPIEZA FINAL"

    print_message $BLUE "Limpiando caché de paquetes..."
    sudo apt clean

    print_message $BLUE "Eliminando paquetes no utilizados..."
    sudo apt autoremove -y

    print_message $GREEN "✓ Limpieza completada"
}

# Función para mostrar resumen/validación de la instalación
show_summary() {
    print_section "VALIDACIÓN DE INSTALACIONES"

    echo -e "${GREEN}===============================================================${NC}"
    echo -e "${GREEN}          CONFIGURACIÓN DE UBUNTU COMPLETADA                    ${NC}"
    echo -e "${GREEN}===============================================================${NC}"
    echo
    echo -e "${CYAN}Estado de las herramientas:${NC}"

    # Validar paquetes básicos
    local basic_packages=(
        "build-essential"
        "unzip"
        "sqlite3"
        "curl"
        "wget"
        "git"
        "htop"
        "tree"
        "fzf"
        "ripgrep"
        "fd-find"
        "zathura"
        "git-delta"
        "jq"
        "yq"
        "bat"
    )
    for pkg in "${basic_packages[@]}"; do
        if dpkg -s "$pkg" &>/dev/null; then
            print_message $GREEN "  ✓ $pkg instalado"
        else
            print_message $RED "  ✗ $pkg NO instalado"
        fi
    done

    # Validar herramientas instaladas por binario
    local tools=(
        "fnm"
        "fish"
        "lazygit"
        "yazi"
        "brew"
        "nvim"
        "pnpm"
        "docker"
    )

    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_message $GREEN "  ✓ $tool instalado"
        else
            print_message $RED "  ✗ $tool NO instalado"
        fi
    done

    # docker compose se valida de forma especial (es subcomando de docker)
    if docker compose version &>/dev/null; then
        print_message $GREEN "  ✓ docker compose instalado"
    else
        print_message $RED "  ✗ docker compose NO instalado"
    fi

    echo -e "${GREEN}===============================================================${NC}"
}

# Función principal
main() {
    print_message $CYAN "🚀 Iniciando configuración automática de Ubuntu..."
    print_message $YELLOW "Este script configurará tu entorno de desarrollo personalizado"
    echo

    # Verificar que estamos en Ubuntu
    if ! command_exists apt; then
        print_message $RED "Error: Este script solo funciona en sistemas basados en Debian/Ubuntu"
        exit 1
    fi

    # Verificar permisos de sudo
    if ! sudo -n true 2>/dev/null; then
        print_message $YELLOW "Se te pedirá tu contraseña para instalar paquetes del sistema"
    fi

    # Ejecutar configuración paso a paso
    update_system
    install_basic_packages
    setup_git
    setup_fnm
    setup_fish
    install_lazygit
    install_yazi
    setup_homebrew
    setup_full_linux
    setup_dev_directories
    cleanup_system

    show_summary
}

# Ejecutar script principal
main "$@"
