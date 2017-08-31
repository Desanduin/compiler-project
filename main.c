#include "ytab.h"
#include "structset.h"
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();
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
				printf("%d\t\t%10s\t%10d\t%10s\t\n", token.category, token.text, token.lineno, token.filename);
				ntoken = yylex();
			}
			fclose(yyin);
		}
		return 0;
	}
}
