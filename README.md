Performance comparison of tree transformations written with standard pattern matching +
recursion vs. with tagless final encoding.

Each `ml`/`sml` file implements `size`, `push_neg`, and `flata` from
[Oleg's lecture notes](http://okmij.org/ftp/tagless-final/course/lecture.pdf) and,
given command line arugments `N` and `D`, computes the sum over
`size (push_neg (flata e))` for `N` randomly generated `e`s of maximum depth `D`.

Assuming `mlton` and `ocamlopt` (with flambda) are installed, `make ITERS=N DEPTH=D`
will produce 8 binaries (described below) and time them with the given command-line
arguments.

The binaries are:
- `initial`: Initial + OCaml
- `initial_flambda`: Initial + OCaml + flambda
- `initial_mlton`: Initial + MLton
- `final`: Final + OCaml
- `final_flambda`: Final + OCaml + flambda
- `final_defunc`: Final + OCaml + manual defunctorization
- `final_defunc_flambda`: Final + OCaml + flambda + manual defunctorization
- `final_defunc_mlton`: Final MLton + manual defunctorization

On my machine:
```
time -p ./initial 200 30
22940398
real 9.18
user 9.15
sys 0.02
time -p ./initial_flambda 200 30
22940398
real 3.60
user 3.56
sys 0.04
time -p ./initial_mlton 200 30
25403522
real 2.14
user 1.92
sys 0.22
time -p ./final 200 30
22940398
real 8.95
user 8.87
sys 0.08
time -p ./final_flambda 200 30
22940398
real 4.30
user 4.20
sys 0.09
time -p ./final_defunc 200 30
22940398
real 8.94
user 8.80
sys 0.14
time -p ./final_defunc_flambda 200 30
22940398
real 4.31
user 4.23
sys 0.07
time -p ./final_defunc_mlton 200 30
24929841
real 1.46
user 1.29
sys 0.16
```
