"""
Helper script para watch mode del Jupyter Book
Monitorea cambios en archivos y reconstruye automáticamente
Incluye auto-refresh del navegador
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
from urllib.parse import urlparse


# Variable global para notificar a los clientes SSE
rebuild_event = threading.Event()


class JupyterBookHandler(FileSystemEventHandler):
    """Handler para detectar cambios y reconstruir el libro"""

    def __init__(self):
        self.last_build = 0
        self.build_delay = 2  # Esperar 2 segundos entre builds

    def on_modified(self, event):
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
                    print('[✓ LISTO] Navegador se recargará automáticamente...')
                    # Notificar a los clientes para que recarguen
                    rebuild_event.set()
                    time.sleep(0.5)  # Dar tiempo para que se complete
                    rebuild_event.clear()
                else:
                    print('[! ADVERTENCIA] Build completado con algunos errores')
                print(f'{"="*50}\n')


class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler personalizado que sirve desde un directorio específico e inyecta auto-reload"""

    def __init__(self, *args, directory=None, **kwargs):
        self.directory_path = directory
        super().__init__(*args, directory=directory, **kwargs)

    def end_headers(self):
        # Permitir CORS para SSE
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

    def do_GET(self):
        # Endpoint para Server-Sent Events (auto-reload)
        if self.path == '/__reload_sse__':
            self.send_response(200)
            self.send_header('Content-Type', 'text/event-stream')
            self.send_header('Cache-Control', 'no-cache')
            self.send_header('Connection', 'keep-alive')
            self.send_header('X-Accel-Buffering', 'no')  # Para nginx/proxies
            self.end_headers()

            # Mantener conexión abierta y enviar eventos de reload
            try:
                # Enviar mensaje inicial
                self.wfile.write(b': connected\n\n')
                self.wfile.flush()

                while True:
                    if rebuild_event.wait(timeout=30):
                        # Enviar evento de reload
                        message = b'event: reload\ndata: {"time": %d}\n\n' % int(time.time())
                        self.wfile.write(message)
                        self.wfile.flush()
                        print('[SSE] Señal de reload enviada a cliente')
                    else:
                        # Keep-alive cada 30 segundos
                        self.wfile.write(b': ping\n\n')
                        self.wfile.flush()
            except (BrokenPipeError, ConnectionResetError, ConnectionAbortedError) as e:
                print(f'[SSE] Cliente desconectado: {type(e).__name__}')
            return

        # Para cualquier otro archivo
        super().do_GET()

    def do_POST(self):
        super().do_POST()

    def send_head(self):
        """Override para inyectar script en archivos HTML"""
        path = self.translate_path(self.path)

        if os.path.isfile(path) and path.endswith('.html'):
            try:
                with open(path, 'rb') as f:
                    content = f.read()

                # Inyectar script de auto-reload antes de </body>
                reload_script = b'''
<script>
// Auto-reload via Server-Sent Events
(function() {
    console.log('[Auto-reload] Iniciando conexion SSE...');

    let eventSource;
    let reconnectAttempts = 0;
    const maxReconnectAttempts = 5;

    function connect() {
        try {
            eventSource = new EventSource('/__reload_sse__');

            eventSource.onopen = function(e) {
                console.log('[Auto-reload] ✓ Conectado al servidor de auto-reload');
                reconnectAttempts = 0;
            };

            eventSource.addEventListener('reload', function(e) {
                console.log('[Auto-reload] ⟳ Cambios detectados, recargando pagina...');
                eventSource.close();
                setTimeout(() => {
                    location.reload();
                }, 500);
            });

            eventSource.onmessage = function(e) {
                console.log('[Auto-reload] Mensaje recibido:', e.data);
            };

            eventSource.onerror = function(e) {
                console.error('[Auto-reload] ✗ Error en conexion SSE:', e);
                eventSource.close();

                if (reconnectAttempts < maxReconnectAttempts) {
                    reconnectAttempts++;
                    const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 10000);
                    console.log('[Auto-reload] Reintentando en ' + (delay/1000) + ' segundos... (intento ' + reconnectAttempts + ')');
                    setTimeout(connect, delay);
                } else {
                    console.warn('[Auto-reload] Maximos intentos alcanzados. Recarga manual necesaria.');
                }
            };
        } catch (err) {
            console.error('[Auto-reload] Error al crear EventSource:', err);
        }
    }

    // Iniciar conexion
    connect();

    // Limpiar al salir
    window.addEventListener('beforeunload', function() {
        if (eventSource) {
            eventSource.close();
        }
    });
})();
</script>
'''

                if b'</body>' in content:
                    content = content.replace(b'</body>', reload_script + b'</body>')
                else:
                    content += reload_script

                self.send_response(200)
                self.send_header('Content-Type', 'text/html')
                self.send_header('Content-Length', str(len(content)))
                self.end_headers()

                from io import BytesIO
                return BytesIO(content)
            except:
                pass

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
    print('[SERVIDOR HTTP INICIADO CON AUTO-RELOAD]')
    print('URL: http://localhost:8000')
    print(f'Sirviendo desde: {serve_directory}')
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
