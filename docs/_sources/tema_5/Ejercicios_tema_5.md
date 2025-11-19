# Tema 5 — Numpy y Matplotlib (Hoja de ejercicios)

```{admonition} Objetivos de aprendizaje
:class: tip
- Trabajar con **arrays N-dimensionales** de Numpy (`ndarray`): creación, indexación y operaciones.
- Aplicar **funciones matemáticas** de Numpy de forma vectorizada sobre arrays.
- Realizar **operaciones matriciales** (submatrices, productos, exponenciales elemento a elemento).
- Representar datos con **Matplotlib**: títulos, etiquetas, leyendas, estilos y `subplot`.
- Cargar y analizar datos desde **ficheros CSV** con `np.genfromtxt` (más adelantes veremos `pandas` para análisis de datos).
- Visualizar la **convergencia de métodos numéricos** (serie de Gregory-Leibniz, Monte Carlo) para el cálculo de π.
```

```{admonition} Requisitos previos
:class: important
- Python 3.10+ y VSCode con la extensión de Python.  
- Haber trabajado con tipos básicos, listas y bucles en Python.  
- Tener instaladas las bibliotecas `numpy` y `matplotlib` (por ejemplo mediante `pip install numpy matplotlib`).  
- Conocer los ejercicios del **Tema 3** sobre el cálculo de π (serie de Gregory-Leibniz y método de Monte Carlo).
```

```{admonition} Contenidos del tema
:class: seealso
- Creación de arrays con `np.array`, `np.linspace` y lectura de datos con `np.genfromtxt`.  
- Indexación, slicing y selección de **submatrices**; funciones agregadas (`np.max`, `np.min`, `np.exp`, …).  
- Ajuste de datos con `np.polyfit` y evaluación con `np.polyval`.  
- Representación de datos con **Matplotlib**: `plot`, `scatter`, estilos, leyendas y `subplot`.  
- Integración de Numpy y Matplotlib para analizar datos científicos (meteorología, métodos numéricos, etc.).
```

---

## Enunciados básicos

### 1. Arrays, funciones y representación con Matplotlib

**Enunciado.**  
Define un array de **200 elementos** entre los valores -50 y 50 utilizando `np.linspace`.  
Calcula el valor de la función

$$
f(x) = \log(x) \cdot \sin(x)
$$

:::{figure} ../images/tema_5/ejercicio1_tema5.png
:alt: Representación de f(x)=log(x)*sin(x)
:width: 50%
:name: fig:simple_plot

Plot resultante
:::

para todos los valores del array. Posteriormente:

1. **Representa** dichos valores con un `plot`.  
2. Observa qué ocurre con los valores tras el cálculo (especialmente para los valores de `x` en los que `log(x)` no está definido).  
3. Responde: ¿se representan correctamente todos los puntos con `plot`? ¿Aparecen huecos o advertencias?  
4. Da **título** a la gráfica, añade **etiquetas** a los ejes, limita el eje x a los valores mínimo y máximo del array, añade una **leyenda** y representa los valores con **asteriscos verdes** y **línea discontinua**.

````{admonition} Recordatorio
:class: hint
- Importaciones típicas:

  ```python
  import numpy as np
  import matplotlib.pyplot as plt
  ```

- Generar 200 puntos entre -50 y 50:  
  `x = np.linspace(-50, 50, 200)`
- La función logarítmica de Numpy es `np.log`. Para valores negativos devolverá `nan` y puede lanzar *warnings*.
- Estilos de representación, por ejemplo:  
  `plt.plot(x, y, 'g*--', label="f(x) = log(x)*sin(x)")`
- No olvides `plt.title`, `plt.xlabel`, `plt.ylabel`, `plt.xlim` y `plt.legend()`.
````

---

### 2. Submatrices y operaciones matriciales con Numpy

**Enunciado.**  
Define en Python la siguiente matriz $A$ (4×4) utilizando Numpy:

:::{figure} ../images/tema_5/ejercicio2_tema5.png
:alt: Matriz con submatrices coloreadas
:width: 50%
:name: fig: slice_matrix

