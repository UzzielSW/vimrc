export PATH="$PATH:/opt/nvim-linux64/bin"

# ejecutar tmux desde que se inicia la terminal
# if [ -z "$TMUX" ]; then
#   exec tmux
# fi

# Si no se ejecuta de forma interactiva, no haga nada.
case $- in
*i*) ;;
*) return ;;
esac

# No incluyas líneas duplicadas ni líneas que empiecen con un espacio en el historial.
HISTCONTROL=ignoreboth

# añadir al archivo de historial, no sobrescribirlo
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Comprueba el tamaño de la ventana después de cada comando y, si es necesario, actualiza los valores de LINES y COLUMNS.
shopt -s checkwinsize

# Si se establece, el patrón «**» utilizado en un contexto de expansión de ruta coincidirá con todos los archivos y cero o más directorios y subdirectorios.
shopt -s globstar

# Hacer que less sea más fácil de usar para archivos de entrada que no son de texto
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Establecer la variable que identifica el chroot en el que se trabaja (utilizada en el indicador siguiente)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Establecer un indicador elegante (sin color, a menos que sepamos que «queremos» color).
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
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

# Si se trata de un xterm, establece el título como usuario@host:dir.
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# importando alias
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# configuracion para no usar ./archivo para ejecutar
export PATH=$PATH:.
# export PBASH=/mnt/c/Users/USUARIO/Documents/Bash/
export EDITOR=vim

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
