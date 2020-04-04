filtro : thread.o lex.yy.o
	gcc -o filtro thread.o lex.yy.o -ll

thread.o : thread.c
		gcc -c thread.c

lex.yy.o : lex.yy.c
		gcc -c lex.yy.c

lex.yy.c : filtro.l thread.h
		flex filtro.l