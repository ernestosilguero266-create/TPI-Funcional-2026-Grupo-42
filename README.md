# TPI Funcional 2026 — Grupo 42 🚦

**Sistema de Semáforos Inteligentes y Análisis Comparativo de Paradigmas**

Núcleo lógico de un sistema embebido de control de semáforos, desarrollado con el
**paradigma funcional** (funciones puras, inmutabilidad y composición) en
**Common Lisp**, con integración del ecosistema **Quicklisp** y un estudio
comparativo en **OCaml**.

---

## 👥 Integrantes

| Nombre y Apellido         | Usuario GitHub       |
|---------------------------|----------------------|
| Otero Manuel              | Manuotero11          |
| Facundo Gaston Roda       | Rodafacundogaston    |
| Rodriguez Agustina Ailén  | Agusrodriguez-hub    |
| Joaquina Aymara Castañeda | Joacast              |
| Ernesto Silguero          | Erness266            |

---

## 🔗 Enlaces de la entrega

 Repositorio: https://github.com/ernestosilguero266-create/TPI-Funcional-2026-Grupo-42.git
 Video de defensa: [https://youtu.be/<ID-del-video>](https://www.youtube.com/watch?v=e7jRBheWc54)


Como ejecutar el programa

Fase 1 y 2 — Common Lisp (SBCL + Quicklisp)

Requisitos: [SBCL](http://www.sbcl.org/) y [Quicklisp](https://www.quicklisp.org/).
La Fase 2 integra `local-time` con `(ql:quickload "local-time")`, por lo que
Quicklisp debe estar instalado para cargar core.lisp.

cd lisp
sbcl --load core.lisp
```

Ejemplos en el REPL (ver bloque del **Requerimiento 7** al final de `core.lisp`):

```lisp
(transicion 'en-rojo 'verde)                     ; => (EN-ROJO "cambiar-a-verde")
(timer 100)                                      ; => :VERDE
(auditoria-quicklisp 90)                         ; [FASE 2 local-time] "Tiempo 1970-01-01 00:01:30: la luz ha cambiado de ROJO a VERDE"
(auditoria-quicklisp 100)                        ; sin cambio de color => NIL (no imprime)
(duracion-ciclo)                                 ; => 216
(recomendacion-ciclo (duracion-ciclo))           ; => "...demasiado largo (> 150 s)..."
(ciclos-por-tiempo 15)                           ; => 4
(distribucion-horaria)                           ; => ((:ROJO . 41.66) (:AMARILLO . 2.77) (:VERDE . 55.55))
```

Para instalar Quicklisp (una sola vez):

```lisp
;; (descargar quicklisp.lisp desde https://www.quicklisp.org/install.html)
(load "quicklisp.lisp")
(quicklisp-quickstart:install)
(ql:add-to-init-file)
```

### Fase 3 — OCaml

**Requisitos:** [OCaml](https://ocaml.org/) (o el entorno en línea
[ocaml.org/play](https://ocaml.org/play)).

```bash
cd comparativa
ocaml solucion.ml          # modo script: ejecuta la demo
# o compilar a binario nativo:
ocamlfind ocamlopt solucion.ml -o solucion && ./solucion
```

---

## 🧩 Fases del trabajo

- **Fase 1 — Núcleo en Lisp:** Requerimientos 1 a 6 con inmutabilidad absoluta,
  cero bucles imperativos (recursión de cola + orden superior) y clasificación
  taxonómica de cada función.
- **Fase 2 — Ecosistema (Quicklisp):** integración de **`local-time`** (la auditoría
  del Req 3 muestra la fecha y hora en formato legible `2025-05-16 14:30:00` en
  lugar del *epoch* Unix).
- **Fase 3 — Comparativa (OCaml):** reimplementación de `transicion` y `timer`,
  con análisis de inferencia de tipos y `match...with`. Detalle en
  [`docs/INFORME.md`](docs/INFORME.md).

---

## 📜 Código de Honor

Ver [`docs/HONOR.md`](docs/HONOR.md). Cada integrante declara el uso de IA en el
proyecto.
