---
name: "feature-planner"
description: "Activar cuando el usuario solicite crear un nuevo feature, planificar una funcionalidad, analizar impactos o diseñar planes de rollback y walkthrough"
---

# Feature Planner Skill — CrowKit 🦅

Esta Skill asiste al desarrollador y al agente en la fase de planificación del ciclo de vida de desarrollo en **CrowKit**, clasificando la tarea por su talla (**S**, **M** o **L**) y automatizando la creación del plan técnico correspondiente.

## 🎯 Modelo de Tallas (S / M / L)

1. **Talla S (< 50 líneas, fixes o tooling menor):** No requiere archivos en `docs/plans/`. La justificación va en el chat y cuerpo del PR.
2. **Talla M (50 - 250 líneas, features estándar):** Requiere **1 documento consolidado de diseño** (`docs/plans/XX-feature-plan.md`) que unifica impacto, implementación, rollback y evidencias en la misma rama `feat/`.
3. **Talla L (> 250 líneas, Greenfield o Épicas):** Requiere la **suite completa de 4 documentos** (`analysis`, `implementation-plan`, `rollback-plan`, `walkthrough`).

---

## Instrucciones de Ejecución

Cuando se inicie la planificación de un feature o requerimiento:

1. **Clasificación de Talla y Alcance:**
   - Proponer la talla (**S**, **M** o **L**) según la cantidad estimada de líneas y componentes afectados.
   - En **Pausa 1**, presentar la propuesta al usuario para su aprobación inicial.

2. **Preparación de la Rama:**
   - Para tallas **S** y **M**, la rama se crea directamente desde `development`:
     ```bash
     git switch -c <tipo>/<nombre-corto>
     ```
   - Para talla **L**, se evalúa si requiere rama documental desacoplada (`doc/`) o rama directa `feat/` según la necesidad de revisión formal previa.

3. **Generación de la Documentación Técnica:**
   - **Talla M:** Generar el plan consolidado usando la **Plantilla de Plan Consolidado** (`docs/plans/XX-feature-plan.md`).
   - **Talla L:** Generar los 4 documentos técnicos (`analysis`, `plan`, `rollback`, `walkthrough`).
   - Actualizar el backlog en `docs/backlog/backlog.md` indexando el nuevo plan.

4. **Verificación Documental:**
   - Validar sintaxis y enlaces con las herramientas configuradas por el proyecto.

5. **Continuidad Autónoma:**
   - Una vez aprobado el diseño en la **Pausa 1**, el agente procede directamente a implementar el código C++20, pruebas unitarias y verificación sin detenerse hasta la apertura del PR y monitoreo de checks de CI.

---

## Plantillas Oficiales de Documentación

### 0. Plantilla de Plan Consolidado — Talla M (`docs/plans/XX-feature-plan.md`)
```markdown
# Plan de Diseño e Implementación — [Nombre del Feature] 🦅

**Talla:** Media (M) | **Épica:** [Épica XX] | **Backlog ID:** [CK-XXXX]

---

## 1. Objetivo y Análisis de Impacto
- **Propósito:** [Breve descripción del valor y comportamiento esperado]
- **Componentes Afectados:** [`libs/...`, `tools/...`, etc.]
- **Contratos / API:** [Nuevos métodos, structs o endpoints sin romper retrocompatibilidad]

## 2. Plan de Implementación Técnica
### Archivos Afectados
- `[NEW/MODIFY] libs/...`
- `[NEW/MODIFY] libs/.../tests/...`

### Estrategia de Pruebas (GoogleTest & CTest)
- [Pruebas unitarias para validar caminos felices y de error]

## 3. Plan de Rollback y Contingencia
- **Reversión Git:** `git revert <commit-hash>`
- **Impacto de Rollback:** Nulo / aislado al módulo modificado.

## 4. Walkthrough de Validación y Evidencias
- [x] Compilación limpia en C++20 con el sistema de build del proyecto
- [x] Pruebas unitarias y CTest pasando al 100%
```

