#include "ytab.h"
#include "structset.h"
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();
void print();
void push();
int main(int argc, char *argv[]) {
	int ntoken = 0;
	
	if (argc == 0) {
		printf("Please provide an input file");
		return 0;
	} else {
		if ((yyin = fopen(argv[1], "r")) == NULL) {
			printf("Can't open %s\n", *argv);
			return 1;
		} else {
			token.filename = argv[1];
			ntoken = yylex();	
			printf("Category\tText\t\tLineno\tFilename\tIval/Sval\t\n");
			while (ntoken){
				push();
				ntoken = yylex();
			}
			print();
			fclose(yyin);
		}
		return 0;
	}
}

void print() {
	tokenlist *current;
	current->t = token;
	while (current != NULL) {
		printf("%d\t\t%10s\t%10d\t%10s\t%d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		current = current->next;
		printf("hi\n");
	}
}
void push(){
	tokenlist *current;
	current->t = token;
	while (current->next != NULL) {
		current = current->next;	
	}
	current->next = malloc(sizeof(tokenlist));
	current->next->t = token;
	current->next->next = NULL;
}
