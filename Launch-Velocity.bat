@echo off
title Launching VELOCITY...
cd /d "%~dp0"
if exist ".venv\Scripts\python.exe" (
    start "" ".venv\Scripts\python.exe" "run_app.py"
) else (
    python run_app.py
)
exit
