(** bnp - Belnap four-valued logic. *)

(** @author Matthew Kukla *)

(** Truth values (True, False, Neither, Both). *)
type belnap = T | F | N | B

type bnp_expr =
    | Val of belnap
    | BVar of string
    | Not of bnp_expr
    | Cnf of bnp_expr
    | Unop of (belnap -> belnap) * bnp_expr (** User-defined unary operators *)
    | And of bnp_expr * bnp_expr
    | Or of bnp_expr * bnp_expr
    | Impl of bnp_expr * bnp_expr
    | Impl_CMI of bnp_expr * bnp_expr
    | Impl_BN of bnp_expr * bnp_expr
    | Impl_ST of bnp_expr * bnp_expr
    | Cns of bnp_expr * bnp_expr
    | Gul of bnp_expr * bnp_expr
    | Binop of (belnap -> belnap -> belnap) *  bnp_expr * bnp_expr
    (** User-defined binary operators *)

(** Negation *)
val not_bnp : belnap -> belnap

(** Conflation *)
val conf : belnap -> belnap

(** Conjunction *)
val and_bnp : belnap -> belnap -> belnap
    
(** Disjunction *)
val or_bnp : belnap -> belnap -> belnap

(** Truth-preserving implication  *)
val implic : belnap -> belnap -> belnap

(** Material implication *)
val implic_cmi : belnap -> belnap -> belnap

(** Belnap implication *)
val implic_bn : belnap -> belnap -> belnap

(** Strong implication *)
val implic_st : belnap -> belnap -> belnap

(** Consensus *)
val cns : belnap -> belnap -> belnap

(** Gullibility *)
val gull : belnap -> belnap -> belnap

(** Evaluate formula over valuation *)
val eval_bnp : bnp_expr -> (string * belnap) list -> belnap
