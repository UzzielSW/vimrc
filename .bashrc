# if [ -z "$TMUX" ]; then
#   exec tmux
# fi

# Si no se está ejecutando de forma interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

# no poner líneas duplicadas o líneas que empiecen con espacio en el historial.
# Ver bash(1) para más opciones
HISTCONTROL=ignoreboth

# agregar al archivo de historial, no sobrescribirlo
shopt -s histappend

# para establecer la longitud del historial ver HISTSIZE y HISTFILESIZE en bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# verificar el tamaño de la ventana después de cada comando y, si es necesario,
# actualizar los valores de LINES y COLUMNS.
shopt -s checkwinsize

# Si está configurado, el patrón "**" usado en un contexto de expansión de nombre de ruta
# coincidirá con todos los archivos y cero o más directorios y subdirectorios.
#shopt -s globstar

# hacer less más amigable para archivos de entrada que no son texto, ver lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# establecer variable que identifica el chroot en el que trabajas (usado en el prompt de abajo)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# establecer un prompt elegante (sin color, a menos que sepamos que "queremos" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# descomentar para un prompt con color, si el terminal tiene la capacidad; desactivado
# por defecto para no distraer al usuario: el enfoque en una ventana de terminal
# debe estar en la salida de comandos, no en el prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Tenemos soporte de color; asumimos que es compatible con Ecma-48
    # (ISO/IEC-6429). (La falta de tal soporte es extremadamente rara, y tal
    # caso tendería a soportar setf en lugar de setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Si esto es un xterm establecer el título a usuario@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# habilitar soporte de color de ls y también agregar alias útiles
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# advertencias y errores de GCC con color
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# importando alias
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# habilitar características de completado programable (no necesitas habilitar
# esto, si ya está habilitado en /etc/bash.bashrc y /etc/profile
# obtiene /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # Esto carga nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Esto carga nvm bash_completion

# configuracion para no usar ./archivo para ejecutar
export PATH=$PATH:.
export EDITOR=vim

# AJUSTAR NOMBRE DE USUARIO
export PBASH=/mnt/c/Users/USUARIO/Documents/Bash/

# configuracion para pegar en modo vi (p/P)
# Pegar desde el portapapeles de Windows con "p" en modo normal
vi_append_clipboard() {
  local content
  content=$(powershell.exe -Command "Get-Clipboard" | sed 's/\r$//' | sed ':a;N;$!ba;s/\n/\r/g')
  READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}$content${READLINE_LINE:READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT + ${#content}))
}

vi_insert_clipboard() {
  local content
  content=$(powershell.exe -Command "Get-Clipboard" | sed 's/\r$//' | sed ':a;N;$!ba;s/\n/\r/g')
  READLINE_LINE="${content}${READLINE_LINE}"
  READLINE_POINT=${#content}
}

# Bind 'p' y 'P' en modo normal (vi)
bind -m vi-command -x '"p": vi_append_clipboard'
bind -m vi-command -x '"P": vi_insert_clipboard'

# export PATH=$PATH:$(go env GOPATH)/bin
