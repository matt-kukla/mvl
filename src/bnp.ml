type belnap = T | F | N | B

type bnp_expr = 
    | Val of belnap
    | BVar of string
    | Not of bnp_expr
    | Cnf of bnp_expr
    | Unop of (belnap -> belnap) * bnp_expr
    | And of bnp_expr * bnp_expr
    | Or of bnp_expr * bnp_expr
    | Impl of bnp_expr * bnp_expr
    | Impl_CMI of bnp_expr * bnp_expr
    | Impl_BN of bnp_expr * bnp_expr
    | Impl_ST of bnp_expr * bnp_expr
    | Cns of bnp_expr * bnp_expr
    | Gul of bnp_expr * bnp_expr
    | Binop of (belnap -> belnap -> belnap) *  bnp_expr * bnp_expr

let not_bnp x =
match x with
    | T -> F 
    | F -> T
    | N -> N
    | B -> B

let conf x =
match x with 
    | (T|F) -> x
    | B -> N
    | N -> B

let and_bnp x y =
match x, y with
    | N, N | N, T | T, N -> N
    | F, _ | _, F | B, N | N, B -> F
    | T, T -> T
    | B, B | B, T | T, B -> B

let or_bnp x y =
match x, y with
    | N, N | N, F | F, N -> N
    | _, T | T, _ | B, N | N, B-> T
    | F, F -> F
    | B, F | F, B | B, B -> B

let implic x y = 
match x, y with
    | _ , T -> T
    | N, _ | B, B -> T
    | F, _ -> T
    | T, B -> T
    | T, (F|N) -> F
    | B, (F|N) -> F

let implic_cmi x y = 
match x, y with
    | _, T | F, _ | N, _ -> T
    | T, z -> z
    | B, z -> z

let implic_bn x y = 
match x, y with
    | _, T | F, _  | B, B | N, N -> T
    | (T|B), F | (T|B), N | N, F | (T|N), B -> F

let implic_st x y =
match x, y with
    | _, T | F, _ | N, N -> T
    | T, F | T, B | B, F -> F
    | (T|B), N | N, (F|B) -> N
    | B, B -> B

let cns x y =
match x, y with
    | T, (T|B) | B, T -> T
    | F, (F|B) | B, F -> F
    | F, (T|N) | T, (F|N) -> N
    | B, B -> B
    | N, _ | _, N-> N

let gull x y =
match x, y with
    | T, N | N, T | T, T -> T
    | F, F | F, N | N, F -> F
    | N, N -> N
    | B, _ | _, B | T, F | F, T -> B

let rec eval_bnp e v = 
match e with
    | Val(x) -> x
    | BVar(x) -> List.assoc x v
    | Not(x) -> not_bnp (eval_bnp x v)
    | Cnf(x) -> conf (eval_bnp x v)
    | Unop(u, x) -> u (eval_bnp x v)
    | And(l, r) -> and_bnp (eval_bnp l v) (eval_bnp r v)
    | Or(l, r) -> or_bnp (eval_bnp l v) (eval_bnp r v)
    | Impl(l, r) -> implic(eval_bnp l v) (eval_bnp r v)
    | Impl_CMI(l, r) -> implic_cmi(eval_bnp l v) (eval_bnp r v)
    | Impl_BN(l, r) -> implic_bn (eval_bnp l v) (eval_bnp r v)
    | Impl_ST(l, r) -> implic_st (eval_bnp l v) (eval_bnp r v)
    | Cns(l, r) -> cns (eval_bnp l v) (eval_bnp r v)
    | Gul(l, r) -> gull (eval_bnp l v) (eval_bnp r v)
    | Binop(b, l, r) -> b (eval_bnp l v) (eval_bnp r v)
