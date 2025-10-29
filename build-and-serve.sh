#!/bin/bash
# Script para construir y servir el libro usando el entorno conda local

echo "========================================"
echo "  Build y Servidor del Jupyter Book"
echo "========================================"
echo ""

# Verificar y activar el entorno conda si es necesario
echo "[1/4] Verificando entorno conda..."
CONDA_ENV_PATH="$(pwd)/.conda"
NEEDS_ACTIVATION=0

if [ -n "$CONDA_PREFIX" ]; then
    if [ "$CONDA_PREFIX" = "$CONDA_ENV_PATH" ]; then
        echo "[INFO] Ya estás en el entorno conda local correcto"
    else
        echo "[INFO] Estás en otro entorno conda, cambiando al entorno local..."
        NEEDS_ACTIVATION=1
    fi
else
    echo "[INFO] Activando entorno conda local..."
    NEEDS_ACTIVATION=1
fi

if [ "$NEEDS_ACTIVATION" -eq 1 ]; then
    eval "$(conda shell.bash hook)"
    conda activate ./.conda
    if [ $? -ne 0 ]; then
        echo "ERROR: No se pudo activar el entorno conda local"
        echo "Verifica que el entorno existe en .conda"
        exit 1
    fi
    echo "Entorno activado correctamente."
fi
echo ""

# Verificar si existe el directorio content
if [ ! -d "content" ]; then
    echo "ERROR: No se encuentra el directorio 'content'"
    if [ "$NEEDS_ACTIVATION" -eq 1 ]; then
        conda deactivate
    fi
    exit 1
fi

# Limpiar build anterior si existe
echo "[2/4] Limpiando builds anteriores..."
if [ -d "content/_build" ]; then
    rm -rf content/_build
    echo "Build anterior eliminado."
else
    echo "No hay build anterior para limpiar."
fi
echo ""

# Construir el libro
echo "[3/4] Construyendo el libro..."
echo "Esto puede tomar varios minutos debido a la ejecución de notebooks..."
echo ""
jupyter-book build content

BUILD_ERROR=$?

# Verificar si el build fue exitoso
if [ $BUILD_ERROR -ne 0 ]; then
    echo ""
    echo "ERROR: El build falló. Revisa los mensajes de error arriba."
    if [ "$NEEDS_ACTIVATION" -eq 1 ]; then
        conda deactivate
    fi
    exit $BUILD_ERROR
fi

echo ""
echo "[4/4] Build completado! Iniciando servidor..."
echo ""
echo "========================================"
echo "  Servidor local en: http://localhost:8000"
echo "========================================"
echo ""
echo "El navegador se abrirá automáticamente en 3 segundos..."
echo "Presiona Ctrl+C para detener el servidor"
echo ""

# Abrir el navegador según el sistema operativo
sleep 3
if [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:8000
else
    xdg-open http://localhost:8000 2>/dev/null
fi

# Iniciar el servidor
cd content/_build/html
python -m http.server 8000

# Desactivar el entorno solo si lo activamos nosotros
if [ "$NEEDS_ACTIVATION" -eq 1 ]; then
    conda deactivate
fi
