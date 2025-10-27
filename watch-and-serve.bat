@echo off
REM Script con hot reloading - usa watchdog para detectar cambios

echo ========================================
echo   Hot Reloading del Jupyter Book
echo ========================================
echo.

REM Activar el entorno conda local
echo [1/4] Activando entorno conda local...
call conda activate .\.conda
if %ERRORLEVEL% neq 0 (
    echo ERROR: No se pudo activar el entorno conda local
    pause
    exit /b 1
)
echo Entorno activado correctamente.
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
if %ERRORLEVEL% neq 0 (
    echo.
    echo ADVERTENCIA: El build tuvo algunos errores, pero continuaremos...
)
echo.

REM Verificar que el build existe
if not exist "content\_build\html\index.html" (
    echo ERROR: El build inicial fallo. No se encontro index.html
    echo Revisa los errores arriba.
    call conda deactivate
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

REM Desactivar entorno al salir
call conda deactivate
