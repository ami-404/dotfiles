#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias q='exit'
PS1='[\u@\h \W]\$ '
# eval "$(starship init bash)"

. "/home/ameen/.deno/env"

# pnpm
export PNPM_HOME="/home/ameen/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
