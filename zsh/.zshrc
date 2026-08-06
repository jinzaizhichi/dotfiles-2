# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
# zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# -------------- CUSTOM CONFIG ---------------
# TMOUT=18000
# TRAPALRM() { gitlogue --theme gruvbox -p /Users/mingday/GitHub_WORKSPACE/kubernetes --background=false -s 70 }

mkcd() {
    mkdir -p "$@" && cd "$1"
}

# ---------------------------------------------------------------------------------------
# -------------------- Remapping settings --------------------
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey '\e.' insert-last-word
bindkey -s '^f' 'fzf^M'
bindkey -s '^o' 'ranger^M'
bindkey -s '^s' 'ncdu^M'
# -------------------- zstyle settings --------------------
fpath=(~/.config/zsh/completion /opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

setopt NO_GLOBAL_RCS
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "/tmp/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# -------------------- Custom Functions --------------------
function helm-images() {
	helm template . \
		| yq '..|.image? | select(.)' \
		| sort -u
}

function google() {
  open "http://www.google.com/search?q=$1"
}
function mkcd() {
    mkdir -p $1 && cd $1
}

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
# stty -ixon
bindkey '^p' pet-select
# -------------------- Alias settings --------------------
alias proxy="http_proxy=http://127.0.0.1:6152 https_proxy=http://127.0.0.1:6152 all_proxy=socks5://127.0.0.1:6153"
alias sss="sudo lsof -i -n -P"
alias ss="snitch"
alias hosts="sudo vim /etc/hosts"
# alias rm='echo -e "\n\e[1;41mPlease do NOT use the fucking rm command.(use trash FILES instead！)\e[0m\n\nUsage:\n\ntrash-put[tp]           trash files and directories.\ntrash-empty[te]         empty the trashcan(s).\ntrash-list[tl]          list trashed files.\ntrash-restore[tr]       restore a trashed file.\ntrash-rm[trm]           remove individual files from the trashcan." && false'
alias tp='trash-put'
alias te='trash-empty'
# alias tl='trash-list'
alias tr='trash-restore'
alias trm='trash-rm'
alias grep='rg -i'
alias pwdc='pwd | c'
alias pc='pwd | c'
alias tar='gtar'
alias ls="lsd"
alias l='ls -l'
alias ll='lsd -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lls='/bin/ls'
alias ..='cd ../'
alias ../='cd ../'
alias ../../='cd ../../'
alias ../..='cd ../../'
alias ../../../='cd ../../../'
alias ../../..='cd ../../../'
alias vim='setproxy && nvim'
alias v='setproxy && nvim'
alias nv='neovide'
alias vvim='nvim -u NONE'
alias vi='/opt/homebrew/bin/vim'
alias lz='proxy LANG=zh_CN.UTF-8 lazygit'
alias lzd='proxy LANG=zh_CN.UTF-8 lazydocker'
alias vimc='setproxy && cd ~/.config/nvim && vim ~/.config/nvim/init.lua'
alias vimz='proxy vim ~/.zshrc'
alias vimg='vim main.go'
alias setproxy='export http_proxy=http://127.0.0.1:6152 && export https_proxy=http://127.0.0.1:6152 && export all_proxy=socks5://127.0.0.1:6152 '
alias unproxy='unset http_proxy && unset https_proxy && unset all_proxy'
# 手残有时候老是按错
alias s='ls -al'
alias la='lsd -l -a'
alias sub='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias hy='nohup ~/PATH/hysteria client > ~/PATH/logs/hy.log 2>&1 &'
alias hysteria='nohup ~/PATH/hysteria client > /dev/null 2>&1 & ; nohup ~/PATH/hysteria-tun-darwin-10.12-arm64 client -c ./vir_config.json > /dev/null 2>&1 &'
alias cat='bat'
alias ccat='bat -p'
alias chrome='open -a "Google Chrome"'
alias resume='miktex-xelatex resume_photo.tex && open resume_photo.pdf'
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"   --border --multi --info inline-right --marker ▏ --pointer ▌ --prompt '▌ ' --highlight-line --color gutter:-1,selected-bg:238,selected-fg:146,current-fg:189'
alias gitlogs="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gitlog="series"
alias ping='pingu'
alias top='bpytop'
#  brew install kubecolor/tap/kubecolor
alias kubectl=kubecolor
# make completion work with kubecolor
compdef kubecolor=kubectl
alias remotedocker='docker --context remote '
alias jdk8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home'
alias jdk11='export JAVA_HOME=/opt/homebrew/opt/openjdk@11'
alias zz='zoxide'
alias goland='open /Applications/GoLand.app'
alias dotfiles='open https://github.com/AGou-ops/dotfiles'
alias udp2raw='sudo /Users/mingday/path/udp2raw_mp_mac_m1 -c -l0.0.0.0:3333  -r101.69.229.138:8141  -k "passwd" --raw-mode faketcp
'
alias dockerlogs='open http://localhost:9999 && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro -p 9999:8080 amir20/dozzle:latest'
alias history='history -E'
# alias pc='proxychains4'
alias fps='if [[ $(launchctl getenv MTL_HUD_ENABLED) -eq 1 ]]; then launchctl unsetenv MTL_HUD_ENABLED; echo "MTL_HUD_ENABLED turned off"; else launchctl setenv MTL_HUD_ENABLED 1; echo "MTL_HUD_ENABLED turned on"; fi'

alias etcd-ui='java -jar ~/PATH/etcd-workbench-1.1.4.jar'

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias krn="kubectl --kubeconfig ~/.kube/config.rn"
alias c="pbcopy"
alias C="pbcopy"

alias kb="kubebuilder"
alias gitpush="lucky_commit && git push"

alias open="open -a /Applications/Bloom.app "
alias oc="opencode"
alias sz='source ~/.zshrc && rehash'
alias codexx='omx --madmax --high'

#

# ------ alias file collections.
[ -f ~/.config/zsh/aliases/.kubectl_aliases ] && source ~/.config/zsh/aliases/.kubectl_aliases
[ -f ~/.config/zsh/aliases/fubectl.source ] && source ~/.config/zsh/aliases/fubectl.source

# -------------------- PATH settings --------------------
export HISTFILESIZE=9999999999
export HISTSIZE=9999999999
export MASON_PATH="/Users/mingday/.local/share/nvim/mason/bin"
export TABNINE=" ~/.vim/plugged/cmp-tabnine/binaries/4.4.6/aarch64-apple-darwin"
export PSQL="/Library/PostgreSQL/14/bin"
export GOPATH="/Users/mingday/go"
export GOBIN="/Users/mingday/go/bin"
export CARGOBIN="/Users/mingday/.cargo/bin"
export PODMAN="/opt/podman/bin"
export KTOP="${HOME}/.krew/bin"
export ITERM2="/Users/mingday/.iterm2"
export TMUX_SESSION="$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin"
export GNUSED="/opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin"
export PG_HOME="/Library/PostgreSQL/16"
# read man pages use neovim
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export EDITOR='vim --clean'
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export LANG="en_US.UTF-8"
# cheange kubectl editor
export KUBE_EDITOR="/opt/homebrew/bin/nvim --clean"
export ADB_HOME="/Users/mingday/PATH/adb"
export GNU_TAR="/opt/homebrew/opt/gnu-tar/libexec/gnubin"
export BUN_BIN="~/.bun/bin"
export TRASHCLI_BIN="/opt/homebrew/opt/trash-cli/bin"
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export LOCALBIN="/Users/mingday/.local/bin"
# - PATH
export PATH="$LOCALBIN:$JAVA_HOME/bin:$TRASHCLI_BIN:$BUN_BIN:$GNU_TAR:$ITERM2:$ADB_HOME/bin:$PG_HOME/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/openjdk/bin:$GNUSED:/opt/homebrew/opt/curl/bin:/opt/homebrew/opt/ruby/bin:/Users/mingday/PATH/bin:/Users/mingday/PATH:$LUALSP:$TABNINE:$PATH:$MASON_PATH:$PSQL:$GOBIN:$CARGOBIN:$PODMAN:$KTOP:$TMUX_SESSION:/Users/mingday/Library/Python/3.9/bin"
# -------------- ls colors theme --------------
# vivid install required.( brew install vivid )
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/molokai.yml)"
export TERM=xterm-256color

