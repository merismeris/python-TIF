#!/bin/bash
# Script con hot reloading - reconstruye automaticamente cuando cambias archivos

echo "========================================"
echo "  Hot Reloading del Jupyter Book"
echo "========================================"
echo ""

# Activar el entorno conda local
echo "[1/3] Activando entorno conda local..."
eval "$(conda shell.bash hook)"
conda activate ./.conda
if [ $? -ne 0 ]; then
    echo "ERROR: No se pudo activar el entorno conda local"
    exit 1
fi
echo "Entorno activado correctamente."
echo ""

# Verificar si sphinx-autobuild esta instalado
echo "[2/3] Verificando sphinx-autobuild..."
if ! pip show sphinx-autobuild > /dev/null 2>&1; then
    echo "sphinx-autobuild no esta instalado. Instalando..."
    pip install sphinx-autobuild
    if [ $? -ne 0 ]; then
        echo "ERROR: No se pudo instalar sphinx-autobuild"
        conda deactivate
        exit 1
    fi
    echo "sphinx-autobuild instalado correctamente."
fi
echo ""

# Limpiar build anterior (opcional)
if [ -d "content/_build" ]; then
    echo "Limpiando build anterior..."
    rm -rf content/_build
    echo ""
fi

echo "[3/3] Iniciando servidor con hot reloading..."
echo ""
echo "========================================"
echo "  Servidor: http://localhost:8000"
echo "========================================"
echo ""
echo "CARACTERISTICAS:"
echo " - Se reconstruye automaticamente al detectar cambios"
echo " - El navegador se recarga automaticamente"
echo " - Monitorea archivos .md, .ipynb, .yml, .rst"
echo ""
echo "El navegador se abrira automaticamente en 3 segundos..."
echo "Presiona Ctrl+C para detener"
echo ""

# Abrir el navegador
sleep 3
if [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:8000
else
    xdg-open http://localhost:8000 2>/dev/null
fi

# Iniciar sphinx-autobuild con configuracion para Jupyter Book
sphinx-autobuild content content/_build/html \
    --port 8000 \
    --open-browser \
    --ignore "content/_build/*" \
    --ignore "**/.ipynb_checkpoints/*" \
    --ignore "**/.*" \
    --watch content \
    --delay 1

# Desactivar el entorno al salir
conda deactivate
