struct token {
   int category;   /* the integer code returned by yylex */
   char *text;     /* the actual string (lexeme) matched */
   int lineno;     /* the line number on which the token occurs */
   char *filename; /* the source file in which the token occurs */
   int ival;       /* if you had an integer constant, store its value here */
   char *sval;      /* if you had a string constant, malloc space and store */
   }token;               /*    the string (less quotes and after escapes) here */

typedef struct tokenl {
      struct token t;
      struct tokenl *next;
      }tokenlist;
int eof;
