type belnap = T | F | N | B

type bnp_expr = 
    | Val of belnap
    | And of bnp_expr * bnp_expr
    | Or of bnp_expr * bnp_expr
    | Not of bnp_expr
    | Impl of bnp_expr * bnp_expr

let not_bnp x =
match x with
    | T -> F 
    | F -> T
    | N -> N
    | B -> B

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
    
let rec eval_bnp e = 
match e with
    | Val(x) -> x
    | And(l, r) -> and_bnp (eval_bnp l) (eval_bnp r)
    | Or(l, r) -> or_bnp (eval_bnp l) (eval_bnp r)
    | Not(x) -> not_bnp (eval_bnp  x)
    | Impl(l, r) -> implic(eval_bnp l) (eval_bnp r) 
