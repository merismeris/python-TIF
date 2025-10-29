@echo off
REM Script con hot reloading - usa watchdog para detectar cambios

echo ========================================
echo   Hot Reloading del Jupyter Book
echo ========================================
echo.

REM Verificar y activar el entorno conda si es necesario
echo [1/4] Verificando entorno conda...
set "CONDA_ENV_PATH=%CD%\.conda"
set "NEEDS_ACTIVATION=0"

REM Comprobar si estamos en el entorno correcto
if defined CONDA_PREFIX (
    if /I "%CONDA_PREFIX%"=="%CONDA_ENV_PATH%" (
        echo [INFO] Ya estas en el entorno conda local correcto
    ) else (
        echo [INFO] Estas en otro entorno conda, cambiando al entorno local...
        set "NEEDS_ACTIVATION=1"
    )
) else (
    echo [INFO] Activando entorno conda local...
    set "NEEDS_ACTIVATION=1"
)

if "%NEEDS_ACTIVATION%"=="1" (
    call conda activate .\.conda
    if %ERRORLEVEL% neq 0 (
        echo ERROR: No se pudo activar el entorno conda local
        pause
        exit /b 1
    )
    echo Entorno activado correctamente.
)
echo.

REM Verificar e instalar watchdog si es necesario
echo [2/4] Verificando dependencias...
pip show watchdog >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Instalando watchdog...
    pip install watchdog
    echo.
)

REM Build inicial
echo [3/4] Construyendo libro inicial...
jupyter-book build content --keep-going

set "BUILD_ERROR=%ERRORLEVEL%"

if %BUILD_ERROR% neq 0 (
    echo.
    echo ADVERTENCIA: El build tuvo algunos errores, pero continuaremos...
)
echo.

REM Verificar que el build existe
if not exist "content\_build\html\index.html" (
    echo ERROR: El build inicial fallo. No se encontro index.html
    echo Revisa los errores arriba.
    if "%NEEDS_ACTIVATION%"=="1" (
        call conda deactivate
    )
    pause
    exit /b 1
)

echo [4/4] Iniciando servidor y modo watch...
echo.
echo ========================================
echo   COMO USAR:
echo ========================================
echo  1. El servidor esta en http://localhost:8000
echo  2. Edita archivos .md o .ipynb en content/
echo  3. Guarda los cambios (Ctrl+S)
echo  4. El libro se reconstruye automaticamente
echo  5. El navegador se RECARGA AUTOMATICAMENTE!
echo.
echo NUEVA CARACTERISTICA: Auto-reload del navegador
echo Ya no necesitas presionar F5 manualmente!
echo.
echo Presiona Ctrl+C para detener
echo.

REM Abrir navegador
echo Abriendo navegador en 3 segundos...
timeout /t 3 /nobreak > nul
start http://localhost:8000

REM Ejecutar el script de watch (v2 usa polling HTTP para mejor compatibilidad)
python watch_helper_v2.py

REM Desactivar entorno solo si lo activamos nosotros
if "%NEEDS_ACTIVATION%"=="1" (
    call conda deactivate
)
