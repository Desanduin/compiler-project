YACC=yacc
LEX=flex
CC=cc

all: 120++

.c.o:
	$(CC) -c $<

120++: lex.yy.o main.o tree.o symt.o semantic.o 120gram.tab.o
	cc -o 120++  lex.yy.o main.o tree.o symt.o semantic.o 120gram.tab.o

120gram.tab.c: 120gram.y
	bison -dtv 120gram.y

lex.yy.c: clex.l 120gram.tab.c
	$(LEX)  clex.l

120lex.o: 120gram.h

120gram.tab.o: 120gram.tab.c
	$(CC) -c -g 120gram.tab.c

tree.o: tree.h

symt.o: symt.h

semantic.o: semantic.h

clean:
	rm -f 120++ *.o
	rm -f lex.yy.c 120gram.tab.c
	rm -f 120gram.output

