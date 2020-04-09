let _ = Random.init 0

type exp
  = Lit of int
  | Neg of exp
  | Add of exp * exp

let rec eval : exp -> int = function
  | Lit i -> i
  | Neg e -> -eval e
  | Add (e1, e2) -> eval e1 + eval e2

let rec view : exp -> string = function
  | Lit i -> string_of_int i
  | Neg e -> "-(" ^ view e ^ ")"
  | Add (e1, e2) -> "(" ^ view e1 ^ " + " ^ view e2 ^ ")"

let rec size : exp -> int = function
  | Lit i -> 1
  | Neg e -> 1 + size e
  | Add (e1, e2) -> 1 + size e1 + size e2

let rec push_neg : exp -> exp = function
  | (Lit _ | Neg (Lit _)) as e -> e
  | Neg (Neg e) -> push_neg e
  | Neg (Add (e1, e2)) -> Add (push_neg (Neg e1), push_neg (Neg e2))
  | Add (e1, e2) -> Add (push_neg e1, push_neg e2)

let rec flata : exp -> exp = function
  | (Lit _ | Neg _) as e -> e
  | Add (Add (e1, e2), e3) -> flata (Add (e1, Add (e2, e3)))
  | Add (e1, e2) -> Add (e1, flata e2)

let norm e = flata (push_neg e)

(*
let ti1 = Add (Lit 8, Neg (Add (Lit 1, Lit 2)))
let ti3 = Add (ti1, Neg (Neg ti1))
let _ = print_endline (view ti3)
let _ = print_endline (view (norm ti3)) *)

let rec rand_exp (depth : int) : exp =
  if depth = 0 then Lit (Random.int 100) else
  let depth = depth - 1 in
  match Random.int 21 with
  | 0 -> Lit (Random.int 100)
  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 -> Neg (rand_exp depth)
  | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 -> Add (rand_exp depth, rand_exp depth)
  | _ -> assert false

let rec rand_norm (n : int) (depth : int) =
  let rec go n sum = 
    if n = 0 then sum else
    go (n-1) (size (norm (rand_exp depth)) + sum)
  in go n 0

let _ =
  print_endline (string_of_int (rand_norm
    (int_of_string Sys.argv.(1))
    (int_of_string Sys.argv.(2))))
