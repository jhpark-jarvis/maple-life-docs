#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-$HOME/maple-life-docs}"
VENV_DIR="${VENV_DIR:-$PROJECT_DIR/.venv}"

echo "[1/5] move to project directory"
cd "$PROJECT_DIR"

echo "[2/5] update source"
git pull --ff-only

echo "[3/5] activate virtualenv"
if [ ! -d "$VENV_DIR" ]; then
  echo "virtualenv not found: $VENV_DIR"
  echo "create it first with: python3 -m venv .venv"
  exit 1
fi
source "$VENV_DIR/bin/activate"

echo "[4/5] install dependencies"
pip install -r requirements.txt

echo "[5/5] validate Flask + Cloudflare backend mode"
export FLASK_APP=run.py
flask cloudflare-check

echo
echo "PythonAnywhere refresh complete."
echo "Next step: open the Web tab and click Reload."
