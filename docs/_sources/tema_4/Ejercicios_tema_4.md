# Tema 4 — Funciones en Python y módulos externos (Hoja de ejercicios)

```{admonition} Objetivos de aprendizaje
:class: tip
- Definir, documentar y utilizar **funciones** en Python (`def`, `return`, parámetros y ámbito).
- Organizar código en **módulos** y practicar **importaciones** selectivas y de módulo completo.
- Aplicar funciones a **problemas de Física** (Reynolds, frenada, distancias geodésicas).
- Consumir **APIs web** sencillas desde Python utilizando `requests`.
```

```{admonition} Requisitos previos
:class: important
- Python 3.10+ y VSCode con la extensión de Python.  
- Conocimientos básicos de control de flujo, listas y diccionarios.  
- (Opcional) `numpy` para algunos cálculos y `requests` para APIs.
```

```{admonition} Contenidos del tema
:class: seealso
- Sintaxis y **ámbito** de las funciones; valores de retorno múltiples.  
- **Módulos** y `import` (`from paquete import nombre`, `import paquete`).  
- Buenas prácticas: **nombres claros**, **docstrings**, **tipado** (anotaciones).  
- Uso de **APIs** con `requests` y tratamiento de JSON.
```

---

## Enunciados básicos

### 1. Número de Reynolds como función

**Enunciado.**  
Implementa una función que calcule el **número de Reynolds** y devuelva **dos valores**: el número y el **régimen** como cadena `"laminar"`, `"transición"` o `"turbulento"`.

```{admonition} Recordatorio
:class: hint
- Fórmula: $ \mathrm{Re} = \dfrac{\rho\, v\, L}{\mu} $ o $ \mathrm{Re} = \dfrac{v\, L}{\nu} $.  
- Umbrales típicos en tuberías: `laminar < 2300`, `2300–4000 transición`, `> 4000 turbulento`.  
- Devuelve tuplas en Python: `return re, regimen`.
```

---

### 2. Reimplementación de funciones de MATLAB en Python

**Enunciado.**  
En un **mismo fichero** define las siguientes funciones, y realiza una llamada de prueba a cada una en el propio documento:

- `factorial(n)` (convertir el programa de la sesión anterior en **función**).  
- `csr(...)` se corresponde a **combinaciones sin repetición**. La fórmula es $ \mathrm{CSR} = \dfrac{n!}{r!(n-r)!} $.  
- `ajuste_lineal(x, y)` → Recuerda el ejercicio AJUSTE realizado anteriormente; devuelve `m, b` de la recta $ y = m x + b $ que mejor ajusta los datos definidos por las listas `x` e `y`. Realiza este ejercicio una vez hayamos tratado `numpy`. Puedes compronbar tu función con `numpy.polyfit(x, y, 1)`.

```{admonition} Recordatorio
:class: hint
- **Factorial**: valida `n` entero y `n >= 0`.  
- **Ajuste lineal**: usa las fórmulas vistas en clase (medias, sumatorios). Estas son:

$$
m = (N·Σ(xy) - Σx·Σy) / (N·Σ(x²) - (Σx)²)
$$
$$
b = (Σy - m·Σx) / N
$$
donde N es el número de puntos (longitud de las listas x e y).
```

```{admonition} Nota de estilo
:class: tip
- Evita `print` dentro de las funciones; **devuelve** resultados para poder probarlos.
```

---

### 3. Módulos propios: `TIF.py` y `Principal.py`

**Enunciado.**  
Crea un fichero `TIF.py` con las funciones del ejercicio 2. En `Principal.py`, prueba **dos formas** de importación:

```python
from TIF import factorial
# ... o bien ...
import TIF
```

````{admonition} Recordatorio
:class: hint
- Accede con `TIF.funcion(...)` cuando importas el módulo completo.  
````

````{admonition} ¿Qué es __pycache__?
:class: hint

Es la carpeta donde Python guarda **bytecode compilado** (`.pyc`) para acelerar cargas futuras.  
Se regenera automáticamente al importar módulos.
````

---

### 4. Distancia Haversine como función

**Enunciado.**  
Implementa `get_haversine_distance(lat1, lon1, lat2, lon2)` que reciba **latitudes y longitudes en grados** y devuelva la distancia **en km** entre ambos puntos sobre la esfera terrestre.

```{admonition} Recordatorio
:class: hint
- Convierte a **radianes** con `math.radians`.  
- Fórmula de Haversine con radio medio terrestre $ r = 6372.7954\ \mathrm{km} $.  
- Devuelve un número (float). Evita `print` dentro de la función.
```

---

