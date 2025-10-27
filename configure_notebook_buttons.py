#!/usr/bin/env python3
"""
Script para configurar los botones de ejecución (thebe, binder, colab)
en notebooks individuales de Jupyter Book.

Uso:
    python configure_notebook_buttons.py <ruta_notebook> [opciones]

Ejemplos:
    # Habilitar todos los botones
    python configure_notebook_buttons.py content/tema_1/notebook.ipynb --all

    # Solo habilitar Colab
    python configure_notebook_buttons.py content/tema_1/notebook.ipynb --colab

    # Habilitar thebe y binder
    python configure_notebook_buttons.py content/tema_1/notebook.ipynb --thebe --binder

    # Deshabilitar todos
    python configure_notebook_buttons.py content/tema_1/notebook.ipynb --none
"""

import json
import sys
import argparse
from pathlib import Path


def configure_notebook(notebook_path, thebe=False, binder=False, colab=False, jupyterlab=False):
    """Configura los metadatos de un notebook para controlar los botones de ejecución."""

    notebook_path = Path(notebook_path)

    if not notebook_path.exists():
        print(f"❌ Error: El archivo {notebook_path} no existe")
        return False

    # Leer el notebook
    with open(notebook_path, 'r', encoding='utf-8') as f:
        notebook = json.load(f)

    # Configurar metadatos
    notebook['metadata']['thebe'] = thebe
    notebook['metadata']['launch_buttons'] = {
        'notebook_interface': 'jupyterlab' if jupyterlab else False,
        'binderhub_url': 'https://mybinder.org' if binder else False,
        'colab_url': 'https://colab.research.google.com' if colab else False
    }

    # Guardar el notebook
    with open(notebook_path, 'w', encoding='utf-8') as f:
        json.dump(notebook, f, indent=1, ensure_ascii=False)

    print(f"✅ Notebook configurado: {notebook_path.name}")
    print(f"   - Thebe: {thebe}")
    print(f"   - JupyterLab: {jupyterlab}")
    print(f"   - Binder: {binder}")
    print(f"   - Colab: {colab}")

    return True


def main():
    parser = argparse.ArgumentParser(
        description='Configura los botones de ejecución en notebooks de Jupyter Book',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )

    parser.add_argument('notebook', help='Ruta al archivo .ipynb')
    parser.add_argument('--all', action='store_true',
                       help='Habilitar todos los botones (thebe, binder, colab, jupyterlab)')
    parser.add_argument('--none', action='store_true',
                       help='Deshabilitar todos los botones')
    parser.add_argument('--thebe', action='store_true',
                       help='Habilitar thebe (ejecución en línea)')
    parser.add_argument('--binder', action='store_true',
                       help='Habilitar Binder')
    parser.add_argument('--colab', action='store_true',
                       help='Habilitar Google Colab')
    parser.add_argument('--jupyterlab', action='store_true',
                       help='Habilitar botón de JupyterLab')

    args = parser.parse_args()

    # Determinar configuración
    if args.all:
        thebe = binder = colab = jupyterlab = True
    elif args.none:
        thebe = binder = colab = jupyterlab = False
    else:
        thebe = args.thebe
        binder = args.binder
        colab = args.colab
        jupyterlab = args.jupyterlab

    # Configurar notebook
    success = configure_notebook(
        args.notebook,
        thebe=thebe,
        binder=binder,
        colab=colab,
        jupyterlab=jupyterlab
    )

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
