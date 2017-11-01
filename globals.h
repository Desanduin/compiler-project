#ifndef STRUCTSET_H_
#define STRUCTSET_H_
#include <stdio.h>
// Only works in C99, bool doesn't work otherwise
#include <stdbool.h>
// token and tokenl struct yanked from Dr. J's notes
// some global varilables defined here for easy access

<<<<<<< HEAD
struct token {
=======
typedef struct token {
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   int category;   /* the integer code returned by yylex */
   char *text;     /* the actual string (lexeme) matched */
   int lineno;     /* the line number on which the token occurs */
   char *filename; /* the source file in which the token occurs */
   int ival;       /* if you had an integer constant, store its value here */
   double dval;
   char *sval;      /* if you had a string constant, malloc space and store */
<<<<<<< HEAD
};               /*    the string (less quotes and after escapes) here */
=======
} *token;               /*    the string (less quotes and after escapes) here */
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56

typedef struct tokenl {
      struct token t;
      struct tokenl *next;
      }tokenlist;
char *fname;
char *funame;
FILE *saved_yyin;
int eof;
<<<<<<< HEAD
int numErrors;
int user_include;
bool debug;
int lineno;
=======
int user_include;
bool debug;




>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
#endif
