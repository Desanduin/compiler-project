/*
 * Grammar for 120++, a subset of C++ used in CS 120 at University of Idaho
 *
 * Adaptation by Clinton Jeffery, with help from Matthew Brown, Ranger
 * Adams, and Shea Newton.
 *
 * Based on Sandro Sigala's transcription of the ISO C++ 1996 draft standard.
 * 
 */

/*	$Id: parser.y,v 1.3 1997/11/19 15:13:16 sandro Exp $	*/

/*
 * Copyright (c) 1997 Sandro Sigala <ssigala@globalnet.it>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * ISO C++ parser.
 *
 * Based on the ISO C++ draft standard of December '96.
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"
#include "globals.h"
<<<<<<< HEAD
#include "gram_rules.h"
=======

>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
extern char *yytext;
extern int yylex();
extern int yylineno;
int yydebug=0;
<<<<<<< HEAD
struct tree *savedTree;
static void yyerror(const char *);

%}
%union {
	struct token *tokenData;
	struct tree *treenode;
}
%define parse.error verbose
=======

static void yyerror(char *s);


%}
%union {
   struct tree *treenode;
}

>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
%type <treenode> typedef_name
%type <treenode> namespace_name
%type <treenode> original_namespace_name
%type <treenode> class_name
%type <treenode> enum_name
%type <treenode> identifier
%type <treenode> decl_specifier_seq decl_specifier
%type <treenode> literal
%type <treenode> integer_literal
%type <treenode> character_literal
%type <treenode> floating_literal
%type <treenode> string_literal
%type <treenode> boolean_literal
%type <treenode> translation_unit
%type <treenode> primary_expression
%type <treenode> id_expression
%type <treenode> unqualified_id
%type <treenode> qualified_id
%type <treenode> nested_name_specifier
%type <treenode> postfix_expression
%type <treenode> expression_list
%type <treenode> unary_expression
%type <treenode> unary_operator
%type <treenode> new_expression
%type <treenode> new_placement
%type <treenode> new_type_id
%type <treenode> new_declarator
%type <treenode> direct_new_declarator
%type <treenode> new_initializer
%type <treenode> delete_expression
%type <treenode> cast_expression
%type <treenode> pm_expression
%type <treenode> multiplicative_expression
%type <treenode> additive_expression
%type <treenode> shift_expression
%type <treenode> relational_expression
%type <treenode> equality_expression
%type <treenode> and_expression
%type <treenode> exclusive_or_expression
%type <treenode> inclusive_or_expression
%type <treenode> logical_and_expression
%type <treenode> logical_or_expression
%type <treenode> conditional_expression
%type <treenode> assignment_expression
%type <treenode> assignment_operator
%type <treenode> expression
%type <treenode> constant_expression
%type <treenode> statement
%type <treenode> labeled_statement
%type <treenode> expression_statement
%type <treenode> compound_statement
%type <treenode> statement_seq
%type <treenode> selection_statement
%type <treenode> condition
%type <treenode> iteration_statement
%type <treenode> for_init_statement
%type <treenode> jump_statement
%type <treenode> declaration_statement
%type <treenode> declaration_seq
%type <treenode> declaration
%type <treenode> block_declaration
%type <treenode> simple_declaration
%type <treenode> storage_class_specifier
%type <treenode> function_specifier
%type <treenode> type_specifier
%type <treenode> simple_type_specifier
%type <treenode> type_name
%type <treenode> elaborated_type_specifier
%type <treenode> enum_specifier
%type <treenode> enumerator_list
%type <treenode> enumerator_definition
%type <treenode> enumerator
%type <treenode> namespace_definition
%type <treenode> named_namespace_definition
%type <treenode> original_namespace_definition
%type <treenode> extension_namespace_definition
%type <treenode> unnamed_namespace_definition
%type <treenode> namespace_body
%type <treenode> namespace_alias_definition
%type <treenode> qualified_namespace_specifier
%type <treenode> using_declaration
%type <treenode> using_directive
%type <treenode> asm_definition
%type <treenode> linkage_specification
%type <treenode> init_declarator_list
%type <treenode> init_declarator
%type <treenode> declarator
%type <treenode> direct_declarator
%type <treenode> ptr_operator
%type <treenode> cv_qualifier_seq
%type <treenode> cv_qualifier
%type <treenode> declarator_id
%type <treenode> type_id
%type <treenode> type_specifier_seq
%type <treenode> abstract_declarator
%type <treenode> direct_abstract_declarator
%type <treenode> parameter_declaration_clause
%type <treenode> parameter_declaration_list
%type <treenode> parameter_declaration
%type <treenode> function_definition
%type <treenode> function_body
%type <treenode> initializer
%type <treenode> initializer_clause
%type <treenode> initializer_list
%type <treenode> class_specifier
%type <treenode> class_head
%type <treenode> class_key
%type <treenode> member_specification
%type <treenode> member_declaration
%type <treenode> member_declarator_list
%type <treenode> member_declarator
%type <treenode> pure_specifier
%type <treenode> constant_initializer
%type <treenode> base_clause
%type <treenode> base_specifier_list
%type <treenode> base_specifier
%type <treenode> access_specifier
%type <treenode> conversion_function_id
%type <treenode> conversion_type_id
%type <treenode> conversion_declarator
%type <treenode> ctor_initializer
%type <treenode> mem_initializer_list
%type <treenode> mem_initializer
%type <treenode> mem_initializer_id
%type <treenode> operator_function_id
%type <treenode> operator
%type <treenode> try_block
%type <treenode> function_try_block
%type <treenode> handler_seq
%type <treenode> handler
%type <treenode> exception_declaration
%type <treenode> throw_expression
%type <treenode> exception_specification
%type <treenode> type_id_list
%type <treenode> declaration_seq_opt
%type <treenode> nested_name_specifier_opt
%type <treenode> expression_list_opt
%type <treenode> COLONCOLON_opt
%type <treenode> new_placement_opt
%type <treenode> new_initializer_opt
%type <treenode> new_declarator_opt
%type <treenode> expression_opt
%type <treenode> statement_seq_opt
%type <treenode> condition_opt
%type <treenode> enumerator_list_opt
%type <treenode> initializer_opt
%type <treenode> constant_expression_opt
%type <treenode> abstract_declarator_opt
%type <treenode> type_specifier_seq_opt
%type <treenode> direct_abstract_declarator_opt
%type <treenode> ctor_initializer_opt
%type <treenode> COMMA_opt
%type <treenode> member_specification_opt
%type <treenode> SEMICOLON_opt
%type <treenode> conversion_declarator_opt
%type <treenode> handler_seq_opt
%type <treenode> assignment_expression_opt
%type <treenode> type_id_list_opt

<<<<<<< HEAD
%token <tokenData> IDENTIFIER INTEGER FLOATING CHARACTER STRING
%token <tokenData> TYPEDEF_NAME NAMESPACE_NAME CLASS_NAME ENUM_NAME

%token <tokenData> ELLIPSIS COLONCOLON DOTSTAR ADDEQ SUBEQ MULEQ DIVEQ MODEQ
%token <tokenData> XOREQ ANDEQ OREQ SL SR SREQ SLEQ EQEQ NOTEQ LTEQ GTEQ ANDAND OROR
%token <tokenData> PLUSPLUS MINUSMINUS ARROWSTAR ARROW

%token <tokenData> ASM AUTO BOOL BREAK CASE CATCH CHAR CLASS CONST CONST_CAST CONTINUE
%token <tokenData> DEFAULT DELETE DO DOUBLE DYNAMIC_CAST ELSE ENUM EXPLICIT EXPORT EXTERN
%token <tokenData> FALSE FLOAT FOR FRIEND IF INLINE INT LONG MUTABLE NAMESPACE NEW
%token <tokenData> OPERATOR PRIVATE PROTECTED PUBLIC REGISTER REINTERPRET_CAST RETURN
%token <tokenData> SHORT SIGNED SIZEOF STATIC STATIC_CAST STRUCT SWITCH THIS
%token <tokenData> THROW TRUE TRY TYPEDEF TYPEID TYPENAME UNION UNSIGNED USING VIRTUAL
%token <tokenData> VOID VOLATILE WCHAR_T WHILE SEMIC LPAREN RPAREN COMMA LCURLY RCURLY LBRAK RBRAK AND DOT
%token <tokenData> LT GT UNDER PLUS EQ DASH MOD MUL DIV OR QUEST KARAT EXPOINT TILDE COLON
%token <tokenData> ZERO
=======
%token <treenode> IDENTIFIER INTEGER FLOATING CHARACTER STRING
%token <treenode> TYPEDEF_NAME NAMESPACE_NAME CLASS_NAME ENUM_NAME

%token <treenode> ELLIPSIS COLONCOLON DOTSTAR ADDEQ SUBEQ MULEQ DIVEQ MODEQ
%token <treenode> XOREQ ANDEQ OREQ SL SR SREQ SLEQ EQ NOTEQ LTEQ GTEQ ANDAND OROR
%token <treenode> PLUSPLUS MINUSMINUS ARROWSTAR ARROW

%token <treenode> ASM AUTO BOOL BREAK CASE CATCH CHAR CLASS CONST CONST_CAST CONTINUE
%token <treenode> DEFAULT DELETE DO DOUBLE DYNAMIC_CAST ELSE ENUM EXPLICIT EXPORT EXTERN
%token <treenode> FALSE FLOAT FOR FRIEND IF INLINE INT LONG MUTABLE NAMESPACE NEW
%token <treenode> OPERATOR PRIVATE PROTECTED PUBLIC REGISTER REINTERPRET_CAST RETURN
%token <treenode> SHORT SIGNED SIZEOF STATIC STATIC_CAST STRUCT SWITCH THIS
%token <treenode> THROW TRUE TRY TYPEDEF TYPEID TYPENAME UNION UNSIGNED USING VIRTUAL
%token <treenode> VOID VOLATILE WCHAR_T WHILE ';' '(' ')' ',' '{' '}' '[' ']' '&' '.'
%token <treenode> '<' '>' '_' '+' '=' '-' '%' '*' '/' '|' '?' '^' '!' '~' ':'

>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
%start translation_unit



%%

/*
 * makeTreeNode placements helpfully provided by the script gramtree.m
 * gramtree.m was provided by a student in CS445, with a link in Dr. J's
 * lecture notes, at the start of Lecture 23
 *
*/

/*----------------------------------------------------------------------
 * Context-dependent identifiers.
 *----------------------------------------------------------------------*/

typedef_name:
<<<<<<< HEAD
     TYPEDEF_NAME           { $$ = leaf($1, TYPEDEF_NAME); }
=======
     TYPEDEF_NAME           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


namespace_name:
<<<<<<< HEAD
     original_namespace_name           { $$ = $1; }
=======
     original_namespace_name           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


original_namespace_name:
<<<<<<< HEAD
     NAMESPACE_NAME           { $$ = leaf($1, NAMESPACE_NAME); }
=======
     NAMESPACE_NAME           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


class_name:
<<<<<<< HEAD
     CLASS_NAME           { $$ = leaf($1, CLASS_NAME); }
=======
     CLASS_NAME           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


enum_name:
<<<<<<< HEAD
     ENUM_NAME           { $$ = leaf($1, ENUM_NAME); }
