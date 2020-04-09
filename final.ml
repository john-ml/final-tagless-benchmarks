let _ = Random.init 0

module type Exp = sig
  type t
  val lit : int -> t
  val neg : t -> t
  val add : t -> t -> t
end

module Eval = struct
  type t = int
  let lit i = i
  let neg e = -e
  let add e1 e2 = e1 + e2
end

module View = struct
  type t = string
  let lit i = string_of_int i
  let neg e = "-(" ^ e ^ ")"
  let add e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"
end

module Size = struct
  type t = int
  let lit i = 1
  let neg e = 1 + e
  let add e1 e2 = 1 + e1 + e2
end

type push_neg_ctx = Pos | Neg
module PushNeg (E : Exp) = struct
  type t = push_neg_ctx -> E.t
  let lit n = function
    | Pos -> E.lit n
    | Neg -> E.neg (E.lit n)
  let neg e = function
    | Pos -> e Neg
    | Neg -> e Pos
  let add e1 e2 ctx = E.add (e1 ctx) (e2 ctx)
end

type 'e flata_ctx = LCA of 'e | NonLCA
module FlatA (E : Exp) = struct
  type t = E.t flata_ctx -> E.t
  let lit n = function
    | NonLCA -> E.lit n
    | LCA e -> E.add (E.lit n) e
  let neg e = function
    | NonLCA -> E.neg (e NonLCA)
    | LCA e3 -> E.add (E.neg (e NonLCA)) e3
  let add e1 e2 ctx = e1 (LCA (e2 ctx))
end

module Norm (E : Exp) = PushNeg (FlatA (E))
(*
module Ti3 (E : Exp) = struct
  let ti1 = E.add (E.lit 8) (E.neg (E.add (E.lit 1) (E.lit 2)))
  let e = E.add ti1 (E.neg (E.neg ti1))
end

module Ti3View = Ti3 (View) 
let _ = print_endline Ti3View.e

module Ti3NormView = Ti3 (Norm (View))
let _ = print_endline (Ti3NormView.e Pos NonLCA)
*)
module RandE (E : Exp) = struct
  let rec rand_exp (depth : int) : E.t =
    if depth = 0 then E.lit (Random.int 100) else
    let depth = depth - 1 in
    match Random.int 21 with
    | 0 -> E.lit (Random.int 100)
    | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 -> E.neg (rand_exp depth)
    | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 -> E.add (rand_exp depth) (rand_exp depth)
    | _ -> assert false
end

(* module RandNormExp = RandE (Norm (View)) *)
module RandNormExp = RandE (Norm (Size))
let rec rand_norm (n : int) (depth : int) =
  let rec go n sum = 
    if n = 0 then sum else
    go (n-1) (RandNormExp.rand_exp depth Pos NonLCA + sum)
  in go n 0

let _ =
  print_endline (string_of_int (rand_norm
    (int_of_string Sys.argv.(1))
    (int_of_string Sys.argv.(2))))
(* let _ = rand_norm 10 20 *)
