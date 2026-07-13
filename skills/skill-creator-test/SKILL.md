---
name: skill-creator-test
description: "Actívala cuando el usuario solicite crear, optimizar o estructurar una nueva skill o conjunto de instrucciones reutilizables (.md) para agentes de IA."
---

## 📌 Visión General
Esta skill transforma solicitudes abstractas, prompts largos o flujos de trabajo repetitivos en archivos de habilidades estructurados bajo el estándar `SKILL.md`. Garantiza que los agentes de IA comprendan su rol, sigan flujos de trabajo precisos y respeten restricciones técnicas sin saturar su ventana de contexto.

## ⚙️ Flujo de Trabajo

### 1. Extracción de Requisitos
* Analiza el proceso repetitivo que el usuario desea automatizar.
* Identifica los datos de entrada necesarios y el formato de salida esperado.

### 2. Generación del Frontmatter
* Asigna un `name` utilizando únicamente minúsculas, números y guiones corporativos.
* Redacta una `description` clara y persuasiva en tercera persona, especificando el disparador exacto de activación.

### 3. Redacción del Contenido (Estructura Estándar)
* **Visión General**: Define el propósito en un máximo de dos líneas.
* **Procedimiento**: Detalla los pasos secuenciales utilizando verbos en imperativo.
* **Formato de Salida**: Especifica la estructura visual (Markdown, JSON, tablas) que adoptará la respuesta.
* **Restricciones**: Lista los límites operativos y los errores críticos que el agente debe evitar.

### 4. Optimización de Contexto
* Revisa que las instrucciones no utilicen mayúsculas absolutas innecesarias (ej. evitar "ALWAYS", "NEVER").
* Explica brevemente el "porqué" de las reglas críticas para mejorar el razonamiento del modelo.
* Si el proceso requiere cálculos matemáticos complejos, sugiere la creación de una subcarpeta `scripts/` asociada.

## 📋 Formato de Salida
El resultado final debe entregarse estrictamente dentro de un bloque de código Markdown con la siguiente estructura:

```markdown
---
name: [nombre-de-la-skill]
description: "[Descripción clara del activador de la skill]"
---

## 📌 Visión General
...

## ⚙️ Procedimiento o Flujo de Trabajo
1. ...

## 📋 Formato de Salida
...

## 🛑 Restricciones y Límites
* ...
```

## 🛑 Restricciones y Límites
* **Longitud**: El archivo final generado nunca debe exceder las 500 líneas de texto.
* **Tono**: Evita un lenguaje excesivamente rígido; prioriza instrucciones basadas en el contexto y la lógica.
* **Independencia**: No asumas herramientas externas a menos que el usuario las especifique de forma explícita.
