;;;; =====================================================================
;;;; TPI FUNCIONAL 2026 - Grupo 42
;;;; Sistema de Semaforos Inteligentes - Nucleo logico en Common Lisp
;;;; Fase 1 (Requerimientos 1 al 6) + Fase 2 (Quicklisp: local-time)
;;;; ---------------------------------------------------------------------
;;;; RESTRICCIONES DE DISENO RESPETADAS:
;;;;   * Inmutabilidad absoluta: sin defparameter/defvar mutables, sin setq/setf.
;;;;     El estado (color y tiempo) fluye SOLO por argumentos de funciones.
;;;;   * Cero bucles imperativos: sin loop/dolist/dotimes/while. Toda iteracion
;;;;     se resuelve con recursividad de cola u orden superior (mapcar/reduce).
;;;;   * Cada funcion lleva su encabezado de clasificacion taxonomica.
;;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; CARGA DEL ECOSISTEMA (Fase 2: Quicklisp + local-time)
;;; Se asume Quicklisp instalado (requisito de la Fase 2). El eval-when hace
;;; que local-time este disponible al cargar (load) y al compilar (compile-file),
;;; de modo que los simbolos cualificados local-time:... se lean sin error.
;;; ---------------------------------------------------------------------
(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload "local-time"))


;;; =====================================================================
;;; CONFIGURACION DE NEGOCIO (valores por defecto, inmutables)
;;; =====================================================================

;; =====================================================================
;; FUNCION: tiempos-por-defecto
;; NATURALEZA: Pura (sin estado externo; siempre retorna lo mismo)
;; ESTRATEGIA: Constructora simple (devuelve una estructura literal fresca)
;; IMPACTO: No destructiva
;; =====================================================================
(defun tiempos-por-defecto ()
  (list (cons :rojo 90)
        (cons :amarillo 6)
        (cons :verde 120)))

;; =====================================================================
;; FUNCION: tiempo-de
;; NATURALEZA: Pura
;; ESTRATEGIA: Funcion de consulta / accesor (usa assoc)
;; IMPACTO: No destructiva
;; =====================================================================
(defun tiempo-de (color tiempos)
  (cdr (assoc color tiempos)))

;; =====================================================================
;; FUNCION: secuencia-temporal
;; NATURALEZA: Pura
;; ESTRATEGIA: Constructora simple
;; IMPACTO: No destructiva
;; =====================================================================
(defun secuencia-temporal ()
  (list :rojo :verde :amarillo))

