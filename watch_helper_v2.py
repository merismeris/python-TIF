"""
Helper script para watch mode del Jupyter Book - Versión 2
Usa polling HTTP simple para máxima compatibilidad
"""
import time
import subprocess
import threading
import http.server
import socketserver
import os
import json
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from datetime import datetime


# Variable global para el timestamp del último build
last_build_time = time.time()
build_lock = threading.Lock()


class JupyterBookHandler(FileSystemEventHandler):
    """Handler para detectar cambios y reconstruir el libro"""

    def __init__(self):
        self.last_build = 0
        self.build_delay = 2  # Esperar 2 segundos entre builds

    def on_modified(self, event):
        global last_build_time

        if event.is_directory:
            return

        # Solo reconstruir para archivos relevantes
        if event.src_path.endswith(('.md', '.ipynb', '.yml', '.rst')):
            # Ignorar archivos en directorios de build o checkpoints
            if '_build' in event.src_path or '.ipynb_checkpoints' in event.src_path:
                return

            current_time = time.time()
            if current_time - self.last_build > self.build_delay:
                self.last_build = current_time
                print(f'\n{"="*50}')
                print(f'[CAMBIO DETECTADO] {Path(event.src_path).name}')
                print(f'{"="*50}')
                print('[RECONSTRUYENDO...]')

                result = subprocess.run(
                    ['jupyter-book', 'build', 'content', '--keep-going'],
                    capture_output=True,
                    text=True
                )

                if result.returncode == 0:
                    print('[✓ LISTO] Build completado')
                    with build_lock:
                        last_build_time = time.time()
                    print(f'[AUTO-RELOAD] Navegador se recargará automáticamente...')
                else:
                    print('[! ADVERTENCIA] Build completado con algunos errores')
                print(f'{"="*50}\n')


class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler personalizado con polling endpoint"""

    def __init__(self, *args, directory=None, **kwargs):
        self.directory_path = directory
        super().__init__(*args, directory=directory, **kwargs)

    def log_message(self, format, *args):
        # Silenciar logs de polling
        if '/__check_reload__' not in args[0]:
            super().log_message(format, *args)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

    def do_GET(self):
        # Endpoint de polling para verificar si hay que recargar
        if self.path == '/__check_reload__':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
            self.end_headers()

            with build_lock:
                response = {
                    'timestamp': last_build_time,
                    'time': datetime.now().strftime('%H:%M:%S')
                }

            self.wfile.write(json.dumps(response).encode())
            return

        # Para archivos HTML, inyectar script de auto-reload
        super().do_GET()

    def send_head(self):
        """Override para inyectar script en archivos HTML"""
        path = self.translate_path(self.path)

        if os.path.isfile(path) and path.endswith('.html'):
            try:
                with open(path, 'rb') as f:
                    content = f.read()

                # Inyectar script de auto-reload antes de </body>
                reload_script = '''
<script>
// Auto-reload via HTTP Polling (compatible con todos los navegadores)
(function() {
    console.log('[Auto-reload] Sistema de auto-reload iniciado (polling)');

    let lastTimestamp = null;
    let isReloading = false;

    async function checkForUpdates() {
        if (isReloading) return;

        try {
            const response = await fetch('/__check_reload__', {
                cache: 'no-cache'
            });

            if (!response.ok) {
                console.warn('[Auto-reload] Error al consultar actualizaciones:', response.status);
                return;
            }

            const data = await response.json();

            if (lastTimestamp === null) {
                // Primera vez
                lastTimestamp = data.timestamp;
                console.log('[Auto-reload] OK Conectado. Monitoreando cambios...');
            } else if (data.timestamp > lastTimestamp) {
                // Hay cambios!
                console.log('[Auto-reload] >> Cambios detectados! Recargando en 1 segundo...');
                isReloading = true;

                // Pequeño delay para asegurar que el build termino
                setTimeout(() => {
                    location.reload();
                }, 1000);
            }
        } catch (err) {
            console.warn('[Auto-reload] Error de conexion:', err.message);
        }
    }

    // Verificar cada 2 segundos
    const intervalId = setInterval(checkForUpdates, 2000);

    // Check inicial
    checkForUpdates();

    // Limpiar al salir
    window.addEventListener('beforeunload', function() {
        clearInterval(intervalId);
    });

    console.log('[Auto-reload] Polling activo cada 2 segundos');
})();
</script>
'''.encode('utf-8')

                # Convertir content a string para facilitar la inyección
                content_str = content.decode('utf-8', errors='ignore')

                if '</body>' in content_str:
                    content_str = content_str.replace('</body>', reload_script.decode('utf-8') + '</body>')
                else:
                    content_str += reload_script.decode('utf-8')

                content = content_str.encode('utf-8')

                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                self.send_header('Content-Length', str(len(content)))
                self.end_headers()

                from io import BytesIO
                return BytesIO(content)
            except Exception as e:
                print(f'[ERROR] No se pudo inyectar script: {e}')

        return super().send_head()


def start_server(serve_dir):
    """Inicia el servidor HTTP desde un directorio específico"""
    Handler = lambda *args, **kwargs: CustomHTTPRequestHandler(
        *args, directory=serve_dir, **kwargs
    )
    httpd = socketserver.TCPServer(('', 8000), Handler)
    httpd.serve_forever()


if __name__ == '__main__':
    # Guardar el directorio actual (raíz del proyecto)
    project_root = Path.cwd()
    serve_directory = project_root / 'content' / '_build' / 'html'
    content_directory = project_root / 'content'

    print('\n' + '='*50)
    print('[SERVIDOR HTTP CON AUTO-RELOAD INICIADO]')
    print('URL: http://localhost:8000')
    print(f'Sirviendo desde: {serve_directory}')
    print('Método: HTTP Polling (compatible con Brave/Chrome/Firefox)')
    print('='*50)

    # Iniciar servidor en thread separado
    server_thread = threading.Thread(
        target=start_server,
        args=(str(serve_directory),),
        daemon=True
    )
    server_thread.start()

    print(f'[MONITOREANDO CAMBIOS EN {content_directory}]')
    print('[AUTO-RELOAD ACTIVADO] El navegador se recargara automaticamente')
    print('Presiona Ctrl+C para detener\n')

    # Iniciar observador de archivos
    event_handler = JupyterBookHandler()
    observer = Observer()
    observer.schedule(event_handler, str(content_directory), recursive=True)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print('\n[DETENIENDO...]')
        observer.stop()

    observer.join()
    print('[LISTO]')
