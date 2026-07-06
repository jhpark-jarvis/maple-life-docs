#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-$HOME/maple-life-docs}"
VENV_NAME="${VENV_NAME:-maple-life-docs-venv}"
FALLBACK_VENV_DIR="${FALLBACK_VENV_DIR:-$PROJECT_DIR/.venv}"

echo "[1/5] move to project directory"
cd "$PROJECT_DIR"

echo "[2/5] update source"
git pull --ff-only

echo "[3/5] activate virtualenv"
if command -v workon >/dev/null 2>&1; then
  workon "$VENV_NAME"
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  set +u
  export ZSH_VERSION="${ZSH_VERSION-}"
  source /usr/local/bin/virtualenvwrapper.sh
  workon "$VENV_NAME"
  set -u
elif [ -d "$HOME/.virtualenvs/$VENV_NAME" ]; then
  source "$HOME/.virtualenvs/$VENV_NAME/bin/activate"
elif [ -d "$FALLBACK_VENV_DIR" ]; then
  source "$FALLBACK_VENV_DIR/bin/activate"
else
  echo "virtualenv not found."
  echo "expected workon env: $VENV_NAME"
  echo "fallback path: $FALLBACK_VENV_DIR"
  exit 1
fi

echo "[4/5] install dependencies"
pip install -r requirements.txt

echo "[5/5] validate Flask + Cloudflare backend mode"
export FLASK_APP=run.py
flask cloudflare-check

echo
echo "PythonAnywhere refresh complete."
echo "Next step: open the Web tab and click Reload."
