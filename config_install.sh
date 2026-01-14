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
NVM_VERSION="v0.40.3"
NODE_LTS_VERSION="22.11.0"

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
        "vim"
        "htop"
        "tree"
        "fzf"
        "ripgrep"
        "fd-find"
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
        git config --global core.editor "vim"

        print_message $GREEN "✓ Git configurado correctamente"
    else
        print_message $YELLOW "Configuración de Git omitida"
    fi
}

# Función para instalar y configurar NVM
setup_nvm() {
    print_section "INSTALANDO NVM Y NODE.JS"

    if confirm_install "NVM (Node Version Manager)"; then
        print_message $BLUE "Descargando NVM..."

        # Descargar e instalar NVM
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

        # Configurar NVM en el shell actual
        export NVM_DIR="$HOME_DIR/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # Agregar configuración al .bashrc
        if ! grep -q "NVM_DIR" "$HOME_DIR/.bashrc"; then
            echo "" >> "$HOME_DIR/.bashrc"
            echo "# NVM Configuration" >> "$HOME_DIR/.bashrc"
            echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME_DIR/.bashrc"
            echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME_DIR/.bashrc"
            echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> "$HOME_DIR/.bashrc"
        fi

        # Recargar .bashrc
        source "$HOME_DIR/.bashrc"

        # Verificar instalación
        if command_exists nvm; then
            print_message $GREEN "✓ NVM instalado correctamente"

            print_message $BLUE "Instalando Node.js LTS ($NODE_LTS_VERSION)..."
            nvm install "$NODE_LTS_VERSION"
            nvm use "$NODE_LTS_VERSION"
            nvm alias default "$NODE_LTS_VERSION"

            print_message $GREEN "✓ Node.js $NODE_LTS_VERSION instalado y configurado"
        else
            print_message $RED "✗ Error al instalar NVM"
            return 1
        fi
    else
        print_message $YELLOW "Instalación de NVM omitida"
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
    else
        print_message $YELLOW "Instalación de Homebrew omitida"
    fi
}

# Función para instalar herramientas adicionales
install_additional_tools() {
    print_section "INSTALANDO HERRAMIENTAS ADICIONALES"

    if confirm_install "herramientas adicionales de desarrollo"; then
        local additional_packages=(
            "docker.io"
            "docker-compose"
            "postgresql-client"
            "redis-tools"
            "jq"
            "yq"
            "bat"
            "tldr"
        )

        print_message $BLUE "Instalando herramientas adicionales..."
        sudo apt install -y "${additional_packages[@]}"

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
        "$HOME_DIR/Downloads"
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

# Función para mostrar resumen de la instalación
show_summary() {
    print_section "RESUMEN DE LA INSTALACIÓN"

    echo -e "${GREEN}Configuración completada exitosamente!${NC}"
    echo
    echo -e "${YELLOW}Próximos pasos recomendados:${NC}"
    echo "1. Reinicia tu terminal o ejecuta: source ~/.bashrc"
    echo "2. Verifica las instalaciones con:"
    echo "   - node --version"
    echo "   - java -version"
    echo "   - brew --version"
    echo "   - nvim --version"
    echo "3. Configura tu editor preferido"
    echo "4. Instala plugins y extensiones necesarias"
    echo
    echo -e "${BLUE}¡Tu entorno de desarrollo está listo!${NC}"
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
    setup_nvm
    setup_java
    setup_homebrew
    install_additional_tools
    setup_dev_directories

    show_summary
}

# Ejecutar script principal
main "$@"