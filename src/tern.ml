exception Unknown

type trilean = T | F | U

type  tern_expr  =
    | Var of string
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
    | BicondSt of tern_expr * tern_expr
    | XorSt of tern_expr * tern_expr
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


let bicond_st x y = and_st (impl_st x y) (impl_st y x)

let xor_st x y = not_tern (bicond_st x y)

let rec eval_tern x v = 
match x with
    | Tr(T) -> T
    | Var(a) -> List.assoc a v
    | Tr(F) -> F
    | Tr(U) -> U
    | Not(a) -> not_tern (eval_tern a v)
    | Unop(u, a) -> u ( eval_tern a v)
    | And(l, r) -> and_tern (eval_tern l v) (eval_tern r v)
    | AndSt(l, r) -> and_st (eval_tern l v) (eval_tern r v)
    | Or(l, r) -> or_tern (eval_tern l v) (eval_tern r v) 
    | OrSt(l, r) ->  or_st (eval_tern l v) (eval_tern r v)
    | XorSt(l, r) -> xor_st (eval_tern l v) (eval_tern r v)
    | Impl(l, r) -> impl_tern (eval_tern l v) (eval_tern r v)
    | Impl_Lukas(l, r) -> impl_lukas (eval_tern l v) (eval_tern r v)
    | ImplSt(l, r) -> impl_st (eval_tern l v) (eval_tern r v)
    | BicondSt(l, r) -> bicond_st (eval_tern l v) (eval_tern r v)
    | Binop(b, l, r) -> b (eval_tern l v) (eval_tern r v)

let to_bool x =
match x with
    | T -> true
    | F -> false
    | U -> raise Unknown

let wdef x = 
match x with 
    | T | F -> true
    | U -> false

(* let rewrite f = 
match f with
    | AndSt(x, XorSt(y, z)) -> XorSt(AndSt(x, y), AndSt(x, z))
    | _ -> Val(U) *)
