@echo off
REM Script para construir el libro desde cero (limpiando cache)

echo ========================================
echo   Build limpio del Jupyter Book
echo ========================================
echo.

echo [1/3] Limpiando completamente builds y cache anteriores...
if exist "content\_build" (
    rmdir /s /q "content\_build"
)
echo Cache limpiado.
echo.

echo [2/3] Construyendo el libro desde cero...
echo Esto puede tomar varios minutos...
echo.
jupyter-book build content --all

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: El build fallo. Revisa los mensajes de error arriba.
    exit /b %ERRORLEVEL%
)

echo.
echo [3/3] Build limpio completado exitosamente!
echo.
echo ========================================
echo   El libro esta listo en:
echo   content\_build\html\index.html
echo ========================================
echo.

pause
