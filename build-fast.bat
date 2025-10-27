@echo off
REM Script para build rapido SIN ejecutar notebooks

echo ========================================
echo   Build rapido (sin ejecutar notebooks)
echo ========================================
echo.

echo Activando entorno conda local...
call conda activate .\.conda
if %ERRORLEVEL% neq 0 (
    echo ERROR: No se pudo activar el entorno conda local
    pause
    exit /b 1
)
echo.

REM Verificar si existe el directorio content
if not exist "content" (
    echo ERROR: No se encuentra el directorio 'content'
    call conda deactivate
    pause
    exit /b 1
)

REM Limpiar build anterior
echo [1/2] Limpiando build anterior...
if exist "content\_build" (
    rmdir /s /q "content\_build"
)
echo.

REM Construir sin ejecutar (usa la config actual: execute_notebooks: off)
echo [2/2] Construyendo libro (rapido, sin ejecutar notebooks)...
echo.
jupyter-book build content

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: El build fallo
    call conda deactivate
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo   Build rapido completado!
echo   Archivo: content\_build\html\index.html
echo ========================================
echo.

call conda deactivate
pause
