#include "globals.h"
#include "tree.h"
#include "semantic.h"
#include "symt.h"
#include "codegen.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();
extern int yyparse();
int flag;
int read(FILE *, int, char *);
extern struct tree *savedTree;
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
	flag = 0;
	o_global = 0;
	 o_local = 0;
	o_param = 0;
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
		debug = 0;
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
	printf("120++ has finished\n");
	return 0;
}

/* handles file opening/token scanning/file closing in one handy function. Note that temp isn't actually used */
int read(FILE *temp, int arg, char *frname) {
	int i;
	if ((yyin = fopen(frname, "r")) == NULL) {
        	printf("Can't open %s\n", frname);
        	return 1;
	} else {
		printf("Opening %s\n", frname);
	}
	gtable = ht_create(sizeof(struct hashtable));
	if (yyparse() == 0){
		//treeprint(savedTree, 0);
		if (semanticAnalysis(savedTree) == 0){
			if (debug == 1) printf("semanticAnalysis passed!\n");
			if (gtable != NULL){
			if (ht_get(gtable, "main") == NULL){
				flag++;
			}
			}
        		for (i = 0; i < 14; i++){
				if (gtable->ltable[i] != NULL){
                		if (ht_get(gtable->ltable[i], "main") == NULL){
                			flag++;
                		}
				}
        		}
        		if (flag == 15){
                		fprintf(stderr, "ERROR: main is not defined\n");
				numErrors++;
			}
			if (numErrors > 0){
			        printf("Number of Errors: %d\n", numErrors);
        			exit(3);
        		}

			codegen(savedTree);
		} else {
			if (debug == 1) printf("semanticAnalysis failed\n");
		}
	// else something catastrophic happened. should never reach here, lexical errors
	// and syntax errors should exit within yyparse
	} else {
		printf("yyparse did not return successfully\n");
		exit(1);
	}
	yylineno = 1;
	return 0;
}

