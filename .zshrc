# === Exports ===
export PATH="$HOME/.local/bin::$PATH"
export VISUAL="vim"
export EDITOR="vim"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WAYLAND_DISPLAY='wayland-1'

if [[ -f "$HOME/.local/share/theme/colors.sh" ]]; then
  source "$HOME/.local/share/theme/colors.sh"

  _eza_hex_to_rgb() {
    local hex="${1#\#}"
    printf '38;2;%d;%d;%d' 0x${hex[1,2]} 0x${hex[3,4]} 0x${hex[5,6]}
  }

  export EZA_COLORS="di=$(_eza_hex_to_rgb "$RED"):fi=$(_eza_hex_to_rgb "$FG"):ln=$(_eza_hex_to_rgb "$BLUE"):ex=$(_eza_hex_to_rgb "$GREEN"):sn=$(_eza_hex_to_rgb "$MAGENTA"):uu=$(_eza_hex_to_rgb "$YELLOW"):gu=$(_eza_hex_to_rgb "$YELLOW"):*.md=$(_eza_hex_to_rgb "$YELLOW")"
fi

# === History ===
HISTFILE=~/.histfile
HISTSIZE=9000
SAVEHIST=9000
setopt autocd extendedglob

# fzf history search on Ctrl-R
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() {
    local selected
    selected=$(
      fc -rl 1 |
        awk '!seen[$0]++' |
        sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' |
        fzf --height=40% --reverse --prompt='History> '
    ) || return
    LBUFFER="$selected"
  }
  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget
fi

zstyle :compinstall filename '/home/tunachip/.zshrc'
autoload -Uz compinit
compinit

# === PROMPT ==
eval "$(starship init zsh)"

# === FUNCTIONS ===
# Auto-manage Python .venv based on current directory
autoload -U add-zsh-hook

_auto_venv() {
  local search="$PWD"
  local found=""
  while [[ "$search" != "/" ]]; do
    if [[ -f "$search/.venv/bin/activate" ]]; then
      found="$search/.venv"
      break
    fi
    search="${search:h}"
  done
  if [[ -n "$found" ]]; then
    if [[ "${VIRTUAL_ENV:-}" != "$found" ]]; then
      if [[ -n "${VIRTUAL_ENV:-}" ]] && typeset -f deactivate >/dev/null 2>&1; then
        deactivate >/dev/null 2>&1 || true
      fi
      source "$found/bin/activate"
    fi
  else
    if [[ -n "${VIRTUAL_ENV:-}" ]] && typeset -f deactivate >/dev/null 2>&1; then
      deactivate >/dev/null 2>&1 || true
    fi
  fi
}
add-zsh-hook chpwd _auto_venv
_auto_venv

# === ALIASES ===

# LS Extensions
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -1'
alias la='eza --icons --group-directories-first -l -A'
alias lf='eza --icons --group-directories-first -f'
alias ld='eza --icons --group-directories-first -D'

# Programs
alias kn='kanata -c ~/.config/kanata/config.kbd'
alias av='source .venv/bin/activate'
alias dav='deactivate'

# Locations
alias dv='cd ~/Development'
alias cf='cd ~/.config'
alias lbin='cd ~/.local/bin'

# Git Actions
alias update='git add .;git commit'

# Config Files
alias kncf='vim ~/.config/kanata/config.kbd'
alias zshcf='vim ~/.zshrc'
alias vimcf='vim ~/.config/vim/'
alias wezcf='vim ~/.config/wezterm/wezterm.lua'
alias nvimcf='vim ~/.config/nvim/'
alias tmuxcf='vim ~/.config/tmux/tmux.conf'
alias swaycf='vim ~/.config/sway/config'
