function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.

# zsh syntax highlighting
if [[ ! -e ~/.config/zsh/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
  zcompile-many ~/.config/zsh/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi

# zsh autosuggestion
if [[ ! -e ~/.config/zsh/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh/zsh-autosuggestions
  zcompile-many ~/.config/zsh/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi

# zsh powerlevel10k
if [[ ! -e ~/.config/zsh/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
  make -C ~/.config/zsh/powerlevel10k pkg
fi

# zsh fzf-tab
if [[ ! -e ~/.config/zsh/fzf-tab ]]; then
  git clone https://github.com/Aloxaf/fzf-tab ~/.config/zsh/fzf-tab
fi

# zsh omz git
if [[ ! -e ~/.config/zsh/git.zsh ]]; then
  curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/git/git.plugin.zsh > ~/.config/zsh/git.zsh
fi


# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile-many ~/.zcompdump
unfunction zcompile-many


# copy .zshrc in directory

cp ~/.zshrc ~/.config/zsh/zshrc

# history file
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
export KUBECONFIG=/home/lollo/.kube/config
export EDITOR=nvim
bindkey -e


# HISTORY
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.
# END HISTORY


# aliases
alias c="clear"
alias duu="du --max-depth=1 -h"
alias l="eza -ahl"
alias ls="eza"
alias lsblk="lsblk -o NAME,FSTYPE,SIZE,FSUSED,LABEL,MOUNTPOINT,RM,RO,UUID"
alias tree='tree -a -I .git'
alias k=kubectl
# alias v="nvim"

# git
alias g="git"
alias gs="git status"
alias ga="git add -A"
alias gc="git commit"
alias gp="git push origin master"


# lfs
export LFS=/mnt/lfs


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
path=('/home/leo/.local/bin' $path)
path=('/home/leo/ardu/ardupilot/Tools/autotest' $path)
path=('/usr/lib/ccache/bin' $path)

# export to sub-processes (make it inherited by child processes)
export PATH


# fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--layout=reverse --border left"

# tab completions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -U compinit; compinit
source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# autojump
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#727169,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Load plugins.
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh
source ~/.config/zsh/kubectl.zsh
source ~/.config/zsh/git.zsh
#source ~/.kbd.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# functions
function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    while true; do
        sleep "${sec:?}" && echo "${msg:?}" && notify-send -u critical -t 0 "${msg:?}"
    done
}

function v(){
  if [ -d "$1" ]; then
    cd "$1"; ls
  elif [ -z "$1" ]; then
    nvim
  else
    nvim "$1"
  fi
}

