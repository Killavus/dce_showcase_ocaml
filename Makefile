CC = opam config exec -- ocamlc
LEXGEN = opam config exec -- ocamllex
PARGEN = opam config exec -- ocamlyacc

OBJEXT = cmo
INTEXT = cmi

FLAGS = -g

OBJ = while_ast.$(OBJEXT) \
			while_parser.$(OBJEXT) \
			while_lexer.$(OBJEXT) \
			data_flow.$(OBJEXT) \
			main.$(OBJEXT)

prog: $(OBJ)
	$(CC) $(OBJ) $(FLAGS) -o analysis

while_parser.cmo : while_parser.cmi

%.$(INTEXT) : %.mli
	$(CC) -c $(FLAGS) $<

%.$(OBJEXT): %.ml
	$(CC) -c $(FLAGS) $< 

while_lexer.ml:
	$(LEXGEN) while_lexer.mll

while_parser.mli:
	$(PARGEN) while_parser.mly	

while_parser.ml: 
	$(PARGEN) while_parser.mly	

clean:
	rm -f while_lexer.ml while_parser.ml while_parser.mli
	rm -f *.cmo *.cmi 
