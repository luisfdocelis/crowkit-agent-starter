---
name: generador-crud
description: Genera automáticamente módulos CRUD (Create, Read, Update, Delete) siguiendo patrones de diseño específicos para ahorrar tokens de planificación.
---

# Instrucciones de Generación CRUD
Cuando se active este skill, sigue este flujo de trabajo estandarizado para minimizar turnos de conversación:

## 1. Análisis de Esquema
- Identifica los campos de la entidad solicitada (ej. nombre, precio, stock).
- Define tipos de datos y validaciones básicas.

## 2. Generación de Archivos
Genera los siguientes componentes en un solo paso:
- **Modelo:** Definición de la tabla o entidad.
- **Repositorio/Controlador:** Lógica para las 4 operaciones básicas.
- **Rutas API:** Endpoints estándar (GET, POST, PUT, DELETE).

## 3. Estilo de Código
- Usa nombres descriptivos en inglés para variables y funciones.
- No añadas comentarios excesivos que inflen el conteo de tokens.
- Sigue la arquitectura existente en el proyecto si ya hay otros módulos CRUD.

## Restricciones
- No preguntes por confirmación en cada paso; genera el bloque completo de archivos.
- Si falta información de un campo, asume un tipo 'string' y continúa.