;; =====================================================================
;; FUNCION: duracion-ciclo                              (Requerimiento 4a)
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden Superior (mapcar + reduce)
;; IMPACTO: No destructiva
;; =====================================================================
(defun duracion-ciclo (&optional (tiempos (tiempos-por-defecto)))
  (reduce #'+ (mapcar #'cdr tiempos)))


;;; =====================================================================
;;; REQUERIMIENTO 1: Estados de Transicion
;;; =====================================================================

;; =====================================================================
;; FUNCION: transiciones-validas
;; NATURALEZA: Pura
;; ESTRATEGIA: Constructora simple
;; IMPACTO: No destructiva
;; =====================================================================
(defun transiciones-validas ()
  (list (cons 'en-rojo 'verde)
        (cons 'en-verde 'amarillo)
        (cons 'en-amarillo 'rojo)))

;; =====================================================================
;; FUNCION: transicion
;; NATURALEZA: Pura (mismas entradas -> misma salida, sin efectos)
;; ESTRATEGIA: Funcion Predicado + condicional (assoc/eql)
;; IMPACTO: No destructiva (construye una lista nueva con list)
;; =====================================================================
(defun transicion (color-actual cambiar-a)
  (if (eql (cdr (assoc color-actual (transiciones-validas))) cambiar-a)
      (list color-actual (format nil "cambiar-a-~(~a~)" cambiar-a))
      (list color-actual 'accion-por-defecto)))


;;; =====================================================================
;;; REQUERIMIENTO 2: Temporizador Automatico
;;; =====================================================================

;; =====================================================================
;; FUNCION: color-en-posicion
;; NATURALEZA: Pura
;; ESTRATEGIA: Recursiva de Cola (Tail Recursion)
;; IMPACTO: No destructiva
;; =====================================================================
(defun color-en-posicion (posicion secuencia tiempos)
  (let ((duracion (tiempo-de (first secuencia) tiempos)))
    (if (< posicion duracion)
        (first secuencia)
        (color-en-posicion (- posicion duracion) (rest secuencia) tiempos))))

;; =====================================================================
;; FUNCION: timer
;; NATURALEZA: Pura (dado un timestamp, siempre retorna el mismo color)
;; ESTRATEGIA: Composicion (delega en recursion de cola color-en-posicion)
;; IMPACTO: No destructiva
;; =====================================================================
(defun timer (timestamp &optional (tiempos (tiempos-por-defecto)))
  (let ((posicion (mod timestamp (duracion-ciclo tiempos))))
    (color-en-posicion posicion (secuencia-temporal) tiempos)))


;;; =====================================================================
;;; REQUERIMIENTO 3: Sistema de Auditoria (logging) -- IMPURO
;;; + FASE 2 (local-time): la fecha se muestra legible para humanos.
;;; =====================================================================

;; =====================================================================
;; FUNCION: auditoria-quicklisp                  (Requerimiento 3 + FASE 2)
;; NATURALEZA: Impura (efecto secundario: imprime en la terminal)
;; ESTRATEGIA: Seleccion por condicion (if) + interop con local-time
;; IMPACTO: No destructiva (no modifica estructuras en memoria)
;; =====================================================================
;; A partir de UN solo timestamp Unix, deriva el color anterior (timer del
;; segundo previo) y el actual (timer del timestamp). Si hubo un cambio de
;; color, audita el evento mostrando la fecha legible con local-time (Fase 2).
;; El formateo se fija en UTC (+utc-zone+) para que la salida sea determinista
;; (no dependa de la zona horaria de la maquina).
(defun auditoria-quicklisp (timestamp)
  (let ((color-anterior (timer (- timestamp 1)))
        (color-actual   (timer timestamp)))
    (if (not (equal color-anterior color-actual))
        (format t "Tiempo ~A: la luz ha cambiado de ~A a ~A~%"
                (local-time:format-timestring nil
                  (local-time:unix-to-timestamp timestamp)
                  :format '((:year 4) "-" (:month 2) "-" (:day 2)
                            " " (:hour 2) ":" (:min 2) ":" (:sec 2))
                  :timezone local-time:+utc-zone+)
                color-anterior
                color-actual))))


;;; =====================================================================
;;; REQUERIMIENTO 4: Analisis de Ciclos Semaforicos
;;; =====================================================================

;; =====================================================================
;; FUNCION: recomendacion-ciclo
;; NATURALEZA: Pura
;; ESTRATEGIA: Funcion Predicado (cond sobre rangos)
;; IMPACTO: No destructiva
;; =====================================================================
(defun recomendacion-ciclo (duracion)
  (cond ((< duracion 35)
         "Ciclo demasiado corto (< 35 s): aumentar la duracion; frustra al conductor.")
        ((> duracion 150)
         "Ciclo demasiado largo (> 150 s): reducir la duracion; supera el umbral psicologico.")
        (t
         "Ciclo en rango optimo (35-150 s): adecuado a la psicologia del conductor.")))


;;; =====================================================================
;;; REQUERIMIENTO 5: Planificacion Temporal
;;; =====================================================================

;; =====================================================================
;; FUNCION: ciclos-por-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA: Composicion (floor sobre duracion-ciclo)
;; IMPACTO: No destructiva
;; =====================================================================
(defun ciclos-por-tiempo (minutos &optional (tiempos (tiempos-por-defecto)))
  (floor (* minutos 60) (duracion-ciclo tiempos)))

 ;MANUEL OTERO
 
;;; =====================================================================
;;; REQUERIMIENTO 6: Informe de Distribucion Temporal
;;; =====================================================================

;; =====================================================================
;; FUNCION: distribucion-horaria
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden Superior (mapcar)
;; IMPACTO: No destructiva
;; =====================================================================
(defun distribucion-horaria (&optional (tiempos (tiempos-por-defecto)))
  (let ((total (duracion-ciclo tiempos)))
    (mapcar (lambda (par)
              (cons (car par) (/ (* (cdr par) 100.0) total)))
            tiempos)))


;;; =====================================================================
;;; REQUERIMIENTO 7: Aseguramiento de la calidad (ejemplos de uso)
;;; ---------------------------------------------------------------------
;;; Bloque listo para COPIAR Y PEGAR en el REPL. Cubre, por requerimiento,
;;; un caso normal, un camino alternativo y un caso que genera error.
;;; (Se deja como comentario para que cargar el archivo no produzca efectos.)
;;; =====================================================================
#|
;; --- Carga ---
;; sbcl --load core.lisp        (o en el REPL:  (load "core.lisp"))

;; ===== Req 1: transicion =====
(transicion 'en-rojo 'verde)        ; NORMAL    => (EN-ROJO "cambiar-a-verde")
(transicion 'en-verde 'amarillo)    ; NORMAL    => (EN-VERDE "cambiar-a-amarillo")
(transicion 'en-amarillo 'rojo)     ; NORMAL    => (EN-AMARILLO "cambiar-a-rojo")
(transicion 'en-rojo 'amarillo)     ; ALTERNATIVO (invalida) => (EN-ROJO ACCION-POR-DEFECTO)
(transicion 'en-rojo 'azul)         ; ALTERNATIVO (color inexistente) => (EN-ROJO ACCION-POR-DEFECTO)
(transicion "en-rojo" 'verde)       ; ALTERNATIVO (tipo no esperado): assoc compara con eql => (... ACCION-POR-DEFECTO)
(transicion 'en-rojo)               ; ERROR: invalid number of arguments (falta el argumento cambiar-a)

;; ===== Req 2: timer (ciclo = 216 s) =====
(timer 0)                           ; NORMAL    => :ROJO      (posicion 0)
(timer 100)                         ; NORMAL    => :VERDE     (90 <= 100 < 210)
(timer 215)                         ; NORMAL    => :AMARILLO  (210 <= 215 < 216)
(timer 216)                         ; ALTERNATIVO (vuelta de ciclo) => :ROJO
(timer 1747405800)                  ; NORMAL    (epoch real grande) => algun color
(timer "100")                       ; ERROR: mod sobre un string -> type-error

;; ===== Req 3: auditoria-quicklisp (Fase 2: local-time -> fecha legible en UTC) =====
;; Recibe UN timestamp; imprime SOLO si entre (1- t) y t hubo cambio de color.
;; Las transiciones del ciclo ocurren en las posiciones 90, 210 y 0 (=216).
(auditoria-quicklisp 90)    ; NORMAL  => "Tiempo 1970-01-01 00:01:30: la luz ha cambiado de ROJO a VERDE"
(auditoria-quicklisp 210)   ; NORMAL  => "Tiempo 1970-01-01 00:03:30: la luz ha cambiado de VERDE a AMARILLO"
(auditoria-quicklisp 216)   ; NORMAL  => "Tiempo 1970-01-01 00:03:36: la luz ha cambiado de AMARILLO a ROJO"
(auditoria-quicklisp 100)   ; ALTERNATIVO (no hay cambio) => NIL (no imprime nada)
(auditoria-quicklisp "90")  ; ERROR: (- "90" 1) -> type-error (resta sobre un string)

;; ===== Req 4: duracion-ciclo / recomendacion-ciclo =====
(duracion-ciclo)                                  ; NORMAL  => 216
(recomendacion-ciclo (duracion-ciclo))            ; NORMAL  => "...demasiado largo (> 150 s)..."
(recomendacion-ciclo 40)                          ; ALTERNATIVO => "...rango optimo..."
(recomendacion-ciclo 'tres)                       ; ERROR: comparar simbolo con numero -> type-error

;; ===== Req 5: ciclos-por-tiempo =====
(ciclos-por-tiempo 15)                            ; NORMAL  => 4   (900 s / 216)
(ciclos-por-tiempo 60)                            ; NORMAL  => 16  (3600 s / 216)
(ciclos-por-tiempo 0)                             ; ALTERNATIVO => 0
(ciclos-por-tiempo "15")                          ; ERROR: aritmetica sobre un string -> type-error

;; ===== Req 6: distribucion-horaria =====
(distribucion-horaria)                            ; NORMAL  => ((:ROJO . 41.66) (:AMARILLO . 2.77) (:VERDE . 55.55))
|#

;;;; =====================================================================
;;;; FIN DE core.lisp
;;;; =====================================================================
