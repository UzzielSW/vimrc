# Instalación de Fish y Plugins oh-my-fish
# sudo apt install fish -y
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
# omf install pj #saltar entre proyectos [Inv.]

if status is-interactive
    alias v nvim
    alias q exit
    alias c clear
    alias W 'cd /mnt/c/Users/USUARIO/'
    alias l ls
    alias ll 'ls -alF'
    alias la 'ls -A'
    alias cd. 'cd ..'
    alias cc "$HOME/./conectar_ssh.sh"

end
