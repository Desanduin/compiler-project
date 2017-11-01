<<<<<<< HEAD
=======
/*
 * HW3 - Gavin Quinn CS 445
 *
*/
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56

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
<<<<<<< HEAD
extern struct tree *savedTree;
extern struct hashtable *symboltable; 
=======
tree *savedTree = NULL;
hashtable_t *gtable;
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
/*
 * exit status: 
 * 		(0) successful, no errors
 * 		(1) lexical error, defined in clex.l
 * 		(2) syntax error, defined in 120gram.y
 * 		(3) "feature not supported" error, NYI
*/

<<<<<<< HEAD

int main(int argc, char *argv[]) {
	depth = 0;
	numErrors = 0;
	savedTree = NULL;
=======
/*
 * TODO:
 * 	- correctly print filenames/line numbers for all errors and standard output
 * 	- review grammar, add error locations
 * 	- integrate prodrule instead of stabbing in a string
*/

int main(int argc, char *argv[]) {
	depth = 0;
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
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
<<<<<<< HEAD
	
        if (numErrors > 0){
 	printf("Number of Errors: %d\n", numErrors);
 	exit(3);
 	}

=======
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
	free(fname);
	return 0;
}

/* handles file opening/token scanning/file closing in one handy function. Note that temp isn't actually used */
int read(FILE *temp, int arg, char *frname) {
	if ((yyin = fopen(frname, "r")) == NULL) {
        	printf("Can't open %s\n", frname);
        	return 1;
	}
<<<<<<< HEAD
	if (yyparse() == 0){
		if(debug == 1) printf("DEBUG: Entering ht_create from read\n");
		if(debug == 1) printf("DEBUG: Exiting into read from ht_create\n");
		//treeprint(savedTree, depth);
		if(debug == 1) printf("DEBUG: Entering semanticAnalysis from read\n");
		symboltable = ht_create(numnodes*1.5);
		semanticAnalysis(savedTree);
=======
	//token.filename = strdup(frname);
	if (yyparse() == 0){
		if(debug == 1) printf("DEBUG: Entering ht_create from read\n");
		gtable = ht_create(numnodes*1.5);
		if(debug == 1) printf("DEBUG: Exiting into read from ht_create\n");
		if(debug == 1) printf("DEBUG: Entering semanticAnalysis from read\n");
		semanticAnalysis(savedTree, gtable);
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
	// else something catastrophic happened. should never reach here, lexical errors
	// and syntax errors should exit within yyparse
	} else {
		printf("yyparse did not return successfully\n");
		exit(1);
	}
	yylineno = 1;
	fclose(yyin);
<<<<<<< HEAD
	return 0;
=======
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
}

