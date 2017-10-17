/*
 * HW3 - Gavin Quinn CS 445
 *
*/

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
tree *savedTree = NULL;
hashtable_t *gtable;
/*
 * exit status: 
 * 		(0) successful, no errors
 * 		(1) lexical error, defined in clex.l
 * 		(2) syntax error, defined in 120gram.y
 * 		(3) "feature not supported" error, NYI
*/

/*
 * TODO:
 * 	- correctly print filenames/line numbers for all errors and standard output
 * 	- review grammar, add error locations
 * 	- integrate prodrule instead of stabbing in a string
*/

int main(int argc, char *argv[]) {
	depth = 0;
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
	free(fname);
	return 0;
}

/* handles file opening/token scanning/file closing in one handy function. Note that temp isn't actually used */
int read(FILE *temp, int arg, char *frname) {
	if ((yyin = fopen(frname, "r")) == NULL) {
        	printf("Can't open %s\n", frname);
        	return 1;
	}
	//token.filename = strdup(frname);
	if (yyparse() == 0){
		if(debug == 1) printf("DEBUG: Entering ht_create from read\n");
		gtable = ht_create(numnodes*1.5);
		if(debug == 1) printf("DEBUG: Exiting into read from ht_create\n");
		if(debug == 1) printf("DEBUG: Entering semanticAnalysis from read\n");
		semanticAnalysis(savedTree, gtable);
	// else something catastrophic happened. should never reach here, lexical errors
	// and syntax errors should exit within yyparse
	} else {
		printf("yyparse did not return successfully\n");
		exit(1);
	}
	yylineno = 1;
	fclose(yyin);
}

