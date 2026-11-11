#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# VELOCITY — Unix Clone-and-Run Launcher

set -e
cd "$(dirname "$0")"

echo "========================================================"
echo "  ⚡ VELOCITY — High-Throughput BitTorrent Engine"
echo "  Initializing Local WebApp Environment..."
echo "========================================================"

if ! command -v python3 &> /dev/null; then
    echo "[ERROR] python3 is required but not found in PATH."
    exit 1
fi

if [ ! -f ".venv/bin/python" ]; then
    echo "[*] Creating virtual environment (.venv)..."
    python3 -m venv .venv
    echo "[*] Installing dependencies..."
    .venv/bin/pip install -r requirements.txt
fi

echo "[*] Launching VELOCITY daemon on http://127.0.0.1:8080/"
echo "[*] Press Ctrl+C to stop."
.venv/bin/python backend/app.py
