@echo off
REM Script rapido para servir el libro (sin rebuild) usando el entorno conda local

echo ========================================
echo   Servidor rapido del Jupyter Book
echo ========================================
echo.

REM Verificar si existe el build
if not exist "content\_build\html\index.html" (
    echo ERROR: No se encuentra el libro construido.
    echo Por favor ejecuta primero: build-and-serve.bat
    echo.
    pause
    exit /b 1
)

echo Activando entorno conda local...
call conda activate .\.conda
if %ERRORLEVEL% neq 0 (
    echo ADVERTENCIA: No se pudo activar el entorno conda
    echo Continuando con el entorno actual...
)
echo.

echo Iniciando servidor local en http://localhost:8000
echo.
echo Presiona Ctrl+C para detener el servidor
echo.
echo Abriendo el navegador en 2 segundos...
timeout /t 2 /nobreak > nul
start http://localhost:8000

python -m http.server 8000 --directory content\_build\html

call conda deactivate
