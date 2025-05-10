#Leer opcion a elegir (vim o nvim)
read -p "a:vim, b:nvim " opc

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

  echo
  echo "Cangando configuracion de Neovim"
  cp ./init.vim $HOME/.config/nvim
}

case "$opc" in
a)
  confVim
  ;;
b)
  confNvim
  ;;
*)
  echo default
  ;;
esac
