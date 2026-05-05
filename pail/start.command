#!/usr/bin/env bash
# macOS / Linux launcher — double-click in Finder (after `chmod +x start.command`).
set -e

cd "$(dirname "$0")"

echo "============================================"
echo "  Pail"
echo "============================================"
echo

# --- 1. Find python ---------------------------------------------------------
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "[ERROR] Python 3 is not installed. Install from https://www.python.org/downloads/"
    read -n 1 -s -r -p "Press any key to close..."
    exit 1
fi

# --- 2. Create venv if missing ---------------------------------------------
if [ ! -x "venv/bin/python" ]; then
    echo "[setup] Creating virtual environment..."
    "$PY" -m venv venv
    rm -f .deps_installed
fi

VENV_PY="$(pwd)/venv/bin/python"

# --- 3. Install / refresh dependencies if needed ---------------------------
NEED_INSTALL=0
if [ ! -f .deps_installed ]; then
    NEED_INSTALL=1
elif [ requirements.txt -nt .deps_installed ]; then
    NEED_INSTALL=1
fi
if [ "$NEED_INSTALL" = "1" ]; then
    echo "[setup] Installing dependencies..."
    "$VENV_PY" -m pip install --upgrade pip
    "$VENV_PY" -m pip install -r requirements.txt
    touch .deps_installed
fi

# --- 4. Persistent Flask secret --------------------------------------------
if [ ! -f .flask_secret ]; then
    "$VENV_PY" -c "import secrets; open('.flask_secret','w').write(secrets.token_hex(32))"
fi
export FLASK_SECRET_KEY="$(cat .flask_secret)"

# --- 5. Launch -------------------------------------------------------------
APP_URL="http://127.0.0.1:5000"
echo
echo "[run] Starting server at $APP_URL"
echo "[run] Press Ctrl+C to stop."
echo

(sleep 1 && (open "$APP_URL" 2>/dev/null || xdg-open "$APP_URL" 2>/dev/null || true)) &

cd webapp
exec "$VENV_PY" app.py
