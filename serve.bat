@echo off
REM Script para servir el libro localmente con un servidor HTTP

echo ========================================
echo   Servidor local del Jupyter Book
echo ========================================
echo.

REM Verificar si existe el build
if not exist "content\_build\html\index.html" (
    echo ERROR: No se encuentra el libro construido.
    echo Por favor ejecuta primero: build.bat
    echo.
    pause
    exit /b 1
)

echo Iniciando servidor local en http://localhost:8000
echo.
echo Presiona Ctrl+C para detener el servidor
echo.
echo Abriendo el navegador en 3 segundos...
timeout /t 3 /nobreak > nul
start http://localhost:8000

python -m http.server 8000 --directory content\_build\html
