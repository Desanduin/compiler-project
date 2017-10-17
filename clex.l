/* yanked from http://www2.cs.uidaho.edu/~jeffery/courses/445/clex.l
slightly adjusted to fit course requirements */
O        [0-7]
D        [0-9]
L        [a-zA-Z_]
H        [a-fA-F0-9]
E        [Ee][+-]?{D}+
fracconst 	([0-9]*\.[0-9]+)|([0-9]+\.)
exppart		[eE][-+]?[0-9]+
floatsuffix	[fFlL]
FS       (f|F|l|L)
IS       (u|U|l|L)
W        [ \t\f]*
LIT      \"(\\.|[^\\"])*\"
COMMENT  \/\*(\*(\/)|[^*])*\*\/|\/\/.*

%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "globals.h"
#include "tree.h"
#include "120gram.h"
void handle_include();
void lexerr(char *s);
int tokenset(int token);
extern YYSTYPE yylval;
/* #define DEBUG */
int errors;
int system_include = 0;
%}

%%

\n                      { yylineno++; }
[ \t\f]+                { }
"break"                 { return tokenset(BREAK); }
"case"                  { return tokenset(CASE); }
"char"                  { return tokenset(CHAR); }
"const"                 { return tokenset(CONST); }
"continue"              { return tokenset(CONTINUE); }
"default"               { return tokenset(DEFAULT); }
"do"                    { return tokenset(DO); }
"double"                { return tokenset(DOUBLE); }
"else"                  { return tokenset(ELSE); }
"float"                 { return tokenset(FLOAT); }
"for"                   { return tokenset(FOR); }
"goto"                  { lexerr("feature not supported in 120++"); }
"if"                    { return tokenset(IF); }
"int"                   { return tokenset(INT); }
"long"                  { return tokenset(LONG); }
"return"                { return tokenset(RETURN); }
"short"                 { return tokenset(SHORT); }
"signed"                { return tokenset(SIGNED); }
"sizeof"                { return tokenset(SIZEOF); }
"struct"                { return tokenset(STRUCT); }
"switch"                { return tokenset(SWITCH); }
"typedef"               { return tokenset(TYPEDEF); }
"union"                 { return tokenset(UNION); }
"unsigned"              { return tokenset(UNSIGNED); }
"void"                  { return tokenset(VOID); }
"while"                 { return tokenset(WHILE); }
"std"			{ return tokenset(NAMESPACE_NAME); }

{L}({L}|{D})*           { return tokenset(IDENTIFIER); }

0[xX]{H}+{IS}?          { lexerr("Hex not supported"); }

0{O}+{IS}?              { lexerr("Octal not supported"); }


{LIT}                   { return tokenset(STRING); }

{O}|{D}			{ return tokenset(INTEGER); }


{fracconst}{exppart}?{floatsuffix}?	{ return tokenset(FLOATING); }
[0-9]+{exppart}{floatsuffix}?		{ return tokenset(FLOATING); }

{COMMENT}		{ }

"#include"[ ]*\"[^\\"]+\"  { handle_include();}

"#include <iostream>"   { system_include = 1; handle_include();}
"#include <fstream>"	{ system_include = 1; handle_include();}
"#include <string>"	{ system_include = 1; handle_include();}
"#include <cstdlib>"	{ system_include = 1; handle_include();}
"#include <ctime>"	{ system_include = 1; handle_include();}
"#include <cmath>"	{ system_include = 1; handle_include();}

">>="                   { return tokenset(SREQ); }
"<<="                   { return tokenset(SLEQ); }
"+="                    { return tokenset(ADDEQ); }
"-="                    { return tokenset(SUBEQ); }
"*="                    { return tokenset(MULEQ); }
"/="                    { return tokenset(DIVEQ); }
"%="                   { return tokenset(MODEQ); }
"|="                    { return tokenset(OREQ); }
">>"                    { return tokenset(SR); }
"<<"                    { return tokenset(SL); }
"++"                    { return tokenset(PLUSPLUS); }
"--"                    { return tokenset(MINUSMINUS); }
"->"                    { return tokenset(ARROW); }
"&&"                    { return tokenset(ANDAND); }
"||"                    { return tokenset(OROR); }
"<="                    { return tokenset(LTEQ); }
">="                    { return tokenset(GTEQ); }
"=="                    { return tokenset(EQ); }
"!="                    { return tokenset(NOTEQ); }
"::"			{ return tokenset(COLONCOLON);}
";"                     { return tokenset(';'); }
"{"                     { return tokenset('{'); }
"}"                     { return tokenset('}'); }
","                     { return tokenset(','); }
":"                     { return tokenset(':'); }
"="                     { return tokenset('='); }
"("                     { return tokenset('('); }
")"                     { return tokenset(')'); }
"["                     { return tokenset('['); }
"]"                     { return tokenset(']'); }
"."                     { return tokenset('.'); }
"!"                     { return tokenset('!'); }
"~"                     { return tokenset('~'); }
"-"                     { return tokenset('-'); }
"+"                     { return tokenset('+'); }
"*"                     { return tokenset('*'); }
"/"                     { return tokenset('/'); }
"%"                     { return tokenset('%'); }
"<"                     { return tokenset('<'); }
">"                     { return tokenset('>'); }
"^"                     { return tokenset('^'); }
"?"                     { return tokenset('?'); }
"using namespace std;"	{ }
.			{ lexerr("token not detected");}
%%

/*
 * focuses on finding lexical errors. needs to include filename and lineno
*/
void lexerr(char *s)
{
        errors++;
        fprintf(stderr, "%s: lexical error", s);
        fprintf(stderr, " line number = %d, filename = , token = \"%s\"\n", yylineno , yytext);
	exit(1);
}

/*
 * Return 1 if done, 0 if yyin points at more input
 */
int yywrap()
{
   return 1;
}


void handle_include()
{
   yylineno++;
   /* added additional lines to catch system_includes. At this time only catches and ignores. no notification */
   if (system_include == 1) {
   	system_include = 0;
   } else {
   user_include++; 
   funame = strchr(yytext, '\"')+1;
   funame[strlen(funame)-1] = '\0';
   yylineno = 0;
   if (yyin == NULL) {
     printf("cannot open include file\n");
     exit(1);
   }
   }
}
// actually creates our token with the tokenvalue as input
// note that .filename and .ival/.sval are not set here
int tokenset(int tokenvalue){
token lextoken = malloc(sizeof(struct token));
lextoken->category = tokenvalue;
lextoken->lineno = yylineno;
lextoken->text = strdup(yytext);
lextoken->filename = fname;
yylval.treenode = makeTreeNode(tokenvalue, yytext, 0);
yylval.treenode->leaf = lextoken;
return tokenvalue;
}

