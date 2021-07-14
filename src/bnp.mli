(** bnp - Belnap four-valued logic. *)

(** @author Matthew Kukla *)

(** Truth values (True, False, Neither, Both). *)
type belnap = T | F | N | B

type bnp_expr =
    Val of belnap
    | And of bnp_expr * bnp_expr
    | Or of bnp_expr * bnp_expr
    | Not of bnp_expr
    | Impl of bnp_expr * bnp_expr
    
(** Negation *)
val not_bnp : belnap -> belnap
    
(** Conjunction *)
val and_bnp : belnap -> belnap -> belnap
    
(** Disjunction *)
val or_bnp : belnap -> belnap -> belnap

(** Implication *)
val implic : belnap -> belnap -> belnap
    
(** Evaluate formula *)
val eval_bnp : bnp_expr -> belnap
