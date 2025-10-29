# Tema 1 — Introducción a Python (Hoja de ejercicios)

```{admonition} Objetivos de aprendizaje
:class: tip
- Familiarizarte con el entorno de trabajo (VSCode + extensiones de Python).
- Practicar **variables y operadores**, **casting** de tipos y E/S por consola (`input`, `print`).
- Usar `import` para **bibliotecas estándar** (`math`) y de **terceros** (`haversine`).
- Implementar y validar la **fórmula de Haversine**.
- Reproducir en Python un cálculo clásico de **Número de Reynolds**.
```

```{admonition} Requisitos previos
:class: important
- Python 3.10+ instalado.
- VSCode con extensión de Python.
- Conocimientos mínimos de consola/terminal.
```

## 1. Par o impar

**Enunciado.** Escribe un programa que determine si un número entero es **par** o **impar**.  
Usa `input()` para leer, `int()` para *casting* y el operador **módulo** `%`. De momento no es necesario validar la entrada.


```{admonition} Recordatorio
:class: hint
* Recuerda que `n % 2 == 0` indica que `n` es par.
* La función `input()` devuelve una cadena, usa operaciones de *casting* como `int()` para convertir a entero.
* Practica el uso de `if`/`else` para la lógica condicional.
* Usa `print()` para mostrar el resultado.
* Revisa el uso de las f-strings para formatear la salida.
```



## 2. Ficha personal con formato

**Enunciado.** Pide **nombre**, **apellidos**, **edad**, **peso** (kg), **altura** (m) y **DNI** (número y letra).  
Muestra exactamente el formato:

> Se llama **XXX XXXX XXXX**, tiene **XX** años, pesa **XX.X** kg, mide **XX.XX** m y su número de DNI es **XXXXX** y letra **X**.

```{admonition} Recordatorio
:class: hint
- Usa `input()` para cada dato y convierte a tipos adecuados (`int`, `float`).
- F-strings con formato: `peso:.1f`, `altura:.2f`. Chuleta de f-strings: <https://fstring.help/cheat/>
```

## 3. Distancia entre coordenadas (Fórmula de Haversine)

