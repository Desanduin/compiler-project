#include "ytab.h"
#include "structset.h"
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();
void print(tokenlist *);
void push(tokenlist *);
int main(int argc, char *argv[]) {
	int ntoken = 0;
	tokenlist *head = NULL;
	head = malloc(sizeof(tokenlist));
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
			head->t = token;
			printf("Category\tText\t\tLineno\tFilename\tIval/Sval\t\n");
			while (ntoken){
				push(head);
				head->t = token;
				ntoken = yylex();
			}
			print(head);
			fclose(yyin);
		}
		return 0;
	}
}

void print(tokenlist *head) {
	tokenlist *current = NULL;
	current = malloc(sizeof(tokenlist));
	current = head;
	while (current != NULL) {
		//printf("%d\t\t%10s\t%10d\t%10s\t%d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		printf("%d\t%s\n", current->t.category, current->t.text);
		current = current->next;
	}
}
void push(tokenlist *head){
	tokenlist *current;
	//current = malloc(sizeof(tokenlist));
	current = head;
	while (current->next != NULL) {
		current = current->next;	
	}
	current->next = malloc(sizeof(tokenlist));
	current->next->t = token;
	current->next->next = NULL;
}
