# 🚀 Quick Start - Jupyter Book

## Para empezar (escoge uno):

### 🔥 Desarrollo activo con hot reload + auto-refresh (RECOMENDADO)
```bash
watch-and-serve.bat
```
- Reconstruye automáticamente
- **Recarga el navegador automáticamente** (¡sin F5!)
- Perfecto para editar y ver cambios al instante
- Usa Server-Sent Events para notificaciones en tiempo real

### ⚡ Build normal + servidor
```bash
build-and-serve.bat
```
- Build completo desde cero
- Inicia servidor
- Abre navegador

### 🏃 Solo servir (si ya tienes el build)
```bash
quick-serve.bat
```
- Instantáneo
- Solo muestra el libro existente

---

## 📝 Comandos útiles

| Necesito... | Comando |
|-------------|---------|
| Ver cambios en tiempo real | `watch-and-serve.bat` |
| Build desde cero | `build-and-serve.bat` |
| Solo ver el libro | `quick-serve.bat` |
| Limpiar notebooks | `clean-notebooks.bat` |
| Build sin ejecutar notebooks | `build-fast.bat` |

---

## 💡 Tips

- **Notebooks con `input()`**: Ya está configurado para NO ejecutarlos
- **Directorio**: Los scripts NO cambian tu directorio actual
- **Puerto**: Servidor en `http://localhost:8000`
- **Detener**: Presiona `Ctrl+C`

---

Ver [BUILD-README.md](BUILD-README.md) para más detalles.
