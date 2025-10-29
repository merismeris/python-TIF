#!/bin/bash
# Script para construir el libro localmente en Linux/Mac

echo "========================================"
echo "  Build local del Jupyter Book"
echo "========================================"
echo ""

# Verificar si existe el directorio content
if [ ! -d "content" ]; then
    echo "ERROR: No se encuentra el directorio 'content'"
    exit 1
fi

# Verificar y activar el entorno conda si es necesario
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
    source $(conda info --base)/etc/profile.d/conda.sh
    conda activate ./.conda
    if [ $? -ne 0 ]; then
        echo "ERROR: No se pudo activar el entorno conda local"
        echo "Verifica que el entorno existe en .conda"
        exit 1
    fi
fi
echo ""

# Limpiar build anterior si existe
echo "[1/3] Limpiando builds anteriores..."
if [ -d "content/_build" ]; then
    rm -rf content/_build
    echo "Build anterior eliminado."
else
    echo "No hay build anterior para limpiar."
fi
echo ""

# Construir el libro
echo "[2/3] Construyendo el libro..."
echo "Esto puede tomar varios minutos debido a la ejecución de notebooks..."
echo ""
jupyter-book build content

BUILD_ERROR=$?

# Desactivar solo si lo activamos nosotros
if [ "$NEEDS_ACTIVATION" -eq 1 ]; then
    conda deactivate
fi

# Verificar si el build fue exitoso
if [ $BUILD_ERROR -ne 0 ]; then
    echo ""
    echo "ERROR: El build falló. Revisa los mensajes de error arriba."
    exit $BUILD_ERROR
fi

echo ""
echo "[3/3] Build completado exitosamente!"
echo ""
echo "========================================"
echo "  El libro está listo en:"
echo "  content/_build/html/index.html"
echo "========================================"
echo ""
echo "Para ver el libro, abre el archivo en tu navegador o ejecuta:"
echo "  open content/_build/html/index.html    # macOS"
echo "  xdg-open content/_build/html/index.html # Linux"
echo ""
