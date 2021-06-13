(** tern - Kleene and Łukasiewicz ternary propositional logic. *)

(** @author Matthew Kukla <matt.kukla@yandex.ru> *)

exception Unknown

(** Truth values (True, False, Unknown) *)
type trilean = T | F | U

(** Ternary logic formulas take the same form as regular propositional
formulas (with the addition of  Łukasiewicz implication). *)
type tern_expr =
    | Tr of trilean
    | And of tern_expr * tern_expr
    | Or of tern_expr * tern_expr
    | Not of tern_expr
    | Impl of tern_expr * tern_expr
    | Impl_Lukas of tern_expr * tern_expr

(** Ternary "not" *)
val not_tern : trilean -> trilean

(** Ternary "and" *)
val and_tern : trilean -> trilean -> trilean 

(** Ternary "or" *)
val or_tern : trilean -> trilean -> trilean

(** Regular ternary (Kleene) implication *)
val impl_tern : trilean -> trilean -> trilean

(** Łukasiewicz implication *)
val impl_lukas : trilean -> trilean -> trilean

(** Evaluate ternary formula *)
val eval_tern : tern_expr -> trilean

(** Convert T or F to respective boolean values.  
Raises [Unknown] when passed [U].*)
val to_bool : trilean -> bool