La [fórmula de Haversine](https://en.wikipedia.org/wiki/Haversine_formula) permite calcular la distancia entre dos puntos en la superficie de una esfera a partir de sus latitudes y longitudes.

:::{figure} ../images/tema_1/haversine_wikipedia.png
:alt: Distancia 
:width: 50%
:name: fig:haversine-diagram

Un diagrama que ilustra la distancia entre dos puntos en la superficie de una esfera según la fórmula de Haversine. Fuente: [CheCheDaWaff](https://commons.wikimedia.org/wiki/User:CheCheDaWaff), vía [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Illustration_of_great-circle_distance.svg). Licencia: [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
:::


**Enunciado.** Pide latitudes y longitudes (en **grados decimales**) de dos puntos y calcula la distancia usando
la **fórmula de Haversine** con funciones del módulo `math` (`radians`, `cos`, `sin`, `asin`, `sqrt`).

Sea $r = 6372.7954\ \text{km}$ el radio medio terrestre.  
Para $(\varphi_1,\lambda_1)$ y $(\varphi_2,\lambda_2)$ en **radianes**:

$$
\begin{align*}
\Delta \varphi = \varphi_2 - \varphi_1 \\
\Delta \lambda = \lambda_2 - \lambda_1 \\
a = \sin^2\left(\frac{\Delta \varphi}{2}\right) +
\cos(\varphi_1)\cos(\varphi_2)\sin^2\left(\frac{\Delta \lambda}{2}\right) \\
d = 2r \arcsin(\sqrt{a})
\end{align*}
$$


```{admonition} Recordatorio
:class: hint
* Convierte grados a radianes con `math.radians`. 
* Valida rangos: lat ∈ [-90, 90], lon ∈ [-180, 180].
* Prueba con coordenadas conocidas, por ejemplo:
  - Salamanca (40.9704, -5.6635) a Madrid (40.4168, -3.7038) ≈ 168 km (este valor dependerá de la fórmula implementada y del radio terrestre usado).

Puedes obtener las coordenadas de ciudades con [Google Maps](https://www.google.com/maps) pulsando con el botón derecho en el mapa y obteniendo la las coordenadas del punto. También puedes usar la opción de *medir distancia* para comprobar resultados.

![Medir distancia en Google Maps](../images/tema_1/medir_distancia_gmaps.jpg)
```

## 4. Distancia con la biblioteca `haversine`

**Enunciado.** Repite el cálculo anterior, pero ahora usando la biblioteca de terceros `haversine`.

En este caso será necesario instalar la biblioteca. Desde la terminal de VSCode (o cualquier consola), tienes que seguir los siguientes pasos:

1. **Asegúrate de tener el entorno virtual activado** (si lo estás usando). Por ejemplo, en Windows CMD:

Si el entorno virtual está en la carpeta `.conda` dentro de la carpeta raíz del proyecto:
```bash
conda activate ./.conda
```

2. **Instala la biblioteca** [`haversine`](https://pypi.org/project/haversine/) usando `pip`, el gestor de paquetes de Python:

```bash
pip install haversine
```

3. Explora los ejemplos disponibles en la [documentación oficial](https://pypi.org/project/haversine/) para usar la función adecuada.

Ejemplo básico de uso:

```python
from haversine import haversine, Unit
point1 = (lat1, lon1)
point2 = (lat2, lon2)
distance = haversine(point1, point2, unit=Unit.KILOMETERS)
print(f"La distancia es {distance:.2f} km")
```

```{admonition} Consejos
:class: tip
* Asegúrate de que las coordenadas estén en el formato correcto (grados decimales).
* **Compara los resultados con la implementación anterior** para verificar la precisión.
* Revisa el código fuente de la biblioteca en [GitHub](https://github.com/mapado/haversine/blob/e0daab1fcd8def37ac0449dd05814a64a93d357a/haversine/haversine.py#L116) para entender cómo se implementa la fórmula internamente.
```
---

## 5. (Adicional) Número de Reynolds

El número de Reynolds es un parámetro adimensional que caracteriza el régimen de flujo de un fluido. A continuación se muestra un video con un experimento visualizando diferentes regímenes de flujo según el valor del número de Reynolds:

<div style="position: relative; padding-bottom: 70.25%; height: 0; overflow: hidden;margin-bottom: 2em;">
<iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://www.youtube.com/embed/xMheDmiKH38?t=365" title="Documental de Python (YouTube)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen loading="lazy"></iframe>
</div>

**Enunciado.** Implementa en Python el cálculo del **Número de Reynolds**.
Recuerda la definición típica \( Re = \dfrac{\rho\, v\, D}{\mu} \) (ajusta a la formulación de tu práctica).

```{hint}
- Pide por consola densidad \(\rho\), velocidad \(v\), diámetro \(D\) (o longitud característica) y viscosidad \(\mu\).
- Devuelve **Re** y clasifica el régimen (turbulento/transicional/laminar según umbrales habituales).
```
---

## Referencias y enlaces útiles

- Documentación de Python: <https://docs.python.org/3/>
- Conversión angular en `math`: <https://docs.python.org/3/library/math.html#angular-conversion>
- Fórmula de Haversine (Wikipedia): <https://en.wikipedia.org/wiki/Haversine_formula>
- `haversine` en PyPI: <https://pypi.org/project/haversine/>
- F-strings *cheat sheet*: <https://fstring.help/cheat/>
- VSCode para Python: <https://code.visualstudio.com/docs/languages/python>

```{admonition} Nota de procedencia
:class: note
Estos enunciados están adaptados del material del **Tema 1** de la asignatura *Técnicas Informáticas en Física*
(Grado en Física), extendidos y formateados para su uso en Jupyter Book con MyST Markdown.
```