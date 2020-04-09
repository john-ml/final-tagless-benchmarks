FLAMBDA_FLAGS=

# ITERS=100, DEPTH=30 are reasonable defaults for my machine
all: sml.pkg \
     initial initial_flambda initial_mlton \
     final final_flambda \
     final_defunc final_defunc_flambda final_defunc_mlton
	time -p ./initial $(ITERS) $(DEPTH)
	time -p ./initial_flambda $(ITERS) $(DEPTH)
	time -p ./initial_mlton $(ITERS) $(DEPTH)
	time -p ./final $(ITERS) $(DEPTH)
	time -p ./final_flambda $(ITERS) $(DEPTH)
	time -p ./final_defunc $(ITERS) $(DEPTH)
	time -p ./final_defunc_flambda $(ITERS) $(DEPTH)
	time -p ./final_defunc_mlton $(ITERS) $(DEPTH)

clean:
	rm *.cmo *.cmx *.cmi *.o *.du *.ud sml.pkg \
	  initial initial_flambda initial_mlton \
	  final final_flambda \
	  final_defunc final_defunc_flambda final_defunc_mlton

sml.pkg:
	smlpkg add github.com/diku-dk/sml-random
	smlpkg sync

initial: initial.ml
	ocamlc initial.ml -o initial

initial_flambda: initial.ml
	ocamlopt -O2 $(FLAMBDA_FLAGS) initial.ml -o initial_flambda

initial_mlton: initial.sml initial.mlb
	mlton -output initial_mlton initial.mlb

final: final.ml
	ocamlc final.ml -o final

final_flambda: final.ml
	ocamlopt -O2 $(FLAMBDA_FLAGS) final.ml -o final_flambda

final_defunc: final_defunc.ml
	ocamlc final_defunc.ml -o final_defunc

final_defunc_flambda: final_defunc.ml
	ocamlopt -O2 $(FLAMBDA_FLAGS) final_defunc.ml -o final_defunc_flambda

final_defunc_mlton: final_defunc.sml final_defunc.mlb 
	mlton -output final_defunc_mlton final_defunc.mlb
