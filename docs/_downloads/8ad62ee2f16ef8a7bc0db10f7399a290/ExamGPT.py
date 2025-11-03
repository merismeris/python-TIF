"""
ExamGPT.py

Utilidad proporcionada para el ejercicio de TIF.

NO es necesario modificar este archivo para completar el enunciado básico.
Si tienes curiosidad, puedes leer el código para ver cómo habla con la API
de Gemini y cómo usa "structured output".

Función principal:

    generar_pregunta_test(tema: str, api_key: str,
                          model: str = "gemini-2.5-flash") -> dict

Devuelve un diccionario con la estructura:

{
    "pregunta": "texto de la pregunta",
    "opciones": [
        {
            "texto": "texto de la opción",
            "es_correcta": True or False,
            "explicacion": "por qué esta opción es correcta o incorrecta"
        },
        ...
    ]
}
"""

from __future__ import annotations

from typing import List
import time

from google import genai
from pydantic import BaseModel


# Modelo por defecto (puedes cambiarlo si quieres probar otros)
DEFAULT_MODEL_ID = "gemini-2.5-flash"

# Pequeña espera entre peticiones para no saturar la API con cuentas gratuitas
REQUEST_DELAY_SECONDS = 2.0


class OpcionTest(BaseModel):
    texto: str
    es_correcta: bool
    explicacion: str


class PreguntaTest(BaseModel):
    pregunta: str
    opciones: List[OpcionTest]


def generar_pregunta_test(
    tema: str,
    api_key: str,
    model: str = DEFAULT_MODEL_ID,
) -> dict:
    """
    Genera una pregunta tipo test sobre `tema` usando un modelo de Gemini.

    Parámetros
    ----------
    tema : str
        Tema sobre el que quieres que trate la pregunta
        (por ejemplo: "derivadas", "mecánica cuántica", etc.).
    api_key : str
        API key de Gemini.
    model : str, opcional
        Identificador del modelo de Gemini a utilizar.
        Por defecto: "gemini-2.5-flash".

    Devuelve
    --------
    dict
        Diccionario con la estructura:

        {
            "pregunta": "texto de la pregunta",
            "opciones": [
                {
                    "texto": "opción A",
                    "es_correcta": true/false,
                    "explicacion": "por qué esta opción es correcta o incorrecta"
                },
                ...
            ]
        }
    """

    # Pequeña espera para espaciar las peticiones y cuidar los límites de la API
    time.sleep(REQUEST_DELAY_SECONDS)

    # Crear el cliente de Gemini usando la API key proporcionada
    client = genai.Client(api_key=api_key)

    # EJEMPLO CLARO DE F-STRING:
    # Usamos un f-string multilínea para construir el prompt
    prompt = f"""
Eres un generador de preguntas tipo test para un examen universitario.
Tema de la pregunta: {tema!r}.

Genera UNA SOLA pregunta de dificultad media, con EXACTAMENTE 4 opciones.
Solo una de las opciones debe ser correcta; las otras 3 deben ser plausibles pero incorrectas.
Devuelve todos los textos en castellano.
No añadas texto fuera de los campos definidos en el esquema.
"""

    # Llamada al modelo usando structured output con un modelo Pydantic
    response = client.models.generate_content(
        model=model,
        contents=prompt,
        config={
            "response_mime_type": "application/json",
            "response_schema": PreguntaTest,
        },
    )

    # Si todo va bien, response.parsed es un objeto PreguntaTest
    pregunta_obj: PreguntaTest | None = response.parsed

    if pregunta_obj is None:
        # Si algo va mal con el parseo estructurado, lanzamos un error claro
        raise RuntimeError(
            "No se ha podido generar la pregunta de forma estructurada. "
            "Prueba a ejecutar de nuevo el programa."
        )

    # Convertimos el objeto Pydantic a un dict estándar para que el alumnado
    # solo trabaje con dict y list
    return pregunta_obj.model_dump()
