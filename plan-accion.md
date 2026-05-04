# Plan de Configuración: Enjambre Híbrido de Agentes (Mayo 2026)

## 1. Infraestructura y Modelos (Híbrido)
- **Capa de Pago (DeepSeek API):**
  - `deepseek-v4-pro`: Orquestación y lógica compleja.
  - `deepseek-reasoner`: Auditoría lógica y seguridad.
  - `deepseek-v4-flash`: Refinamiento de prompts e investigación rápida.
- **Capa Cloud Gratis (Ollama / Minimax):**
  - `gamma-4:31b` (Ollama): Generación de código (Developer).
  - `minimax-m2.5`: Especialista en documentación y Diátaxis.
- **Capa Local (RTX 3060 - LM Studio):**
  - `gemma-4-e4b`: Respuestas rápidas y fallback.

## 2. Definición de Agentes (Basado en agents/)

### A. Orquestadores (Primary)
- **architect-developer:** Líder de proyecto. Garantiza el Ciclo Atómico (Diseño -> ADR -> Código).
- **quick-response:** Soporte técnico inmediato y chat de baja latencia.

### B. Especialistas (Sub-agents)
- **architect:** Auditor de macro-arquitectura y patrones. Provee la base para los ADRs.
- **developer:** Ejecutor técnico. Escribe código basado estrictamente en ADRs.
- **documenter:** Guardián de `docs/`. Gestiona ADRs y documentación técnica (English).
- **investigator:** Inteligencia técnica. Analiza fuentes oficiales y RFCs.
- **prompt-optimizer:** Refinador de instrucciones para eliminar ambigüedad.

## 3. Protocolo de Gobernanza (Ciclo Atómico)

1. **Investigación y Diseño:** El `investigator` analiza y el `architect` diseña la solución.
2. **Documentación Obligatoria:** El `documenter` registra la decisión en `docs/adr/`. **No se escribe código sin ADR.**
3. **Implementación:** El `developer` codifica siguiendo el ADR.
4. **Validación y Cierre:** El `architect-developer` valida contra los estándares (SOLID/DRY) y el `documenter` finaliza la documentación.

## 4. Reglas de Comunicación y Calidad
- **Idioma:** Usuario (Español), Técnico/Interno (Inglés).
- **Estándares:** Clean Architecture, SOLID, DRY.
- **Seguridad:** Validación de inputs por defecto, no exposición de secretos.

## 5. Restricciones de Rol y Blindaje Operativo
Para garantizar la integridad del Ciclo Atómico, se establecen las siguientes prohibiciones estrictas:
- **investigator & architect:** Tienen estrictamente **prohibido** editar archivos de código o documentación. Su salida debe ser exclusivamente analítica o descriptiva (prompts, diagramas, especificaciones).
- **documenter:** Solo tiene permiso para crear o modificar archivos dentro de `docs/` o secciones de documentación (README, docstrings). Tiene **prohibido** alterar la lógica funcional del código.
- **developer:** Solo tiene permiso para editar archivos de código fuente. Tiene **prohibido** tomar decisiones arquitectónicas o modificar los ADRs ya establecidos.
- **architect-developer (Orquestador):** Es el único con permisos transversales, pero su función debe limitarse a la supervisión y delegación, evitando realizar tareas que correspondan a los especialistas.

## 6. Restricciones Técnicas (Hardware RTX 3060)
- **Local Model:** El modelo `gemma-4-e4b` se optimiza para <8GB VRAM.
- **Fallback:** En caso de caída de servicios Cloud, el tráfico se redirige al modelo local.
