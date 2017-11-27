#ifndef STRUCTSET_H_
#define STRUCTSET_H_
#include <stdio.h>
#include "symt.h"
// Only works in C99, bool doesn't work otherwise
#include <stdbool.h>
// token and tokenl struct yanked from Dr. J's notes
// some global varilables defined here for easy access

struct token {
   int category;   /* the integer code returned by yylex */
   char *text;     /* the actual string (lexeme) matched */
   int lineno;     /* the line number on which the token occurs */
   char *filename; /* the source file in which the token occurs */
   int ival;       /* if you had an integer constant, store its value here */
   double dval;
   char *sval;      /* if you had a string constant, malloc space and store */
};               /*    the string (less quotes and after escapes) here */

typedef struct tokenl {
      struct token t;
      struct tokenl *next;
      }tokenlist;
char *fname;
char *funame;
FILE *saved_yyin;
int eof;
int numErrors;
int user_include;
int func_global;
int param_global;
int debug;
int lineno;
struct hashtable *gtable;
int analysisPass;
#endif