Matriz A
:::


Trabajando con Numpy:

1. Obtén la **submatriz en verde** indicada en el enunciado original (ver figura de la matriz coloreada).  
2. Obtén la **submatriz en rojo**.  
3. Obtén la **submatriz en azul**.  
4. Calcula el resultado de **multiplicar** la matriz azul por la matriz verde (en ese orden, usando producto matricial).  
5. Obtén la **exponencial** de los elementos de la matriz roja (función $e^x$ elemento a elemento).  
6. Calcula el **valor mayor de la primera fila** de $A$ y el **valor menor de la tercera columna** de $A$.

````{admonition} Recordatorio
:class: hint
- Por convención, las importaciones suelen ser:

  ```python
  import numpy as np
  ```

- Para definir la matriz:

  ```python
  A = np.array([
      [5, 6, 7, 7],
      [5, 6, 7, 6],
      [6, 7, 7, 7],
      [2, 2, 8, 2],
  ])
  ```

- En Numpy, **la indexación comienza en 0.**
- En Numpy, el slicing se hace con `matriz[inicio:fin_sin_incluir]` (el índice `fin` no se incluye). Ejemplo:
  ```python
  submatriz_roja = A[1:4, 0:3]  # Filas 1 a 3, columnas 0 a 2
  ```
- El slicing **no permite seleccionar filas y columnas no consecutivas.** (La submatriz verde no puede obtenerse con slicing).
- No obstante, para una indexación similar a MATLAB (seleccionar filas y columnas concretas aunque sean no consecutivas) se recomienda usar:

  ```python
  sub = A[np.ix_([filas], [columnas])]
  ```
  Por ejemplo, filas 0 y 2, columnas 1 y 2:  
  `A[np.ix_([0, 2], [1, 2])]`
- Producto matricial: `C = A @ B` o `np.matmul(A, B)`.  
- Exponencial elemento a elemento: `np.exp(matriz_roja)`.  
- Primera fila: `A[0, :]`; tercera columna: `A[:, 2]`.  
  Usa `np.max` y `np.min` según convenga.
````

---

### 3. Ajuste lineal y cuadrático con `np.polyfit`

**Enunciado.**  
Dispones de los siguientes **valores experimentales**:

- Variable independiente $x$:

$$
x = [1.2,\ 2.5,\ 3.4,\ 4.0,\ 5.4,\ 6.1,\ 7.2,\ 8.1,\ 9.0,\ 10.1]
$$

- Variable dependiente $y$:

$$
y = [24.8,\ 24.5,\ 24.0,\ 23.3,\ 22.4,\ 21.3,\ 20.0,\ 18.5,\ 16.8,\ 14.9]
$$

Se pide:

1. Ajusta los datos a un **modelo lineal** $y = m x + b$ utilizando `np.polyfit` con grado 1.  
2. Ajusta los mismos datos a un **modelo cuadrático** $y = ax^2 + bx + c$ utilizando `np.polyfit` con grado 2.  
3. Representa los datos y los ajustes usando `subplot` en **dos subplots diferentes**, de forma que la figura resultante sea similar a la mostrada en la hoja de enunciados:  
   - Subplot 1: datos experimentales y recta del modelo lineal.  
   - Subplot 2: datos experimentales y curva del modelo cuadrático.  
4. Muestra por pantalla los **coeficientes** del modelo lineal y del modelo cuadrático.


:::{figure} ../images/tema_5/ejercicio3_tema5.png
:alt: Representación de ajustes lineal y cuadrático
:width: 100%
:name: fig: representation_linear_quadratic

Representación de ajustes lineal y cuadrático
:::


````{admonition} Recordatorio
:class: hint
- Arrays de Numpy para los datos:

  ```python
  x = np.array([1.2, 2.5, 3.4, 4.0, 5.4, 6.1, 7.2, 8.1, 9.0, 10.1])
  y = np.array([24.8, 24.5, 24.0, 23.3, 22.4, 21.3, 20.0, 18.5, 16.8, 14.9])
  ```

