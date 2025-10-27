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

REM Construir el libro
echo [2/3] Construyendo el libro...
echo Esto puede tomar varios minutos debido a la ejecucion de notebooks...
echo.
jupyter-book build content

REM Verificar si el build fue exitoso
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: El build fallo. Revisa los mensajes de error arriba.
    exit /b %ERRORLEVEL%
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
