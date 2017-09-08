
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
				if (saved_yyin) {
				}
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
	printf("%s%30s%30s%30s%30s\n", "Category", "Text", "Lineno", "Filename", "Ival/Sval");
	while (current->next != NULL) {
		current->t.sval = malloc(strlen(current->t.text)+1);
		buffer = malloc(strlen(current->t.text)+1);
		// we know that category 293 is a STRING constant
		if (current->t.category == STRING){
			strcpy(current->t.sval, current->t.text);
			current->t.sval = strchr(current->t.sval, '\"')+1;
			current->t.sval[strlen(current->t.sval)-1] = '\0';
			// buffer = strpbrk(current->t.sval, "\n\\\'");
			// buffer = current->t.sval;
			printf("%d%30s%30d%30s\t\t\t", current->t.category, current->t.text, current->t.lineno, current->t.filename);
			for (int i = 0,j = 0; i < strlen(current->t.sval); i++) {	
				if (current->t.sval[i] == '\\' && current->t.sval[i+1] == 'n') {
					printf("\n\n");
					i++;
					//current->t.sval[i] = '\0';
					//current->t.sval[i+1] = '\0';
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == 't') {
					printf("\t");
					current->t.sval[i] = '\0';
                                        current->t.sval[i+1] = '\0';
				} else {
				buffer[i] = current->t.sval[i];
				printf("%c", buffer[i]);	
				}
			}
			//printf(@"%s\n", current->t.sval);
		} else if (current->t.category == ICON){
			current->t.ival = atoi(current->t.text);
			printf("%d%30s%30d%30s%30d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		} else {
		//current->t.sval = realloc(current->t.sval, strlen(current->t.sval)+1);
		printf("%d%30s%30d%30s\n", current->t.category, current->t.text, current->t.lineno, current->t.filename);
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
