@echo off
REM Script para limpiar las salidas de todos los notebooks

echo ========================================
echo   Limpiar salidas de notebooks
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

echo Limpiando salidas de todos los notebooks...
echo.

REM Limpiar notebooks recursivamente en el directorio content
jupyter nbconvert --clear-output --inplace content/**/*.ipynb

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Fallo al limpiar los notebooks
    call conda deactivate
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo   Notebooks limpiados exitosamente!
echo ========================================
echo.
echo Todas las celdas de salida han sido eliminadas.
echo Los notebooks ahora solo contienen el codigo fuente.
echo.

call conda deactivate
pause
