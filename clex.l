/* yanked from http://www2.cs.uidaho.edu/~jeffery/courses/445/clex.l
slightly adjusted to fit course requirements */
O        [0-7]
D        [0-9]
L        [a-zA-Z_]
H        [a-fA-F0-9]
E        [Ee][+-]?{D}+
FS       (f|F|l|L)
IS       (u|U|l|L)
W        [ \t\f]*
LIT      \"(\\.|[^\\"])*\"

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "ytab.h"
#include "structset.h"

void lexerr(char *s);
void handle_include();
int tokenset(int token);

/* #define DEBUG */

int line_num = 1;
int errors;
int included_iostream = 0;
FILE *saved_yyin;
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
"enum"                  { return tokenset(ENUM); }
"extern"                { return tokenset(EXTERN); }
"float"                 { return tokenset(FLOAT); }
"for"                   { return tokenset(FOR); }
"goto"                  { return tokenset(GOTO); }
"if"                    { return tokenset(IF); }
"int"                   { return tokenset(INT); }
"long"                  { return tokenset(LONG); }
"register"              { return tokenset(REGISTER); }
"return"                { return tokenset(RETURN); }
"short"                 { return tokenset(SHORT); }
"signed"                { return tokenset(SIGNED); }
"sizeof"                { return tokenset(SIZEOF); }
"static"                { return tokenset(STATIC); }
"struct"                { return tokenset(STRUCT); }
"switch"                { return tokenset(SWITCH); }
"typedef"               { return tokenset(TYPEDEF); }
"union"                 { return tokenset(UNION); }
"unsigned"              { return tokenset(UNSIGNED); }
"void"                  { return tokenset(VOID); }
"volatile"              { return tokenset(VOLATILE); }
"while"                 { return tokenset(WHILE); }

{L}({L}|{D})*           { return tokenset(IDENTIFIER); }


0[xX]{H}+{IS}?          { lexerr("Hex not supported\n"); }

0{O}+{IS}?              { lexerr("Octal not supported\n"); }

{D}+{IS}?               { return tokenset(ICON); }

'(\\.|[^\\'])+'         { return tokenset(CCON); }

{D}+{E}{FS}?            { return tokenset(FCON); }
{D}*"."{D}+({E})?{FS}?  { return tokenset(FCON); }
{D}+"."{D}*({E})?{FS}?  { return tokenset(FCON); }

{LIT}                   { return tokenset(STRING); }

"#include"[ ]*\"[^\\"]+\"  { handle_include(); }

"#include <iostream>"   { included_iostream = 1; }

">>="                   { return tokenset(SRASN); }
"<<="                   { return tokenset(SLASN); }
"+="                    { return tokenset(PLASN); }
"-="                    { return tokenset(MIASN); }
"*="                    { return tokenset(MUASN); }
"/="                    { return tokenset(DIASN); }
"%="                    { return tokenset(MOASN); }
"&="                    { return tokenset(ANASN); }
"^="                    { return tokenset(ERASN); }
"|="                    { return tokenset(ORASN); }
">>"                    { return tokenset(SHR); }
"<<"                    { return tokenset(SHL); }
"++"                    { return tokenset(INCOP); }
"--"                    { return tokenset(DECOP); }
"->"                    { return tokenset(FOLLOW); }
"&&"                    { return tokenset(ANDAND); }
"||"                    { return tokenset(OROR); }
"<="                    { return tokenset(LE); }
">="                    { return tokenset(GE); }
"=="                    { return tokenset(EQ); }
"!="                    { return tokenset(NE); }
";"                     { return tokenset(SM); }
"{"                     { return tokenset(LC); }
"}"                     { return tokenset(RC); }
","                     { return tokenset(CM); }
":"                     { return tokenset(COLON); }
"="                     { return tokenset(ASN); }
"("                     { return tokenset(LP); }
")"                     { return tokenset(RP); }
"["                     { return tokenset(LB); }
"]"                     { return tokenset(RB); }
"."                     { return tokenset(DOT); }
"&"                     { return tokenset(AND); }
"!"                     { return tokenset(BANG); }
"~"                     { return tokenset(NOT); }
"-"                     { return tokenset(MINUS); }
"+"                     { return tokenset(PLUS); }
"*"                     { return tokenset(MUL); }
"/"                     { return tokenset(DIV); }
"%"                     { return tokenset(MOD); }
"<"                     { return tokenset(LT); }
">"                     { return tokenset(GT); }
"^"                     { return tokenset(ER); }
"|"                     { return tokenset(OR); }
"?"                     { return tokenset(QUEST); }
%%

void lexerr(char *s)
{
        errors++;

        fprintf(stderr, "%s: lexical error", s);

        /* to do: add mechanism for reporting file name and line number */

        fprintf(stderr, ", token = \"%s\"\n", yytext);
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
   char *newfilename = malloc(strlen(yytext)+1-strlen("#include \"\""));
   saved_yyin = yyin;
   char *fname = strchr(yytext, '\"')+1;
   fname[strlen(fname)-1] = '\0';
   // fprintf(stdout, "included filename '%s'\n", fname); fflush(stdout);
   yyin = fopen(fname,"r");
   if (yyin == NULL) {
     lexerr("cannot open include file");
     exit(1);
   }
}

int tokenset(int tokenvalue){
token.lineno = yylineno;
token.text = yytext;
return tokenvalue;
}

