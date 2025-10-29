# Tema 2 — Estructuras selectivas y repetitivas (Hoja de ejercicios)

```{admonition} Objetivos de aprendizaje
:class: tip
- Practicar **sentencias selectivas**: `if`, `elif`, `else`.
- Usar **bucles** `for` y `while` para iteraciones controladas.
- Entender y aplicar **sentencias de control**: `break`, `continue` y `pass`.
- Validar entradas por consola (`input`) y realizar *casting* de tipos (`int`, `float`, `str`).
- Trabajar con funciones útiles como `enumerate` en bucles.
- Implementar pequeños algoritmos clásicos (conversión binario→decimal, factorial, patrones de texto, FizzBuzz, aproximación de π).
```

```{admonition} Requisitos previos
:class: important
- Python 3.10+ instalado.
- VSCode con extensión de Python.
- Conocimientos mínimos de consola/terminal.
```

```{admonition} Contenidos del tema
:class: seealso
- **Selectivas**: `if`, `elif`, `else`
- **Repetitivas**: `for`, `while`
- **Control de bucle**: `break`, `continue`, `pass`
```

---

## 1. Conversor de binario (sin signo) a decimal

**Enunciado.** Escribe un programa que pida por consola una **cadena** con un número binario **sin signo** y devuelva su **valor decimal**.  
Pista: recorre la cadena de derecha a izquierda o usa `enumerate` sobre la cadena invertida.

La salida debería ser similar a:

```text
Introduzca un numero en binario:10111011
  1    0   1   1   1   0   1   1
128   64  32  16   8   4   2   1
El numero binario 10111011 es 187 en decimal
```

```{admonition} Recordatorio
:class: hint
- Una cadena binaria como `"1011"` representa $1\cdot 2^3 + 0\cdot 2^2 + 1\cdot 2^1 + 1\cdot 2^0 = 11$.
- Puedes invertir con `reversed(cadena)` o `cadena[::-1]`.
- `enumerate(iterable)` te da pares `(indice, valor)`. Útil para potencias.
- Valida que la entrada **solo contiene** `0` y `1`; en caso contrario, vuelve a pedirla.
- Puedes utilizar tabuladores para alinear la salida. Usa `\t` para tabulaciones al igual que `\n` era un salto de línea.
```

---

## 2. Factorial con validación de entrada

**Enunciado.** Pide al usuario un **número natural** $n$.  
Si es válido ($n \ge 0$), calcula **n!**. Si no lo es, vuelve a pedir el valor hasta que cumpla el requisito.

Un posible ejemplo de ejecución del programa:

```text
Introduzca un numero natural: -3
Entrada no valida.
Introduzca un numero natural: 5
El factorial de 5 es 120.
``` 


```{admonition} Recordatorio
:class: hint
- Valida con un bucle `while` hasta obtener un entero $n$ con $n \ge 0$.
- Implementa el factorial con `for` o `while` (también existe `math.factorial`).
- Haz pruebas con valores grandes y observa tiempos: en Python, `int` es de [precisión arbitraria](https://docs.python.org/3/c-api/long.html), pero el tiempo y la memoria crecen con $n$.
```


---

## 3. Dibuja un patrón con bucles anidados

**Enunciado.** Muestra exactamente el siguiente patrón por consola. Intenta pensar una solución con **bucles anidados**.

```
*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*
```

```{admonition} Recordatorio
:class: hint
- Divide el problema en **fase ascendente** y **fase descendente**.
- Usa bucles anidados o genera cada línea con `'* ' * k` y `strip()`.
- Controla los saltos de línea con `print(..., end="")` si lo necesitas.
```

---

## 4. FizzBuzz (múltiplos de 5 y 7)

**Enunciado.** Recorre los números desde **1** hasta un **límite** indicado por el usuario.  
Imprime:
- `"Fizz"` en lugar del número si es múltiplo de **7**,
- `"Buzz"` si es múltiplo de **5**,
- `"FizzBuzz"` si es múltiplo de **5 y 7**,
- el número en caso contrario.

```{admonition} Recordatorio
:class: hint
- Usa el operador módulo `%` para la divisibilidad. Por ejemplo, `n % 5 == 0` indica que `n` es múltiplo de 5.
- **El orden importa**: comprueba primero el caso **ambos** (5 y 7).
- Añade validación para que el límite sea un entero positivo.
```

---

## 5. Aproxima π con la **Serie de Gregory–Leibniz**

