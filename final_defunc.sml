fun size_lit i = 1
fun size_neg e = 1 + e
fun size_add e1 e2 = 1 + e1 + e2

datatype 'e flata_ctx = LCA of 'e | NonLCA
fun flata_lit n NonLCA = size_lit n
  | flata_lit n (LCA e) = size_add (size_lit n) e
fun flata_neg e NonLCA = size_neg (e NonLCA)
  | flata_neg e (LCA e3) = size_add (size_neg (e NonLCA)) e3
fun flata_add e1 e2 ctx = e1 (LCA (e2 ctx))

datatype push_neg_ctx = Pos | Neg
fun push_neg_lit n Pos = flata_lit n
  | push_neg_lit n Neg = flata_neg (flata_lit n)
fun push_neg_neg e Pos = e Neg
  | push_neg_neg e Neg = e Pos
fun push_neg_add e1 e2 ctx = flata_add (e1 ctx) (e2 ctx)

val rng = Random.newgen ()

fun rand_exp 0 = push_neg_lit (Random.range (0, 100) rng)
  | rand_exp depth =
    let
      val depth = depth - 1
      val x = Random.range (0, 21) rng
    in
      if x = 0 then push_neg_lit (Random.range (0, 100) rng) else
      if 1 <= x andalso x <= 10 then push_neg_neg (rand_exp depth) else
      push_neg_add (rand_exp depth) (rand_exp depth)
    end

fun rand_norm (n : int) (depth : int) =
  let
    fun go 0 sum = sum
      | go n sum = go (n-1) (rand_exp depth Pos NonLCA + sum)
  in
    go n 0
  end

val _ =
  case CommandLine.arguments ()
  of n :: depth :: _ =>
     print (Int.toString (rand_norm
       (valOf (Int.fromString n))
       (valOf (Int.fromString depth))))
   | _ => ()
val _ = print "\n"
