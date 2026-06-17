

Sistema de Semáforos Inteligentes

Análisis Comparativo de Paradigmas de Programación

TPI Funcional 2026 — Grupo 42 · Universidad Nacional del Nordeste

Integrantes

| Nombre y Apellido | Usuario GitHub |
|---|---|
| Otero Manuel | [@Manuotero11](https://github.com/Manuotero11) |
| Facundo Gastón Roda | [@Rodafacundogaston](https://github.com/Rodafacundogaston) |
| Rodriguez Agustina Ailén | [@Agusrodriguez-hub](https://github.com/Agusrodriguez-hub) |
| Joaquina Aymara Castañeda | [@Joacast](https://github.com/Joacast) |
| Ernesto Silguero | [@Erness266](https://github.com/Erness266) |


Enlaces de la Entrega

| Recurso | Link |
|---|---|
|  Repositorio | [TPI-Funcional-2026-Grupo-42](https://github.com/ernestosilguero266-create/TPI-Funcional-2026-Grupo-42.git) |
|  Video de defensa | [Ver en YouTube](https://www.youtube.com/watch?v=e7jRBheWc54&t=4s) |
|  Informe PDF | [Descargar informe](https://github.com/ernestosilguero266-create/TPI-Funcional-2026-Grupo-42/blob/db5cca30eb8be51ec4ffc4e0d52a8ecd8f519904/docs/INFORME.pdf) |
|  Código de Honor | [docs/HONOR.md](docs/HONOR.md) |

 Cómo ejecutar el programa

Fase 1 y 2 — Common Lisp

> Requisitos: [SBCL](http://www.sbcl.org/) + [Quicklisp](https://www.quicklisp.org/)

```bash
sbcl --load core.lisp
```

La Fase 2 integra `local-time` via Quicklisp para mostrar timestamps legibles.
Si Quicklisp no está instalado, el programa carga igual y degrada de forma segura.

Fase 3 — OCaml

> Requisitos: [OCaml](https://ocaml.org/) — o usá el navegador en [ocaml.org/play](https://ocaml.org/play)

```bash
ocaml core_ocaml.ml
```



Estructura del Repositorio

```
TPI-Funcional-2026-Grupo-42/
├── core.lisp          → Fases 1 y 2 — Common Lisp (Reqs 1–6 + local-time)
├── docs/
│   ├── INFORME.pdf    → Informe completo Fase 3 (OCaml)
│   └── HONOR.md       → Código de Honor
├── comparativa/
│    └──solucion.ml
└── README.md
```

Sobre el proyecto

El sistema simula el cerebro lógico de un semáforo inteligente:

| # | Requerimiento | Descripción |
|---|---|---|
| 1 |  Transición | Determina si un cambio de color es válido |
| 2 |  Timer | Dado un timestamp, devuelve el color activo |
| 3 |  Auditoría | Registra cada cambio con fecha legible |
| 4 |  Análisis | Evalúa si la duración del ciclo es óptima |
| 5 |  Planificación | Ciclos completos que caben en un período |
| 6 |  Distribución | Porcentaje de tiempo de cada color por hora |
| 7 |  QA | Casos de prueba para cada requerimiento |

> Ciclo: rojo (90 s) → verde (120 s) → amarillo (6 s) = 216 s totales


Paradigmas y Lenguajes · 2026 · UNNE · Grupo 42
