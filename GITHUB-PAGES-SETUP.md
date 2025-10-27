# Configuración de GitHub Pages para python-TIF

## Resumen de cambios realizados

Se ha configurado el proyecto para que GitHub Pages publique automáticamente desde la carpeta `docs/` en la rama `mi-cambio`.

## Archivos modificados

### 1. `.gitignore`
- **Cambio**: Descomentadas las líneas que ignoraban `docs/`
- **Razón**: Ahora necesitamos versionar la carpeta `docs/` para que GitHub Pages la pueda leer

### 2. `.github/workflows/main.yml`
- **Cambio**: Workflow completamente rediseñado
- **Nuevo comportamiento**:
  - Se ejecuta al hacer push a `mi-cambio` (antes era `main`)
  - Genera el build con `jupyter-book build ./content`
  - Copia todo el contenido de `content/_build/html/` a `docs/`
  - Crea archivo `.nojekyll` en `docs/` (importante para GitHub Pages)
  - Hace commit automático de los cambios en `docs/` con el mensaje: `"Auto-update docs/ from Jupyter Book build [skip ci]"`
  - El `[skip ci]` evita que el commit dispare el workflow nuevamente (previene loops infinitos)

### 3. `docs/.nojekyll`
- **Nuevo archivo**: Indica a GitHub Pages que NO use Jekyll para procesar los archivos
- **Importante**: Sin este archivo, GitHub Pages procesará incorrectamente algunos archivos con guiones bajos

## Workflow SFTP (sin cambios)

El workflow `sftp-deploy.yml` sigue funcionando correctamente y no requiere modificaciones:
- Se ejecuta al hacer push a `mi-cambio`
- Genera su propio build independiente
- Modifica temporalmente el `baseurl` en `_config.yml` para USAL
- Sube el contenido al servidor USAL por SFTP

## Configuración necesaria en GitHub

Para que esto funcione, debes configurar GitHub Pages en tu repositorio:

1. Ve a tu repositorio en GitHub
2. Settings → Pages
3. En "Source", selecciona:
   - **Branch**: `mi-cambio`
   - **Folder**: `/docs`
4. Guarda los cambios

## Cómo funciona el flujo de trabajo

```
1. Haces cambios en content/
2. Haces commit y push a mi-cambio
3. Se disparan AMBOS workflows en paralelo:

   Workflow A (main.yml):
   - Genera build
   - Copia a docs/
   - Hace commit automático de docs/
   - GitHub Pages detecta cambio y publica

   Workflow B (sftp-deploy.yml):
   - Genera build con baseurl diferente
   - Sube a servidor USAL por SFTP
```

## URLs resultantes

- **GitHub Pages**: `https://[tu-usuario].github.io/python-TIF/`
- **Hosting USAL**: (la URL que ya tienes configurada)

## Ventajas de esta configuración

1. ✅ Los archivos HTML están versionados en `docs/` (puedes ver el historial)
2. ✅ GitHub Pages lee directamente de la rama `mi-cambio`
3. ✅ No hay confusión con ramas separadas (todo en `mi-cambio`)
4. ✅ El workflow SFTP sigue funcionando independientemente
5. ✅ Prevención de loops infinitos con `[skip ci]`
6. ✅ Solo se disparan los workflows cuando cambias archivos relevantes

## Notas importantes

- **Permisos**: El workflow usa `GITHUB_TOKEN` que GitHub proporciona automáticamente. Asegúrate de que en Settings → Actions → General → Workflow permissions esté en "Read and write permissions"
- **Primera ejecución**: La primera vez que hagas push después de estos cambios, verás que el workflow genera un commit adicional con los archivos en `docs/`
- **Conflictos**: Si trabajas localmente y haces cambios manuales en `docs/`, pueden surgir conflictos. La recomendación es NO modificar `docs/` manualmente, dejarlo solo para el workflow

## Troubleshooting

### El workflow falla con "permission denied"
- Ve a Settings → Actions → General → Workflow permissions
- Selecciona "Read and write permissions"
- Marca "Allow GitHub Actions to create and approve pull requests"

### GitHub Pages muestra 404
- Verifica que hayas configurado Pages para leer de `mi-cambio/docs`
- Asegúrate de que el archivo `.nojekyll` existe en `docs/`
- Espera unos minutos, GitHub Pages puede tardar en actualizar

### Los estilos no cargan correctamente
- Verifica que `baseurl: /python-TIF/` en `_config.yml` sea correcto
- El `baseurl` debe coincidir con el nombre de tu repositorio

### Se crean loops infinitos de builds
- Asegúrate de que el mensaje de commit incluya `[skip ci]`
- Esto está ya configurado en el workflow, pero si lo modificas, mantenlo

## Siguientes pasos

1. Hacer commit de estos cambios
2. Push a `mi-cambio`
3. Configurar GitHub Pages en el repositorio (Settings → Pages)
4. Esperar a que el workflow se ejecute
5. Verificar que `docs/` se actualice automáticamente
6. Acceder a la URL de GitHub Pages para confirmar que funciona
