(* ADT: un estado/color invalido es IMPOSIBLE de construir; el compilador lo rechaza. *) Rodriguez Agustina Ailén
type estado = En_rojo | En_amarillo | En_verde
type color  = Rojo | Amarillo | Verde

(* transicion | Pura | Pattern Matching exhaustivo | No destructiva
   Toplevel infiere: val transicion : estado -> color -> estado * string = <fun> *)
let transicion actual cambiar_a =
  match actual, cambiar_a with
  | En_rojo,     Verde    -> (En_rojo,     "cambiar-a-verde")
  | En_verde,    Amarillo -> (En_verde,    "cambiar-a-amarillo")
  | En_amarillo, Rojo     -> (En_amarillo, "cambiar-a-rojo")
  | _,           _        -> (actual,      "accion-por-defecto")

let tiempo_rojo = 90 and tiempo_verde = 120 and tiempo_amarillo = 6
let duracion_ciclo = tiempo_rojo + tiempo_verde + tiempo_amarillo  (* 216 *)

(* timer | Pura | Orientada a expresiones | No destructiva
   Toplevel infiere: val timer : int -> color = <fun> *)
let timer timestamp =
  let posicion = ((timestamp mod duracion_ciclo) + duracion_ciclo) mod duracion_ciclo in
  if posicion < tiempo_rojo then Rojo
  else if posicion < tiempo_rojo + tiempo_verde then Verde
  else Amarillo
