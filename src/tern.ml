exception Unknown

type trilean = T | F | U

type tern_expr = 
    | Tr of trilean
    | And of tern_expr * tern_expr
    | Or of tern_expr * tern_expr
    | Not of tern_expr 
    | Impl of tern_expr * tern_expr
    | Impl_Lukas of tern_expr * tern_expr

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

let or_tern x y =
match x, y with
     | T, T | T, U | U, T | T, F | F, T -> T
     | U, U | F, U | U, F -> U
     | F, F -> F

let impl_tern x y = or_tern (not_tern x) (y)

let impl_lukas x y= 
match x, y with
    | T, F -> F
    | U, F | T, U -> U
    | T, T | F, F | F, U | F, T | U, U | U, T -> T

let rec eval_tern x = 
match x with
    | Tr(T) -> T
    | Tr(F) -> F
    | Tr(U) -> U
    | And(l, r) -> and_tern (eval_tern l) (eval_tern r)
    | Or(l, r) -> or_tern (eval_tern l) (eval_tern r) 
    | Impl(l, r) -> impl_tern (eval_tern l) (eval_tern r)
    | Impl_Lukas(l, r) -> impl_lukas (eval_tern l) (eval_tern r) 
    | Not(a) -> not_tern (eval_tern a)

let to_bool x =
match x with
    | T -> true
    | F -> false
    | U -> raise Unknown
