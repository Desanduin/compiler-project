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
int read(FILE *, int, char *);
struct tokenl *head;
struct tokenl *current;
int main(int argc, char *argv[]) {
	if (argc == 0) {
		printf("Please provide an input file");
		return 0;
	} else {
		user_include = 0;
		/* NOTE, can currently only handle one header file per argc file. Expected flaw, will resolve by HW2 */
		while (--argc+user_include > 0) {
		printf("%d\n", argc+user_include);
		if (user_include >= 1) {
			read(yyin, argc, funame);
			user_include--;
		} else {
		fname = malloc(sizeof(*argv));
		fname = *++argv;
		read(yyin, argc, fname);
		}
		}
		}
		return 0;
	}

/* handles file opening/token scanning/file closing in one handy function. Note that temp isn't actually used */
int read(FILE *temp, int arg, char *frname) {
	int ntoken = 0;
	head = NULL;
        current = NULL;
        head = malloc(sizeof(tokenlist));
        current = malloc(sizeof(tokenlist));
	if ((yyin = fopen(frname, "r")) == NULL) {
        	printf("Can't open %s\n", frname);
        	return 1;
	}
	token.filename = strdup(frname);
	ntoken = yylex();
	head->t = token;
	while (ntoken) {
		push();
		ntoken = yylex();
	}
	print();
	yylineno = 1;
	fclose(yyin);
}

void print() {
	current = head;
	char *buffer;
	printf("%s%30s%30s%30s%30s\n", "Category", "Text", "Lineno", "Filename", "Ival/Sval");
	while (current->next != NULL) {
		current->t.sval = malloc(strlen(current->t.text)+1);
		buffer = malloc(strlen(current->t.text)+1);
		// we know that the category can relate to constants, so we can separate our ival/sval prints
		if (current->t.category == STRING){
			strcpy(current->t.sval, current->t.text);
			// same code from clex.l, strips the quotation marks from the string
			current->t.sval = strchr(current->t.sval, '\"')+1;
			current->t.sval[strlen(current->t.sval)-1] = '\0';
			printf("%d%30s%30d%30s\t\t\t", current->t.category, current->t.text, current->t.lineno, current->t.filename);
			// TODO: put this in a function
			// This for loop grabs the sval string and iterates through it, searching for an escape character
			// when found, does an action specific to that character!
			for (int i = 0,j = 0; i < strlen(current->t.sval); i++) {	
				if (current->t.sval[i] == '\\' && current->t.sval[i+1] == 'n') {
					printf("\n\n");
					i++;
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == 't') {
					printf("\t");
					i++;
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == '\'') {
					printf("\'");
					i++;
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == '\\') {
					printf("\\");
					i++;
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == '\"') {
					printf("\"");
					i++;
				} else if (current->t.sval[i] == '\\' && current->t.sval[i+1] == '0') {
					current->t.sval[i] = '\0';
					printf("\n");
				} else {
				buffer[i] = current->t.sval[i];
				printf("%c", buffer[i]);	
				}
			}
		} else if (current->t.category == ICON){
			current->t.ival = atoi(current->t.text);
			printf("%d%30s%30d%30s%30d\n", current->t.category, current->t.text, current->t.lineno, current->t.filename, current->t.ival);
		// handles everything that is not an ival or an sval
		} else {
		printf("%d%30s%30d%30s\n", current->t.category, current->t.text, current->t.lineno, current->t.filename);
		}
		current = current->next;
	}
}

// just used for HW1, pushes nodes into a linked list with latest entry at tne end of the line
void push(){
	current = head;
	while (current->next != NULL) {
		current = current->next;	
	}
	current->next = malloc(sizeof(tokenlist));
	current->t = token;
	current = current->next;
}
