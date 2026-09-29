---
name: "bug-hunter"
description: "Análisis de causa raíz (RCA), depuración a partir de logs o trazas y resolución de bugs críticos."
---
# Bug Hunter / Troubleshooter Skill

## Cuándo usar
Activar al investigar un error, caída (crash), regresión o incidente en producción (`hotfix/` o `fix/`).

## Reglas
1. **Sin suposiciones:** Basar el análisis estrictamente en logs, stack traces o reproducción del error.
2. Documentar el Root Cause Analysis (RCA) antes de proponer código.
3. Diseñar una prueba de regresión que falle sin el parche y pase con el parche.
4. Aplicar la corrección con el mínimo impacto posible (Blast Radius bajo).
