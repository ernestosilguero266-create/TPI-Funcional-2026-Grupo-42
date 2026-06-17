(* ===================================================================== *)
(* TPI FUNCIONAL 2026 - Grupo 42                                          *)
(* Fase 3: Estudio Comparativo - Lenguaje asignado: OCaml                 *)
(* Reimplementacion de las funciones `transicion` y `timer`.              *)
(* ---------------------------------------------------------------------- *)
(* Compilar/ejecutar:                                                     *)
(*   ocaml solucion.ml          (modo script, ejecuta la demo del final)  *)
(*   ocamlfind ocamlopt solucion.ml -o solucion && ./solucion             *)
(* En el toplevel (utop / ocaml) se puede pegar funcion por funcion y ver *)
(* la firma que INFIERE el compilador (ver comentarios "val ...").        *)
(* ---------------------------------------------------------------------- *)
(* NOTA DE INFERENCIA DE TIPOS (responde la Pregunta 1 de la consigna):   *)
(* En ninguna de las dos funciones se declaro el tipo a mano. El          *)
(* compilador los DEDUJO solo (sistema Hindley-Milner). Bajo cada `let`   *)
(* se transcribe LITERALMENTE lo que responde el toplevel.                *)
(* ===================================================================== *)


(* --------------------------------------------------------------------- *)
(* TIPOS ALGEBRAICOS (variantes / ADT)                                    *)
(* Un valor de tipo `estado` solo puede ser uno de estos tres            *)
(* constructores. Un estado invalido (p. ej. "azul") es IMPOSIBLE de      *)
(* construir y el compilador lo rechaza ANTES de ejecutar el programa.    *)
(* --------------------------------------------------------------------- *)
type estado = En_rojo | En_amarillo | En_verde
type color  = Rojo | Amarillo | Verde


(* ===================================================================== *)
(* FUNCION: transicion                                                    *)
(* NATURALEZA: Pura (mismas entradas -> misma salida, sin efectos)        *)
(* ESTRATEGIA: Pattern Matching exhaustivo (match ... with sobre tupla)   *)
(* IMPACTO: No destructiva (retorna una tupla nueva e inmutable)          *)
(* ===================================================================== *)
(* El toplevel infiere y responde:                                        *)
(*   val transicion : estado -> color -> estado * string = <fun>          *)
(* No se anoto ningun tipo: usar los constructores En_rojo/Verde alcanza  *)
(* para que el compilador deduzca que el 1er arg es `estado`, el 2do es   *)
(* `color` y el retorno es la tupla `estado * string`.                    *)
let transicion actual cambiar_a =
  match actual, cambiar_a with
  | En_rojo,     Verde    -> (En_rojo,     "cambiar-a-verde")
  | En_verde,    Amarillo -> (En_verde,    "cambiar-a-amarillo")
  | En_amarillo, Rojo     -> (En_amarillo, "cambiar-a-rojo")
  | _,           _        -> (actual,      "accion-por-defecto")


(* --------------------------------------------------------------------- *)
(* Reglas de negocio: duracion de cada color en segundos.                 *)
(* El toplevel las infiere como enteros: val tiempo_rojo : int = 90 ...   *)
(* --------------------------------------------------------------------- *)
let tiempo_rojo     = 90
let tiempo_verde    = 120
let tiempo_amarillo = 6

(* ===================================================================== *)
(* FUNCION: duracion_ciclo (auxiliar del timer)                           *)
(* NATURALEZA: Pura                                                       *)
(* ESTRATEGIA: Expresion aritmetica simple (orientada a expresiones)      *)
(* IMPACTO: No destructiva                                                *)
(* ===================================================================== *)
(* El toplevel infiere:  val duracion_ciclo : int = 216                   *)
(* (es un VALOR, no una funcion: en OCaml todo es una expresion que       *)
(*  produce un valor; aqui la expresion suma se evalua una sola vez.)     *)
let duracion_ciclo = tiempo_rojo + tiempo_verde + tiempo_amarillo

(* ===================================================================== *)
(* FUNCION: timer                                                         *)
(* NATURALEZA: Pura (dado un timestamp, siempre retorna el mismo color)   *)
(* ESTRATEGIA: Orientada a expresiones (if/then/else COMO expresion que   *)
(*             devuelve un valor `color`; no hay sentencias)              *)
(* IMPACTO: No destructiva                                                *)
(* ===================================================================== *)
(* El toplevel infiere y responde:                                        *)
(*   val timer : int -> color = <fun>                                     *)
let timer timestamp =
  (* `mod` puede ser negativo si timestamp < 0; se normaliza para que la   *)
  (* posicion quede siempre en el rango [0, duracion_ciclo).               *)
  let posicion =
    ((timestamp mod duracion_ciclo) + duracion_ciclo) mod duracion_ciclo
  in
  (* Cada rama del if es una EXPRESION; la ultima expresion evaluada es el  *)
  (* valor de retorno. No hace falta `return`.                             *)
  if posicion < tiempo_rojo then Rojo
  else if posicion < tiempo_rojo + tiempo_verde then Verde
  else Amarillo


(* ===================================================================== *)
(* FUNCION: string_of_color (auxiliar de presentacion)                    *)
(* NATURALEZA: Pura                                                       *)
(* ESTRATEGIA: Pattern Matching (match implicito con `function`)          *)
(* IMPACTO: No destructiva                                                *)
(* ===================================================================== *)
(*   val string_of_color : color -> string = <fun>                        *)
let string_of_color = function
  | Rojo     -> "rojo"
  | Amarillo -> "amarillo"
  | Verde    -> "verde"

(* ===================================================================== *)
(* FUNCION: string_of_estado (auxiliar de presentacion)                   *)
(* NATURALEZA: Pura                                                       *)
(* ESTRATEGIA: Pattern Matching (match implicito con `function`)          *)
(* IMPACTO: No destructiva                                                *)
(* ===================================================================== *)
(*   val string_of_estado : estado -> string = <fun>                      *)
let string_of_estado = function
  | En_rojo     -> "en-rojo"
  | En_amarillo -> "en-amarillo"
  | En_verde    -> "en-verde"


(* --------------------------------------------------------------------- *)
(* DEMOSTRACION (punto de entrada impuro: el unico efecto es imprimir).    *)
(* Equivale a los ejemplos de uso del Requerimiento 7 en la version Lisp.  *)
(* --------------------------------------------------------------------- *)
let () =
  let mostrar_transicion actual cambiar_a etiqueta =
    let (e, accion) = transicion actual cambiar_a in
    Printf.printf "  transicion %-12s -> (%s, \"%s\")   [%s]\n"
      (string_of_estado actual) (string_of_estado e) accion etiqueta
  in
  print_endline "=== Req 1: transicion ===";
  mostrar_transicion En_rojo     Verde    "normal";
  mostrar_transicion En_verde    Amarillo "normal";
  mostrar_transicion En_amarillo Rojo     "normal";
  mostrar_transicion En_rojo     Amarillo "invalida -> por defecto";
  print_newline ();
  print_endline "=== Req 2: timer (ciclo = 216 s) ===";
  List.iter
    (fun t ->
       Printf.printf "  timer %-4d -> %s\n" t (string_of_color (timer t)))
    [0; 89; 90; 100; 209; 210; 215; 216];
  Printf.printf "  timer 1747405800 -> %s\n" (string_of_color (timer 1747405800))
