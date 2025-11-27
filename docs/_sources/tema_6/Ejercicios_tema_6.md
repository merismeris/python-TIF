# Tema 6 — Pandas (Hoja de ejercicios)

```{admonition} Objetivos de aprendizaje
:class: tip
- Trabajar con estructuras de datos de **Pandas**: `Series` y `DataFrame`.
- Crear un **DataFrame desde cero** (p. ej. a partir de diccionarios/listas) y modificarlo con nuevas columnas.
- Realizar **filtrado** (boolean indexing), búsquedas y agregaciones (`unique`, `groupby`, `mean`, `min`, `max`, `count`).
- Leer datos desde ficheros (**CSV**) y repetir análisis sobre datos importados.
- Representar resultados con **Matplotlib** (líneas, barras, histogramas) con títulos, etiquetas y leyendas.
```

```{admonition} Requisitos previos
:class: important
- Python 3.10+ y VSCode con la extensión de Python.
- Conocimientos básicos de listas/diccionarios, bucles y condicionales.
- Tener instaladas las bibliotecas `numpy`, `pandas` y `matplotlib` (por ejemplo: `pip install numpy pandas matplotlib`).
```

```{admonition} Contenidos del tema
:class: seealso
- `Series` y `DataFrame`: creación, acceso (`loc`, `iloc`, `at`, `iat`), modificación y cálculo de estadísticas.
- Lectura/escritura de ficheros (CSV, Excel) y, en general, conexión con bases de datos.
- Ejercicios completos: lectura de datos, análisis, visualización y exportación de resultados.
- Recurso recomendado: *[Pandas Cookbook](https://pandas.pydata.org/pandas-docs/stable/user_guide/cookbook.html)*.
```

---

## Convención de importaciones

