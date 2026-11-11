@echo off
title VELOCITY Desktop Launcher
cd /d "%~dp0"
echo ========================================================
echo   Launching VELOCITY Desktop Client...
echo ========================================================
if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" -u run_app.py
) else (
    python -u run_app.py
)
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Application exited with code %errorlevel%
    pause
)
