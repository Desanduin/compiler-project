YACC=yacc
LEX=flex
<<<<<<< HEAD
CC=gcc
BIN=120++ lex.yy.o lex.yy.c tree.o type.o symt.o semantic.o  120gram.tab.h.gch 120gram.tab.c 120gram.tab.h 120gram.tab.o

all: 120++

120++: lex.yy.o main.c tree.o type.o symt.o semantic.o 120gram.tab.o 
	cc -Wall -o 120++  -g lex.yy.o main.c tree.o type.o symt.o semantic.o 120gram.tab.o 

120gram.tab.c 120gram.tab.h: 120gram.y
	yacc -d -Wno-conflicts-sr 120gram.y
	mv -f y.tab.c 120gram.tab.c
	mv -f y.tab.h 120gram.tab.h
lex.yy.c: clex.l
	$(LEX)  clex.l

lex.yy.o: lex.yy.c 120gram.tab.o symt.o
	$(CC) -c -g lex.yy.c

120gram.tab.o: 120gram.tab.c 120gram.tab.h tree.o symt.o
	$(CC) -c -g 120gram.tab.c 120gram.tab.h

tree.o: tree.c tree.h
	$(CC) -c -g tree.c

type.o: type.c type.h
	$(CC) -c -g type.c

symt.o: symt.c symt.h
	$(CC) -c -g symt.c

semantic.o: semantic.c semantic.h
	$(CC) -c -g semantic.c

clean:
	rm -f $(BIN)
=======
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
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56

