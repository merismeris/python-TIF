@echo off
REM Script para build rapido SIN ejecutar notebooks

echo ========================================
echo   Build rapido (sin ejecutar notebooks)
echo ========================================
echo.

REM Verificar y activar el entorno conda si es necesario
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

set "BUILD_ERROR=%ERRORLEVEL%"

if %BUILD_ERROR% neq 0 (
    echo.
    echo ERROR: El build fallo
    if "%NEEDS_ACTIVATION%"=="1" (
        call conda deactivate
    )
    pause
    exit /b %BUILD_ERROR%
)

echo.
echo ========================================
echo   Build rapido completado!
echo   Archivo: content\_build\html\index.html
echo ========================================
echo.

REM Desactivar solo si lo activamos nosotros
if "%NEEDS_ACTIVATION%"=="1" (
    call conda deactivate
)
pause
