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