=======
     ENUM_NAME           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;




identifier:
<<<<<<< HEAD
     IDENTIFIER           { $$ = leaf($1, IDENTIFIER); }
=======
     IDENTIFIER           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


literal:
<<<<<<< HEAD
     integer_literal           { $$ = $1; }
   | character_literal           { $$ = $1; }
   | floating_literal           { $$ = $1; }
   | string_literal           { $$ = $1; }
   | boolean_literal           { $$ = $1; }
=======
     integer_literal           { $$ = $1;; }
   | character_literal           { $$ = $1;; }
   | floating_literal           { $$ = $1;; }
   | string_literal           { $$ = $1;; }
   | boolean_literal           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


integer_literal:
<<<<<<< HEAD
     INTEGER           { $$ = leaf($1, INTEGER); }
=======
     INTEGER           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


character_literal:
<<<<<<< HEAD
     CHARACTER           { $$ = leaf($1, CHARACTER); }
=======
     CHARACTER           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


floating_literal:
<<<<<<< HEAD
     FLOATING           { $$ = leaf($1, FLOATING); }
=======
     FLOATING           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


string_literal:
<<<<<<< HEAD
     STRING           { $$ = leaf($1, STRING); }
=======
     STRING           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


boolean_literal:
<<<<<<< HEAD
     TRUE           { $$ = leaf($1, TRUE); }
   | FALSE           { $$ = leaf($1, FALSE); }
=======
     TRUE           { $$ = $1; }
   | FALSE           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Translation unit.
 *----------------------------------------------------------------------*/
   
translation_unit:
<<<<<<< HEAD
     declaration_seq_opt           { savedTree = $1;}
=======
     declaration_seq_opt           { $$ = makeTreeNode(5, "translation_unit1", 1, $1); savedTree = $$;}
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Expressions.
 *----------------------------------------------------------------------*/
   