export GOINSECURE=gitlab.info.dbappsecurity.com.cn

export K9S_CONFIG_DIR=/Users/mingday/.config/k9s

# -------------------- Other settings --------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# eval "$(zoxide init zsh)"
# eval "$(assh completion zsh)"

eval $(thefuck --alias)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/Users/mingday/.bun/_bun" ] && source "/Users/mingday/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# pnpm
export PNPM_HOME="/Users/mingday/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
(( ! ${+functions[p10k]} )) || p10k finalize

[[ -s "/Users/mingday/.gvm/scripts/gvm" ]] && source "/Users/mingday/.gvm/scripts/gvm"

alias gf=gf

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# mimocode
export PATH=/Users/mingday/.mimocode/bin:$PATH

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi


# Added by Antigravity CLI installer
export PATH="/Users/mingday/.local/bin:$PATH"

# ---------------------------------------------------------
# Custom DNS switching function & completion
# ---------------------------------------------------------
function dns() {
    local service
    local iface
    iface=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
    if [[ -n "$iface" ]]; then
        service=$(networksetup -listnetworkserviceorder | grep -B 1 "Device: $iface" | head -n 1 | sed -E 's/^\([0-9]+\) (.*)/\1/')
    fi
    if [[ -z "$service" ]]; then
        service="Wi-Fi"
    fi

    case "$1" in
        public|pub)
            echo "✅ 正在设置 $service DNS 为: 223.6.6.6 114.114.114.114"
            networksetup -setdnsservers "$service" 223.6.6.6 114.114.114.114
            ;;
        company|com)
            echo "✅ 正在设置 $service DNS 为: 10.20.120.150"
            networksetup -setdnsservers "$service" 10.20.120.150
            ;;
        clear|empty)
            echo "✅ 正在清空 $service DNS (使用 DHCP 获取)"
            networksetup -setdnsservers "$service" "Empty"
            ;;
        status|show|"")
            echo "ℹ️ 当前 $service DNS:"
            networksetup -getdnsservers "$service"
            ;;
        *)
            echo "❌ 未知参数: $1"
            echo "💡 用法: dns [public|pub|company|com|clear|status]"
            return 1
            ;;
    esac
}

function _dns_completion() {
    local -a commands
    commands=(
        'public:设置 DNS 为公网 (223.6.6.6, 114.114.114.114)'
        'pub:设置 DNS 为公网的缩写'
        'company:设置 DNS 为公司内部 (10.20.120.150)'
        'com:设置 DNS 为公司内部的缩写'
        'clear:清空自定义 DNS，恢复 DHCP 获取'
        'status:查看当前 DNS'
    )
    _describe 'command' commands
}
compdef _dns_completion dns
