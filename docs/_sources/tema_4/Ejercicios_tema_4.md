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
- Uso de **APIs** con funciones proporcionadas por terceros.
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

- Si la lista está **vacía**, añade los **dos primeros primos**.  
- En caso contrario, toma el **último elemento** y añade los **dos siguientes primos**.  
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

## Enunciados adicionales (listas, diccionarios, funciones y APIs)


### 7. Genera preguntas tipo test con Gemini (API Google Generative AI)

:::{figure} ../images/tema_4/gemini.png
:alt: Logotipo de Gemini
:width: 50%
:name: fig:gemini-logo

Generando contenido estructurado con Gemini, la plataforma de modelos generativos de Google.
:::

**Enunciado.**  
En los últimos años han aparecido modelos de lenguaje de gran tamaño (*Large Language Models*, LLMs) como ChatGPT o Gemini. Normalmente los usamos "a mano", escribiendo directamente preguntas en una web como usuarios finales. Sin embargo, también es posible utilizarlos desde nuestros propios programas mediante una **API** (*Application Programming Interface*). Una API no es más que un conjunto de funciones que podemos llamar desde nuestro código para pedirle a otro sistema que haga algo por nosotros, sin necesidad de saber cómo está implementado por dentro.

En este ejercicio vais a usar un modelo de **Gemini** para generar automáticamente preguntas tipo test sobre un tema que indique el usuario. En la carpeta de este tema encontraréis el fichero `ExamGPT.py`, que contiene la función ya implementada `generar_pregunta_test`. Esa función se ocupa de toda la parte complicada de hablar con la API de Gemini y de pedirle al modelo que devuelva la información en un formato estructurado. Solo tenéis que conocer qué entradas tiene la función y qué salidas produce para integrarla en vuestro programa (si tenéis curiosidad también podéis abrir el fichero y estudiar su código).

Descargad {download}`ExamGPT.py`, colocadlo junto a vuestro `main.py` e importad la función:

```python
from ExamGPT import generar_pregunta_test

pregunta = generar_pregunta_test(tema, api_key)
```

**Entradas y salidas de la función.**  
- `tema` (`str`): texto corto que define el ámbito de la pregunta (por ejemplo, "derivadas", "mecánica cuántica", etc.). Se utiliza como *prompt* dentro de la función.  
- `api_key` (`str`): vuestra clave personal de Gemini (ver requisitos).  
- Devuelve un diccionario con la forma:

```python
{
	"pregunta": "texto de la pregunta",
	"opciones": [
		{
			"texto": "texto de la opción 1",
			"es_correcta": True or False,
			"explicacion": "por qué esta opción es correcta o incorrecta",
		},
		# ... hasta un total de 4 opciones
	],
}
```

**Programa solicitado.**  
Implementad un script que:
1. Defina vuestra API key de Gemini en una variable (o la lea de una fuente segura).  
2. Pida al usuario el tema por consola.  
3. Genere una pregunta usando `generar_pregunta_test`.  
4. Muestre por pantalla la pregunta y cada opción numerada, accediendo a las claves del diccionario.  
5. Solicite una respuesta al usuario como número del 1 al 4.  
6. Compruebe si la respuesta seleccionada es correcta.  
7. Muestre el resultado: si es correcta, felicita y muestra la explicación; si es incorrecta, informa, muestra la explicación de la opción elegida y la opción correcta con su explicación. Procura que la salida sea clara y agradable.

**Requisitos previos.**  
- Obtener una API key de Gemini en [Google AI Studio](https://aistudio.google.com/app/apikey).  
- Instalar la biblioteca `google-genai` ejecutando `pip install -q -U google-genai`.  
- Realizar los `import` tal como se indica en el ejemplo y disponer de conexión a Internet.  
- Controlar posibles errores (`requests` o `google` pueden lanzar excepciones) y respetar los límites de uso de la API.  
- No compartáis vuestra API key en repositorios públicos ni en entregas visibles: almacenadla en variables de entorno o en un archivo ignorado por control de versiones.

**Mejoras opcionales.**  
1. Solicita al usuario un nivel de dificultad (1 = fácil, 2 = medio, 3 = difícil) y modifica el `tema` para guiar al modelo hacia ese nivel. Observa en `ExamGPT.py` cómo se usa el parámetro `tema`.  
2. Pide al usuario cuántas preguntas desea (N) y genera un examen completo sobre el mismo tema. Usa un bucle para obtener N preguntas, guárdalas en una lista y recorre dicha lista para mostrarlas y recoger respuestas secuencialmente. Muestra el resultado final al terminar (número de aciertos, porcentaje, si había aprobado, etc.).

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
- Instala `requests` si no la tienes: `pip install requests`.
- Añade manejo de **excepciones** (`try/except requests.RequestException`).
```

## Recomendaciones generales

- Prefiere funciones **puras** (devuelven valores sin imprimir ni leer de teclado).  
- Añade **docstrings** y **anotaciones de tipo**.
- Utiliza parametros con valores por defecto cuando tenga sentido. Ejemplo: `def funcion(param1, param2=valor_por_defecto):`