Por convención se importarán las bibliotecas necesarias de la siguiente forma:

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
```

---

## Enunciados básicos

## 1. DataFrame de astronautas: creación, análisis y visualización

**Enunciado.**  
Crea un `DataFrame` desde cero que contenga la información mostrada en la tabla (separada por comas en tu código):

- Fuente: [International Astronaut Database (CSIS)](https://aerospace.csis.org/data/international-astronaut-database/)

| Name | Country | Gender | Flights (separados por comas) | Total Flights | Total Flight Time (ddd:hh:mm) |
|---|---|---|---|---:|---|
| Anna Lee Fisher, M.D. | United States | Woman | STS-51-A (1984) | 1 | 007:23:44 |
| Anne McClain | United States | Woman | Soyuz MS-11 (2018) | 1 | 203:15:16 |
| Aleksandr Samokutyayev | Russia | Man | Soyuz TMA-21 (2011), Soyuz TMA-14M (2014) | 2 | 331:11:23 |

Es posible crear un `DataFrame` de diferentes formas, por ejemplo, a partir de un diccionario en el que las claves son los nombres de la cabecera y los valores son listas con los valores de cada columna.

A partir del `DataFrame` creado:

**a)** Calcula con `pd.unique(dataframe["Country"])` los **países únicos**. Muéstralos por pantalla y muestra también **cuántos** son.

**b)** Obtén el **número de registros** (astronautas) que dispone el `DataFrame`.

**c)** Recorre el `DataFrame` (fila a fila) y almacena en una lista los **minutos totales** de cada astronauta, a partir de la columna `Total Flight Time (ddd:hh:mm)`.  
- ¡Cuidado con el tipo de dato! Usa `split` para obtener días, horas y minutos, y conviértelos al tipo correcto.
- Convierte esa lista en una **nueva columna** del `DataFrame`.

**d)** Busca y muestra por pantalla el astronauta con **más horas de vuelo**.

**e)** Obtén el número total de astronautas con **un único vuelo** (`Total Flights == 1`). (Usa boolean indexing).

**f)** Obtén todos los astronautas **estadounidenses**. (Filtrado igual que el anterior).

**g)** Obtén la **media de horas de vuelo por género**. (Operaciones de estadística / agregación).
Filtra por género y calcula la media de la columna de minutos totales.

````{admonition} Recordatorio
:class: hint
- Crear el `DataFrame` a partir de un diccionario:

  ```python
  df = pd.DataFrame({
      "Name": [...],
      "Country": [...],
      "Gender": [...],
      "Flights": [...],
      "Total Flights": [...],
      "Total Flight Time (ddd:hh:mm)": [...]
  })
  ```

- `pd.unique(df["Country"])` devuelve los valores únicos.
- Número de filas: `len(df)` o `df.shape[0]`.
- Iterar un DF (correcto para practicar, pero lento): `for idx, row in df.iterrows(): ...`
  - Alternativa más pandas: `df.apply(func, axis=1)`
- Añadir/modificar una columna:
  - `df["Total Minutes"] = lista_minutos`
  - o bien `df.at[i, "col"] = ...` para valores individuales.
- Encontrar el máximo y localizar la fila:
  - `idx = df["Total Minutes"].idxmax()`
  - `df.loc[idx]` (o `df.iloc[...]` si trabajas con posiciones).
- Filtrado booleano:
  - `df[df["Total Flights"] == 1]`
  - `df[df["Country"] == "United States"]`

````

---

### Repetición del ejercicio con datos importados (astronautas.csv)

Una vez realizado lo anterior, obtén un `DataFrame` a partir del fichero {download}`astronautas.csv` (disponible en Studium). Ejecuta de nuevo los mismos cálculos, pero esta vez sobre los datos importados.

Además:

- Realiza un **bar plot** que muestre el número de astronautas por país, **ordenado de mayor a menor**.
  - (Usar `groupby("Country")` y `count`, ordenar con `sort_values` el resultado y finalmente realizar un `plot(kind="bar")`).
- Realiza un **histograma** de horas/minutos de vuelo.
  - (Usar `plt.hist` y modificar el número de `bins`).

````{admonition} Recordatorio
:class: hint
- Leer el CSV:

  ```python
  df = pd.read_csv("astronautas.csv")
  ```

  Si el fichero tiene separador distinto, añade `sep=";"` o el que corresponda.

- Bar plot por país (idea típica):

  ```python
  conteo = df.groupby("Country")["Name"].count().sort_values(ascending=False)
  conteo.plot(kind="bar")
  plt.ylabel("Número de astronautas")
  plt.title("Astronautas por país")
  plt.tight_layout()
  plt.show()
  ```

- Histograma:

  ```python
  plt.hist(df["Total Minutes"], bins=20)
  plt.xlabel("Minutos de vuelo")
  plt.ylabel("Frecuencia")
  plt.title("Histograma de minutos de vuelo")
  plt.show()
  ```
````

---

## 2. Análisis de CO2, temperatura, humedad y ocupación desde CO2.csv

**Enunciado.**  
Lee la información disponible en el fichero {download}`CO2.csv` (disponible en Studium) y almacénala en un `DataFrame` de Pandas.

Implementa el código necesario para:

**a.** Calcular la **temperatura media, mínima y máxima** y mostrarla en una gráfica.

**b.** Calcular la **humedad relativa media, mínima y máxima** y mostrarla en una gráfica.

**c.** Mostrar en una gráfica la **cantidad de CO2** y un **valor umbral** de **800 ppm**.

**d.** Mostrar los valores de **ocupación** en una gráfica.

En todos los casos: dar títulos a los ejes y a las gráficas, y establecer leyendas.

````{admonition} Recordatorio
:class: hint
- Lectura típica:

  ```python
  df = pd.read_csv("CO2.csv")
  ```

- Revisa las **columnas reales** del CSV (`df.columns`) para saber cómo se llaman (por ejemplo: `Temperature`, `Humidity`, `CO2`, `Occupancy`, `Date`, etc.).
- Si hay columna de fecha/hora, conviene parsearla:

  ```python
  df["Date"] = pd.to_datetime(df["Date"])
  ```

- Estadísticos (por ejemplo, para una columna `Temperature`):

  ```python
  temp_mean = df["Temperature"].mean()
  temp_min = df["Temperature"].min()
  temp_max = df["Temperature"].max()
  ```

- Para representar series temporales (ejemplo general):

  ```python
  plt.plot(df["Date"], df["Temperature"], label="Temperatura")
  plt.xlabel("Tiempo")
  plt.ylabel("Temperatura")
  plt.title("Temperatura")
  plt.legend()
  plt.tight_layout()
  plt.show()
  ```

- Umbral de CO2:

  ```python
  plt.plot(df["Date"], df["CO2"], label="CO2")
  plt.axhline(800, linestyle="--", label="Umbral 800 ppm")
  plt.legend()
  ```

- Consejo: si haces varias gráficas seguidas, cierra o crea figuras nuevas con `plt.figure()` y usa `plt.tight_layout()`.
````

---

## Recomendaciones generales

- Antes de operar, inspecciona el `DataFrame`: `df.head()`, `df.info()`, `df.describe()`.
- Para los tiempos de vuelo `ddd:hh:mm`, convierte a minutos/horas con cuidado y guarda el resultado en una nueva columna numérica para poder calcular máximos, medias e histogramas.
- Usa `groupby` + agregaciones (`mean`, `count`, `min`, `max`) para análisis por categorías (país, género).
- Etiqueta siempre ejes, añade título y leyenda; termina con `plt.tight_layout()` para evitar cortes en etiquetas.