### 5. Añadir números primos a una lista

**Enunciado.**  
Desarrolla una función que **reciba una lista** y **añada dos números primos**.  
- Si la lista está **vacía**, añade los **dos primeros primos**.  
- En caso contrario, toma el **último elemento** y añade los **dos siguientes primos**.  
- **Llama 100 veces** a la función, pasando **la misma lista**.  
- ¿Cuántos valores tiene la lista al final?

```{admonition} Recordatorio
:class: hint
- Implementa un `siguiente_primo(n)` sencillo.  
- Documenta si la función **modifica in place** o **devuelve** la lista nueva.
```

---

### 6. Distancia de frenado con fricción

**Enunciado.**  
Un coche circula a velocidad inicial $v_0$ y el conductor frena. Implementa una función que calcule la **distancia de frenado** $d$ cuando se proporcionan $v_0$ y el **coeficiente de fricción** $\mu$.  
Usa los **casos de prueba**: $v_0 = 50$ km/h y $v_0 = 30$ km/h con $\mu = 0.3$. Convierte **km/h → m/s** antes del cálculo.

```{admonition} Recordatorio
:class: hint
- Fórmula clásica (modelo uniforme): $ d = \dfrac{v_0^2}{2\,\mu\,g} $, con $ g \approx 9.81\ \mathrm{m/s^2} $.  
- Convierte: `v_ms = v_kmh * 1000 / 3600`.
```

---

## Enunciados adicionales (listas, diccionarios, funciones y APIs)

### 7. Genera un briefing con Gemini (API Google Generative AI)

**Enunciado.**  
Regístrate en [Google AI Studio](https://aistudio.google.com/app/apikey) y crea una **API key** para Gemini. Implementa una función que consulte el endpoint HTTP oficial de Gemini, reciba un `prompt` y devuelva un diccionario con la siguiente estructura:

```python
{
	"model": "gemini-1.5-flash",
	"prompt": "...",
	"text": "...",        # Respuesta principal en texto plano
	"citations": [...],    # Lista (posiblemente vacía) con cualquier mención relevante
}
```

Utiliza esa función para generar, a partir de un tema científico de tu elección, un briefing de tres frases que incluya al menos una referencia o recomendación adicional.

```python
import os
import requests

GEMINI_URL = (
	"https://generativelanguage.googleapis.com/"
	"v1beta/models/gemini-1.5-flash:generateContent"
)

def generate_briefing(prompt: str, api_key: str | None = None) -> dict[str, object]:
	"""Lanza una petición a Gemini y devuelve un diccionario con el formato acordado."""
	key = api_key or os.getenv("GEMINI_API_KEY")
	if not key:
		raise ValueError("Configura la variable de entorno GEMINI_API_KEY con tu clave personal.")

	payload = {
		"contents": [{"parts": [{"text": prompt}]}],
		"safetySettings": [
			{"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"}
		],
	}

	response = requests.post(
		GEMINI_URL,
		params={"key": key},
		json=payload,
		timeout=30,
	)
	response.raise_for_status()
	data = response.json()

	candidate = data.get("candidates", [{}])[0]
	text = "".join(part.get("text", "") for part in candidate.get("content", {}).get("parts", []))
	citations = candidate.get("citations", [])

	return {
		"model": "gemini-1.5-flash",
		"prompt": prompt,
		"text": text.strip(),
		"citations": citations,
	}
```

```{admonition} Recordatorio
:class: hint
- No compartas tu **API key** en repositorios públicos; usa un `.env` o variables de entorno.  
- Añade manejo de errores (`requests.RequestException`, claves ausentes, etc.).  
- Revisa la política de uso de Google AI Studio para respetar límites de peticiones y casos de uso.
```

---

### 8. Explora otra API científica

**Enunciado.**  
Elige una API de https://publicapis.dev/category/science-and-math e **haz una petición sencilla** desde Python.  
Ejemplo rápido sin clave: *Numbers API*

```python
import requests
print(requests.get("http://numbersapi.com/42?json", timeout=10).json())
```

```{admonition} Recordatorio
:class: hint
- Lee la **documentación** de cada API y respeta límites de uso.  
- Añade manejo de **excepciones** (`try/except requests.RequestException`).
```

---

## Recomendaciones generales

- Prefiere funciones **puras** (devuelven valores sin imprimir ni leer de teclado).  
- Añade **docstrings** y **anotaciones de tipo**; facilita pruebas con `pytest` o `doctest`.  
- Nombra con claridad (`ncr` mejor que `csr`, si se trata de combinaciones sin repetición).  
- Valida entradas y documenta supuestos físicos y unidades.
