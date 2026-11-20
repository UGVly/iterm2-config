
# Homebrew USTC mirrors
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# Created by `pipx` on 2026-06-30 03:51:04
export PATH="$PATH:$HOME/.local/bin"

# Python version management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - zsh)"

# Per-project environment loading
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Miniforge / conda / mamba
if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
  . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
fi

# >>> Codex comfortable zsh >>>
# History: keep useful commands, share them across terminals, and avoid noise.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS

# Friendly interactive behavior.
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt EXTENDED_GLOB
export CLICOLOR=1
export LESS="-FRX"
export HOMEBREW_NO_ENV_HINTS=1

# Completion with caching, grouped results, and forgiving case matching.
fpath=(/opt/homebrew/share/zsh-completions $fpath)
autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'

# Comfortable line editing and searchable history.
bindkey -e
WORDCHARS=${WORDCHARS//\//}
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Fuzzy file search, history search, and directory switching.
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height=42% --layout=reverse --border=rounded --info=inline --prompt="❯ " --pointer="❯" --marker="✓" --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc,marker:#a6e3a1,spinner:#f5e0dc,header:#94e2d5'
  export FZF_CTRL_T_OPTS="--preview 'if [ -d {} ]; then eza --tree --level=2 --color=always {}; else bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null; fi' --preview-window=right:55%:wrap"
  source <(fzf --zsh)
fi

# Modern navigation and prompt.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
(( $+functions[enable_transience] )) && enable_transience

# Small, memorable shortcuts. Original commands remain available with `command`.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --git --group-directories-first'
  alias la='eza -a --icons=auto --group-directories-first'
  alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias g='git'
alias gs='git status --short --branch'
alias gd='git diff'
alias gl='git log --graph --decorate --oneline --all -20'

mkcd() {
  if (( $# != 1 )); then
    print -u2 'usage: mkcd <directory>'
    return 2
  fi
  mkdir -p -- "$1" && cd -- "$1"
}

# Inline suggestions load before syntax highlighting; highlighting stays last.
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#cba6f7'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#a6e3a1,underline'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
fi
# <<< Codex comfortable zsh <<<
