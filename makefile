YACC=yacc
LEX=flex
CC=cc

all: 120++

.c.o:
	$(CC) -c $<

120++: 120gram.o 120lex.o main.o tree.o
	cc -o 120++ 120gram.o 120lex.o main.o tree.o

120gram.c 120gram.h: 120gram.y
	$(YACC) -dt --verbose 120gram.y
	mv -f y.tab.c 120gram.c
	mv -f y.tab.h 120gram.h

120lex.c: clex.l
	$(LEX) -t clex.l >120lex.c

120lex.o: 120gram.h

tree.o: tree.h

clean:
	rm -f 120++ *.o
	rm -f 120lex.c 120gram.c 120gram.h

