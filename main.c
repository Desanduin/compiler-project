
#include "globals.h"
#include "tree.h"
#include "semantic.h"
#include "symt.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();
extern int yyparse();
int read(FILE *, int, char *);
extern struct tree *savedTree;
extern struct hashtable *gtable; 
/*
 * exit status: 
 * 		(0) successful, no errors
 * 		(1) lexical error, defined in clex.l
 * 		(2) syntax error, defined in 120gram.y
 * 		(3) "feature not supported" error, NYI
*/


int main(int argc, char *argv[]) {
	depth = 0;
	numErrors = 0;
	analysisPass = 0;
	savedTree = NULL;
	if (argc == 0) {
		printf("Please provide an input file");
		return 0;
	} else {
		fname = malloc(sizeof(*argv));
		user_include = 0;
		new_file = 0;
		/* set to true for detailed output */
		debug = true;
		while (--argc+user_include > 0) {
		if (user_include >= 1) {
		new_file = 1;
		read(yyin, argc, funame);
		user_include--;
		} else {
		strcpy(fname, *++argv);
		read(yyin, argc, fname);
		}
		}
	}
	
        if (numErrors > 0){
 	printf("Number of Errors: %d\n", numErrors);
 	exit(3);
 	}

	free(fname);
	return 0;
}

/* handles file opening/token scanning/file closing in one handy function. Note that temp isn't actually used */
int read(FILE *temp, int arg, char *frname) {
	if ((yyin = fopen(frname, "r")) == NULL) {
        	printf("Can't open %s\n", frname);
        	return 1;
	}
	if (yyparse() == 0){
		gtable = ht_create(numnodes*1.5);
		semanticAnalysis(savedTree);
	// else something catastrophic happened. should never reach here, lexical errors
	// and syntax errors should exit within yyparse
	} else {
		printf("yyparse did not return successfully\n");
		exit(1);
	}
	yylineno = 1;
	fclose(yyin);
	return 0;
}

