---
name: crow-rest-api-architecture
description: Arquitectura modular de APIs REST C++20 con Crow Framework — Blueprints, middlewares, DTOs, testing sin sockets.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
metadata:
  category: architecture
  version: 1.0.0
---

# 🦅 Crow C++ REST API Architecture Guide

Guía de arquitectura modular para APIs REST de alto rendimiento en **C++20** con **Crow** ([CrowCpp/Crow](https://github.com/CrowCpp/Crow)).

> **Ejemplos de código completos en:** `examples/` (leer bajo demanda)

---

## 🏛️ Estructura de Directorios Recomendada

```text
RestAPI/
├── CMakeLists.txt
├── src/
│   ├── main.cpp                     # Registro de blueprints/middlewares
│   ├── api/
│   │   ├── controllers/             # Blueprints por dominio
│   │   └── middlewares/             # CORS, Auth, Logging
│   ├── domain/
│   │   ├── models/                  # Entidades de dominio
│   │   └── dtos/                    # Request / Response DTOs
│   ├── services/                    # Lógica de negocio (sin Crow)
│   ├── repositories/                # Acceso a datos
│   └── core/
│       ├── config/                  # AppConfig, env vars
│       └── errors/                  # AppException, error codes
└── tests/
    ├── unit/                        # GoogleTest — lógica pura
    └── integration/                 # app.handle_full() sin sockets
```

---

## 🧩 1. Blueprints (`crow::Blueprint`)

**Regla:** Nunca definir rutas directamente en `main.cpp`. Cada dominio tiene su propio Blueprint.

```cpp
// api/controllers/UserController.hpp
class UserController {
public:
    explicit UserController(std::shared_ptr<IUserService> svc)
        : svc_(std::move(svc)), bp_("users") { setupRoutes(); }
    crow::Blueprint& getBlueprint() { return bp_; }
private:
    std::shared_ptr<IUserService> svc_;
    crow::Blueprint bp_;
    void setupRoutes();  // Ver examples/user_controller.cpp
};

// main.cpp — registro
app.register_blueprint(userController.getBlueprint());
```

**Reglas de Blueprint:**
- Prefijo de URL definido en el constructor del Blueprint (`"users"`, `"auth"`, `"health"`).
- Un Blueprint por recurso/dominio de negocio.
- Los handlers delegan en el service, nunca implementan lógica de negocio directamente.

---

## 🛡️ 2. Middlewares

Los middlewares en Crow interceptan con `before_handle` y `after_handle`.

**Reglas:**
- El struct `context` almacena estado por-request (timers, auth claims, trace IDs).
- `before_handle`: validar auth, iniciar timer, parsear headers de seguridad.
- `after_handle`: logging, métricas, forzar headers de respuesta (`Content-Type`, CORS).
- Componer múltiples middlewares: `crow::App<CorsMiddleware, AuthMiddleware, LoggerMiddleware>`.

Ver ejemplo completo: [`examples/middlewares.cpp`](examples/middlewares.cpp)

---

## 📦 3. DTOs y Validación

**Reglas:**
- Definir `struct RequestDto` y `struct ResponseDto` separados.
- Implementar `bool isValid() const` para validación antes de procesar.
- Implementar `crow::json::wvalue toJson() const` marcado `[[nodiscard]]`.
- Validar siempre `body.has("campo")` antes de acceder a `body["campo"]` para evitar `std::runtime_error`.
- Usar `std::optional<T>` o `std::expected<T, E>` (C++23) para resultados que pueden fallar.

---

## ⚡ 4. Concurrencia y Rendimiento

1. **No bloquear worker threads:** Operaciones >5ms → `std::async` o thread pool secundario.
2. **Move semantics:** Usar `std::move` para transferir DTOs y strings grandes a los services.
3. **Connection Pool de BD:** Un pool RAII compartido thread-safe, nunca una conexión por request.
4. **Respuestas JSON:** Siempre incluir `Content-Type: application/json` y código HTTP semántico.

---

## 🧪 5. Testing sin Sockets

```cpp
// Test de integración con app.handle_full()
crow::SimpleApp app;
// registrar rutas...
app.validate();

crow::request req;
req.url = "/users/1";
req.method = crow::HTTPMethod::GET;

crow::response res;
app.handle_full(req, res);

EXPECT_EQ(res.code, 200);
```

**Regla:** Ningún test de integración de Crow abre un puerto de red. Usar siempre `app.handle_full()`.

---

## 📋 Checklist de Calidad para PRs

- [ ] Rutas en `crow::Blueprint`, no en `main.cpp`
- [ ] Respuestas JSON con `Content-Type: application/json` y códigos HTTP semánticos
- [ ] Validación de `body.has(...)` antes de acceder a campos JSON
- [ ] Services independientes de Crow (clases C++ puras con interfaces)
- [ ] Repositorios thread-safe con acceso sincronizado

## Ejemplos de Referencia

| Archivo | Contenido |
|:---|:---|
| [`examples/user_controller.cpp`](examples/user_controller.cpp) | Blueprint completo con GET/POST/DELETE |
| [`examples/middlewares.cpp`](examples/middlewares.cpp) | Logging, CORS, Auth middleware |
| [`examples/dtos.cpp`](examples/dtos.cpp) | DTOs con validación y serialización JSON |
| [`examples/main_setup.cpp`](examples/main_setup.cpp) | Registro de blueprints y arranque de app |
| [`examples/integration_test.cpp`](examples/integration_test.cpp) | Tests con `app.handle_full()` |
