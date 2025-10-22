# Configuración del Workflow SFTP Deploy

Este documento explica cómo configurar el despliegue automático de la documentación al servidor SFTP de la Universidad de Salamanca.

## Secrets necesarios

Debes añadir los siguientes secrets en tu repositorio de GitHub:

**Nota**: Si eres colaborador del repositorio, necesitarás que el propietario (owner) añada los secrets, ya que GitHub requiere permisos de administrador para gestionar secrets del repositorio.

1. Ve al repositorio en GitHub (o pide al owner que lo haga)
2. Navega a **Settings** → **Secrets and variables** → **Actions**
3. Añade los siguientes **Repository secrets**:

| Secret Name | Descripción | Ejemplo |
|-------------|-------------|---------|
| `FTP_SERVER_USAL_PYTHON_TIF` | Servidor SFTP de USAL | `sftp.usal.es` |
| `FTP_USERNAME_PYTHON_TIF` | Tu usuario de USAL | `tu_usuario` |
| `FTP_PASSWORD_PYTHON_TIF` | Tu contraseña de USAL | `tu_contraseña` |

## Configuración adicional

### Directorio remoto

Por defecto, el workflow despliega en `public_html`. Si necesitas cambiarlo, edita la variable `SFTP_REMOTE_DIR` en el archivo `sftp-deploy.yml`:

```yaml
SFTP_REMOTE_DIR: 'public_html'  # Cambia esto según tu configuración
```

### Limpieza del directorio remoto

El workflow incluye un paso que **elimina todos los archivos** del directorio remoto antes de subir la nueva versión. Esto asegura que no queden archivos antiguos.

**Si NO quieres eliminar archivos antiguos**, comenta o elimina el paso "Clean remote directory via SFTP":

```yaml
# - name: Clean remote directory via SFTP
#   run: |
#     ...
```

### Trigger del workflow

El workflow se ejecuta automáticamente cuando:
- Haces `push` a la rama `main`
- Los cambios afectan a:
  - Archivos en `content/**`
  - El archivo `requirements.txt`
  - El propio workflow `sftp-deploy.yml`

## Verificación

Después de hacer push a `main`, puedes:

1. Ver el progreso en la pestaña **Actions** de tu repositorio
2. Verificar que los archivos se han subido correctamente al servidor USAL
3. Acceder a tu sitio web en la URL proporcionada por USAL

## Notas sobre baseurl

### Configuración dual: GitHub Pages + USAL

El proyecto está configurado para funcionar en **dos destinos diferentes**:

1. **GitHub Pages**: `https://merismeris.github.io/python-TIF/` (necesita `baseurl: /python-TIF/`)
2. **USAL**: `https://tif.usal.es` (necesita `baseurl: /` o sin baseurl)

**Solución implementada:**

El workflow SFTP modifica temporalmente el `_config.yml` durante el build para USAL:
- Cambia `baseurl: /python-TIF/` → `baseurl: /`
- Compila la documentación con esta configuración
- Restaura el archivo original para no afectar el repositorio

De esta forma:
- ✅ El workflow de GitHub Pages (`main.yml`) sigue funcionando correctamente
- ✅ El workflow de SFTP genera la versión correcta para USAL
- ✅ No hay conflictos entre ambos despliegues

### Si necesitas cambiar el baseurl de USAL

Edita esta línea en `sftp-deploy.yml`:

```yaml
sed -i 's|baseurl: /python-TIF/|baseurl: /|g' ./content/_config.yml
```

Cambia `/` por el path que necesites (ej: `/python/`, `/cursos/tif/`, etc.)

## Troubleshooting

### Error de autenticación
- Verifica que los secrets estén correctamente configurados
- Asegúrate de que las credenciales de USAL sean correctas

### Error de permisos
- Verifica que tu usuario tenga permisos de escritura en el directorio remoto
- Prueba la conexión SFTP manualmente antes de ejecutar el workflow

### Timeout
- Si el build toma mucho tiempo, es normal en la primera ejecución
- Las siguientes ejecuciones serán más rápidas gracias al caché de pip