---

### 1. Plantilla de Análisis de Impacto — Talla L (`docs/plans/XX-feature-analysis.md`)
```markdown
# Análisis de Impacto Técnico — [Nombre del Feature]

## 1. Descripción y Objetivo
[Breve descripción de la funcionalidad y beneficio esperado en CrowKit]

## 2. Impacto en la Base de Datos / Persistencia
- **Nuevas Tablas / Columnas / Schemas:** [Detallar tablas, tipos de datos y constraints SQL]
- **Migración de Datos / Scripts DDL:** [¿Requiere scripts SQL de migración? ¿Qué repositorios en C++ se modifican?]

## 3. Impacto en la API (Crow C++)
- **Nuevas Rutas y Métodos:** [Rutas, verbos HTTP (GET, POST, PUT, DELETE) y blueprints de Crow]
- **DTOs y Serialización:** [Modelos de datos C++ y serialización JSON (nlohmann::json o crow::json)]
- **Middlewares Afectados:** [Auth, CORS, Logging, Rate Limiting, etc.]

## 4. Impacto en Módulos Internos (`libs/`)
- **Librerías C++ Afectadas:** [libs/core, libs/http, libs/db, libs/auth, etc.]
- **Contratos e Interfaces:** [Interfaces virtuales, smart pointers, structs]

## 5. Control de Acceso y Seguridad
- **Permisos y Roles:** [Definir roles necesarios (admin, user, tenant) y validación de tokens JWT]
```

### 2. Plantilla de Plan de Implementación (`docs/plans/XX-feature-implementation-plan.md`)
```markdown
# Plan de Implementación — [Nombre del Feature]

## Componentes y Archivos Afectados

### Código Fuente C++20 (`libs/` y `tools/`)
#### [NEW]
- `libs/[modulo]/include/[modulo]/...`
- `libs/[modulo]/src/...`

#### [MODIFY]
- `CMakeLists.txt`
- `libs/[modulo]/...`

### Pruebas Unitarias y de Integración (GoogleTest / CTest)
#### [NEW / MODIFY]
- `libs/[modulo]/tests/test_[modulo].cpp`
- `tests/integration/test_[feature].cpp`
```

### 3. Plantilla de Plan de Rollback (`docs/plans/XX-feature-rollback-plan.md`)
```markdown
# Plan de Rollback — [Nombre del Feature]

- **Commit Base (HEAD previo):** `HASH_COMMIT_DESARROLLO` (Obtenido con `git rev-parse HEAD` en `development` antes del checkout de la rama)

En caso de fallo crítico en el despliegue o la compilación/ejecución local, seguir estos pasos para revertir cambios:

1. **Reversión de Código (Git):**
   ```bash
   git checkout development
   git branch -D feat/[nombre-feature]
   git reset --hard HASH_COMMIT_DESARROLLO
   ```
2. **Reversión de Base de Datos:**
   ```bash
   # Ejecutar script DDL de rollback correspondiente
   psql -U crowkit -d crowkit -f scripts/db/rollback_[modulo].sql
   ```
3. **Reversión de Contenedores / Entorno Local:**
   ```bash
   docker compose down
   docker compose up -d --build
   ```
```

### 4. Plantilla de Walkthrough (`docs/plans/XX-feature-walkthrough.md`)
```markdown
# Walkthrough de Entrega — [Nombre del Feature]

## Resumen de Cambios
[Resumen de la implementación realizada en C++20 / CrowKit]

## Logs y Resultados de Pruebas
- **Compilación C++ (CMake / Release):** [Pegar resumen de build]
- **CTest / GoogleTest Suite:** [Pegar resumen de ejecución de tests]

## Evidencias de Ejecución
- **Respuestas de Endpoints (curl / HTTP):** [Pegar respuestas JSON de prueba]
```
