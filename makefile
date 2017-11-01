YACC=yacc
LEX=flex
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