primary_expression:
<<<<<<< HEAD
     literal           { $$ = $1; }
   | THIS           { $$ = leaf($1, THIS); }
   | LPAREN expression RPAREN           { $$ = makeTreeNode(PRIMARY_EXPRESSION, "primary_expression1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   | id_expression           { $$ = $1; }
=======
     literal           { $$ = $1;; }
   | THIS           { $$ = $1; }
   | '(' expression ')'           { $$ = makeTreeNode(10, "primary_expression1", 3, $1, $2, $3); }
   | id_expression           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


id_expression:
     unqualified_id           { $$ = $1; }
   | qualified_id           { $$ = $1; }
   ;


unqualified_id:
     identifier          
   | operator_function_id          
   | conversion_function_id   
<<<<<<< HEAD
   | TILDE class_name           { $$ = makeTreeNode(UNQUALIFIED_ID, "unqualified_id1", 2, leaf($1, TILDE), $2); }
=======
   | '~' class_name           { $$ = makeTreeNode(15, "unqualified_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


qualified_id:
<<<<<<< HEAD
     nested_name_specifier unqualified_id           { $$ = makeTreeNode(QUALIFIED_ID, "qualified_id1", 2, $1, $2); }
=======
     nested_name_specifier unqualified_id           { $$ = makeTreeNode(20, "qualified_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


nested_name_specifier:
<<<<<<< HEAD
     class_name COLONCOLON nested_name_specifier namespace_name COLONCOLON nested_name_specifier           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier1", 6, $1, leaf($2, COLONCOLON), $3, $4, leaf($5, COLONCOLON), $6); }
   | class_name COLONCOLON           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier2", 2, $1, leaf($2, COLONCOLON)); }
   | namespace_name COLONCOLON           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier3", 2, $1, leaf($2, COLONCOLON)); }
=======
     class_name COLONCOLON nested_name_specifier namespace_name COLONCOLON nested_name_specifier           { $$ = makeTreeNode(25, "nested_name_specifier1", 6, $1, $2, $3, $4, $5, $6); }
   | class_name COLONCOLON           { $$ = makeTreeNode(25, "nested_name_specifier2", 2, $1, $2); }
   | namespace_name COLONCOLON           { $$ = makeTreeNode(25, "nested_name_specifier3", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


postfix_expression:
     primary_expression          
<<<<<<< HEAD
   | postfix_expression LBRAK expression RBRAK           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression1", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   | postfix_expression LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression2", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | DOUBLE LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression3", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | INT LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression4", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | CHAR LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression5", 4, leaf($1, CHAR), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | BOOL LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression6", 4, leaf($1, BOOL), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | postfix_expression DOT COLONCOLON id_expression           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression7", 4, $1, leaf($2, DOT), leaf($3, COLONCOLON), $4); }
   | postfix_expression DOT id_expression           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression8", 3, $1, leaf($2, DOT), $3); }
   | postfix_expression ARROW COLONCOLON id_expression           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression9", 4, $1, leaf($2, ARROW), leaf($3, COLONCOLON), $4); }
   | postfix_expression ARROW id_expression           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression10", 3, $1, leaf($2, ARROW), $3); }
   | postfix_expression PLUSPLUS           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression11", 2, $1, leaf($2, PLUSPLUS)); }
   | postfix_expression MINUSMINUS           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression12", 2, $1, leaf($2, MINUSMINUS)); }
   | DYNAMIC_CAST LT type_id GT LPAREN expression RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression13", 7, leaf($1, DYNAMIC_CAST), leaf($2, LT), $3, leaf($4, GT), leaf($5, LPAREN), $6, leaf($7, RPAREN)); }
   | STATIC_CAST LT type_id GT LPAREN expression RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression14", 7, leaf($1, STATIC_CAST), leaf($2, LT), $3, leaf($4, GT), leaf($5, LPAREN), $6, leaf($7, RPAREN)); }
   | REINTERPRET_CAST LT type_id GT LPAREN expression RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression15", 7, leaf($1, REINTERPRET_CAST), leaf($2, LT), $3, leaf($4, GT), leaf($5, LPAREN), $6, leaf($7, RPAREN)); }
   | CONST_CAST LT type_id GT LPAREN expression RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression16", 7, leaf($1, CONST_CAST), leaf($2, LT), $3, leaf($4, GT), leaf($5, LPAREN), $6, leaf($7, RPAREN)); }
   | TYPEID LPAREN expression RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression17", 4, leaf($1, TYPEID), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | TYPEID LPAREN type_id RPAREN           { $$ = makeTreeNode(POSTFIX_EXPRESSION, "postfix_expression18", 4, leaf($1, TYPEID), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
=======
   | postfix_expression '[' expression ']'           { $$ = makeTreeNode(30, "postfix_expression1", 4, $1, $2, $3, $4); }
   | postfix_expression '(' expression_list_opt ')'           { $$ = makeTreeNode(30, "postfix_expression2", 4, $1, $2, $3, $4); }
   | DOUBLE '(' expression_list_opt ')'           { $$ = makeTreeNode(30, "postfix_expression3", 4, $1, $2, $3, $4); }
   | INT '(' expression_list_opt ')'           { $$ = makeTreeNode(30, "postfix_expression4", 4, $1, $2, $3, $4); }
   | CHAR '(' expression_list_opt ')'           { $$ = makeTreeNode(30, "postfix_expression5", 4, $1, $2, $3, $4); }
   | BOOL '(' expression_list_opt ')'           { $$ = makeTreeNode(30, "postfix_expression6", 4, $1, $2, $3, $4); }
   | postfix_expression '.' COLONCOLON id_expression           { $$ = makeTreeNode(30, "postfix_expression7", 4, $1, $2, $3, $4); }
   | postfix_expression '.' id_expression           { $$ = makeTreeNode(30, "postfix_expression8", 3, $1, $2, $3); }
   | postfix_expression ARROW COLONCOLON id_expression           { $$ = makeTreeNode(30, "postfix_expression9", 4, $1, $2, $3, $4); }
   | postfix_expression ARROW id_expression           { $$ = makeTreeNode(30, "postfix_expression10", 3, $1, $2, $3); }
   | postfix_expression PLUSPLUS           { $$ = makeTreeNode(30, "postfix_expression11", 2, $1, $2); }
   | postfix_expression MINUSMINUS           { $$ = makeTreeNode(30, "postfix_expression12", 2, $1, $2); }
   | DYNAMIC_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(30, "postfix_expression13", 7, $1, $2, $3, $4, $5, $6, $7); }
   | STATIC_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(30, "postfix_expression14", 7, $1, $2, $3, $4, $5, $6, $7); }
   | REINTERPRET_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(30, "postfix_expression15", 7, $1, $2, $3, $4, $5, $6, $7); }
   | CONST_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(30, "postfix_expression16", 7, $1, $2, $3, $4, $5, $6, $7); }
   | TYPEID '(' expression ')'           { $$ = makeTreeNode(30, "postfix_expression17", 4, $1, $2, $3, $4); }
   | TYPEID '(' type_id ')'           { $$ = makeTreeNode(30, "postfix_expression18", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


expression_list:
     assignment_expression          
<<<<<<< HEAD
   | expression_list COMMA assignment_expression           { $$ = makeTreeNode(EXPRESSION_LIST, "expression_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | expression_list ',' assignment_expression           { $$ = makeTreeNode(35, "expression_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


unary_expression:
     postfix_expression          
<<<<<<< HEAD
   | PLUSPLUS cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression1", 2, leaf($1, PLUSPLUS), $2); }
   | MINUSMINUS cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression2", 2, leaf($1, MINUSMINUS), $2); }
   | MUL cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression3", 2, leaf($1, MUL), $2); }
   | AND cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression4", 2, leaf($1, AND), $2); }
   | unary_operator cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression5", 2, $1, $2); }
   | SIZEOF unary_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression6", 2, leaf($1, SIZEOF), $2); }
   | SIZEOF LPAREN type_id RPAREN           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression7", 4, leaf($1, SIZEOF), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
=======
   | PLUSPLUS cast_expression           { $$ = makeTreeNode(40, "unary_expression1", 2, $1, $2); }
   | MINUSMINUS cast_expression           { $$ = makeTreeNode(40, "unary_expression2", 2, $1, $2); }
   | '*' cast_expression           { $$ = makeTreeNode(40, "unary_expression3", 2, $1, $2); }
   | '&' cast_expression           { $$ = makeTreeNode(40, "unary_expression4", 2, $1, $2); }
   | unary_operator cast_expression           { $$ = makeTreeNode(40, "unary_expression5", 2, $1, $2); }
   | SIZEOF unary_expression           { $$ = makeTreeNode(40, "unary_expression6", 2, $1, $2); }
   | SIZEOF '(' type_id ')'           { $$ = makeTreeNode(40, "unary_expression7", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | new_expression          
   | delete_expression          
   ;


unary_operator:
<<<<<<< HEAD
     PLUS { $$ = leaf($1, PLUS); }      
   | DASH   { $$ = leaf($1, DASH); }         
   | EXPOINT  { $$ = leaf($1, EXPOINT); }           
   | TILDE    { $$ = leaf($1, TILDE); }         
=======
     '+'          
   | '-'          
   | '!'           
   | '~'           
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_expression:
<<<<<<< HEAD
     NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression1", 4, leaf($1, NEW), $2, $3, $4); }
   | COLONCOLON NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression2", 5, leaf($1, COLONCOLON), leaf($2, NEW), $3, $4, $5); }
   | NEW new_placement_opt LPAREN type_id RPAREN new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression3", 6, leaf($1, NEW), $2, leaf($3, LPAREN), $4, leaf($5, RPAREN), $6); }
   | COLONCOLON NEW new_placement_opt LPAREN type_id RPAREN new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression4", 7, leaf($1, COLONCOLON), leaf($2, NEW), $3, leaf($4, LPAREN), $5, leaf($6, RPAREN), $7); }
=======
     NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(45, "new_expression1", 4, $1, $2, $3, $4); }
   | COLONCOLON NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(45, "new_expression2", 5, $1, $2, $3, $4, $5); }
   | NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(45, "new_expression3", 6, $1, $2, $3, $4, $5, $6); }
   | COLONCOLON NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(45, "new_expression4", 7, $1, $2, $3, $4, $5, $6, $7); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_placement:
<<<<<<< HEAD
     LPAREN expression_list RPAREN           { $$ = makeTreeNode(NEW_PLACEMENT, "new_placement1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
=======
     '(' expression_list ')'           { $$ = makeTreeNode(50, "new_placement1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_type_id:
<<<<<<< HEAD
     type_specifier_seq new_declarator_opt           { $$ = makeTreeNode(NEW_TYPE_ID, "new_type_id1", 2, $1, $2); }
=======
     type_specifier_seq new_declarator_opt           { $$ = makeTreeNode(55, "new_type_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_declarator:
<<<<<<< HEAD
     ptr_operator new_declarator_opt           { $$ = makeTreeNode(NEW_DECLARATOR, "new_declarator1", 2, $1, $2); }
=======
     ptr_operator new_declarator_opt           { $$ = makeTreeNode(60, "new_declarator1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | direct_new_declarator           { $$ = $1; }
   ;


direct_new_declarator:
<<<<<<< HEAD
     LBRAK expression RBRAK           { $$ = makeTreeNode(DIRECT_NEW_DECLARATOR, "direct_new_declarator1", 3, leaf($1, LBRAK), $2, leaf($3, RBRAK)); }
   | direct_new_declarator LBRAK constant_expression RBRAK           { $$ = makeTreeNode(DIRECT_NEW_DECLARATOR, "direct_new_declarator2", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
=======
     '[' expression ']'           { $$ = makeTreeNode(65, "direct_new_declarator1", 3, $1, $2, $3); }
   | direct_new_declarator '[' constant_expression ']'           { $$ = makeTreeNode(65, "direct_new_declarator2", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_initializer:
<<<<<<< HEAD
     LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(NEW_INITIALIZER, "new_initializer1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
=======
     '(' expression_list_opt ')'           { $$ = makeTreeNode(70, "new_initializer1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


delete_expression:
<<<<<<< HEAD
     DELETE cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression1", 2, leaf($1, DELETE), $2); }
   | COLONCOLON DELETE cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression2", 3, leaf($1, COLONCOLON), leaf($2, DELETE), $3); }
   | DELETE LBRAK RBRAK cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression3", 4, leaf($1, DELETE), leaf($2, LBRAK), leaf($3, RBRAK), $4); }
   | COLONCOLON DELETE LBRAK RBRAK cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression4", 5, leaf($1, COLONCOLON), leaf($2, DELETE), leaf($3, LBRAK), leaf($4, RBRAK), $5); }
=======
     DELETE cast_expression           { $$ = makeTreeNode(75, "delete_expression1", 2, $1, $2); }
   | COLONCOLON DELETE cast_expression           { $$ = makeTreeNode(75, "delete_expression2", 3, $1, $2, $3); }
   | DELETE '[' ']' cast_expression           { $$ = makeTreeNode(75, "delete_expression3", 4, $1, $2, $3, $4); }
   | COLONCOLON DELETE '[' ']' cast_expression           { $$ = makeTreeNode(75, "delete_expression4", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


cast_expression:
<<<<<<< HEAD
     unary_expression           { $$ = makeTreeNode(CAST_EXPRESSION, "cast_expression1", 1, $1); }
   | LPAREN type_id RPAREN cast_expression           { $$ = makeTreeNode(CAST_EXPRESSION, "cast_expression2", 4, leaf($1, LPAREN), $2, leaf($3, RPAREN), $4); }
=======
     unary_expression           { $$ = makeTreeNode(80, "cast_expression1", 1, $1); }
   | '(' type_id ')' cast_expression           { $$ = makeTreeNode(80, "cast_expression2", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


pm_expression:
     cast_expression           { $$ = $1; }
<<<<<<< HEAD
   | pm_expression DOTSTAR cast_expression           { $$ = makeTreeNode(PM_EXPRESSION, "pm_expression1", 3, $1, leaf($2, DOTSTAR), $3); }
   | pm_expression ARROWSTAR cast_expression           { $$ = makeTreeNode(PM_EXPRESSION, "pm_expression2", 3, $1, leaf($2, ARROWSTAR), $3); }
=======
   | pm_expression DOTSTAR cast_expression           { $$ = makeTreeNode(85, "pm_expression1", 3, $1, $2, $3); }
   | pm_expression ARROWSTAR cast_expression           { $$ = makeTreeNode(85, "pm_expression2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


multiplicative_expression:
     pm_expression           { $$ = $1; }
<<<<<<< HEAD
   | multiplicative_expression MUL pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression1", 3, $1, leaf($2, MUL), $3); }
   | multiplicative_expression DIV pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression2", 3, $1, leaf($2, DIV), $3); }
   | multiplicative_expression MOD pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression3", 3, $1, leaf($2, MOD), $3); }
=======
   | multiplicative_expression '*' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression1", 3, $1, $2, $3); }
   | multiplicative_expression '/' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression2", 3, $1, $2, $3); }
   | multiplicative_expression '%' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression3", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


additive_expression:
     multiplicative_expression           { $$ = $1; }
<<<<<<< HEAD
   | additive_expression PLUS multiplicative_expression           { $$ = makeTreeNode(ADDITIVE_EXPRESSION, "additive_expression1", 3, $1, leaf($2, PLUS), $3); }
   | additive_expression DASH multiplicative_expression           { $$ = makeTreeNode(ADDITIVE_EXPRESSION, "additive_expression2", 3, $1, leaf($2, DASH), $3); }
=======
   | additive_expression '+' multiplicative_expression           { $$ = makeTreeNode(100, "additive_expression1", 3, $1, $2, $3); }
   | additive_expression '-' multiplicative_expression           { $$ = makeTreeNode(100, "additive_expression2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


shift_expression:
     additive_expression           { $$ = $1; }
<<<<<<< HEAD
   | shift_expression SL additive_expression           { $$ = makeTreeNode(SHIFT_EXPRESSION, "shift_expression1", 3, $1, leaf($2, SL), $3); }
   | shift_expression SR additive_expression           { $$ = makeTreeNode(SHIFT_EXPRESSION, "shift_expression2", 3, $1, leaf($2, SR), $3); }
=======
   | shift_expression SL additive_expression           { $$ = makeTreeNode(105, "shift_expression1", 3, $1, $2, $3); }
   | shift_expression SR additive_expression           { $$ = makeTreeNode(105, "shift_expression2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


relational_expression:
     shift_expression           { $$ = $1; }
<<<<<<< HEAD
   | relational_expression LT shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression1", 3, $1, leaf($2, LT), $3); }
   | relational_expression GT shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression2", 3, $1, leaf($2, GT), $3); }
   | relational_expression LTEQ shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression3", 3, $1, leaf($2, LTEQ), $3); }
   | relational_expression GTEQ shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression4", 3, $1, leaf($2, GTEQ), $3); }
=======
   | relational_expression '<' shift_expression           { $$ = makeTreeNode(110, "relational_expression1", 3, $1, $2, $3); }
   | relational_expression '>' shift_expression           { $$ = makeTreeNode(110, "relational_expression2", 3, $1, $2, $3); }
   | relational_expression LTEQ shift_expression           { $$ = makeTreeNode(110, "relational_expression3", 3, $1, $2, $3); }
   | relational_expression GTEQ shift_expression           { $$ = makeTreeNode(110, "relational_expression4", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


equality_expression:
     relational_expression           { $$ = $1; }
<<<<<<< HEAD
   | equality_expression EQEQ relational_expression           { $$ = makeTreeNode(EQUALITY_EXPRESSION, "equality_expression1", 3, $1, leaf($2, EQEQ), $3); }
   | equality_expression NOTEQ relational_expression           { $$ = makeTreeNode(EQUALITY_EXPRESSION, "equality_expression2", 3, $1, leaf($2, NOTEQ), $3); }
=======
   | equality_expression EQ relational_expression           { $$ = makeTreeNode(115, "equality_expression1", 3, $1, $2, $3); }
   | equality_expression NOTEQ relational_expression           { $$ = makeTreeNode(115, "equality_expression2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


and_expression:
     equality_expression           { $$ = $1;}
<<<<<<< HEAD
   | and_expression AND equality_expression           { $$ = makeTreeNode(AND_EXPRESSION, "and_expression1", 3, $1, leaf($2, AND), $3); }
=======
   | and_expression '&' equality_expression           { $$ = makeTreeNode(120, "and_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


exclusive_or_expression:
     and_expression           { $$ = $1;}
<<<<<<< HEAD
   | exclusive_or_expression KARAT and_expression           { $$ = makeTreeNode(EXCLUSIVE_OR_EXPRESSION, "exclusive_or_expression1", 3, $1, leaf($2, KARAT), $3); }
=======
   | exclusive_or_expression '^' and_expression           { $$ = makeTreeNode(125, "exclusive_or_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


inclusive_or_expression:
     exclusive_or_expression           { $$ = $1;}
<<<<<<< HEAD
   | inclusive_or_expression OR exclusive_or_expression           { $$ = makeTreeNode(INCLUSIVE_OR_EXPRESSION, "inclusive_or_expression1", 3, $1, leaf($2, OR), $3); }
=======
   | inclusive_or_expression '|' exclusive_or_expression           { $$ = makeTreeNode(130, "inclusive_or_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


logical_and_expression:
     inclusive_or_expression           { $$ = $1;}
<<<<<<< HEAD
   | logical_and_expression ANDAND inclusive_or_expression           { $$ = makeTreeNode(LOGICAL_AND_EXPRESSION, "logical_and_expression1", 3, $1, leaf($2, ANDAND), $3); }
=======
   | logical_and_expression ANDAND inclusive_or_expression           { $$ = makeTreeNode(135, "logical_and_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


logical_or_expression:
     logical_and_expression           { $$ = $1;}
<<<<<<< HEAD
   | logical_or_expression OROR logical_and_expression           { $$ = makeTreeNode(LOGICAL_OR_EXPRESSION, "logical_or_expression1", 3, $1, leaf($2, OROR), $3); }
=======
   | logical_or_expression OROR logical_and_expression           { $$ = makeTreeNode(140, "logical_or_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


conditional_expression:
     logical_or_expression           { $$ = $1;}
<<<<<<< HEAD
   | logical_or_expression QUEST expression COLON assignment_expression           { $$ = makeTreeNode(CONDITIONAL_EXPRESSION, "conditional_expression1", 5, $1, leaf($2, QUEST), $3, leaf($4, COLON), $5); }
=======
   | logical_or_expression '?' expression ':' assignment_expression           { $$ = makeTreeNode(145, "conditional_expression1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


assignment_expression:
     conditional_expression           { $$ = $1;}
<<<<<<< HEAD
   | logical_or_expression assignment_operator assignment_expression           { $$ = makeTreeNode(ASSIGNMENT_EXPRESSION, "assignment_expression1", 3, $1, $2, $3); }
=======
   | logical_or_expression assignment_operator assignment_expression           { $$ = makeTreeNode(150, "assignment_expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | throw_expression           { $$ = $1;}
   ;


assignment_operator:
<<<<<<< HEAD
     EQ           { $$ = leaf($1, EQ); }
   | MULEQ           { $$ = leaf($1, MULEQ); }
   | DIVEQ           { $$ = leaf($1, DIVEQ); }
   | MODEQ           { $$ = leaf($1, MODEQ); }
   | ADDEQ           { $$ = leaf($1, ADDEQ); }
   | SUBEQ           { $$ = leaf($1, SUBEQ); }
   | SREQ           { $$ = leaf($1, SREQ); }
   | SLEQ           { $$ = leaf($1, SLEQ); }
   | ANDEQ           { $$ = leaf($1, ANDEQ); }
   | XOREQ           { $$ = leaf($1, XOREQ); }
   | OREQ           { $$ = leaf($1, OREQ); }
=======
     '='           { $$ = $1;; }
   | MULEQ           { $$ = $1;; }
   | DIVEQ           { $$ = $1;; }
   | MODEQ           { $$ = $1;; }
   | ADDEQ           { $$ = $1;; }
   | SUBEQ           { $$ = $1;; }
   | SREQ           { $$ = $1;; }
   | SLEQ           { $$ = $1;; }
   | ANDEQ           { $$ = $1;; }
   | XOREQ           { $$ = $1;; }
   | OREQ           { $$ = $1;; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


expression:
     assignment_expression           { $$ = $1;}
<<<<<<< HEAD
   | expression COMMA assignment_expression           { $$ = makeTreeNode(EXPRESSION, "expression1", 3, $1, leaf($2, COMMA), $3); }
=======
   | expression ',' assignment_expression           { $$ = makeTreeNode(155, "expression1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Statements.
 *----------------------------------------------------------------------*/
   
constant_expression:
     conditional_expression           { $$ = $1;}
   ;


statement:
     labeled_statement           { $$ = $1; }
   | expression_statement           { $$ = $1; }
   | compound_statement           { $$ = $1; }
   | selection_statement           { $$ = $1; }
   | iteration_statement           { $$ = $1; }
   | jump_statement           { $$ = $1; }
   | declaration_statement           { $$ = $1; }
   | try_block           { $$ = $1; }
   ;


labeled_statement:
<<<<<<< HEAD
     identifier COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement1", 3, $1, leaf($2, COLON), $3); }
   | CASE constant_expression COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement2", 4, leaf($1, CASE), $2, leaf($3, COLON), $4); }
   | DEFAULT COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement3", 3, leaf($1, DEFAULT), leaf($2, COLON), $3); }
=======
     identifier ':' statement           { $$ = makeTreeNode(160, "labeled_statement1", 3, $1, $2, $3); }
   | CASE constant_expression ':' statement           { $$ = makeTreeNode(160, "labeled_statement2", 4, $1, $2, $3, $4); }
   | DEFAULT ':' statement           { $$ = makeTreeNode(160, "labeled_statement3", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


expression_statement:
<<<<<<< HEAD
     expression_opt SEMIC           { $$ = makeTreeNode(EXPRESSION_STATEMENT, "expression_statement1", 2, $1, leaf($2, SEMIC)); }
=======
     expression_opt ';'           { $$ = makeTreeNode(165, "expression_statement1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


compound_statement:
<<<<<<< HEAD
     LCURLY statement_seq_opt RCURLY           { $$ = makeTreeNode(COMPOUND_STATEMENT, "compound_statement1", 3, leaf($1, LCURLY), $2, leaf($3, RCURLY));  }
=======
     '{' statement_seq_opt '}'           { $$ = makeTreeNode(170, "compound_statement1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


statement_seq:
     statement           { $$ = $1;}
<<<<<<< HEAD
   | statement_seq statement           { $$ = makeTreeNode(STATEMENT_SEQ, "statement_seq1", 2, $1, $2); }
=======
   | statement_seq statement           { $$ = makeTreeNode(175, "statement_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


selection_statement:
<<<<<<< HEAD
     IF LPAREN condition RPAREN statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement1", 5, leaf($1, IF), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | IF LPAREN condition RPAREN statement ELSE statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement2", 7, leaf($1, IF), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, leaf($6, ELSE), $7); }
   | SWITCH LPAREN condition RPAREN statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement3", 5, leaf($1, SWITCH), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
=======
     IF '(' condition ')' statement           { $$ = makeTreeNode(180, "selection_statement1", 5, $1, $2, $3, $4, $5); }
   | IF '(' condition ')' statement ELSE statement           { $$ = makeTreeNode(180, "selection_statement2", 7, $1, $2, $3, $4, $5, $6, $7); }
   | SWITCH '(' condition ')' statement           { $$ = makeTreeNode(180, "selection_statement3", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


condition:
     expression           { $$ = $1;}
<<<<<<< HEAD
   | type_specifier_seq declarator EQ assignment_expression           { $$ = makeTreeNode(CONDITION, "condition1", 4, $1, $2, leaf($3, EQ), $4); }
=======
   | type_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(185, "condition1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


iteration_statement:
<<<<<<< HEAD
     WHILE LPAREN condition RPAREN statement           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement1", 5, leaf($1, WHILE), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | DO statement WHILE LPAREN expression RPAREN SEMIC           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement2", 7, leaf($1, DO), $2, leaf($3, WHILE), leaf($4, LPAREN), $5, leaf($6, RPAREN), leaf($7, SEMIC)); }
   | FOR LPAREN for_init_statement condition_opt SEMIC expression_opt RPAREN statement           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement3", 8, leaf($1, FOR), leaf($2, LPAREN), $3, $4, leaf($5, SEMIC), $6, leaf($7, RPAREN), $8); }
=======
     WHILE '(' condition ')' statement           { $$ = makeTreeNode(190, "iteration_statement1", 5, $1, $2, $3, $4, $5); }
   | DO statement WHILE '(' expression ')' ';'           { $$ = makeTreeNode(190, "iteration_statement2", 7, $1, $2, $3, $4, $5, $6, $7); }
   | FOR '(' for_init_statement condition_opt ';' expression_opt ')' statement           { $$ = makeTreeNode(190, "iteration_statement3", 8, $1, $2, $3, $4, $5, $6, $7, $8); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


for_init_statement:
     expression_statement           { $$ = $1;}
   | simple_declaration           { $$ = $1;}
   ;


jump_statement:
<<<<<<< HEAD
     BREAK SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement1", 2, leaf($1, BREAK), leaf($2, SEMIC)); }
   | CONTINUE SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement2", 2, leaf($1, CONTINUE), leaf($2, SEMIC)); }
   | RETURN expression_opt SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement3", 3, leaf($1, RETURN), $2, leaf($3, SEMIC)); }
=======
     BREAK ';'           { $$ = makeTreeNode(200, "jump_statement1", 2, $1, $2); }
   | CONTINUE ';'           { $$ = makeTreeNode(200, "jump_statement2", 2, $1, $2); }
   | RETURN expression_opt ';'           { $$ = makeTreeNode(200, "jump_statement3", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


declaration_statement:
     block_declaration           { $$ = $1;}
   ;

/*----------------------------------------------------------------------
 * Declarations.
 *----------------------------------------------------------------------*/
   
declaration_seq:
     declaration           { $$ = $1;}
<<<<<<< HEAD
   | declaration_seq declaration           { $$ = makeTreeNode(DECLARATION_SEQ, "declaration_seq1", 2, $1, $2); }
=======
   | declaration_seq declaration           { $$ = makeTreeNode(205, "declaration_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


declaration:
     block_declaration           { $$ = $1;}
   | function_definition           { $$ = $1;}
   | linkage_specification           { $$ = $1;}
   | namespace_definition           { $$ = $1;}
   ;


block_declaration:
     simple_declaration           { $$ = $1; }
   | asm_definition           { $$ = $1; }
   | namespace_alias_definition           { $$ = $1; }
   | using_declaration           { $$ = $1; }
   | using_directive           { $$ = $1; }
   ;


simple_declaration:
<<<<<<< HEAD
     decl_specifier_seq init_declarator_list SEMIC           { $$ = makeTreeNode(SIMPLE_DECLARATION, "simple_declaration1", 3, $1, $2, leaf($3, SEMIC)); }
   | decl_specifier_seq SEMIC           { $$ = makeTreeNode(SIMPLE_DECLARATION, "simple_declaration2", 2, $1, leaf($2, SEMIC)); }
=======
     decl_specifier_seq init_declarator_list ';'           { $$ = makeTreeNode(210, "simple_declaration1", 3, $1, $2, $3); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(215, "simple_declaration2", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


decl_specifier:
     storage_class_specifier           { $$ = $1;}
   | type_specifier           { $$ = $1;}
   | function_specifier           { $$ = $1;}
<<<<<<< HEAD
   | FRIEND           { $$ = leaf($1, FRIEND);}
   | TYPEDEF           { $$ = leaf($1, TYPEDEF);}
=======
   | FRIEND           { $$ = $1;}
   | TYPEDEF           { $$ = $1;}
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


decl_specifier_seq:
     decl_specifier           { $$ = $1;}
<<<<<<< HEAD
   | decl_specifier_seq decl_specifier           { $$ = makeTreeNode(DECL_SPECIFIER_SEQ, "decl_specifier_seq1", 2, $1, $2); }
=======
   | decl_specifier_seq decl_specifier           { $$ = makeTreeNode(220, "decl_specifier_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


storage_class_specifier:
<<<<<<< HEAD
     AUTO           { $$ = leaf($1, AUTO);}
   | REGISTER           { $$ = leaf($1, REGISTER); }
   | STATIC           { $$ = leaf($1, STATIC); }
   | EXTERN           { $$ = leaf($1, EXTERN); }
   | MUTABLE           { $$ = leaf($1, MUTABLE); }
=======
     AUTO           { $$ = $1;}
   | REGISTER           { $$ = $1; }
   | STATIC           { $$ = $1; }
   | EXTERN           { $$ = $1; }
   | MUTABLE           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


function_specifier:
<<<<<<< HEAD
     INLINE           { $$ = leaf($1, INLINE); }
   | VIRTUAL           { $$ = leaf($1, VIRTUAL); }
   | EXPLICIT           { $$ = leaf($1, EXPLICIT); }
=======
     INLINE           { $$ = $1; }
   | VIRTUAL           { $$ = $1; }
   | EXPLICIT           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


type_specifier:
     simple_type_specifier           { $$ = $1; }
   | class_specifier           { $$ = $1; }
   | enum_specifier           { $$ = $1; }
   | elaborated_type_specifier           { $$ = $1; }
   | cv_qualifier           { $$ = $1;}
   ;


simple_type_specifier:
     type_name           { $$ = $1; }
<<<<<<< HEAD
   | nested_name_specifier type_name           { $$ = makeTreeNode(SIMPLE_TYPE_SPECIFIER, "simple_type_specifier1", 2, $1, $2); }
   | COLONCOLON nested_name_specifier_opt type_name           { $$ = makeTreeNode(SIMPLE_TYPE_SPECIFIER, "simple_type_specifier2", 3, leaf($1, COLONCOLON), $2, $3); }
   | CHAR           { $$ = leaf($1, CHAR); }
   | WCHAR_T        { $$ = leaf($1, WCHAR_T); }
   | BOOL           { $$ = leaf($1, BOOL); }
   | SHORT          { $$ = leaf($1, SHORT); }
   | INT            { $$ = leaf($1, INT); }
   | LONG           { $$ = leaf($1, LONG); }
   | SIGNED         { $$ = leaf($1, SIGNED); }
   | UNSIGNED       { $$ = leaf($1, UNSIGNED); }
   | FLOAT          { $$ = leaf($1, FLOAT); }
   | DOUBLE         { $$ = leaf($1, DOUBLE); }
   | VOID           { $$ = leaf($1, VOID); }
=======
   | nested_name_specifier type_name           { $$ = makeTreeNode(225, "simple_type_specifier1", 2, $1, $2); }
   | COLONCOLON nested_name_specifier_opt type_name           { $$ = makeTreeNode(225, "simple_type_specifier2", 3, $1, $2, $3); }
   | CHAR           { $$ = $1; }
   | WCHAR_T           { $$ = $1; }
   | BOOL           { $$ = $1; }
   | SHORT           { $$ = $1; }
   | INT           { $$ = $1; }
   | LONG           { $$ = $1; }
   | SIGNED           { $$ = $1; }
   | UNSIGNED           { $$ = $1; }
   | FLOAT           { $$ = $1; }
   | DOUBLE           { $$ = $1; }
   | VOID           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


type_name:
     class_name           { $$ = $1; }
   | enum_name           { $$ = $1; }
   | typedef_name           { $$ = $1; }
   ;


elaborated_type_specifier:
<<<<<<< HEAD
     class_key COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier1", 4, $1, leaf($2, COLONCOLON), $3, $4); }
   | class_key COLONCOLON identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier2", 3, $1, leaf($2, COLONCOLON), $3); }
   | ENUM COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier3", 4, leaf($1, ENUM), leaf($2, COLONCOLON), $3, $4); }
   | ENUM COLONCOLON identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier4", 3, leaf($1, ENUM), leaf($2, COLONCOLON), $3); }
   | ENUM nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier5", 3, leaf($1, ENUM), $2, $3); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier6", 4, leaf($1, TYPENAME), $2, $3, $4); }
=======
     class_key COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier1", 4, $1, $2, $3, $4); }
   | class_key COLONCOLON identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier2", 3, $1, $2, $3); }
   | ENUM COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier3", 4, $1, $2, $3, $4); }
   | ENUM COLONCOLON identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier4", 3, $1, $2, $3); }
   | ENUM nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier5", 3, $1, $2, $3); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier6", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


enum_specifier:
<<<<<<< HEAD
     ENUM identifier LCURLY enumerator_list_opt RCURLY           { $$ = makeTreeNode(ENUM_SPECIFIER, "enum_specifier1", 5, leaf($1, ENUM), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
=======
     ENUM identifier '{' enumerator_list_opt '}'           { $$ = makeTreeNode(235, "enum_specifier1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


enumerator_list:
     enumerator_definition           { $$ = $1;}
<<<<<<< HEAD
   | enumerator_list COMMA enumerator_definition           { $$ = makeTreeNode(ENUMERATOR_LIST, "enumerator_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | enumerator_list ',' enumerator_definition           { $$ = makeTreeNode(240, "enumerator_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


enumerator_definition:
     enumerator           { $$ = $1; }
<<<<<<< HEAD
   | enumerator EQ constant_expression           { $$ = makeTreeNode(ENUMERATOR_DEFINITION, "enumerator_definition1", 3, $1, leaf($2, EQ), $3); }
=======
   | enumerator '=' constant_expression           { $$ = makeTreeNode(245, "enumerator_definition1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


enumerator:
     identifier           { $$ = $1;}
   ;


namespace_definition:
     named_namespace_definition           { $$ = $1;}
   | unnamed_namespace_definition           { $$ = $1;}
   ;


named_namespace_definition:
     original_namespace_definition           { $$ = $1;}
   | extension_namespace_definition           { $$ = $1; }
   ;


original_namespace_definition:
<<<<<<< HEAD
     NAMESPACE identifier LCURLY namespace_body RCURLY           { $$ = makeTreeNode(ORIGINAL_NAMESPACE_DEFINITION, "original_namespace_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
=======
     NAMESPACE identifier '{' namespace_body '}'           { $$ = makeTreeNode(250, "original_namespace_definition1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


extension_namespace_definition:
<<<<<<< HEAD
     NAMESPACE original_namespace_name LCURLY namespace_body RCURLY           { $$ = makeTreeNode(EXTENSION_NAMESPACE_DEFINITION, "extension_namespace_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
=======
     NAMESPACE original_namespace_name '{' namespace_body '}'           { $$ = makeTreeNode(255, "extension_namespace_definition1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


unnamed_namespace_definition:
<<<<<<< HEAD
     NAMESPACE LCURLY namespace_body RCURLY           { $$ = makeTreeNode(UNNAMED_NAMESPACE_DEFINITION, "unnamed_namespace_definition1", 4, leaf($1, NAMESPACE), leaf($2, LCURLY), $3, leaf($4, RCURLY)); }
=======
     NAMESPACE '{' namespace_body '}'           { $$ = makeTreeNode(260, "unnamed_namespace_definition1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


namespace_body:
     declaration_seq_opt           { $$ = $1;}
   ;


namespace_alias_definition:
<<<<<<< HEAD
     NAMESPACE identifier EQ qualified_namespace_specifier SEMIC           { $$ = makeTreeNode(NAMESPACE_ALIAS_DEFINITION, "namespace_alias_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, EQ), $4, leaf($5, SEMIC)); }
=======
     NAMESPACE identifier '=' qualified_namespace_specifier ';'           { $$ = makeTreeNode(265, "namespace_alias_definition1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


qualified_namespace_specifier:
<<<<<<< HEAD
     COLONCOLON nested_name_specifier namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier1", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier2", 2, leaf($1, COLONCOLON), $2); }
   | nested_name_specifier namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier3", 2, $1, $2); }
=======
     COLONCOLON nested_name_specifier namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier1", 3, $1, $2, $3); }
   | COLONCOLON namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier2", 2, $1, $2); }
   | nested_name_specifier namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier3", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | namespace_name           { $$ = $1; }
   ;


using_declaration:
<<<<<<< HEAD
     USING TYPENAME COLONCOLON nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration1", 6, leaf($1, USING), leaf($2, TYPENAME), leaf($3, COLONCOLON), $4, $5, leaf($6, SEMIC)); }
   | USING TYPENAME nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration2", 5, leaf($1, USING), leaf($2, TYPENAME), $3, $4, leaf($5, SEMIC)); }
   | USING COLONCOLON nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration3", 5, leaf($1, USING), leaf($2, COLONCOLON), $3, $4, leaf($5, SEMIC)); }
   | USING nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration4", 4, leaf($1, USING), $2, $3, leaf($4, SEMIC)); }
   | USING COLONCOLON unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration5", 4, leaf($1, USING), $2, $3, leaf($4, SEMIC)); }
=======
     USING TYPENAME COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration1", 6, $1, $2, $3, $4, $5, $6); }
   | USING TYPENAME nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration2", 5, $1, $2, $3, $4, $5); }
   | USING COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration3", 5, $1, $2, $3, $4, $5); }
   | USING nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration4", 4, $1, $2, $3, $4); }
   | USING COLONCOLON unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration5", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


using_directive:
<<<<<<< HEAD
     USING NAMESPACE COLONCOLON nested_name_specifier namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive1", 6, leaf($1, USING), leaf($2, NAMESPACE), leaf($3, COLONCOLON), $4, $5, leaf($6, SEMIC)); }
   | USING NAMESPACE COLONCOLON namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive2", 5, leaf($1, USING), leaf($2, NAMESPACE), leaf($3, COLONCOLON), $4, leaf($5, SEMIC)); }
   | USING NAMESPACE nested_name_specifier namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive3", 5, leaf($1, USING), leaf($2, NAMESPACE), $3, $4, leaf($5, SEMIC)); }
   | USING NAMESPACE namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive4", 4, leaf($1, USING), leaf($2, NAMESPACE), $3, leaf($4, SEMIC)); }
=======
     USING NAMESPACE COLONCOLON nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(280, "using_directive1", 6, $1, $2, $3, $4, $5, $6); }
   | USING NAMESPACE COLONCOLON namespace_name ';'           { $$ = makeTreeNode(280, "using_directive2", 5, $1, $2, $3, $4, $5); }
   | USING NAMESPACE nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(280, "using_directive3", 5, $1, $2, $3, $4, $5); }
   | USING NAMESPACE namespace_name ';'           { $$ = makeTreeNode(280, "using_directive4", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


asm_definition:
<<<<<<< HEAD
     ASM LPAREN string_literal RPAREN SEMIC           { $$ = makeTreeNode(ASM_DEFINITION, "asm_definition1", 5, leaf($1, ASM), leaf($2, LPAREN), $3, leaf($4, RPAREN), leaf($5, SEMIC)); }
=======
     ASM '(' string_literal ')' ';'           { $$ = makeTreeNode(285, "asm_definition1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


linkage_specification:
<<<<<<< HEAD
     EXTERN string_literal LCURLY declaration_seq_opt RCURLY           { $$ = makeTreeNode(LINKAGE_SPECIFICATION, "linkage_specification1", 5, leaf($1, EXTERN), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
   | EXTERN string_literal declaration           { $$ = makeTreeNode(LINKAGE_SPECIFICATION, "linkage_specification2", 3, leaf($1, EXTERN), $2, $3); }
=======
     EXTERN string_literal '{' declaration_seq_opt '}'           { $$ = makeTreeNode(290, "linkage_specification1", 5, $1, $2, $3, $4, $5); }
   | EXTERN string_literal declaration           { $$ = makeTreeNode(290, "linkage_specification2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Declarators.
 *----------------------------------------------------------------------*/
   
init_declarator_list:
     init_declarator           { $$ = $1;}
<<<<<<< HEAD
   | init_declarator_list COMMA init_declarator           { $$ = makeTreeNode(INIT_DECLARATOR_LIST, "init_declarator_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | init_declarator_list ',' init_declarator           { $$ = makeTreeNode(295, "init_declarator_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


init_declarator:
<<<<<<< HEAD
     declarator initializer_opt           { $$ = makeTreeNode(INIT_DECLARATOR, "init_declarator1", 2, $1, $2); }
=======
     declarator initializer_opt           { $$ = makeTreeNode(300, "init_declarator1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


declarator:
     direct_declarator           { $$ = $1;}
<<<<<<< HEAD
   | ptr_operator declarator           { $$ = makeTreeNode(DECLARATOR, "declarator1", 2, $1, $2); }
=======
   | ptr_operator declarator           { $$ = makeTreeNode(305, "declarator1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


direct_declarator:
     declarator_id           { $$ = $1; }
<<<<<<< HEAD
   | direct_declarator LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq exception_specification           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator1", 6, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, $6); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator2", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN exception_specification           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator3", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator4", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | CLASS_NAME LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator5", 4, leaf($1, CLASS_NAME), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | CLASS_NAME COLONCOLON declarator_id LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator6", 6, leaf($1, CLASS_NAME), leaf($2, COLONCOLON), $3, leaf($4, LPAREN), $5, leaf($6, RPAREN)); }
   | CLASS_NAME COLONCOLON CLASS_NAME LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator7", 6, leaf($1, CLASS_NAME), leaf($2, COLONCOLON), leaf($3, CLASS_NAME), leaf($4, LPAREN), $5, leaf($6, RPAREN)); }
   | direct_declarator LBRAK constant_expression_opt RBRAK           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator8", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   | LPAREN declarator RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator9", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
=======
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(310, "direct_declarator1", 6, $1, $2, $3, $4, $5, $6); }
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(310, "direct_declarator2", 5, $1, $2, $3, $4, $5); }
   | direct_declarator '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(310, "direct_declarator3", 5, $1, $2, $3, $4, $5); }
   | direct_declarator '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator4", 4, $1, $2, $3, $4); }
   | CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator5", 4, $1, $2, $3, $4); }
   | CLASS_NAME COLONCOLON declarator_id '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator6", 6, $1, $2, $3, $4, $5, $6); }
   | CLASS_NAME COLONCOLON CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator7", 6, $1, $2, $3, $4, $5, $6); }
   | direct_declarator '[' constant_expression_opt ']'           { $$ = makeTreeNode(310, "direct_declarator8", 4, $1, $2, $3, $4); }
   | '(' declarator ')'           { $$ = makeTreeNode(310, "direct_declarator9", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


ptr_operator:
<<<<<<< HEAD
     MUL           { $$ = leaf($1, MUL);}
   | MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator1", 2, leaf($1, MUL), $2); }
   | AND           { $$ = leaf($1, AND); }
   | nested_name_specifier MUL           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator2", 2, $1, leaf($2, MUL)); }
   | nested_name_specifier MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator3", 3, $1, leaf($2, MUL), $3); }
   | COLONCOLON nested_name_specifier MUL           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator4", 3, leaf($1, COLONCOLON), $2, leaf($3, MUL)); }
   | COLONCOLON nested_name_specifier MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator5", 4, leaf($1, COLONCOLON), $2, leaf($1, MUL), $4); }
=======
     '*'           { $$ = $1;}
   | '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator1", 2, $1, $2); }
   | '&'           { $$ = $1; }
   | nested_name_specifier '*'           { $$ = makeTreeNode(315, "ptr_operator2", 2, $1, $2); }
   | nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator3", 3, $1, $2, $3); }
   | COLONCOLON nested_name_specifier '*'           { $$ = makeTreeNode(315, "ptr_operator4", 3, $1, $2, $3); }
   | COLONCOLON nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator5", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


cv_qualifier_seq:
     cv_qualifier           { $$ = $1; }
<<<<<<< HEAD
   | cv_qualifier cv_qualifier_seq           { $$ = makeTreeNode(CV_QUALIFIER_SEQ, "cv_qualifier_seq1", 2, $1, $2); }
=======
   | cv_qualifier cv_qualifier_seq           { $$ = makeTreeNode(320, "cv_qualifier_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


cv_qualifier:
<<<<<<< HEAD
     CONST           { $$ = leaf($1, CONST); }
   | VOLATILE           { $$ = leaf($1, VOLATILE); }
=======
     CONST           { $$ = $1; }
   | VOLATILE           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


declarator_id:
     id_expression           { $$ = $1; }
<<<<<<< HEAD
   | COLONCOLON id_expression           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id1", 2, leaf($1, COLONCOLON), $2); }
   | COLONCOLON nested_name_specifier type_name           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id2", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON type_name           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id3", 2, leaf($1, COLONCOLON), $2); }
=======
   | COLONCOLON id_expression           { $$ = makeTreeNode(325, "declarator_id1", 2, $1, $2); }
   | COLONCOLON nested_name_specifier type_name           { $$ = makeTreeNode(325, "declarator_id2", 3, $1, $2, $3); }
   | COLONCOLON type_name           { $$ = makeTreeNode(325, "declarator_id3", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


type_id:
<<<<<<< HEAD
     type_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(TYPE_ID, "type_id1", 2, $1, $2); }
=======
     type_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(330, "type_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


type_specifier_seq:
<<<<<<< HEAD
     type_specifier type_specifier_seq_opt           { $$ = makeTreeNode(TYPE_SPECIFIER_SEQ, "type_specifier_seq1", 2, $1, $2); }
=======
     type_specifier type_specifier_seq_opt           { $$ = makeTreeNode(335, "type_specifier_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


abstract_declarator:
<<<<<<< HEAD
     ptr_operator abstract_declarator_opt           { $$ = makeTreeNode(ABSTRACT_DECLARATOR, "abstract_declarator1", 2, $1, $2); }
=======
     ptr_operator abstract_declarator_opt           { $$ = makeTreeNode(340, "abstract_declarator1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | direct_abstract_declarator           { $$ = $1;}
   ;


direct_abstract_declarator:
<<<<<<< HEAD
     direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq exception_specification           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator1", 6, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, $6); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator2", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN exception_specification           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator3", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator4", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | direct_abstract_declarator_opt LBRAK constant_expression_opt RBRAK           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator5", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   | LPAREN abstract_declarator RPAREN           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator6", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
=======
     direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(345, "direct_abstract_declarator1", 6, $1, $2, $3, $4, $5, $6); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(345, "direct_abstract_declarator2", 5, $1, $2, $3, $4, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(345, "direct_abstract_declarator3", 5, $1, $2, $3, $4, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(345, "direct_abstract_declarator4", 4, $1, $2, $3, $4); }
   | direct_abstract_declarator_opt '[' constant_expression_opt ']'           { $$ = makeTreeNode(345, "direct_abstract_declarator5", 4, $1, $2, $3, $4); }
   | '(' abstract_declarator ')'           { $$ = makeTreeNode(345, "direct_abstract_declarator6", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


parameter_declaration_clause:
<<<<<<< HEAD
     parameter_declaration_list ELLIPSIS           { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause1", 2, $1, leaf($2, ELLIPSIS));}
   | parameter_declaration_list           { $$ = $1;}
   | ELLIPSIS           { $$ = leaf($1, ELLIPSIS);}
   |     /* epsilon */          { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause2", 0); }
   | parameter_declaration_list COMMA ELLIPSIS           { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause3", 3, $1, leaf($2, COMMA), leaf($3, ELLIPSIS)); }
=======
     parameter_declaration_list ELLIPSIS           { $$ = NULL;}
   | parameter_declaration_list           { $$ = $1;}
   | ELLIPSIS           { $$ = NULL;}
   |     /* epsilon */          { $$ = NULL; }
   | parameter_declaration_list ',' ELLIPSIS           { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


parameter_declaration_list:
     parameter_declaration           { $$ = $1;}
<<<<<<< HEAD
   | parameter_declaration_list COMMA parameter_declaration           { $$ = makeTreeNode(PARAMETER_DECLARATION_LIST, "parameter_declaration_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | parameter_declaration_list ',' parameter_declaration           { $$ = makeTreeNode(350, "parameter_declaration_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


parameter_declaration:
<<<<<<< HEAD
     decl_specifier_seq declarator           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration1", 2, $1, $2); }
   | decl_specifier_seq declarator EQ assignment_expression           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration2", 4, $1, $2, leaf($3, EQ), $4); }
   | decl_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration3", 2, $1, $2); }
   | decl_specifier_seq abstract_declarator_opt EQ assignment_expression           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration4", 4, $1, $2, leaf($3, EQ), $4); }
=======
     decl_specifier_seq declarator           { $$ = makeTreeNode(355, "parameter_declaration1", 2, $1, $2); }
   | decl_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(355, "parameter_declaration2", 4, $1, $2, $3, $4); }
   | decl_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(355, "parameter_declaration3", 2, $1, $2); }
   | decl_specifier_seq abstract_declarator_opt '=' assignment_expression           { $$ = makeTreeNode(355, "parameter_declaration4", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


function_definition:
<<<<<<< HEAD
     declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition1", 3, $1, $2, $3); }
   | decl_specifier_seq declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition2", 4, $1, $2, $3, $4); }
   | declarator function_try_block           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition3", 2, $1, $2); }
   | decl_specifier_seq declarator function_try_block           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition4", 3, $1, $2, $3); }
=======
     declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(360, "function_definition1", 3, $1, $2, $3); }
   | decl_specifier_seq declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(360, "function_definition2", 4, $1, $2, $3, $4); }
   | declarator function_try_block           { $$ = makeTreeNode(360, "function_definition3", 2, $1, $2); }
   | decl_specifier_seq declarator function_try_block           { $$ = makeTreeNode(360, "function_definition4", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


function_body:
     compound_statement           { $$ = $1;}
   ;


initializer:
<<<<<<< HEAD
     EQ initializer_clause           { $$ = makeTreeNode(INITIALIZER, "initializer1", 2, leaf($1, EQ), $2); }
   | LPAREN expression_list RPAREN           { $$ = makeTreeNode(INITIALIZER, "initializer2", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
=======
     '=' initializer_clause           { $$ = makeTreeNode(365, "initializer1", 2, $1, $2); }
   | '(' expression_list ')'           { $$ = makeTreeNode(365, "initializer2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


initializer_clause:
     assignment_expression           { $$ = $1; }
<<<<<<< HEAD
   | LCURLY initializer_list COMMA_opt RCURLY           { $$ = makeTreeNode(INITIALIZER_CLAUSE, "initializer_clause1", 4, leaf($1, LCURLY), $2, $3, leaf($4, RCURLY)); }
   | LCURLY RCURLY           { $$ = makeTreeNode(INITIALIZER_CLAUSE, "initializer_clause2", 2, leaf($1, LCURLY), leaf($2, RCURLY)); }
=======
   | '{' initializer_list COMMA_opt '}'           { $$ = makeTreeNode(370, "initializer_clause1", 4, $1, $2, $3, $4); }
   | '{' '}'           { $$ = makeTreeNode(370, "initializer_clause2", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


initializer_list:
     initializer_clause           { $$ = $1; }
<<<<<<< HEAD
   | initializer_list COMMA initializer_clause           { $$ = makeTreeNode(INITIALIZER_LIST, "initializer_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | initializer_list ',' initializer_clause           { $$ = makeTreeNode(375, "initializer_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


/*----------------------------------------------------------------------
 * Classes.
 *----------------------------------------------------------------------*/
   
class_specifier:
<<<<<<< HEAD
     class_head LCURLY member_specification_opt RCURLY           { $$ = makeTreeNode(CLASS_SPECIFIER, "class_specifier1", 4, $1, leaf($2, LCURLY), $3, leaf($4, RCURLY)); }
=======
     class_head '{' member_specification_opt '}'           { $$ = makeTreeNode(380, "class_specifier1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


class_head:
<<<<<<< HEAD
     class_key identifier           { $$ = makeTreeNode(CLASS_HEAD, "class_head1", 2, $1, $2); }
   | class_key identifier base_clause           { $$ = makeTreeNode(CLASS_HEAD, "class_head2", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier           { $$ = makeTreeNode(CLASS_HEAD, "class_head3", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier base_clause           { $$ = makeTreeNode(CLASS_HEAD, "class_head4", 4, $1, $2, $3, $4); }
=======
     class_key identifier           { $$ = makeTreeNode(385, "class_head1", 2, $1, $2); }
   | class_key identifier base_clause           { $$ = makeTreeNode(385, "class_head2", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier           { $$ = makeTreeNode(385, "class_head3", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier base_clause           { $$ = makeTreeNode(385, "class_head4", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


class_key:
<<<<<<< HEAD
     CLASS           { $$ = leaf($1, CLASS); }
   | STRUCT           { $$ = leaf($1, STRUCT); }
   | UNION           { $$ = leaf($1, UNION); }
=======
     CLASS           { $$ = $1; }
   | STRUCT           { $$ = $1; }
   | UNION           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


member_specification:
<<<<<<< HEAD
     member_declaration member_specification_opt           { $$ = makeTreeNode(MEMBER_SPECIFICATION, "member_specification1", 2, $1, $2); }
   | access_specifier COLON member_specification_opt           { $$ = makeTreeNode(MEMBER_SPECIFICATION, "member_specification2", 3, $1, leaf($2, COLON), $3); }
=======
     member_declaration member_specification_opt           { $$ = makeTreeNode(390, "member_specification1", 2, $1, $2); }
   | access_specifier ':' member_specification_opt           { $$ = makeTreeNode(390, "member_specification2", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


member_declaration:
<<<<<<< HEAD
     decl_specifier_seq member_declarator_list SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration1", 3, $1, $2, leaf($3, SEMIC)); }
   | decl_specifier_seq SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration2", 2, $1, leaf($2, SEMIC)); }
   | member_declarator_list SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration3", 2, $1, leaf($2, SEMIC)); }
   | SEMIC           { $$ = leaf($1, SEMIC); }
   | function_definition SEMICOLON_opt           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration4", 2, $1, $2); }
   | qualified_id SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration5", 2, $1, leaf($2, SEMIC)); }
=======
     decl_specifier_seq member_declarator_list ';'           { $$ = makeTreeNode(400, "member_declaration1", 3, $1, $2, $3); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(400, "member_declaration2", 2, $1, $2); }
   | member_declarator_list ';'           { $$ = makeTreeNode(400, "member_declaration3", 2, $1, $2); }
   | ';'           { $$ = $1; }
   | function_definition SEMICOLON_opt           { $$ = makeTreeNode(400, "member_declaration4", 2, $1, $2); }
   | qualified_id ';'           { $$ = makeTreeNode(400, "member_declaration5", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | using_declaration           { $$ = $1; }
   ;


member_declarator_list:
     member_declarator           { $$ = $1; }
<<<<<<< HEAD
   | member_declarator_list COMMA member_declarator           { $$ = makeTreeNode(MEMBER_DECLARATOR_LIST, "member_declarator_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | member_declarator_list ',' member_declarator           { $$ = makeTreeNode(405, "member_declarator_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


member_declarator:
     declarator           { $$ = $1;}
<<<<<<< HEAD
   | declarator pure_specifier           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator1", 2, $1, $2); }
   | declarator constant_initializer           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator2", 2, $1, $2); }
   | identifier COLON constant_expression           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator3", 3, $1, leaf($2, COLON), $3); }
=======
   | declarator pure_specifier           { $$ = makeTreeNode(410, "member_declarator1", 2, $1, $2); }
   | declarator constant_initializer           { $$ = makeTreeNode(410, "member_declarator2", 2, $1, $2); }
   | identifier ':' constant_expression           { $$ = makeTreeNode(410, "member_declarator3", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


pure_specifier:
<<<<<<< HEAD
    EQ ZERO           { $$ = makeTreeNode(PURE_SPECIFIER, "pure_specifier1", 2, leaf($1, EQ), leaf($2, ZERO)); }
=======
     '=' '0'           { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


constant_initializer:
<<<<<<< HEAD
     EQ constant_expression           { $$ = makeTreeNode(CONSTANT_INITIALIZER, "constant_initializer1", 2, leaf($1, EQ), $2); }
=======
     '=' constant_expression           { $$ = makeTreeNode(415, "constant_initializer1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


/*----------------------------------------------------------------------
 * Derived classes.
 *----------------------------------------------------------------------*/
   
base_clause:
<<<<<<< HEAD
     COLON base_specifier_list           { $$ = makeTreeNode(BASE_CLAUSE, "base_clause1", 2, leaf($1, COLON), $2); }
=======
     ':' base_specifier_list           { $$ = makeTreeNode(420, "base_clause1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


base_specifier_list:
     base_specifier           { $$ = $1; }
<<<<<<< HEAD
   | base_specifier_list COMMA base_specifier           { $$ = makeTreeNode(BASE_SPECIFIER_LIST, "base_specifier_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | base_specifier_list ',' base_specifier           { $$ = makeTreeNode(425, "base_specifier_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


base_specifier:
<<<<<<< HEAD
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier1", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier2", 2, leaf($1, COLONCOLON), $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier3", 2, $1, $2); }
   | class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier4", 1, $1); }
   | VIRTUAL access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier5", 5, leaf($1, VIRTUAL), $2, leaf($3, COLONCOLON), $4, $5); }
   | VIRTUAL access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier6", 4, leaf($1, VIRTUAL), $2, $3, $4); }
   | VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier7", 4, leaf($1, VIRTUAL), leaf($2, COLONCOLON), $3, $4); }
   | VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier8", 3, leaf($1, VIRTUAL), $2, $3); }
   | access_specifier VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier9", 5, $1, leaf($2, VIRTUAL), leaf($3, COLONCOLON), $4, $5); }
   | access_specifier VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier10", 4, $1, leaf($2, VIRTUAL), $3, $4); }
   | access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier11", 4, $1, leaf($2, COLONCOLON), $3, $4); }
   | access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(BASE_SPECIFIER, "base_specifier12", 3, $1, $2, $3); }
=======
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(430, "base_specifier1", 3, $1, $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(430, "base_specifier2", 2, $1, $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(430, "base_specifier3", 2, $1, $2); }
   | class_name           { $$ = makeTreeNode(430, "base_specifier4", 1, $1); }
   | VIRTUAL access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier5", 5, $1, $2, $3, $4, $5); }
   | VIRTUAL access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier6", 4, $1, $2, $3, $4); }
   | VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier7", 4, $1, $2, $3, $4); }
   | VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier8", 3, $1, $2, $3); }
   | access_specifier VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier9", 5, $1, $2, $3, $4, $5); }
   | access_specifier VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier10", 4, $1, $2, $3, $4); }
   | access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier11", 4, $1, $2, $3, $4); }
   | access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(430, "base_specifier12", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


access_specifier:
<<<<<<< HEAD
     PRIVATE           { $$ = leaf($1, PRIVATE); }
   | PROTECTED           { $$ = leaf($1, PROTECTED); }
   | PUBLIC           { $$ = leaf($1, PUBLIC); }
=======
     PRIVATE           { $$ = $1; }
   | PROTECTED           { $$ = $1; }
   | PUBLIC           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Special member functions.
 *----------------------------------------------------------------------*/
   
conversion_function_id:
<<<<<<< HEAD
     OPERATOR conversion_type_id           { $$ = makeTreeNode(CONVERSION_FUNCTION_ID, "conversion_function_id1", 2, leaf($1, OPERATOR), $2); }
=======
     OPERATOR conversion_type_id           { $$ = makeTreeNode(435, "conversion_function_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


conversion_type_id:
<<<<<<< HEAD
     type_specifier_seq conversion_declarator_opt           { $$ = makeTreeNode(CONVERSION_TYPE_ID, "conversion_type_id1", 2, $1, $2); }
=======
     type_specifier_seq conversion_declarator_opt           { $$ = makeTreeNode(440, "conversion_type_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


conversion_declarator:
<<<<<<< HEAD
     ptr_operator conversion_declarator_opt           { $$ = makeTreeNode(CONVERSION_DECLARATOR, "conversion_declarator1", 2, $1, $2); }
=======
     ptr_operator conversion_declarator_opt           { $$ = makeTreeNode(445, "conversion_declarator1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


ctor_initializer:
<<<<<<< HEAD
     COLON mem_initializer_list           { $$ = makeTreeNode(CTOR_INITIALIZER, "ctor_initializer1", 2, leaf($1, COLON), $2); }
=======
     ':' mem_initializer_list           { $$ = makeTreeNode(450, "ctor_initializer1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


mem_initializer_list:
     mem_initializer           { $$ = $1; }
<<<<<<< HEAD
   | mem_initializer COMMA mem_initializer_list           { $$ = makeTreeNode(MEM_INITIALIZER_LIST, "mem_initializer_list1", 3, $1, leaf($2, COLON), $3); }
=======
   | mem_initializer ',' mem_initializer_list           { $$ = makeTreeNode(455, "mem_initializer_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


mem_initializer:
<<<<<<< HEAD
     mem_initializer_id LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(MEM_INITIALIZER, "mem_initializer1", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
=======
     mem_initializer_id '(' expression_list_opt ')'           { $$ = makeTreeNode(450, "mem_initializer1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


mem_initializer_id:
<<<<<<< HEAD
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id1", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id2", 2, leaf($1, COLONCOLON), $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id3", 2, $1, $2); }
=======
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(500, "mem_initializer_id1", 3, $1, $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(500, "mem_initializer_id2", 2, $1, $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(500, "mem_initializer_id3", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | class_name           { $$ = $1; }
   | identifier           { $$ = $1; }
   ;

/*----------------------------------------------------------------------
 * Overloading.
 *----------------------------------------------------------------------*/
   
operator_function_id:
<<<<<<< HEAD
     OPERATOR operator           { $$ = makeTreeNode(OPERATOR_FUNCTION_ID, "operator_function_id1", 2, leaf($1, OPERATOR), $2); }
=======
     OPERATOR operator           { $$ = makeTreeNode(505, "operator_function_id1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


operator:
<<<<<<< HEAD
     NEW           { $$ = leaf($1, NEW); }
   | DELETE           { $$ = leaf($1, DELETE); }
   | NEW LBRAK RBRAK           { $$ = makeTreeNode(OPERATOR_VALUE, "operator1", 3, leaf($1, NEW), leaf($2, LBRAK), leaf($3, RBRAK)); }
   | DELETE LBRAK RBRAK           { $$ = makeTreeNode(OPERATOR_VALUE, "operator2", 3, leaf($1, DELETE), leaf($2, LBRAK), leaf($3, RBRAK)); }
   | PLUS	{ $$ = leaf($1, PLUS); }
   | UNDER  { $$ = leaf($1, UNDER);}
   | MUL    { $$ = leaf($1, MUL);} 
   | DIV    { $$ = leaf($1, DIV);}       
   | MOD    { $$ = leaf($1, MOD);}       
   | KARAT  { $$ = leaf($1, KARAT);}        
   | AND    { $$ = leaf($1, AND);}       
   | OR     { $$ = leaf($1, OR);}      
   | TILDE  { $$ = leaf($1, TILDE);}        
   | EXPOINT  { $$ = leaf($1, EXPOINT);}         
   | EQ       { $$ = leaf($1, EQ);}    
   | LT       { $$ = leaf($1, LT);}    
   | GT       { $$ = leaf($1, GT);}    
   | ADDEQ           { $$ = leaf($1, ADDEQ); }
   | SUBEQ           { $$ = leaf($1, SUBEQ); }
   | MULEQ           { $$ = leaf($1, MULEQ); }
   | DIVEQ           { $$ = leaf($1, DIVEQ); }
   | MODEQ           { $$ = leaf($1, MODEQ); }
   | XOREQ           { $$ = leaf($1, XOREQ); }
   | ANDEQ           { $$ = leaf($1, ANDEQ); }
   | OREQ           { $$ = leaf($1, OREQ); }
   | SL           { $$ = leaf($1, SL); }
   | SR           { $$ = leaf($1, SR); }
   | SREQ           { $$ = leaf($1, SREQ); }
   | SLEQ           { $$ = leaf($1, SLEQ); }
   | EQEQ           { $$ = leaf($1, EQEQ); }
   | NOTEQ           { $$ = leaf($1, NOTEQ); }
   | LTEQ           { $$ = leaf($1, LTEQ); }
   | GTEQ           { $$ = leaf($1, GTEQ); }
   | ANDAND           { $$ = leaf($1, ANDAND); }
   | OROR           { $$ = leaf($1, OROR);}
   | PLUSPLUS           { $$ = leaf($1, PLUSPLUS); }
   | MINUSMINUS           { $$ = leaf($1, MINUSMINUS); }
   | COMMA           { $$ = leaf($1, COMMA); }
   | ARROWSTAR           { $$ = leaf($1, ARROWSTAR); }
   | ARROW           { $$ = leaf($1, ARROW); }
   | LPAREN RPAREN           { $$ = makeTreeNode(OPERATOR_VALUE, "operator3", 2, leaf($1, LPAREN), leaf($1, RPAREN)); }
   | LBRAK RBRAK           { $$ = makeTreeNode(OPERATOR_VALUE, "opreator4", 2, leaf($1, LBRAK), leaf($2, RBRAK)); }
=======
     NEW           { $$ = $1; }
   | DELETE           { $$ = $1; }
   | NEW '[' ']'           { $$ = makeTreeNode(510, "operator1", 3, $1, $2, $3); }
   | DELETE '[' ']'           { $$ = makeTreeNode(510, "operator2", 3, $1, $2, $3); }
   | '+'          
   | '_'          
   | '*'           
   | '/'           
   | '%'           
   | '^'          
   | '&'           
   | '|'           
   | '~'          
   | '!'           
   | '='           
   | '<'           
   | '>'           
   | ADDEQ           { $$ = $1; }
   | SUBEQ           { $$ = $1; }
   | MULEQ           { $$ = $1; }
   | DIVEQ           { $$ = $1; }
   | MODEQ           { $$ = $1; }
   | XOREQ           { $$ = $1; }
   | ANDEQ           { $$ = $1; }
   | OREQ           { $$ = $1; }
   | SL           { $$ = $1; }
   | SR           { $$ = $1; }
   | SREQ           { $$ = $1; }
   | SLEQ           { $$ = $1; }
   | EQ           { $$ = $1; }
   | NOTEQ           { $$ = $1; }
   | LTEQ           { $$ = $1; }
   | GTEQ           { $$ = $1; }
   | ANDAND           { $$ = $1; }
   | OROR           { $$ = $1;}
   | PLUSPLUS           { $$ = $1; }
   | MINUSMINUS           { $$ = $1; }
   | ','           { $$ = $1; }
   | ARROWSTAR           { $$ = $1; }
   | ARROW           { $$ = $1; }
   | '(' ')'           { $$ = makeTreeNode(510, "operator3", 2, $1, $2); }
   | '[' ']'           { $$ = makeTreeNode(510, "opreator4", 2, $1, $2);; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;



/*----------------------------------------------------------------------
 * Exception handling.
 *----------------------------------------------------------------------*/
   
try_block:
<<<<<<< HEAD
     TRY compound_statement handler_seq           { $$ = makeTreeNode(TRY_BLOCK, "try_block1", 3, leaf($1, TRY), $2, $3); }
=======
     TRY compound_statement handler_seq           { $$ = makeTreeNode(515, "try_block1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


function_try_block:
<<<<<<< HEAD
     TRY ctor_initializer_opt function_body handler_seq           { $$ = makeTreeNode(FUNCTION_TRY_BLOCK, "function_try_block1", 4, leaf($1, TRY), $2, $3, $4); }
=======
     TRY ctor_initializer_opt function_body handler_seq           { $$ = makeTreeNode(520, "function_try_block1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


handler_seq:
<<<<<<< HEAD
     handler handler_seq_opt           { $$ = makeTreeNode(HANDLER_SEQ, "handler_seq1", 2, $1, $2); }
=======
     handler handler_seq_opt           { $$ = makeTreeNode(525, "handler_seq1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


handler:
<<<<<<< HEAD
     CATCH LPAREN exception_declaration RPAREN compound_statement           { $$ = makeTreeNode(HANDLER, "handler1", 5, leaf($1, CATCH), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
=======
     CATCH '(' exception_declaration ')' compound_statement           { $$ = makeTreeNode(530, "handler1", 5, $1, $2, $3, $4, $5); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


exception_declaration:
<<<<<<< HEAD
     type_specifier_seq declarator           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration1", 2, $1, $2); }
   | type_specifier_seq abstract_declarator           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration2", 2, $1, $2); }
   | type_specifier_seq           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration3", 1, $1); }
   | ELLIPSIS           { $$ = leaf($1, ELLIPSIS); }
=======
     type_specifier_seq declarator           { $$ = makeTreeNode(535, "exception_declaration1", 2, $1, $2); }
   | type_specifier_seq abstract_declarator           { $$ = makeTreeNode(535, "exception_declaration2", 2, $1, $2); }
   | type_specifier_seq           { $$ = makeTreeNode(535, "exception_declaration3", 1, $1); }
   | ELLIPSIS           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


throw_expression:
<<<<<<< HEAD
     THROW assignment_expression_opt           { $$ = makeTreeNode(THROW_EXPRESSION, "throw_expression1", 2, leaf($1, THROW), $2); }
=======
     THROW assignment_expression_opt           { $$ = makeTreeNode(540, "throw_expression1", 2, $1, $2); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


exception_specification:
<<<<<<< HEAD
     THROW LPAREN type_id_list_opt RPAREN           { $$ = makeTreeNode(EXCEPTION_SPECIFICATION, "exception_specification1", 4, leaf($1, THROW), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
=======
     THROW '(' type_id_list_opt ')'           { $$ = makeTreeNode(545, "exception_specification1", 4, $1, $2, $3, $4); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


type_id_list:
     type_id           { $$ = $1; }
<<<<<<< HEAD
   | type_id_list COMMA type_id           { $$ = makeTreeNode(TYPE_ID_LIST, "type_id_list1", 3, $1, leaf($2, COMMA), $3); }
=======
   | type_id_list ',' type_id           { $$ = makeTreeNode(550, "type_id_list1", 3, $1, $2, $3); }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;

/*----------------------------------------------------------------------
 * Epsilon (optional) definitions.
 *----------------------------------------------------------------------*/
   
declaration_seq_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(551, "declaration_seq_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | declaration_seq           { $$ = $1; }
   ;


nested_name_specifier_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(552, "nested_name_specifier_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | nested_name_specifier           { $$ = $1; }
   ;


expression_list_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(553, "expression_list_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | expression_list           { $$ = $1; }
   ;


COLONCOLON_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(554, "COLONCOLON_opt1", 0); }
   | COLONCOLON           { $$ = leaf($1, COLONCOLON);}
=======
     /* epsilon */          { $$ = NULL; }
   | COLONCOLON           { $$ = $1;}
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


new_placement_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(555, "new_placement_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | new_placement           { $$ = $1; }
   ;


new_initializer_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(556, "new_initializer_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | new_initializer           { $$ = $1; }
   ;


new_declarator_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(557, "new_declarator_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | new_declarator           { $$ = $1; }
   ;


expression_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(558, "expression_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | expression           { $$ = $1; }
   ;


statement_seq_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(559, "statement_seq_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | statement_seq           { $$ = $1; }
   ;


condition_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(560, "condition_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | condition           { $$ = $1; }
   ;


enumerator_list_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(561, "enumerator_list_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | enumerator_list           { $$ = $1; }
   ;


initializer_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(562, "initializer_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | initializer           { $$ = $1; }
   ;


constant_expression_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(563, "constant_expression_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | constant_expression           { $$ = $1; }
   ;


abstract_declarator_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(564, "abstract_declarator_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | abstract_declarator           { $$ = $1; }
   ;


type_specifier_seq_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(565, "type_specifier_seq_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | type_specifier_seq           { $$ = $1; }
   ;


direct_abstract_declarator_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(566, "direct_abstract_declarator_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | direct_abstract_declarator           { $$ = $1; }
   ;


ctor_initializer_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(567, "ctor_initializer_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | ctor_initializer           { $$ = $1; }
   ;


COMMA_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(568, "COMMA_opt1", 0); }
   | COMMA           { $$ = leaf($1, COMMA); }
=======
     /* epsilon */          { $$ = NULL; }
   | ','           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


member_specification_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(569, "member_specification_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | member_specification           { $$ = $1;}
   ;


SEMICOLON_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(570, "SEMICOLON_opt1", 0); }
   | SEMIC           { $$ = leaf($1, SEMIC); }
=======
     /* epsilon */          { $$ = NULL; }
   | ';'           { $$ = $1; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   ;


conversion_declarator_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(571, "conversion_declarator_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | conversion_declarator           { $$ = $1; }
   ;




handler_seq_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(572, "handler_seq_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | handler_seq           { $$ = $1; }
   ;


assignment_expression_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(573, "assignment_expression_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | assignment_expression           { $$ = $1; }
   ;


type_id_list_opt:
<<<<<<< HEAD
     /* epsilon */          { $$ = makeTreeNode(574, "type_id_list_opt1", 0); }
=======
     /* epsilon */          { $$ = NULL; }
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
   | type_id_list           { $$ = $1; }
   ;

%%

/* 
 * standard yyerror to find syntax errors
 * need to add filename and lineno functionality
*/
<<<<<<< HEAD
static void yyerror(const char *s)
{
	fprintf(stderr, "ERROR: line %d, parser.error verbose output: %s\n", lineno, s);
=======
static void yyerror(char *s)
{
	fprintf(stderr, "syntax error on line %d, string: %s\n", yylineno, s);
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
	exit(2);
}
