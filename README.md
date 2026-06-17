<div align="center">


🚦 Sistema de Semáforos Inteligentes

Análisis Comparativo de Paradigmas de Programación

TPI Funcional 2026 — Grupo 42
Universidad Nacional del Nordeste

</div>

👥 Integrantes

Nombre y ApellidoUsuario GitHubOtero Manuel@Manuotero11Facundo Gastón Roda@RodafacundogastonRodriguez Agustina Ailén@Agusrodriguez-hubJoaquina Aymara Castañeda@JoacastErnesto Silguero@Erness266


🔗 Enlaces de la Entrega

RecursoLink📁 RepositorioTPI-Funcional-2026-Grupo-42🎥 Video de defensaVer en YouTube📄 Informe PDFDescargar informe⚖️ Código de Honordocs/HONOR.md


▶️ Cómo ejecutar el programa

Fase 1 y 2 — Common Lisp


Requisitos: SBCL + Quicklisp



bashsbcl --load core.lisp

La Fase 2 integra la librería local-time via Quicklisp para mostrar timestamps legibles.
Si Quicklisp no está instalado, el programa carga igual y degrada de forma segura.

Fase 3 — OCaml


Requisitos: OCaml — o usá el navegador en ocaml.org/play



bashocaml core_ocaml.ml


📁 Estructura del Repositorio

TPI-Funcional-2026-Grupo-42/
├── core.lisp          → Fases 1 y 2 — Common Lisp (Reqs 1–6 + local-time)
├── docs/
│   ├── INFORME.pdf    → Informe completo Fase 3 (OCaml)
│   └── HONOR.md       → Código de Honor
└── README.md


🧠 Sobre el proyecto

El sistema simula el cerebro lógico de un semáforo inteligente:


🔴 Req 1 — Transición: determina si un cambio de color es válido (en-rojo → verde, etc.)
⏱️ Req 2 — Timer: dado un timestamp Unix, devuelve el color activo en ese instante
📋 Req 3 — Auditoría: registra cada cambio con fecha legible (via local-time)
📊 Req 4 — Análisis: evalúa si la duración del ciclo es psicológicamente óptima
🗓️ Req 5 — Planificación: calcula cuántos ciclos completos caben en un período
📈 Req 6 — Distribución: porcentaje de tiempo de cada color por hora
✅ Req 7 — QA: casos de prueba documentados para cada requerimiento


El ciclo es rojo (90s) → verde (120s) → amarillo (6s) = 216s por ciclo completo.


<div align="center">
<sub>Paradigmas y Lenguajes · 2026 · UNNE · Grupo 42</sub>
</div>
