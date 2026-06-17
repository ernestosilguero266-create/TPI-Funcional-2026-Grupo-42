
















;;; =====================================================================
;;; Facundo Gaston Roda
;;; REQUERIMIENTO 5: Planificacion Temporal
;;; =====================================================================

;; ========================================================
;; FUNCIÓN: ciclos-por-tiempo
;; NATURALEZA: Pura
;; ESTRATEGIA: Composicion (floor sobre duracion-ciclo)
;; IMPACTO: No destructiva
;; ========================================================
;; Ej: 15 min = 900 s / 216 = 4 ciclos completos
(defun ciclos-por-tiempo (minutos &optional (tiempos (tiempos-por-defecto)))
  (cond
    ((not (numberp minutos))
     (error "El parametro debe ser un numero."))
    ((< minutos 0)
     (error "Los minutos no pueden ser negativos."))
    (t
     (floor (* minutos 60)
            (duracion-ciclo tiempos)))))

;;; =====================================================================
;;; REQUERIMIENTO 6: Informe de Distribucion Temporal
;;; =====================================================================

;; ========================================================
;; FUNCIÓN: distribucion-horaria
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden Superior (mapcar con lambda)
;; IMPACTO: No destructiva
;; ========================================================
;; Resultado con defaults:
;;   rojo 41,67%  amarillo 2,78%  verde 55,56% aprox

(defun distribucion-horaria (&optional (tiempos (tiempos-por-defecto)))
  (let ((total (duracion-ciclo tiempos)))
    (mapcar (lambda (par)
              (cons (car par)
                    (/ (* (cdr par) 100.0)
                       total)))
            tiempos)))

;;; Casos de prueba Req 5 y 6:
;; (ciclos-por-tiempo 15)   => 4
;; (ciclos-por-tiempo 60)   => 16
;; (ciclos-por-tiempo 0)    => 0
;; (ciclos-por-tiempo -10)  => error: Los minutos no pueden ser negativos. 
;; (ciclos-por-tiempo "15") => error: El parametro debe ser un numero. 

;; (distribucion-horaria)
;; => ((:ROJO . 41.666668)
;;     (:AMARILLO . 2.7777779)
;;     (:VERDE . 55.555557))
