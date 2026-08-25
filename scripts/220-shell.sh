#!/usr/bin/env bash
set -euo pipefail

echo "==> Configuring interactive Bash environment"

# Ensure mise is available even when this script runs from a shell that has
# not reloaded ~/.bashrc since 30-mise.sh was executed.
export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise >/dev/null 2>&1; then
  echo "ERROR: mise is not installed or not available on PATH."
  echo "Run scripts/30-mise.sh first."
  exit 1
fi

echo "==> Installing shell tools with mise"

mise use --global \
  starship@latest \
  zoxide@latest \
  eza@latest

echo "==> Writing managed Bash configuration"

CONFIG_DIR="$HOME/.config/dev-bootstrap"
SHELL_CONFIG="$CONFIG_DIR/bashrc"

mkdir -p "$CONFIG_DIR"

cat > "$SHELL_CONFIG" <<'EOF'
# Managed by dev-bootstrap/scripts/40-shell.sh

# Better directory listings
alias ls='eza'
alias ll='eza -lah --group-directories-first'
alias la='eza -a'
alias tree='eza --tree'

# Safer and more convenient defaults
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'

# Interactive fuzzy finder defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# GPG terminal integration
if tty -s; then
  export GPG_TTY="$(tty)"
fi

# Managed environment fragments
if [ -d "$HOME/.config/dev-bootstrap/env" ]; then
  for env_file in "$HOME/.config/dev-bootstrap/env/"*.sh; do
    [ -r "$env_file" ] && source "$env_file"
  done
  unset env_file
fi

# Smart directory navigation
eval "$(zoxide init bash)"

# Cross-shell prompt
eval "$(starship init bash)"
EOF

echo "==> Ensuring managed configuration is sourced"

SOURCE_LINE='source "$HOME/.config/dev-bootstrap/bashrc"'

if ! grep -Fqx "$SOURCE_LINE" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

# dev-bootstrap managed shell configuration
source "$HOME/.config/dev-bootstrap/bashrc"
EOF
fi

echo "==> Shell configuration installed"
echo "Open a new shell or run:"
echo
echo "  source ~/.bashrc"