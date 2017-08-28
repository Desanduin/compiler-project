#include "ytab.h"
#include "structset.h"
#include <stdio.h>
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
			ntoken = yylex();
			while (ntoken){
				printf("Category\tText\tLineno\tFilename\tIval/Sval\t\n");
				printf("%d\t\t%s\t%d\t\n", ntoken, yytext, yylineno);
				printf("text string of the token: %s\n", yytext);
				printf("int value of the token: %d\n", ntoken);
				printf("line number of token: %d\n", yylineno);
				ntoken = yylex();
			}
			fclose(yyin);
		}
		return 0;
	}
}
