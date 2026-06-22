# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.local/bin:$PATH"

# directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if not exists
# if [ ! -d "$ZINIT_HOME" ]; then
#   mkdir -p "$(dirname $ZINIT_HOME)"
#   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# fi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

############################Abbreviations#################################################
# declare a list of expandable aliases to fill up later
typeset -a ealiases
ealiases=()

# write a function for adding an alias to the list mentioned above
function abbrev-alias() {
    alias $1
    ealiases+=(${1%%\=*})
}

# expand any aliases in the current line buffer
function expand-ealias() {
    if [[ $LBUFFER =~ "\<(${(j:|:)ealiases})\$" ]]; then
        zle _expand_alias
        zle expand-word
    fi
    zle magic-space
}
zle -N expand-ealias

# Bind the space key to the expand-alias function above, so that space will expand any expandable aliases
bindkey ' '        expand-ealias
bindkey '^ '       magic-space     # control-space to bypass completion
bindkey -M isearch " "      magic-space     # normal space during searches

# A function for expanding any aliases before accepting the line as is and executing the entered command
expand-alias-and-accept-line() {
    expand-ealias
    zle .backward-delete-char
    zle .accept-line
}
zle -N accept-line expand-alias-and-accept-line

#############################################################################

# sors
source "${ZINIT_HOME}/zinit.zsh"

# add powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# extra snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# load zsh-completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bindkey -v
bindkey -e

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -M viins 'jj' vi-cmd-mode

bindkey -s '^[[1;5D' '\eb'
bindkey -s '^[[1;5C' '\ef'

bindkey '^H' backward-kill-word
bindkey "^[[3~" delete-char

export KEYTIMEOUT=20

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' 
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# abbravations
abbrev-alias mk="mkdir -p"
abbrev-alias g="git"
abbrev-alias ga="git add ."
abbrev-alias gcb="git checkout --branch"
abbrev-alias gc="git commit -m "
abbrev-alias ll="ls -lA"

# alias
alias ls='ls --color'
alias c='clear'
alias q='exit'
alias t='tmux'
alias matrix='cmatrix -s -C blue'
alias s='yay -Ss'
alias i='yay -Si'
alias I='yay -S'
alias e='yazi'
alias lsa='ls -la'
alias n='nvim-web'
alias v='nvim'
alias ..="cd .."
alias ...="cd ../.."

alias nvim-old="NVIM_APPNAME=nvimO nvim"
alias nvim-web="NVIM_APPNAME=nvimW nvim"
alias nvimw="NVIM_APPNAME=nvimW nvim"

alias peaclock="peaclock --config-dir ~/.config/peaclock"

function nvims() {
  items=("default" "nvimO" "nvimW")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"
bindkey -s ^n "n\n"
bindkey -s ^e "y\n"
bindkey -s ^b "tmux\n"
bindkey -s ^v "nvim\n"

# shell integration
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
