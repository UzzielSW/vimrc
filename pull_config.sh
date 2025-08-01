#!/bin/bash

# Script para actualizar los archivos de configuración del repositorio
# con los cambios realizados en la configuración local

pullVim() {
  echo "Actualizando configuración de Vim..."
  if [ -f "$HOME/.vimrc" ]; then
    cp "$HOME/.vimrc" ./.vimrc
    echo "✓ .vimrc actualizado"
  else
    echo "✗ No se encontró $HOME/.vimrc"
  fi
}

pullNvimLinux() {
  echo "Actualizando configuración de Neovim (Linux)..."
  local ruta_nvim="$HOME/.config/nvim/"

  if [ -f "$ruta_nvim/init.vim" ]; then
    cp "$ruta_nvim/init.vim" ./init.vim
    echo "✓ init.vim actualizado"
  else
    echo "✗ No se encontró $ruta_nvim/init.vim"
  fi
}

pullNvimWindows() {
  echo "Actualizando configuración de Neovim (Windows)..."

  while true; do
    read -p "¿Cuál es tu nombre de usuario de Windows? " nombreUser
    nombreUser=$(echo "$nombreUser" | xargs)
    ruta_nvim="/mnt/c/Users/$nombreUser/AppData/Local/nvim"
    if [ -d "$ruta_nvim" ]; then
      break
    else
      echo "La carpeta $ruta_nvim no existe. Intenta de nuevo."
    fi
  done

  if [ -f "$ruta_nvim/init.vim" ]; then
    cp "$ruta_nvim/init.vim" ./init.vim
    echo "✓ init.vim actualizado"
  else
    echo "✗ No se encontró $ruta_nvim/init.vim"
  fi
}

pullTmux() {
  echo "Actualizando configuración de Tmux..."
  if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" ./.tmux.conf
    echo "✓ .tmux.conf actualizado"
  else
    echo "✗ No se encontró $HOME/.tmux.conf"
  fi
}

pullBash() {
  echo "Actualizando configuración de Bash..."
  if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" ./.bashrc
    echo "✓ .bashrc actualizado"
  else
    echo "✗ No se encontró $HOME/.bashrc"
  fi

  if [ -f "$HOME/.bash_aliases" ]; then
    cp "$HOME/.bash_aliases" ./.bash_aliases
    echo "✓ .bash_aliases actualizado"
  else
    echo "✗ No se encontró $HOME/.bash_aliases"
  fi
}

pullWezterm() {
  echo "Actualizando configuración de WezTerm..."

  while true; do
    read -p "¿Cuál es tu nombre de usuario de Windows? " nombreUser
    nombreUser=$(echo "$nombreUser" | xargs)
    destino="/mnt/c/Users/$nombreUser"
    if [ -d "$destino" ]; then
      break
    else
      echo "La carpeta $destino no existe. Intenta de nuevo."
    fi
  done

  if [ -f "$destino/.wezterm.lua" ]; then
    cp "$destino/.wezterm.lua" ./.wezterm.lua
    echo "✓ .wezterm.lua actualizado"
  else
    echo "✗ No se encontró $destino/.wezterm.lua"
  fi
}

pullPowerShell() {
  echo "Actualizando configuración de PowerShell..."

  while true; do
    read -p "¿Cuál es tu nombre de usuario de Windows? " nombreUser
    nombreUser=$(echo "$nombreUser" | xargs)
    destino="/mnt/c/Users/$nombreUser/Documents/PowerShell"
    if [ -d "$destino" ]; then
      break
    else
      echo "La carpeta $destino no existe. Intenta de nuevo."
    fi
  done

  local file="Microsoft.PowerShell_profile.ps1"
  if [ -f "$destino/$file" ]; then
    cp "$destino/$file" ./$file
    echo "✓ $file actualizado"
  else
    echo "✗ No se encontró $destino/$file"
  fi
}

pullFish() {
  echo "Actualizando configuración de Fish..."
  local ruta_fish="$HOME/.config/fish/"

  if [ -f "$ruta_fish/conf.fish" ]; then
    cp "$ruta_fish/conf.fish" ./conf.fish
    echo "✓ conf.fish actualizado"
  else
    echo "✗ No se encontró $ruta_fish/conf.fish"
  fi
}

pullAll() {
  echo "Actualizando todas las configuraciones..."
  pullVim
  pullNvimLinux
  pullTmux
  pullBash
  pullFish
  echo "✓ Todas las configuraciones actualizadas"
}

# Función para configurar rutas personalizadas
pullCustom() {
  echo "Actualizando configuración personalizada..."
  read -p "Ingresa la ruta del archivo de origen: " ruta_origen
  read -p "Ingresa el nombre del archivo de destino en el repositorio: " archivo_destino

  if [ -f "$ruta_origen" ]; then
    cp "$ruta_origen" "./$archivo_destino"
    echo "✓ $archivo_destino actualizado desde $ruta_origen"
  else
    echo "✗ No se encontró $ruta_origen"
  fi
}

#-----------------------------------------
# MAIN
#-----------------------------------------

echo -e "\n=== Script de Actualización de Configuraciones ==="
echo -e "\n a: Vim\n b: Neovim Linux\n c: Neovim Windows\n d: Tmux\n e: Fish\n f: Bash\n g: WezTerm\n h: PowerShell\n i: Todas\n j: Personalizada"
read -p "Opción: " opc

case "$opc" in
a)
  pullVim
  ;;
b)
  pullNvimLinux
  ;;
c)
  pullNvimWindows
  ;;
d)
  pullTmux
  ;;
e)
  pullFish
  ;;
f)
  pullBash
  ;;
g)
  pullWezterm
  ;;
h)
  pullPowerShell
  ;;
i)
  pullAll
  ;;
j)
  pullCustom
  ;;
*)
  echo "Opción no válida"
  ;;
esac

echo -e "\n=== Actualización completada ==="
