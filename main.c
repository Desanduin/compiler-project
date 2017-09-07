
#include "ytab.h"
#include "structset.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
			while (ntoken){
				push();
				ntoken = yylex();
			}
			print();
			yylineno = 1;
			fclose(yyin);
		}
		}
		return 0;
	}
}

void print() {
	current = head;
	char *buffer;
	printf("Category\tText\tLineno\tFilename\tIval/Sval\n");
	while (current->next != NULL) {
		current->t.sval = malloc(strlen(current->t.text)+1);
		buffer = malloc(strlen(current->t.text)+1);
		// we know that category 293 is a STRING constant
		if (current->t.category == 293){
			strcpy(current->t.sval, current->t.text);
			current->t.sval = strchr(current->t.sval, '\"')+1;
			printf("%s\n", buffer);
			current->t.sval[strlen(current->t.sval)-1] = '\0';
			buffer = strpbrk(current->t.sval, "\n\\\'");
			printf("%s\n", buffer);
			printf("%d\t\t%10s\t%10d\t%10s\t%s\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.sval);
		} else if (current->t.category == 290){
			current->t.ival = atoi(current->t.text);
			printf("%d\t\t%10s\t%10d\t%10s\t%d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		} else {
		//current->t.sval = realloc(current->t.sval, strlen(current->t.sval)+1);
		printf("%d\t\t%10s\t%10d\t%10s\t\n", current->t.category, current->t.text, current->t.lineno, current->t.filename);
		}
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
	current = current->next;
}
