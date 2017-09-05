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
struct tokenl *head;
struct tokenl *current;
int main(int argc, char *argv[]) {
	int ntoken = 0;
	if (argc == 0) {
		printf("Please provide an input file");
		return 0;
	} else {
		while (--argc > 0) {
		head = NULL;
		current = NULL;
		head = malloc(sizeof(tokenlist));
		current = malloc(sizeof(tokenlist));
		if ((yyin = fopen(*++argv, "r")) == NULL) {
			printf("Can't open %s\n", *argv);
			return 1;
		} else {
			token.filename = *argv;
			ntoken = yylex();
			head->t = token;
			printf("Category\tText\t\tLineno\tFilename\tIval/Sval\t\n");
			while (ntoken){
				push();
				ntoken = yylex();
			}
			print();
			fclose(yyin);
		}
		}
		return 0;
	}
}

void print() {
	current = head;
	while (current->next != NULL) {
		printf("%d\t\t%10s\t%10d\t%10s\t%d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		//printf("%d\t%s\n", current->t.category, current->t.text);
		current = current->next;
	}
}
void push(){
	current = head;
	while (current->next != NULL) {
		current = current->next;	
	}
	current->next = malloc(sizeof(tokenlist));
	current->t = token;
	//printf("%d\t%s\n", current->t.category, current->t.text);
	current = current->next;
}
