@echo off
title VELOCITY High-Throughput BitTorrent WebApp
cd /d "%~dp0"

echo ========================================================
echo   ⚡ VELOCITY — High-Throughput BitTorrent Engine
echo   Initializing Local WebApp Environment...
echo ========================================================
echo.

:: 1. Check for Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python 3.10+ is required but not found in PATH.
    echo Please install Python from https://python.org or Microsoft Store.
    pause
    exit /b 1
)

:: 2. Setup Virtual Environment if missing
if not exist ".venv\Scripts\python.exe" (
    echo [*] Setting up virtual environment in .venv...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo [*] Installing dependencies from requirements.txt...
    ".venv\Scripts\pip.exe" install -r requirements.txt
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install dependencies.
        pause
        exit /b 1
    )
)

:: 3. Launch WebApp Daemon
echo [*] Launching VELOCITY daemon on http://127.0.0.1:8080/
echo [*] Press Ctrl+C in this terminal to stop the engine.
echo.

".venv\Scripts\python.exe" -u backend/app.py

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Application exited with error code %errorlevel%
    pause
)
