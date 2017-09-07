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
COMMENT  \/\*(\*(\/)|[^*])*\*\/|\/\/.*

%{
#define _GNU_SOURCE
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
int errors;
int system_include = 0;
FILE *saved_yyin;
%}

%%

\n                      { yylineno++; }
[ \t\f]+                { }
<<EOF>>			{eof++; return 0;}
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
"goto"                  { return tokenset(GOTO); }
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

{L}({L}|{D})*           { return tokenset(IDENTIFIER); }

0[xX]{H}+{IS}?          { lexerr("Hex not supported\n"); }

0{O}+{IS}?              { lexerr("Octal not supported\n"); }

{D}+{IS}?               { return tokenset(ICON); }

'(\\.|[^\\'])+'         { return tokenset(CCON); }

{D}+{E}{FS}?            { return tokenset(FCON); }
{D}*"."{D}+({E})?{FS}?  { return tokenset(FCON); }
{D}+"."{D}*({E})?{FS}?  { return tokenset(FCON); }

{LIT}                   { return tokenset(STRING); }

{COMMENT}		{ }

"#include"[ ]*\"[^\\"]+\"  { handle_include();}

"#include <iostream>"   { system_include = 1; handle_include();}
"#include <fstream>"	{ system_include = 1; handle_include();}
"#include <string>"	{ system_include = 1; handle_include();}
"#include <cstdlib>"	{ system_include = 1; handle_include();}
"#include <ctime>"	{ system_include = 1; handle_include();}
"#include <cmath>"	{ system_include = 1; handle_include();}

">>="                   { return tokenset(SRASN); }
"<<="                   { return tokenset(SLASN); }
"+="                    { return tokenset(PLASN); }
"-="                    { return tokenset(MIASN); }
"*="                    { return tokenset(MUASN); }
"/="                    { return tokenset(DIASN); }
"%="                   { return tokenset(MOASN); }
"|="                    { return tokenset(ORASN); }
">>"                    { return tokenset(SHR); }
"<<"                    { return tokenset(SHL); }
"++"                    { return tokenset(INCOP); }
"--"                    { return tokenset(DECOP); }
"->"                    { return tokenset(FOLLOW); }
"&&"                    { return tokenset(AND); }
"||"                    { return tokenset(OR); }
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
   if (system_include == 1) {
	printf("%s\n", strdup(yytext));
   	system_include = 0;
	yylineno = 0;
   } else {
   char *newfilename = malloc(strlen(yytext)+1-strlen("#include \"\""));
   saved_yyin = yyin;
   char *fname = strchr(yytext, '\"')+1;
   fname[strlen(fname)-1] = '\0';
   // fprintf(stdout, "included filename '%s'\n", fname); fflush(stdout);
   yyin = fopen(fname,"r");
   yylineno = 0;
   if (yyin == NULL) {
     lexerr("cannot open include file");
     exit(1);
   }
   }
}

int tokenset(int tokenvalue){
token.category = tokenvalue;
token.lineno = yylineno;
token.text = strdup(yytext);
return tokenvalue;
}

