@echo off
REM Script para construir y servir el libro usando el entorno conda local

echo ========================================
echo   Build y Servidor del Jupyter Book
echo ========================================
echo.

REM Activar el entorno conda local
echo [1/4] Activando entorno conda local...
call conda activate .\.conda
if %ERRORLEVEL% neq 0 (
    echo ERROR: No se pudo activar el entorno conda local
    echo Verifica que el entorno existe en .conda
    pause
    exit /b 1
)
echo Entorno activado correctamente.
echo.

REM Verificar si existe el directorio content
if not exist "content" (
    echo ERROR: No se encuentra el directorio 'content'
    call conda deactivate
    pause
    exit /b 1
)

REM Limpiar build anterior si existe
echo [2/4] Limpiando builds anteriores...
if exist "content\_build" (
    rmdir /s /q "content\_build"
    echo Build anterior eliminado.
) else (
    echo No hay build anterior para limpiar.
)
echo.

REM Construir el libro
echo [3/4] Construyendo el libro...
echo Esto puede tomar varios minutos debido a la ejecucion de notebooks...
echo.
jupyter-book build content

REM Verificar si el build fue exitoso
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: El build fallo. Revisa los mensajes de error arriba.
    call conda deactivate
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [4/4] Build completado! Iniciando servidor...
echo.
echo ========================================
echo   Servidor local en: http://localhost:8000
echo ========================================
echo.
echo El navegador se abrira automaticamente en 3 segundos...
echo Presiona Ctrl+C para detener el servidor
echo.

REM Abrir el navegador
timeout /t 3 /nobreak > nul
start http://localhost:8000

REM Iniciar el servidor sin cambiar de directorio
python -m http.server 8000 --directory content\_build\html

REM Desactivar el entorno al salir
call conda deactivate