La [serie de Gregory–Leibniz](https://es.wikipedia.org/wiki/Serie_de_Leibniz) para $\frac{\pi}{4}$ es:

$$
\frac{\pi}{4} = 1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \cdots = \sum_{k=0}^{\infty} \frac{(-1)^k}{2k+1}.
$$

**Enunciado.** Pide al usuario una **tolerancia positiva** $\varepsilon$ que represente la **diferencia máxima permitida entre dos sumas parciales consecutivas**.  
Suma términos hasta que $|S_n - S_{n-1}| < \varepsilon$ y reporta $\pi \approx 4\,S_n$.


Una posible ejecución del programa:

```text
Introduzca la tolerancia (ej. 1e-6): 0.01 
Iteracion N=1, Error: 1.0 
Iteracion N=2, Error: 0.33333333333333326 
Iteracion N=3, Error: 0.19999999999999996 
....
Iteracion N=49, Error: 0.010309278350515427 
Iteracion N=50, Error: 0.010101010101010055 
Iteracion N=51, Error: 0.00990099009900991 
Aproximacion de pi: 3.1611986129870506
```

```{admonition} Recordatorio
:class: hint
- Usa un `while` que avance el índice `k` y acumule en `S`.
- La serie **converge lentamente**; elige $\varepsilon$ razonable (p. ej., `1e-6`).
- Puedes mostrar una **traza**: cada cierto número de iteraciones imprime el error aproximado.
- Considera `decimal` si quieres controlar precisión, aunque no es necesario.
```

---

## 6. (Adicional) Aproxima π con **Monte Carlo**

Imagina un tablero cuadrado **1×1** que contiene **un cuarto de círculo** de radio 1 en una esquina.  

Si generas puntos aleatorios $(x, y)$ uniformes en $[0,1]\times[0,1]$, la fracción que cae dentro del cuarto de círculo (de color rojo donde $x^2 + y^2 \le 1$) aproxima $\pi/4$.

:::{figure} https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Pi_monte_carlo_all.gif/660px-Pi_monte_carlo_all.gif
:alt: Simulación Monte Carlo para aproximación de pi
:width: 50%
:name: fig:pi-montecarlo

Animación que muestra puntos aleatorios en el cuadrante y la convergencia visual de la estimación de $\pi$. Fuente: [Wikimedia Commons - Pi_monte_carlo_all.gif](https://commons.wikimedia.org/wiki/File:Pi_monte_carlo_all.gif). 
:::

**Enunciado.** Pide un entero **t** (número de lanzamientos/puntos).  
Genera $t$ puntos aleatorios $(x, y)$ en $[0,1]^2$, cuenta cuántos caen dentro del cuarto de círculo (**g**), y estima:

$
\pi \approx \frac{4g}{t}.
$

```{admonition} Recordatorio
:class: tip
- Usa `from random import random` para generar `x = random()` y `y = random()`.
- Utiliza la distancia al origen para determinar si el punto está dentro del cuarto de círculo.
- Prueba distintos valores de `t` (p. ej., 1e3, 1e4, 1e5) y observa la **[ley de los grandes números](https://es.wikipedia.org/wiki/Ley_de_los_grandes_n%C3%BAmeros)**.
```

## Recomendaciones generales de implementación

```{admonition} Buenas prácticas
:class: tip
- Valida entradas con bucles `while` (opcionalmente — si queréis — consultad los [materiales adicionales](../contenido_extra/w4-python-ad-exceptions.ipynb) para ver manejo de excepciones y como manejar si el usuario introduce un valor no válido).
- Documenta tus ejercicios con comentarios y comenta los pasos clave (sobre todo en las aproximaciones de π).
- Utiliza el depurador de VSCode para seguir la ejecución paso a paso.
```

## Referencias y enlaces útiles

- Serie Gregory–Leibniz: https://es.wikipedia.org/wiki/Serie_de_Leibniz
- El Método Montecarlo explicado por [Eduardo Sáenz de Cabezón](https://investigacion.unirioja.es/investigadores/247/detalle) en el canal de YouTube "Derivando"

<div style="position: relative; padding-bottom: 70.25%; height: 0; overflow: hidden;margin-bottom: 2em;">
<iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://www.youtube.com/embed/m4X94Sq1Q4M" title="
Ruletas y bombas atómicas: EL MÉTODO MONTECARLO" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen loading="lazy"></iframe>
</div>


