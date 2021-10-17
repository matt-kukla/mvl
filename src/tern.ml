exception Unknown

type trilean = T | F | U

type tern_expr = 
    | Tr of trilean
    | Not of tern_expr
    | Unop of (trilean -> trilean) * tern_expr
    | And of tern_expr * tern_expr
    | AndSt of tern_expr * tern_expr
    | Or of tern_expr * tern_expr
    | OrSt of tern_expr * tern_expr
    | Impl of tern_expr * tern_expr
    | Impl_Lukas of tern_expr * tern_expr
    | ImplSt of tern_expr * tern_expr
    | Binop of (trilean -> trilean -> trilean) *  tern_expr * tern_expr

let not_tern x = 
match x with
    | F -> T
    | U -> U
    | T -> F

let and_tern x y =
match x, y with
    | T, T -> T
    | F, F | T, F | F, T -> F
    | U, F | F, U -> F
    | U, U | U, T | T, U -> U

let and_st x y =
match x, y with
    | U, _ | _, U -> U
    | T, T -> T
    | _ -> F

let or_tern x y =
match x, y with
     | T, T | T, U | U, T | T, F | F, T -> T
     | U, U | F, U | U, F -> U
     | F, F -> F

let or_st x y =
match x, y with
    | U, _ | _, U-> U
    | T, F | (F|T), T -> T
    | F, F -> F

let impl_tern x y = or_tern (not_tern x) (y)

let impl_lukas x y= 
match x, y with
    | T, F -> F
    | U, F | T, U -> U
    | T, T | F, F | F, U | F, T | U, U | U, T -> T

let impl_st x y = 
match x, y with
    | U, _ | _, U -> U
    | T, T | F, T | F, F-> T
    | T, F -> F

let rec eval_tern x = 
match x with
    | Tr(T) -> T
    | Tr(F) -> F
    | Tr(U) -> U
    | Not(a) -> not_tern (eval_tern a)
    | Unop(u, a) -> u ( eval_tern a)
    | And(l, r) -> and_tern (eval_tern l) (eval_tern r)
    | AndSt(l, r) -> and_st (eval_tern l) (eval_tern r)
    | Or(l, r) -> or_tern (eval_tern l) (eval_tern r) 
    | OrSt(l, r) ->  or_st (eval_tern l) (eval_tern r)
    | Impl(l, r) -> impl_tern (eval_tern l) (eval_tern r)
    | Impl_Lukas(l, r) -> impl_lukas (eval_tern l) (eval_tern r)
    | ImplSt(l, r) -> impl_st (eval_tern l) (eval_tern r)
    | Binop(b, l, r) -> b (eval_tern l) (eval_tern r)

let to_bool x =
match x with
    | T -> true
    | F -> false
    | U -> raise Unknown
