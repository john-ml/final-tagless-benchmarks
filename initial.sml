datatype exp
  = Lit of int
  | Neg of exp
  | Add of exp * exp

fun eval (Lit i) = i
  | eval (Neg e) = ~(eval e)
  | eval (Add (e1, e2)) = eval e1 + eval e2

fun size (Lit i) = 1
  | size (Neg e) = 1 + size e
  | size (Add (e1, e2)) = 1 + size e1 + size e2

fun push_neg (e as Lit _) = e
  | push_neg (e as Neg (Lit _)) = e
  | push_neg (Neg (Neg e)) = push_neg e
  | push_neg (Neg (Add (e1, e2))) = Add (push_neg (Neg e1), push_neg (Neg e2))
  | push_neg (Add (e1, e2)) = Add (push_neg e1, push_neg e2)

fun flata (e as Lit _) = e
  | flata (e as Neg _) = e
  | flata (Add (Add (e1, e2), e3)) = flata (Add (e1, Add (e2, e3)))
  | flata (Add (e1, e2)) = Add (e1, flata e2)

fun norm e = flata (push_neg e)

val rng = Random.newgen ()

fun rand_exp 0 = Lit (Random.range (0, 100) rng)
  | rand_exp depth =
    let
      val depth = depth - 1
      val x = Random.range (0, 21) rng
    in
      if x = 0 then Lit (Random.range (0, 100) rng) else
      if 1 <= x andalso x <= 10 then Neg (rand_exp depth) else
      Add (rand_exp depth, rand_exp depth)
    end

fun rand_norm (n : int) (depth : int) =
  let
    fun go 0 sum = sum
      | go n sum = go (n-1) (size (norm (rand_exp depth)) + sum)
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
