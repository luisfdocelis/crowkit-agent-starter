---
name: cpp-modern-features
description: C++20/17/14/11 modern features — auto, lambdas, ranges, structured bindings, concepts, move semantics.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
metadata:
  mcpmarket-version: 1.0.0
---

# Modern C++ Features (C++11–C++20)

> **Ejemplos de código en:** `examples/` (leer bajo demanda explícita)

## Reglas de Uso

### `auto` — Inferencia de Tipos
- Usar `auto` para iteradores, tipos de retorno de lambdas y tipos complejos de STL.
- Preferir tipos explícitos cuando la claridad semántica importa (`int`, `bool`, `size_t`).
- Usar `const auto&` en range-for sobre contenedores de objetos grandes.

### Lambdas
- Captura por valor `[=]` para lambdas que escapan el scope; por referencia `[&]` solo cuando el lambda no outlive su scope.
- Marcar `mutable` cuando se necesita modificar variables capturadas por valor.
- Usar lambdas genéricas `[](const auto& x)` (C++14) en vez de templates cuando sea suficiente.
- Devolver `std::function<>` solo si el tipo de la lambda no puede inferirse; preferir `auto`.

### Range-Based For
- Siempre usar `const auto&` para leer, `auto&` para modificar en contenedores.
- No modificar el contenedor mientras se itera sobre él.
- Para C++20: preferir `std::ranges::for_each` cuando se necesita proyección.

### Inicialización Uniforme `{}`
- Usar `{}` para inicialización para prevenir narrowing conversions.
- Resolver el "most vexing parse" con `Type obj{}` en lugar de `Type obj()`.

### Move Semantics
- Implementar move constructor y move assignment en clases que poseen recursos (RAII).
- Marcar ambos `noexcept` para habilitar optimizaciones del compilador y STL.
- Usar `std::move()` solo cuando se transfiere ownership definitivamente; no usar sobre `const`.
- Preferir `std::forward<T>()` en templates con forwarding references (`T&&`).

### Variadic Templates & Fold Expressions (C++17)
- Usar fold expressions `(args + ...)` en lugar de recursión variádica cuando sea posible.
- Combinar con `if constexpr` para branches en tiempo de compilación.

### Structured Bindings (C++17)
- Usar `auto [key, val]` en iteración sobre `std::map` / `std::unordered_map`.
- Usar `auto& [a, b]` para modificar elementos de structs/tuplas.
- No usar en objetos temporales (dangling reference risk).

### Concepts (C++20)
- Definir concepts con `requires` para constraining templates y mejorar mensajes de error.
- Preferir concepts de la STL (`std::integral`, `std::floating_point`, `std::ranges::range`) antes de definir propios.
- Usar sintaxis abreviada `void f(Numeric auto x)` cuando sea suficiente.

### Ranges Library (C++20)
- Componer operaciones con `|` (pipe) y `std::views::filter`, `transform`, `take`, `drop`.
- Las views son **lazy**: no crean copias intermedias.
- Usar `std::ranges::sort`, `find`, `copy_if` en lugar de versiones del namespace `std` para soporte de projections.
- Usar `std::views::iota(n, m)` para rangos numéricos sin contenedor.

## Best Practices

1. `auto` para tipos complejos; tipos explícitos cuando la semántica lo requiere.
2. Lambdas sobre function objects para operaciones inline.
3. Range-for sobre iteradores manuales.
4. `{}` para inicialización — previene narrowing.
5. Move constructors y assignments siempre `noexcept`.
6. `std::move` solo al transferir ownership definitivo.
7. Structured bindings sobre `std::get<>()` para tuples/pairs.
8. Concepts para constraining templates y error messages legibles.
9. Ranges para operaciones lazy y composables.
10. `const auto&` en range-for con objetos grandes.

## Common Pitfalls

1. `auto` excesivo que oculta tipos y reduce legibilidad.
2. Captura por referencia en lambdas que outlive su scope (dangling ref).
3. `std::move` sobre `const` — deshabilita move semantics silenciosamente.
4. Olvidar `noexcept` en move ops — bloquea optimizaciones del STL.
5. Modificar contenedor durante range-for.
6. Structured bindings sobre temporales — dangling reference.
7. Asumir que views de ranges copian datos — son lazy.
8. Mover un objeto y luego usarlo de nuevo.

## Ejemplos de Referencia

Ver directorio `examples/` para snippets completos y ejecutables:

| Archivo | Contenido |
|:---|:---|
| [`examples/auto_inference.cpp`](examples/auto_inference.cpp) | `auto`, iteradores, structured bindings |
| [`examples/lambdas.cpp`](examples/lambdas.cpp) | Capturas, genéricas, mutable, `std::function` |
| [`examples/range_for.cpp`](examples/range_for.cpp) | Range-based for, custom range |
| [`examples/move_semantics.cpp`](examples/move_semantics.cpp) | Rule of Five, `std::move`, perfect forwarding |
| [`examples/variadic_templates.cpp`](examples/variadic_templates.cpp) | Variadic + fold expressions |
| [`examples/structured_bindings.cpp`](examples/structured_bindings.cpp) | Tuples, pairs, structs, maps |
| [`examples/concepts.cpp`](examples/concepts.cpp) | `concept`, `requires`, STL concepts |
| [`examples/ranges.cpp`](examples/ranges.cpp) | `std::views`, pipe composition, projections |

## Recursos

- [C++ Reference](https://en.cppreference.com/)
- [Modern C++ Tutorial](https://changkun.de/modern-cpp/)
- [C++20 Ranges](https://www.modernescpp.com/index.php/c-20-ranges-library)
