let _ = Random.init 0

let view_lit i = string_of_int i
let view_neg e = "-(" ^ e ^ ")"
let view_add e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"

let size_lit i = 1
let size_neg e = 1 + e
let size_add e1 e2 = 1 + e1 + e2

type 'e flata_ctx = LCA of 'e | NonLCA
let flata_lit n = function
  | NonLCA -> size_lit n
  | LCA e -> size_add (size_lit n) e
let flata_neg e = function
  | NonLCA -> size_neg (e NonLCA)
  | LCA e3 -> size_add (size_neg (e NonLCA)) e3
let flata_add e1 e2 ctx = e1 (LCA (e2 ctx))

type push_neg_ctx = Pos | Neg
let push_neg_lit n = function
  | Pos -> flata_lit n
  | Neg -> flata_neg (flata_lit n)
let push_neg_neg e = function
  | Pos -> e Neg
  | Neg -> e Pos
let push_neg_add e1 e2 ctx = flata_add (e1 ctx) (e2 ctx)

let rec rand_norm_size (depth : int) =
  if depth = 0 then push_neg_lit (Random.int 100) else
  let depth = depth - 1 in
  match Random.int 21 with
  | 0 -> push_neg_lit (Random.int 100)
  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 ->
    push_neg_neg (rand_norm_size depth)
  | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 ->
    push_neg_add (rand_norm_size depth) (rand_norm_size depth)
  | _ -> assert false

let rec rand_norm (n : int) (depth : int) =
  let rec go n sum = 
    if n = 0 then sum else
    go (n-1) (rand_norm_size depth Pos NonLCA + sum)
  in go n 0

let _ =
  print_endline (string_of_int (rand_norm
    (int_of_string Sys.argv.(1))
    (int_of_string Sys.argv.(2))))
(* let _ = rand_norm 10 20 *)