- Ajuste lineal:

  ```python
  coef_lin = np.polyfit(x, y, 1)   # [m, b]
  ```

- Ajuste cuadrático:

  ```python
  coef_quad = np.polyfit(x, y, 2)  # [a, b, c]
  ```

- Para evaluar los modelos:

  ```python
  y_lin = np.polyval(coef_lin, x)
  y_quad = np.polyval(coef_quad, x)
  ```

- Para crear dos subplots:

  ```python
  fig, (ax1, ax2) = plt.subplots(1, 2)
  ```

  Luego usa `ax1.plot(...)`, `ax2.plot(...)`, añade títulos, etiquetas y leyendas en cada subplot.
````

---

### 4. Análisis de datos meteorológicos con `np.genfromtxt`

**Enunciado.**  
Se dispone de un fichero {download}`estacion_2867.csv` (en el mismo directorio que tu programa) con información meteorológica de Matacán. Cada fila del fichero contiene:

$$
\text{Año},\ \text{Mes},\ \text{Día},\ \text{TempMedia},\ \text{TempMaxima},\ \text{TempMinima}
$$


1. Carga los datos en una matriz Numpy llamada `matrix_datos` con:

   ```python
   matrix_datos = np.genfromtxt('estacion_2867.csv', delimiter=',')
   ```

2. Usando las funciones disponibles en Numpy, calcula y muestra por pantalla:  
   - La **temperatura media** de noviembre de **1990**.  
   - La **temperatura máxima** de noviembre de **1992**.  
   - La **temperatura mínima** del año **2010** (en cualquier mes).  
3. Inicialmente, recorre las filas de la matriz con un bucle y **almacena** aquellos registros que cumplan las condiciones anteriores. Posteriormente, intenta resolver lo mismo utilizando las funciones de Numpy (boolean masks, `np.mean`, `np.max`, `np.min`…).  
4. Representa en una **misma gráfica** las temperaturas de los 3 años anteriores (1990, 1992 y 2010) del **mes de noviembre** (por ejemplo, la temperatura media) usando colores y marcadores distintos para cada año.  
   - El eje de las abscisas será el **día del mes**.  
   - Añade **leyenda**, título y etiquetas de ejes.


:::{figure} ../images/tema_5/ejercicio4_tema5.png
:alt: Temperaturas de noviembre de 1990, 1992 y 2010
:width: 80%
:name: fig: representation_november_temperatures

Temperaturas de noviembre de 1990, 1992 y 2010 en la estación de Matacán (2867)
:::

````{admonition} Recordatorio
:class: hint
- Si el fichero tiene cabecera, puedes necesitar `skip_header=1` en `np.genfromtxt`. Revisa el fichero para comprobarlo.
- Recuerda que las columnas se indexan como:  

  ```text
  col 0 -> Año
  col 1 -> Mes
  col 2 -> Día
  col 3 -> TempMedia
  col 4 -> TempMaxima
  col 5 -> TempMinima
  ```

- Máscaras booleanas en Numpy, permiten filtrar filas que cumplen condiciones. Por ejemplo, para obtener los datos de noviembre de 1990:

  ```python
  mask_nov_1990 = (matrix_datos[:, 0] == 1990) & (matrix_datos[:, 1] == 11)
  datos_nov_1990 = matrix_datos[mask_nov_1990]
  temp_media_nov_1990 = np.mean(datos_nov_1990[:, 3])
  ```

- Para la representación, puedes obtener el vector de días con `datos_nov_1990[:, 2]` y las temperaturas correspondientes con la columna que elijas.
````

---

## Enunciados adicionales

### 5. Visualización de la serie de Gregory-Leibniz para π

**Enunciado.**  
En el **Tema 3** implementaste un programa para calcular aproximaciones de π utilizando la **serie de Gregory-Leibniz**:

$$
\pi \approx 4 \sum_{k=0}^{N} \frac{(-1)^k}{2k+1}
$$

Ahora, utilizando Numpy y Matplotlib:

1. Calcula un array con las **aproximaciones parciales** de π para distintos valores de $N$ (por ejemplo, desde 1 hasta un valor suficientemente grande).  
2. Representa en una gráfica la **evolución de la aproximación** de π en función de $N$ (en el eje x, el número de términos; en el eje y, el valor aproximado de π).  
3. Añade una línea horizontal con el valor real de `np.pi` para comparar visualmente la convergencia.  
4. Etiqueta los ejes, añade título y leyenda.


:::{figure} ../images/tema_5/pi_approximation.gif
:alt: Aproximación de π mediante la serie de Gregory-Leibniz
:width: 80%
:name: fig: representation_pi_approximation

Aproximación de π mediante la serie de Gregory-Leibniz
:::

````{admonition} Recordatorio
:class: hint
- Puedes generar una secuencia de Ns con `np.arange(1, N_max+1)`.  
- Para crear las aproximaciones, o bien reutilizas tu código del Tema 3 adaptándolo a Numpy, o bien usas bucles y vas almacenando cada aproximación en una lista/array.  
- Para la línea horizontal:

  ```python
  plt.axhline(np.pi, linestyle='--', label='π (np.pi)')
  ```

- Es interesante usar escala logarítmica en el eje x si quieres apreciar mejor la convergencia para grandes N (`plt.xscale('log')`), aunque no es obligatorio.
````

---

### 6. Visualización del método de Monte Carlo para π

**Enunciado.**  
En el **Tema 3** resolviste el cálculo de π mediante el **método de Monte Carlo**, generando puntos aleatorios en el cuadrado $[-1, 1] \times [-1, 1]$ y contando cuántos caen dentro del círculo de radio 1 centrado en el origen.

En este ejercicio, usando Numpy y Matplotlib:

1. Reutiliza o escribe una función que genere **N puntos aleatorios** en el cuadrado $[-1, 1] \times [-1, 1]$.  
2. Determina qué puntos caen **dentro** del círculo $x^2 + y^2 \leq 1$ y cuáles quedan **fuera**.  
3. Representa gráficamente:  
   - La **circunferencia** de radio 1 centrada en el origen.  
   - Los puntos que caen **dentro** del círculo en color azul.  
   - Los puntos que caen **fuera** del círculo en color rojo.  
4. Calcula el valor aproximado de π con el método de Monte Carlo y muéstralo en el **título de la figura**.  
5. Asegúrate de que los ejes x e y tengan la misma escala para que el círculo parezca realmente un círculo.

:::{figure} ../images/tema_5/monte_carlo_pi_approximation.gif
:alt: Aproximación de π mediante Monte Carlo
:width: 80%
:name: fig: representation_monte_carlo_pi_approximation

Aproximación de π mediante Monte Carlo
:::

````{admonition} Recordatorio
:class: hint
- Generación de puntos aleatorios con Numpy:

  ```python
  N = 5000
  x = np.random.uniform(-1, 1, N)
  y = np.random.uniform(-1, 1, N)
  ```

- Condición de pertenencia al círculo:

  ```python
  dentro = x**2 + y**2 <= 1
  ```

- Estimación de π:

  ```python
  pi_est = 4 * np.sum(dentro) / N
  ```

- Para representar la circunferencia, puedes generar puntos en el círculo unitario:

  ```python
  theta = np.linspace(0, 2*np.pi, 400)
  plt.plot(np.cos(theta), np.sin(theta))
  ```

- Asegura la misma escala en ambos ejes:

  ```python
  plt.axis('equal')
  ```
````

---

## Recomendaciones generales

- Intenta **vectorizar** los cálculos usando Numpy en lugar de usar bucles siempre que sea posible.  
- Etiqueta siempre los **ejes**, añade **títulos** descriptivos y **leyendas** claras.  
- Ajusta límites de los ejes (`plt.xlim`, `plt.ylim`) para que la información se vea bien.  
- Para depurar, puedes imprimir dimensiones (`.shape`) de los arrays y comprobar que las operaciones matriciales tienen sentido.
