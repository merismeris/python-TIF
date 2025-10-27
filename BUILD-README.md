# Guía de Scripts de Build

Esta guía explica todos los scripts disponibles para construir y servir el Jupyter Book.

## 📋 Configuración de Ejecución de Notebooks

El archivo `content/_config.yml` controla cómo se ejecutan los notebooks:

```yaml
execute:
  execute_notebooks: off  # Opciones: 'off', 'cache', 'force'
```

### Opciones disponibles:

- **`off`** (ACTUAL): No ejecuta notebooks, usa las salidas guardadas
  - ✅ Build rápido (segundos en lugar de minutos)
  - ✅ No hay problemas con celdas de `input()`
  - ⚠️ Debes ejecutar los notebooks manualmente y guardar las salidas

- **`cache`**: Solo ejecuta notebooks que han cambiado
  - ✅ Build más rápido que `force`
  - ⚠️ Puede tener problemas con `input()`

- **`force`**: Ejecuta todos los notebooks en cada build
  - ✅ Siempre actualizado
  - ❌ Build muy lento
  - ❌ Falla con celdas que requieren `input()`

## 🚀 Scripts Disponibles

### 1. Hot Reloading con Auto-Refresh (RECOMENDADO PARA DESARROLLO) ⚡🔄

```bash
watch-and-serve.bat
```

- ✅ **Reconstruye automáticamente** cuando cambias archivos
- ✅ **Recarga el navegador AUTOMÁTICAMENTE** (¡ya no necesitas F5!)
- ✅ Usa Server-Sent Events (SSE) para comunicación en tiempo real
- ✅ Monitorea `.md`, `.ipynb`, `.yml`, `.rst`
- ✅ Servidor en `localhost:8000`
- ✅ Instala `watchdog` automáticamente si no lo tienes
- ✅ **Mantiene tu directorio actual**

**Cuándo usar**: Durante desarrollo activo. Edita, guarda y ve los cambios al instante sin tocar nada.

---

### 2. Build y Servidor (TODO EN UNO)

```bash
build-and-serve.bat
```

- ✅ Activa entorno conda local
- ✅ Limpia builds anteriores
- ✅ Construye el libro
- ✅ Inicia servidor en `localhost:8000`
- ✅ Abre el navegador automáticamente
- ✅ **Mantiene el directorio actual** (no cambia de carpeta)

**Cuándo usar**: Para ver el libro completo desde cero.

---

### 3. Build Rápido (sin ejecutar notebooks)

```bash
build-fast.bat
```

- ✅ Build en segundos (no ejecuta notebooks)
- ✅ Usa las salidas ya guardadas en los `.ipynb`

**Cuándo usar**: Cuando solo cambias texto/markdown o ya tienes las salidas guardadas.

---

### 4. Build Normal

```bash
build.bat
```

- Build básico sin servidor
- Respeta la configuración de `execute_notebooks` en `_config.yml`

**Cuándo usar**: Solo para generar el HTML sin servir.

---

### 5. Build Limpio

```bash
build-clean.bat
```

- Limpia completamente el cache
- Reconstruye todo con `--all`

**Cuándo usar**: Cuando hay problemas con el cache o builds corruptos.

---

### 6. Servidor Rápido

```bash
quick-serve.bat
```

- Solo sirve el libro (no hace build)
- ✅ Instantáneo

**Cuándo usar**: Cuando ya tienes el build hecho y solo quieres verlo.

---

### 7. Limpiar Notebooks

```bash
clean-notebooks.bat
```

- Elimina todas las salidas de los notebooks
- Deja solo el código fuente

**Cuándo usar**:
- Antes de hacer commit (archivos más pequeños)
- Cuando quieres re-ejecutar todo desde cero
- Para eliminar salidas con errores

---

## 🔧 Solución para Notebooks con `input()`

Si tienes notebooks con celdas que usan `input()`, tienes dos opciones:

### Opción A: No ejecutar esos notebooks (RECOMENDADO)

1. Ejecuta el notebook manualmente en Jupyter
2. Guarda las salidas
3. Deja `execute_notebooks: off` en `_config.yml`
4. El build usará las salidas guardadas

### Opción B: Marcar notebooks específicos

Añade al principio del notebook (en metadata o en una celda markdown):

```yaml
---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: Python 3
  language: python
  name: python3
execution:
  execute_notebooks: 'off'
---
```

## 📊 Flujo de Trabajo Recomendado

### Para desarrollo activo (MEJOR OPCIÓN):

```bash
# 1. Inicia el modo watch
watch-and-serve.bat

# 2. Edita archivos .md o .ipynb
# 3. Guarda los cambios
# 4. ¡El navegador se recarga automáticamente!
```

### Para desarrollo diario (sin hot reload):

```bash
# 1. Editar notebooks en Jupyter Lab/VSCode
# 2. Ejecutar manualmente y guardar
# 3. Build rápido + servidor
build-and-serve.bat
```

### Para commit a Git:

```bash
# 1. Limpiar notebooks (opcional, reduce tamaño)
clean-notebooks.bat

# 2. Commit
git add .
git commit -m "Update notebooks"
```

### Para producción:

```bash
# 1. Asegurar que todos los notebooks tienen salidas
# 2. Build limpio
build-clean.bat

# 3. Deploy (según tu método)
```

## ⚡ Tiempos de Build Aproximados

- **Con `execute_notebooks: off`**: 10-30 segundos
- **Con `execute_notebooks: cache`**: 1-5 minutos (depende de cambios)
- **Con `execute_notebooks: force`**: 5-15 minutos (ejecuta todo)
- **Con `watch-and-serve.bat`**: 5-15 segundos por cambio incremental

## 🛠️ Troubleshooting

### Problema: "ERROR: No se pudo activar el entorno conda"
**Solución**: Verifica que existe `.conda/` en el directorio del proyecto

### Problema: "Notebook falla al ejecutar"
**Solución**:
1. Cambia a `execute_notebooks: off`
2. Ejecuta el notebook manualmente
3. Guarda las salidas

### Problema: "Build muy lento"
**Solución**: Cambia a `execute_notebooks: off` o `cache`

### Problema: "Las salidas no aparecen en el libro"
**Solución**:
1. Ejecuta los notebooks manualmente en Jupyter
2. Guarda con las salidas (Ctrl+S)
3. Haz el build

## 📝 Notas

- Todos los scripts activan automáticamente el entorno conda local (`.conda`)
- El servidor usa el puerto 8000 por defecto
- Presiona `Ctrl+C` para detener el servidor
- Los builds se guardan en `content/_build/html/`
