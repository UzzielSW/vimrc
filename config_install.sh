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
				"tldr" # Manual de comandos. Permite ver la documentación de los comandos de forma mas legible.
    )

    print_message $BLUE "Instalando paquetes básicos..."
    sudo apt install -y "${packages[@]}"

    print_message $GREEN "✓ Paquetes básicos instalados correctamente"
}

# Función para configurar Git
setup_git() {
    print_section "CONFIGURANDO GIT"

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

    if confirm_install "FNM (Fast Node Manager)"; then
        print_message $BLUE "Instalando FNM..."

        curl -fsSL https://fnm.vercel.app/install | bash

        print_message $GREEN "✓ FNM instalado correctamente"
    else
        print_message $YELLOW "Instalación de FNM omitida"
    fi
}

# Función para instalar Java
setup_java() {
    print_section "INSTALANDO JAVA"

    if confirm_install "Java Development Kit"; then
        print_message $BLUE "Instalando Java..."

        sudo apt install -y default-jre openjdk-21-jdk

        # Configurar JAVA_HOME
        local java_home=$(readlink -f /usr/bin/java | sed 's:/bin/java::')
        if ! grep -q "JAVA_HOME" "$HOME_DIR/.bashrc"; then
            echo "" >> "$HOME_DIR/.bashrc"
            echo "# Java Configuration" >> "$HOME_DIR/.bashrc"
            echo "export JAVA_HOME=$java_home" >> "$HOME_DIR/.bashrc"
            echo 'export PATH=$JAVA_HOME/bin:$PATH' >> "$HOME_DIR/.bashrc"
        fi

        print_message $GREEN "✓ Java instalado correctamente"
        print_message $BLUE "JAVA_HOME configurado en $java_home"
    else
        print_message $YELLOW "Instalación de Java omitida"
    fi
}

# Función para instalar Fish, Oh My Fish y plugin pj
setup_fish() {
    print_section "INSTALANDO FISH SHELL Y OH MY FISH"

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
        if confirm_install "Neovim desde Homebrew"; then
            print_message $BLUE "Instalando Neovim..."
            brew install neovim
            print_message $GREEN "✓ Neovim instalado correctamente"
        fi

				if confirm_install "pnpm desde Homebrew"; then
						print_message $BLUE "Instalando pnpm..."
						brew install pnpm
						print_message $GREEN "✓ pnpm instalado correctamente"
				fi

    else
        print_message $YELLOW "Instalación de Homebrew omitida"
    fi
}

# Función para instalar herramientas adicionales
install_additional_tools() {
    print_section "INSTALANDO HERRAMIENTAS ADICIONALES"

    if confirm_install "herramientas adicionales de desarrollo"; then


        local additional_packages=(
            "docker.io" # Docker es un contenedor de software que permite a los desarrolladores crear, distribuir y ejecutar aplicaciones en contenedores.
            "docker-compose" # Docker Compose es una herramienta para definir y ejecutar aplicaciones Docker de múltiples contenedores.
            "postgresql-client"
            "redis-tools"
        )

        print_message $BLUE "Instalando herramientas adicionales..."
        sudo apt install -y "${additional_packages[@]}"

        # Añadir usuario al grupo docker (Ubuntu) para usar Docker sin sudo
        if dpkg -l docker.io &>/dev/null; then
            sudo usermod -aG docker "$USERNAME"
            print_message $GREEN "✓ Usuario $USERNAME añadido al grupo docker"
            print_message $YELLOW "Para aplicar cambios de Docker: newgrp docker (o cierra sesión y vuelve a entrar)"
        fi

        print_message $GREEN "✓ Herramientas adicionales instaladas correctamente"
    else
        print_message $YELLOW "Instalación de herramientas adicionales omitida"
    fi
}

# Función para crear directorios de desarrollo
setup_dev_directories() {
    print_section "CREANDO DIRECTORIOS DE DESARROLLO"

    local dev_dirs=(
        "$HOME_DIR/Projects"
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

# Función para mostrar resumen de la instalación
show_summary() {
    print_section "RESUMEN DE LA INSTALACIÓN"

    echo -e "${GREEN}===============================================================${NC}"
    echo -e "${GREEN}          CONFIGURACIÓN DE UBUNTU COMPLETADA                    ${NC}"
    echo -e "${GREEN}===============================================================${NC}"
    echo
    echo -e "${CYAN}Herramientas configuradas / instaladas:${NC}"
    echo "  - Sistema actualizado"
    echo "  - Paquetes básicos (build-essential, curl, wget, git, vim, htop, tree, fzf, ripgrep, fd-find, zathura)"
    echo "  - Git (si aceptaste)"
    echo "  - FNM (si aceptaste)"
    echo "  - Java JDK (si aceptaste)"
    echo "  - Fish shell, Oh My Fish y plugin pj (si aceptaste)"
    echo "  - Lazygit (si aceptaste)"
    echo "  - Yazi (si aceptaste)"
    echo "  - Homebrew y Neovim (si aceptaste)"
    echo "  - Herramientas adicionales: Docker, postgresql-client, redis-tools (si aceptaste)"
    echo "  - Directorios de desarrollo"
    echo "  - Limpieza de caché y paquetes no utilizados"
    echo
    echo -e "${YELLOW}Próximos pasos recomendados:${NC}"
    echo "1. Reinicia tu terminal o ejecuta: source ~/.bashrc"
    echo "2. Si instalaste Docker: ejecuta \`newgrp docker\` para usar Docker sin sudo"
    echo "3. Verifica instalaciones: fnm --version, java -version, brew --version, nvim --version, lazygit --version, yazi --version"
    echo
    echo -e "${BLUE}¡Tu entorno de desarrollo en Ubuntu está listo!${NC}"
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
    setup_java
    setup_fish
    install_lazygit
    install_yazi
    setup_homebrew
    install_additional_tools
    setup_dev_directories
    cleanup_system

    show_summary
}

# Ejecutar script principal
main "$@"
