confVim() {
  echo "Cargando Vim-Plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo
  echo "Cargando configuracion de Vim"
  cp ./.vimrc $HOME/.vimrc
}

confNvim() {
  echo "Cargando Vim-Plug..."
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  # Define la ruta de la carpeta que quieres validar
  # Asegúrate de usar comillas si la ruta puede contener espacios
  ruta_nvim="$HOME/.config/nvim/"

  # "si NO es un directorio"
  if [ ! -d "$ruta_nvim" ]; then
    echo "La carpeta '$ruta_nvim' no existe. Creándola..."
    # Creamos la carpeta. La opción -p crea directorios padre si son necesarios
    # y no da error si la carpeta ya existe (aunque ya lo validamos, -p es buena práctica)
    #
    mkdir -p "$ruta_nvim"
  fi

  echo
  echo "Cangando configuracion de Neovim"
  cp ./init.vim $ruta_nvim/init.vim
}

confTmux() {
  echo
  echo "Cangando configuracion de Tmux"
  cp ./.tmux.conf $HOME
}

confBash() {
  echo
  echo "Cangando configuracion de bash"
  cp ./.bashrc $HOME
  cp ./.bash_aliases $HOME
}

confWezterm() {
  echo
  echo "Cargando configuración de WezTerm"

  # Validar que el archivo fuente existe
  if [ ! -f ./.wezterm.lua ]; then
    echo "Error: No se encontró el archivo .wezterm.lua en el directorio actual."
    return 1
  fi

  while true; do
    read -p "¿Cuál es tu nombre de usuario de Windows? " nombreUser
    nombreUser=$(echo "$nombreUser" | xargs) # Elimina espacios al inicio/final
    destino="/mnt/c/Users/$nombreUser"
    if [ -d "$destino" ]; then
      break
    else
      echo "La carpeta $destino no existe. Intenta de nuevo."
    fi
  done

  cp ./.wezterm.lua "$destino/" && \
    echo "Configuración de WezTerm copiada exitosamente a $destino/" || \
    echo "Error al copiar el archivo."
}


confFish() {
  ruta_nvim="$HOME/.config/fish/"

  # "si NO es un directorio"
  if [ ! -d "$ruta_nvim" ]; then
    echo "La carpeta '$ruta_nvim' no existe. Creándola..."
    # Creamos la carpeta. La opción -p crea directorios padre si son necesarios
    # y no da error si la carpeta ya existe (aunque ya lo validamos, -p es buena práctica)
    #
    mkdir -p "$ruta_nvim"
  fi

  echo
  echo "Cangando configuracion de Fish"
  cp conf.fish $ruta_nvim/conf.fish
}

#Leer opcion a elegir (vim o nvim)
read -p "a:vim, b:nvim, c:Tmux, d:Fish e:Bash f:wezterm" opc
# TODO: agregar configuracion para instalar nvim y lo necesario
# TODO agregar configuracion de zathura

case "$opc" in
a)
  confVim
  ;;
b)
  confNvim
  ;;
c)
  confTmux
  ;;
d)
  confFish
  ;;
e)
  confBash
  ;;
f)
  confWezterm
  ;;
*)
  echo default
  ;;
esac
