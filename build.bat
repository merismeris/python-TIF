@echo off
REM Script para construir el libro localmente en Windows

echo ========================================
echo   Build local del Jupyter Book
echo ========================================
echo.

REM Verificar si existe el directorio content
if not exist "content" (
    echo ERROR: No se encuentra el directorio 'content'
    exit /b 1
)

REM Limpiar build anterior si existe
echo [1/3] Limpiando builds anteriores...
if exist "content\_build" (
    rmdir /s /q "content\_build"
    echo Build anterior eliminado.
) else (
    echo No hay build anterior para limpiar.
)
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
        echo Verifica que el entorno existe en .conda
        pause
        exit /b 1
    )
)
echo.

REM Construir el libro
echo [2/3] Construyendo el libro...
echo Esto puede tomar varios minutos debido a la ejecucion de notebooks...
echo.
jupyter-book build content

set "BUILD_ERROR=%ERRORLEVEL%"

REM Desactivar solo si lo activamos nosotros
if "%NEEDS_ACTIVATION%"=="1" (
    call conda deactivate
)

REM Verificar si el build fue exitoso
if %BUILD_ERROR% neq 0 (
    echo.
    echo ERROR: El build fallo. Revisa los mensajes de error arriba.
    exit /b %BUILD_ERROR%
)

echo.
echo [3/3] Build completado exitosamente!
echo.
echo ========================================
echo   El libro esta listo en:
echo   content\_build\html\index.html
echo ========================================
echo.
echo Para ver el libro, abre el archivo en tu navegador o ejecuta:
echo   start content\_build\html\index.html
echo.

pause
