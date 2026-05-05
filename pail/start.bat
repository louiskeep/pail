@echo off
setlocal EnableDelayedExpansion

REM Run from the directory that contains this script
cd /d "%~dp0"

echo ============================================
echo   Pail / Salamand3r - S3 File Mover
echo ============================================
echo.

REM ---- 1. Find a usable Python ---------------------------------------------
set "PY="
where py >nul 2>nul && (set "PY=py -3")
if not defined PY (
    where python >nul 2>nul && (set "PY=python")
)
if not defined PY (
    echo [ERROR] Python is not installed or not on PATH.
    echo Install Python 3.10+ from https://www.python.org/downloads/
    echo Make sure to tick "Add Python to PATH" during install.
    pause
    exit /b 1
)

REM ---- 2. Create venv if missing -------------------------------------------
if not exist "venv\Scripts\python.exe" (
    echo [setup] Creating virtual environment...
    %PY% -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create venv.
        pause
        exit /b 1
    )
    REM Force a fresh dependency install on first run
    if exist ".deps_installed" del ".deps_installed"
)

set "VENV_PY=%CD%\venv\Scripts\python.exe"

REM ---- 3. Install / refresh dependencies if needed -------------------------
set "NEED_INSTALL=0"
if not exist ".deps_installed" set "NEED_INSTALL=1"
if exist ".deps_installed" (
    for %%F in (requirements.txt) do (
        for %%G in (.deps_installed) do (
            if %%~tF GTR %%~tG set "NEED_INSTALL=1"
        )
    )
)

if "!NEED_INSTALL!"=="1" (
    echo [setup] Installing dependencies...
    "%VENV_PY%" -m pip install --upgrade pip
    "%VENV_PY%" -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] pip install failed.
        pause
        exit /b 1
    )
    echo done > .deps_installed
)

REM ---- 4. Persistent Flask secret key (so sessions survive restarts) -------
if not exist ".flask_secret" (
    "%VENV_PY%" -c "import secrets; open('.flask_secret','w').write(secrets.token_hex(32))"
)
set /p FLASK_SECRET_KEY=<.flask_secret

REM ---- 5. Launch the app, open browser, then run server in foreground ------
set "APP_URL=http://127.0.0.1:5000"
echo.
echo [run] Starting server at %APP_URL%
echo [run] Press Ctrl+C in this window to stop.
echo.
start "" "%APP_URL%"

cd webapp
"%VENV_PY%" app.py

endlocal
