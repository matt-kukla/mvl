(** tern - Kleene and Łukasiewicz ternary propositional logic. *)

(** @author Matthew Kukla *)

exception Unknown

(** Truth values (True, False, Unknown) *)
type trilean = T | F | U

type tern_expr =
    | Var of string
    | Tr of trilean
    | Not of tern_expr
    | Unop of (trilean -> trilean) * tern_expr (** User-defined unary operators *)
    | And of tern_expr * tern_expr
    | AndSt of tern_expr * tern_expr
    | Or of tern_expr * tern_expr
    | OrSt of tern_expr * tern_expr
    | Impl of tern_expr * tern_expr
    | Impl_Lukas of tern_expr * tern_expr
    | ImplSt of tern_expr * tern_expr
    | BicondSt of tern_expr * tern_expr
    | XorSt of tern_expr * tern_expr
    | Binop of (trilean -> trilean -> trilean) *  tern_expr * tern_expr
    (** User-defined binary operators *)

(** Ternary "not" *)
val not_tern : trilean -> trilean

(** Ternary "and" *)
val and_tern : trilean -> trilean -> trilean 

(** Strict "and" *)
val and_st : trilean -> trilean -> trilean

(** Ternary "or" *)
val or_tern : trilean -> trilean -> trilean

(** Strict "or" *)
val or_st : trilean -> trilean -> trilean

(** Regular ternary (Kleene) implication *)
val impl_tern : trilean -> trilean -> trilean

(** Łukasiewicz implication *)
val impl_lukas : trilean -> trilean -> trilean

(** Strict implication *)
val impl_st : trilean -> trilean -> trilean

(** Strict biconditional *)
val bicond_st : trilean -> trilean -> trilean

(** Evaluate ternary formula over given valuation *)
val eval_tern : tern_expr -> (string * trilean) list -> trilean

(** Convert T or F to respective boolean values.  
Raises [Unknown] when passed [U].*)
val to_bool : trilean -> bool
