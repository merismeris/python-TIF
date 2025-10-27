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

# Verificar si el build fue exitoso
if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: El build falló. Revisa los mensajes de error arriba."
    exit $?
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
