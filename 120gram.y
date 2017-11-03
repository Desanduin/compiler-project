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
#include "gram_rules.h"
extern char *yytext;
extern int yylex();
extern int yylineno;
int yydebug=0;
struct tree *savedTree;
static void yyerror(const char *);

%}
%union {
	struct token *tokenData;
	struct tree *treenode;
}
%define parse.error verbose
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
     TYPEDEF_NAME           { $$ = leaf($1, TYPEDEF_NAME); }
   ;


namespace_name:
     original_namespace_name           { $$ = $1; }
   ;


original_namespace_name:
     NAMESPACE_NAME           { $$ = leaf($1, NAMESPACE_NAME); }
   ;


class_name:
     CLASS_NAME           { $$ = leaf($1, CLASS_NAME); }
   ;


enum_name:
     ENUM_NAME           { $$ = leaf($1, ENUM_NAME); }
   ;




identifier:
     IDENTIFIER           { $$ = leaf($1, IDENTIFIER); }
   ;


literal:
     integer_literal           { $$ = $1; }
   | character_literal           { $$ = $1; }
   | floating_literal           { $$ = $1; }
   | string_literal           { $$ = $1; }
   | boolean_literal           { $$ = $1; }
   ;


integer_literal:
     INTEGER           { $$ = leaf($1, INTEGER); }
   ;


character_literal:
     CHARACTER           { $$ = leaf($1, CHARACTER); }
   ;


floating_literal:
     FLOATING           { $$ = leaf($1, FLOATING); }
   ;


string_literal:
     STRING           { $$ = leaf($1, STRING); }
   ;


boolean_literal:
     TRUE           { $$ = leaf($1, TRUE); }
   | FALSE           { $$ = leaf($1, FALSE); }
   ;

/*----------------------------------------------------------------------
 * Translation unit.
 *----------------------------------------------------------------------*/
   
translation_unit:
     declaration_seq_opt           { savedTree = $1;}
   ;

/*----------------------------------------------------------------------
 * Expressions.
 *----------------------------------------------------------------------*/
   
primary_expression:
     literal           { $$ = $1; }
   | THIS           { $$ = leaf($1, THIS); }
   | LPAREN expression RPAREN           { $$ = makeTreeNode(PRIMARY_EXPRESSION, "primary_expression1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   | id_expression           { $$ = $1; }
   ;


id_expression:
     unqualified_id           { $$ = $1; }
   | qualified_id           { $$ = $1; }
   ;


unqualified_id:
     identifier          
   | operator_function_id          
   | conversion_function_id   
   | TILDE class_name           { $$ = makeTreeNode(UNQUALIFIED_ID, "unqualified_id1", 2, leaf($1, TILDE), $2); }
   ;


qualified_id:
     nested_name_specifier unqualified_id           { $$ = makeTreeNode(QUALIFIED_ID, "qualified_id1", 2, $1, $2); }
   ;


nested_name_specifier:
     class_name COLONCOLON nested_name_specifier namespace_name COLONCOLON nested_name_specifier           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier1", 6, $1, leaf($2, COLONCOLON), $3, $4, leaf($5, COLONCOLON), $6); }
   | class_name COLONCOLON           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier2", 2, $1, leaf($2, COLONCOLON)); }
   | namespace_name COLONCOLON           { $$ = makeTreeNode(NESTED_NAME_SPECIFIER, "nested_name_specifier3", 2, $1, leaf($2, COLONCOLON)); }
   ;


postfix_expression:
     primary_expression          
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
   ;


expression_list:
     assignment_expression          
   | expression_list COMMA assignment_expression           { $$ = makeTreeNode(EXPRESSION_LIST, "expression_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


unary_expression:
     postfix_expression          
   | PLUSPLUS cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression1", 2, leaf($1, PLUSPLUS), $2); }
   | MINUSMINUS cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression2", 2, leaf($1, MINUSMINUS), $2); }
   | MUL cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression3", 2, leaf($1, MUL), $2); }
   | AND cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression4", 2, leaf($1, AND), $2); }
   | unary_operator cast_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression5", 2, $1, $2); }
   | SIZEOF unary_expression           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression6", 2, leaf($1, SIZEOF), $2); }
   | SIZEOF LPAREN type_id RPAREN           { $$ = makeTreeNode(UNARY_EXPRESSION, "unary_expression7", 4, leaf($1, SIZEOF), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | new_expression          
   | delete_expression          
   ;


unary_operator:
     PLUS { $$ = leaf($1, PLUS); }      
   | DASH   { $$ = leaf($1, DASH); }         
   | EXPOINT  { $$ = leaf($1, EXPOINT); }           
   | TILDE    { $$ = leaf($1, TILDE); }         
   ;


new_expression:
     NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression1", 4, leaf($1, NEW), $2, $3, $4); }
   | COLONCOLON NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression2", 5, leaf($1, COLONCOLON), leaf($2, NEW), $3, $4, $5); }
   | NEW new_placement_opt LPAREN type_id RPAREN new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression3", 6, leaf($1, NEW), $2, leaf($3, LPAREN), $4, leaf($5, RPAREN), $6); }
   | COLONCOLON NEW new_placement_opt LPAREN type_id RPAREN new_initializer_opt           { $$ = makeTreeNode(NEW_EXPRESSION, "new_expression4", 7, leaf($1, COLONCOLON), leaf($2, NEW), $3, leaf($4, LPAREN), $5, leaf($6, RPAREN), $7); }
   ;


new_placement:
     LPAREN expression_list RPAREN           { $$ = makeTreeNode(NEW_PLACEMENT, "new_placement1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   ;


new_type_id:
     type_specifier_seq new_declarator_opt           { $$ = makeTreeNode(NEW_TYPE_ID, "new_type_id1", 2, $1, $2); }
   ;


new_declarator:
     ptr_operator new_declarator_opt           { $$ = makeTreeNode(NEW_DECLARATOR, "new_declarator1", 2, $1, $2); }
   | direct_new_declarator           { $$ = $1; }
   ;


direct_new_declarator:
     LBRAK expression RBRAK           { $$ = makeTreeNode(DIRECT_NEW_DECLARATOR, "direct_new_declarator1", 3, leaf($1, LBRAK), $2, leaf($3, RBRAK)); }
   | direct_new_declarator LBRAK constant_expression RBRAK           { $$ = makeTreeNode(DIRECT_NEW_DECLARATOR, "direct_new_declarator2", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   ;


new_initializer:
     LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(NEW_INITIALIZER, "new_initializer1", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   ;


delete_expression:
     DELETE cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression1", 2, leaf($1, DELETE), $2); }
   | COLONCOLON DELETE cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression2", 3, leaf($1, COLONCOLON), leaf($2, DELETE), $3); }
   | DELETE LBRAK RBRAK cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression3", 4, leaf($1, DELETE), leaf($2, LBRAK), leaf($3, RBRAK), $4); }
   | COLONCOLON DELETE LBRAK RBRAK cast_expression           { $$ = makeTreeNode(DELETE_EXPRESSION, "delete_expression4", 5, leaf($1, COLONCOLON), leaf($2, DELETE), leaf($3, LBRAK), leaf($4, RBRAK), $5); }
   ;


cast_expression:
     unary_expression           { $$ = makeTreeNode(CAST_EXPRESSION, "cast_expression1", 1, $1); }
   | LPAREN type_id RPAREN cast_expression           { $$ = makeTreeNode(CAST_EXPRESSION, "cast_expression2", 4, leaf($1, LPAREN), $2, leaf($3, RPAREN), $4); }
   ;


pm_expression:
     cast_expression           { $$ = $1; }
   | pm_expression DOTSTAR cast_expression           { $$ = makeTreeNode(PM_EXPRESSION, "pm_expression1", 3, $1, leaf($2, DOTSTAR), $3); }
   | pm_expression ARROWSTAR cast_expression           { $$ = makeTreeNode(PM_EXPRESSION, "pm_expression2", 3, $1, leaf($2, ARROWSTAR), $3); }
   ;


multiplicative_expression:
     pm_expression           { $$ = $1; }
   | multiplicative_expression MUL pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression1", 3, $1, leaf($2, MUL), $3); }
   | multiplicative_expression DIV pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression2", 3, $1, leaf($2, DIV), $3); }
   | multiplicative_expression MOD pm_expression           { $$ = makeTreeNode(MULTIPLICATIVE_EXPRESSION, "multiplicative_expression3", 3, $1, leaf($2, MOD), $3); }
   ;


additive_expression:
     multiplicative_expression           { $$ = $1; }
   | additive_expression PLUS multiplicative_expression           { $$ = makeTreeNode(ADDITIVE_EXPRESSION, "additive_expression1", 3, $1, leaf($2, PLUS), $3); }
   | additive_expression DASH multiplicative_expression           { $$ = makeTreeNode(ADDITIVE_EXPRESSION, "additive_expression2", 3, $1, leaf($2, DASH), $3); }
   ;


shift_expression:
     additive_expression           { $$ = $1; }
   | shift_expression SL additive_expression           { $$ = makeTreeNode(SHIFT_EXPRESSION, "shift_expression1", 3, $1, leaf($2, SL), $3); }
   | shift_expression SR additive_expression           { $$ = makeTreeNode(SHIFT_EXPRESSION, "shift_expression2", 3, $1, leaf($2, SR), $3); }
   ;


relational_expression:
     shift_expression           { $$ = $1; }
   | relational_expression LT shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression1", 3, $1, leaf($2, LT), $3); }
   | relational_expression GT shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression2", 3, $1, leaf($2, GT), $3); }
   | relational_expression LTEQ shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression3", 3, $1, leaf($2, LTEQ), $3); }
   | relational_expression GTEQ shift_expression           { $$ = makeTreeNode(RELATIONAL_EXPRESSION, "relational_expression4", 3, $1, leaf($2, GTEQ), $3); }
   ;


equality_expression:
     relational_expression           { $$ = $1; }
   | equality_expression EQEQ relational_expression           { $$ = makeTreeNode(EQUALITY_EXPRESSION, "equality_expression1", 3, $1, leaf($2, EQEQ), $3); }
   | equality_expression NOTEQ relational_expression           { $$ = makeTreeNode(EQUALITY_EXPRESSION, "equality_expression2", 3, $1, leaf($2, NOTEQ), $3); }
   ;


and_expression:
     equality_expression           { $$ = $1;}
   | and_expression AND equality_expression           { $$ = makeTreeNode(AND_EXPRESSION, "and_expression1", 3, $1, leaf($2, AND), $3); }
   ;


exclusive_or_expression:
     and_expression           { $$ = $1;}
   | exclusive_or_expression KARAT and_expression           { $$ = makeTreeNode(EXCLUSIVE_OR_EXPRESSION, "exclusive_or_expression1", 3, $1, leaf($2, KARAT), $3); }
   ;


inclusive_or_expression:
     exclusive_or_expression           { $$ = $1;}
   | inclusive_or_expression OR exclusive_or_expression           { $$ = makeTreeNode(INCLUSIVE_OR_EXPRESSION, "inclusive_or_expression1", 3, $1, leaf($2, OR), $3); }
   ;


logical_and_expression:
     inclusive_or_expression           { $$ = $1;}
   | logical_and_expression ANDAND inclusive_or_expression           { $$ = makeTreeNode(LOGICAL_AND_EXPRESSION, "logical_and_expression1", 3, $1, leaf($2, ANDAND), $3); }
   ;


logical_or_expression:
     logical_and_expression           { $$ = $1;}
   | logical_or_expression OROR logical_and_expression           { $$ = makeTreeNode(LOGICAL_OR_EXPRESSION, "logical_or_expression1", 3, $1, leaf($2, OROR), $3); }
   ;


conditional_expression:
     logical_or_expression           { $$ = $1;}
   | logical_or_expression QUEST expression COLON assignment_expression           { $$ = makeTreeNode(CONDITIONAL_EXPRESSION, "conditional_expression1", 5, $1, leaf($2, QUEST), $3, leaf($4, COLON), $5); }
   ;


assignment_expression:
     conditional_expression           { $$ = $1;}
   | logical_or_expression assignment_operator assignment_expression           { $$ = makeTreeNode(ASSIGNMENT_EXPRESSION, "assignment_expression1", 3, $1, $2, $3); }
   | throw_expression           { $$ = $1;}
   ;


assignment_operator:
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
   ;


expression:
     assignment_expression           { $$ = $1;}
   | expression COMMA assignment_expression           { $$ = makeTreeNode(EXPRESSION, "expression1", 3, $1, leaf($2, COMMA), $3); }
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
     identifier COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement1", 3, $1, leaf($2, COLON), $3); }
   | CASE constant_expression COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement2", 4, leaf($1, CASE), $2, leaf($3, COLON), $4); }
   | DEFAULT COLON statement           { $$ = makeTreeNode(LABELED_STATEMENT, "labeled_statement3", 3, leaf($1, DEFAULT), leaf($2, COLON), $3); }
   ;


expression_statement:
     expression_opt SEMIC           { $$ = makeTreeNode(EXPRESSION_STATEMENT, "expression_statement1", 2, $1, leaf($2, SEMIC)); }
   ;


compound_statement:
     LCURLY statement_seq_opt RCURLY           { $$ = makeTreeNode(COMPOUND_STATEMENT, "compound_statement1", 3, leaf($1, LCURLY), $2, leaf($3, RCURLY));  }
   ;


statement_seq:
     statement           { $$ = $1;}
   | statement_seq statement           { $$ = makeTreeNode(STATEMENT_SEQ, "statement_seq1", 2, $1, $2); }
   ;


selection_statement:
     IF LPAREN condition RPAREN statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement1", 5, leaf($1, IF), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | IF LPAREN condition RPAREN statement ELSE statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement2", 7, leaf($1, IF), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, leaf($6, ELSE), $7); }
   | SWITCH LPAREN condition RPAREN statement           { $$ = makeTreeNode(SELECTION_STATEMENT, "selection_statement3", 5, leaf($1, SWITCH), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   ;


condition:
     expression           { $$ = $1;}
   | type_specifier_seq declarator EQ assignment_expression           { $$ = makeTreeNode(CONDITION, "condition1", 4, $1, $2, leaf($3, EQ), $4); }
   ;


iteration_statement:
     WHILE LPAREN condition RPAREN statement           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement1", 5, leaf($1, WHILE), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | DO statement WHILE LPAREN expression RPAREN SEMIC           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement2", 7, leaf($1, DO), $2, leaf($3, WHILE), leaf($4, LPAREN), $5, leaf($6, RPAREN), leaf($7, SEMIC)); }
   | FOR LPAREN for_init_statement condition_opt SEMIC expression_opt RPAREN statement           { $$ = makeTreeNode(ITERATION_STATEMENT, "iteration_statement3", 8, leaf($1, FOR), leaf($2, LPAREN), $3, $4, leaf($5, SEMIC), $6, leaf($7, RPAREN), $8); }
   ;


for_init_statement:
     expression_statement           { $$ = $1;}
   | simple_declaration           { $$ = $1;}
   ;


jump_statement:
     BREAK SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement1", 2, leaf($1, BREAK), leaf($2, SEMIC)); }
   | CONTINUE SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement2", 2, leaf($1, CONTINUE), leaf($2, SEMIC)); }
   | RETURN expression_opt SEMIC           { $$ = makeTreeNode(JUMP_STATEMENT, "jump_statement3", 3, leaf($1, RETURN), $2, leaf($3, SEMIC)); }
   ;


declaration_statement:
     block_declaration           { $$ = $1;}
   ;

/*----------------------------------------------------------------------
 * Declarations.
 *----------------------------------------------------------------------*/
   
declaration_seq:
     declaration           { $$ = $1;}
   | declaration_seq declaration           { $$ = makeTreeNode(DECLARATION_SEQ, "declaration_seq1", 2, $1, $2); }
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
     decl_specifier_seq init_declarator_list SEMIC           { $$ = makeTreeNode(SIMPLE_DECLARATION, "simple_declaration1", 3, $1, $2, leaf($3, SEMIC)); }
   | decl_specifier_seq SEMIC           { $$ = makeTreeNode(SIMPLE_DECLARATION, "simple_declaration2", 2, $1, leaf($2, SEMIC)); }
   ;


decl_specifier:
     storage_class_specifier           { $$ = $1;}
   | type_specifier           { $$ = $1;}
   | function_specifier           { $$ = $1;}
   | FRIEND           { $$ = leaf($1, FRIEND);}
   | TYPEDEF           { $$ = leaf($1, TYPEDEF);}
   ;


decl_specifier_seq:
     decl_specifier           { $$ = $1;}
   | decl_specifier_seq decl_specifier           { $$ = makeTreeNode(DECL_SPECIFIER_SEQ, "decl_specifier_seq1", 2, $1, $2); }
   ;


storage_class_specifier:
     AUTO           { $$ = leaf($1, AUTO);}
   | REGISTER           { $$ = leaf($1, REGISTER); }
   | STATIC           { $$ = leaf($1, STATIC); }
   | EXTERN           { $$ = leaf($1, EXTERN); }
   | MUTABLE           { $$ = leaf($1, MUTABLE); }
   ;


function_specifier:
     INLINE           { $$ = leaf($1, INLINE); }
   | VIRTUAL           { $$ = leaf($1, VIRTUAL); }
   | EXPLICIT           { $$ = leaf($1, EXPLICIT); }
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
   ;


type_name:
     class_name           { $$ = $1; }
   | enum_name           { $$ = $1; }
   | typedef_name           { $$ = $1; }
   ;


elaborated_type_specifier:
     class_key COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier1", 4, $1, leaf($2, COLONCOLON), $3, $4); }
   | class_key COLONCOLON identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier2", 3, $1, leaf($2, COLONCOLON), $3); }
   | ENUM COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier3", 4, leaf($1, ENUM), leaf($2, COLONCOLON), $3, $4); }
   | ENUM COLONCOLON identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier4", 3, leaf($1, ENUM), leaf($2, COLONCOLON), $3); }
   | ENUM nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier5", 3, leaf($1, ENUM), $2, $3); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier           { $$ = makeTreeNode(ELABORATED_TYPE_SPECIFIER, "elaborated_type_specifier6", 4, leaf($1, TYPENAME), $2, $3, $4); }
   ;


enum_specifier:
     ENUM identifier LCURLY enumerator_list_opt RCURLY           { $$ = makeTreeNode(ENUM_SPECIFIER, "enum_specifier1", 5, leaf($1, ENUM), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
   ;


enumerator_list:
     enumerator_definition           { $$ = $1;}
   | enumerator_list COMMA enumerator_definition           { $$ = makeTreeNode(ENUMERATOR_LIST, "enumerator_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


enumerator_definition:
     enumerator           { $$ = $1; }
   | enumerator EQ constant_expression           { $$ = makeTreeNode(ENUMERATOR_DEFINITION, "enumerator_definition1", 3, $1, leaf($2, EQ), $3); }
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
     NAMESPACE identifier LCURLY namespace_body RCURLY           { $$ = makeTreeNode(ORIGINAL_NAMESPACE_DEFINITION, "original_namespace_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
   ;


extension_namespace_definition:
     NAMESPACE original_namespace_name LCURLY namespace_body RCURLY           { $$ = makeTreeNode(EXTENSION_NAMESPACE_DEFINITION, "extension_namespace_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
   ;


unnamed_namespace_definition:
     NAMESPACE LCURLY namespace_body RCURLY           { $$ = makeTreeNode(UNNAMED_NAMESPACE_DEFINITION, "unnamed_namespace_definition1", 4, leaf($1, NAMESPACE), leaf($2, LCURLY), $3, leaf($4, RCURLY)); }
   ;


namespace_body:
     declaration_seq_opt           { $$ = $1;}
   ;


namespace_alias_definition:
     NAMESPACE identifier EQ qualified_namespace_specifier SEMIC           { $$ = makeTreeNode(NAMESPACE_ALIAS_DEFINITION, "namespace_alias_definition1", 5, leaf($1, NAMESPACE), $2, leaf($3, EQ), $4, leaf($5, SEMIC)); }
   ;


qualified_namespace_specifier:
     COLONCOLON nested_name_specifier namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier1", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier2", 2, leaf($1, COLONCOLON), $2); }
   | nested_name_specifier namespace_name           { $$ = makeTreeNode(QUALIFIED_NAMESPACE_SPECIFIER, "qualified_namespace_specifier3", 2, $1, $2); }
   | namespace_name           { $$ = $1; }
   ;


using_declaration:
     USING TYPENAME COLONCOLON nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration1", 6, leaf($1, USING), leaf($2, TYPENAME), leaf($3, COLONCOLON), $4, $5, leaf($6, SEMIC)); }
   | USING TYPENAME nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration2", 5, leaf($1, USING), leaf($2, TYPENAME), $3, $4, leaf($5, SEMIC)); }
   | USING COLONCOLON nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration3", 5, leaf($1, USING), leaf($2, COLONCOLON), $3, $4, leaf($5, SEMIC)); }
   | USING nested_name_specifier unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration4", 4, leaf($1, USING), $2, $3, leaf($4, SEMIC)); }
   | USING COLONCOLON unqualified_id SEMIC           { $$ = makeTreeNode(USING_DECLARATION, "using_declaration5", 4, leaf($1, USING), $2, $3, leaf($4, SEMIC)); }
   ;


using_directive:
     USING NAMESPACE COLONCOLON nested_name_specifier namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive1", 6, leaf($1, USING), leaf($2, NAMESPACE), leaf($3, COLONCOLON), $4, $5, leaf($6, SEMIC)); }
   | USING NAMESPACE COLONCOLON namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive2", 5, leaf($1, USING), leaf($2, NAMESPACE), leaf($3, COLONCOLON), $4, leaf($5, SEMIC)); }
   | USING NAMESPACE nested_name_specifier namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive3", 5, leaf($1, USING), leaf($2, NAMESPACE), $3, $4, leaf($5, SEMIC)); }
   | USING NAMESPACE namespace_name SEMIC           { $$ = makeTreeNode(USING_DIRECTIVE, "using_directive4", 4, leaf($1, USING), leaf($2, NAMESPACE), $3, leaf($4, SEMIC)); }
   ;


asm_definition:
     ASM LPAREN string_literal RPAREN SEMIC           { $$ = makeTreeNode(ASM_DEFINITION, "asm_definition1", 5, leaf($1, ASM), leaf($2, LPAREN), $3, leaf($4, RPAREN), leaf($5, SEMIC)); }
   ;


linkage_specification:
     EXTERN string_literal LCURLY declaration_seq_opt RCURLY           { $$ = makeTreeNode(LINKAGE_SPECIFICATION, "linkage_specification1", 5, leaf($1, EXTERN), $2, leaf($3, LCURLY), $4, leaf($5, RCURLY)); }
   | EXTERN string_literal declaration           { $$ = makeTreeNode(LINKAGE_SPECIFICATION, "linkage_specification2", 3, leaf($1, EXTERN), $2, $3); }
   ;

/*----------------------------------------------------------------------
 * Declarators.
 *----------------------------------------------------------------------*/
   
init_declarator_list:
     init_declarator           { $$ = $1;}
   | init_declarator_list COMMA init_declarator           { $$ = makeTreeNode(INIT_DECLARATOR_LIST, "init_declarator_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


init_declarator:
     declarator initializer_opt           { $$ = makeTreeNode(INIT_DECLARATOR, "init_declarator1", 2, $1, $2); }
   ;


declarator:
     direct_declarator           { $$ = $1;}
   | ptr_operator declarator           { $$ = makeTreeNode(DECLARATOR, "declarator1", 2, $1, $2); }
   ;


direct_declarator:
     declarator_id           { $$ = $1; }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq exception_specification           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator1", 6, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, $6); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator2", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN exception_specification           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator3", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_declarator LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator4", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | CLASS_NAME LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator5", 4, leaf($1, CLASS_NAME), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | CLASS_NAME COLONCOLON declarator_id LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator6", 6, leaf($1, CLASS_NAME), leaf($2, COLONCOLON), $3, leaf($4, LPAREN), $5, leaf($6, RPAREN)); }
   | CLASS_NAME COLONCOLON CLASS_NAME LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator7", 6, leaf($1, CLASS_NAME), leaf($2, COLONCOLON), leaf($3, CLASS_NAME), leaf($4, LPAREN), $5, leaf($6, RPAREN)); }
   | direct_declarator LBRAK constant_expression_opt RBRAK           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator8", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   | LPAREN declarator RPAREN           { $$ = makeTreeNode(DIRECT_DECLARATOR, "direct_declarator9", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   ;


ptr_operator:
     MUL           { $$ = leaf($1, MUL);}
   | MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator1", 2, leaf($1, MUL), $2); }
   | AND           { $$ = leaf($1, AND); }
   | nested_name_specifier MUL           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator2", 2, $1, leaf($2, MUL)); }
   | nested_name_specifier MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator3", 3, $1, leaf($2, MUL), $3); }
   | COLONCOLON nested_name_specifier MUL           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator4", 3, leaf($1, COLONCOLON), $2, leaf($3, MUL)); }
   | COLONCOLON nested_name_specifier MUL cv_qualifier_seq           { $$ = makeTreeNode(PTR_OPERATOR, "ptr_operator5", 4, leaf($1, COLONCOLON), $2, leaf($1, MUL), $4); }
   ;


cv_qualifier_seq:
     cv_qualifier           { $$ = $1; }
   | cv_qualifier cv_qualifier_seq           { $$ = makeTreeNode(CV_QUALIFIER_SEQ, "cv_qualifier_seq1", 2, $1, $2); }
   ;


cv_qualifier:
     CONST           { $$ = leaf($1, CONST); }
   | VOLATILE           { $$ = leaf($1, VOLATILE); }
   ;


declarator_id:
     id_expression           { $$ = $1; }
   | COLONCOLON id_expression           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id1", 2, leaf($1, COLONCOLON), $2); }
   | COLONCOLON nested_name_specifier type_name           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id2", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON type_name           { $$ = makeTreeNode(DECLARATOR_ID, "declarator_id3", 2, leaf($1, COLONCOLON), $2); }
   ;


type_id:
     type_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(TYPE_ID, "type_id1", 2, $1, $2); }
   ;


type_specifier_seq:
     type_specifier type_specifier_seq_opt           { $$ = makeTreeNode(TYPE_SPECIFIER_SEQ, "type_specifier_seq1", 2, $1, $2); }
   ;


abstract_declarator:
     ptr_operator abstract_declarator_opt           { $$ = makeTreeNode(ABSTRACT_DECLARATOR, "abstract_declarator1", 2, $1, $2); }
   | direct_abstract_declarator           { $$ = $1;}
   ;


direct_abstract_declarator:
     direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq exception_specification           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator1", 6, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5, $6); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN cv_qualifier_seq           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator2", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN exception_specification           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator3", 5, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   | direct_abstract_declarator_opt LPAREN parameter_declaration_clause RPAREN           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator4", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   | direct_abstract_declarator_opt LBRAK constant_expression_opt RBRAK           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator5", 4, $1, leaf($2, LBRAK), $3, leaf($4, RBRAK)); }
   | LPAREN abstract_declarator RPAREN           { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR, "direct_abstract_declarator6", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   ;


parameter_declaration_clause:
     parameter_declaration_list ELLIPSIS           { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause1", 2, $1, leaf($2, ELLIPSIS));}
   | parameter_declaration_list           { $$ = $1;}
   | ELLIPSIS           { $$ = leaf($1, ELLIPSIS);}
   |     /* epsilon */          { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause2", 0); }
   | parameter_declaration_list COMMA ELLIPSIS           { $$ = makeTreeNode(PARAMETER_DECLARATION_CLAUSE, "parameter_declaration_clause3", 3, $1, leaf($2, COMMA), leaf($3, ELLIPSIS)); }
   ;


parameter_declaration_list:
     parameter_declaration           { $$ = $1;}
   | parameter_declaration_list COMMA parameter_declaration           { $$ = makeTreeNode(PARAMETER_DECLARATION_LIST, "parameter_declaration_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


parameter_declaration:
     decl_specifier_seq declarator           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration1", 2, $1, $2); }
   | decl_specifier_seq declarator EQ assignment_expression           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration2", 4, $1, $2, leaf($3, EQ), $4); }
   | decl_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration3", 2, $1, $2); }
   | decl_specifier_seq abstract_declarator_opt EQ assignment_expression           { $$ = makeTreeNode(PARAMETER_DECLARATION, "parameter_declaration4", 4, $1, $2, leaf($3, EQ), $4); }
   ;


function_definition:
     declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition1", 3, $1, $2, $3); }
   | decl_specifier_seq declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition2", 4, $1, $2, $3, $4); }
   | declarator function_try_block           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition3", 2, $1, $2); }
   | decl_specifier_seq declarator function_try_block           { $$ = makeTreeNode(FUNCTION_DEFINITION, "function_definition4", 3, $1, $2, $3); }
   ;


function_body:
     compound_statement           { $$ = $1;}
   ;


initializer:
     EQ initializer_clause           { $$ = makeTreeNode(INITIALIZER, "initializer1", 2, leaf($1, EQ), $2); }
   | LPAREN expression_list RPAREN           { $$ = makeTreeNode(INITIALIZER, "initializer2", 3, leaf($1, LPAREN), $2, leaf($3, RPAREN)); }
   ;


initializer_clause:
     assignment_expression           { $$ = $1; }
   | LCURLY initializer_list COMMA_opt RCURLY           { $$ = makeTreeNode(INITIALIZER_CLAUSE, "initializer_clause1", 4, leaf($1, LCURLY), $2, $3, leaf($4, RCURLY)); }
   | LCURLY RCURLY           { $$ = makeTreeNode(INITIALIZER_CLAUSE, "initializer_clause2", 2, leaf($1, LCURLY), leaf($2, RCURLY)); }
   ;


initializer_list:
     initializer_clause           { $$ = $1; }
   | initializer_list COMMA initializer_clause           { $$ = makeTreeNode(INITIALIZER_LIST, "initializer_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


/*----------------------------------------------------------------------
 * Classes.
 *----------------------------------------------------------------------*/
   
class_specifier:
     class_head LCURLY member_specification_opt RCURLY           { $$ = makeTreeNode(CLASS_SPECIFIER, "class_specifier1", 4, $1, leaf($2, LCURLY), $3, leaf($4, RCURLY)); }
   ;


class_head:
     class_key identifier           { $$ = makeTreeNode(CLASS_HEAD, "class_head1", 2, $1, $2); }
   | class_key identifier base_clause           { $$ = makeTreeNode(CLASS_HEAD, "class_head2", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier           { $$ = makeTreeNode(CLASS_HEAD, "class_head3", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier base_clause           { $$ = makeTreeNode(CLASS_HEAD, "class_head4", 4, $1, $2, $3, $4); }
   ;


class_key:
     CLASS           { $$ = leaf($1, CLASS); }
   | STRUCT           { $$ = leaf($1, STRUCT); }
   | UNION           { $$ = leaf($1, UNION); }
   ;


member_specification:
     member_declaration member_specification_opt           { $$ = makeTreeNode(MEMBER_SPECIFICATION, "member_specification1", 2, $1, $2); }
   | access_specifier COLON member_specification_opt           { $$ = makeTreeNode(MEMBER_SPECIFICATION, "member_specification2", 3, $1, leaf($2, COLON), $3); }
   ;


member_declaration:
     decl_specifier_seq member_declarator_list SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration1", 3, $1, $2, leaf($3, SEMIC)); }
   | decl_specifier_seq SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration2", 2, $1, leaf($2, SEMIC)); }
   | member_declarator_list SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration3", 2, $1, leaf($2, SEMIC)); }
   | SEMIC           { $$ = leaf($1, SEMIC); }
   | function_definition SEMICOLON_opt           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration4", 2, $1, $2); }
   | qualified_id SEMIC           { $$ = makeTreeNode(MEMBER_DECLARATION, "member_declaration5", 2, $1, leaf($2, SEMIC)); }
   | using_declaration           { $$ = $1; }
   ;


member_declarator_list:
     member_declarator           { $$ = $1; }
   | member_declarator_list COMMA member_declarator           { $$ = makeTreeNode(MEMBER_DECLARATOR_LIST, "member_declarator_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


member_declarator:
     declarator           { $$ = $1;}
   | declarator pure_specifier           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator1", 2, $1, $2); }
   | declarator constant_initializer           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator2", 2, $1, $2); }
   | identifier COLON constant_expression           { $$ = makeTreeNode(MEMBER_DECLARATOR, "member_declarator3", 3, $1, leaf($2, COLON), $3); }
   ;


pure_specifier:
    EQ ZERO           { $$ = makeTreeNode(PURE_SPECIFIER, "pure_specifier1", 2, leaf($1, EQ), leaf($2, ZERO)); }
   ;


constant_initializer:
     EQ constant_expression           { $$ = makeTreeNode(CONSTANT_INITIALIZER, "constant_initializer1", 2, leaf($1, EQ), $2); }
   ;


/*----------------------------------------------------------------------
 * Derived classes.
 *----------------------------------------------------------------------*/
   
base_clause:
     COLON base_specifier_list           { $$ = makeTreeNode(BASE_CLAUSE, "base_clause1", 2, leaf($1, COLON), $2); }
   ;


base_specifier_list:
     base_specifier           { $$ = $1; }
   | base_specifier_list COMMA base_specifier           { $$ = makeTreeNode(BASE_SPECIFIER_LIST, "base_specifier_list1", 3, $1, leaf($2, COMMA), $3); }
   ;


base_specifier:
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
   ;


access_specifier:
     PRIVATE           { $$ = leaf($1, PRIVATE); }
   | PROTECTED           { $$ = leaf($1, PROTECTED); }
   | PUBLIC           { $$ = leaf($1, PUBLIC); }
   ;

/*----------------------------------------------------------------------
 * Special member functions.
 *----------------------------------------------------------------------*/
   
conversion_function_id:
     OPERATOR conversion_type_id           { $$ = makeTreeNode(CONVERSION_FUNCTION_ID, "conversion_function_id1", 2, leaf($1, OPERATOR), $2); }
   ;


conversion_type_id:
     type_specifier_seq conversion_declarator_opt           { $$ = makeTreeNode(CONVERSION_TYPE_ID, "conversion_type_id1", 2, $1, $2); }
   ;


conversion_declarator:
     ptr_operator conversion_declarator_opt           { $$ = makeTreeNode(CONVERSION_DECLARATOR, "conversion_declarator1", 2, $1, $2); }
   ;


ctor_initializer:
     COLON mem_initializer_list           { $$ = makeTreeNode(CTOR_INITIALIZER, "ctor_initializer1", 2, leaf($1, COLON), $2); }
   ;


mem_initializer_list:
     mem_initializer           { $$ = $1; }
   | mem_initializer COMMA mem_initializer_list           { $$ = makeTreeNode(MEM_INITIALIZER_LIST, "mem_initializer_list1", 3, $1, leaf($2, COLON), $3); }
   ;


mem_initializer:
     mem_initializer_id LPAREN expression_list_opt RPAREN           { $$ = makeTreeNode(MEM_INITIALIZER, "mem_initializer1", 4, $1, leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   ;


mem_initializer_id:
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id1", 3, leaf($1, COLONCOLON), $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id2", 2, leaf($1, COLONCOLON), $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(MEM_INITIALIZER_ID, "mem_initializer_id3", 2, $1, $2); }
   | class_name           { $$ = $1; }
   | identifier           { $$ = $1; }
   ;

/*----------------------------------------------------------------------
 * Overloading.
 *----------------------------------------------------------------------*/
   
operator_function_id:
     OPERATOR operator           { $$ = makeTreeNode(OPERATOR_FUNCTION_ID, "operator_function_id1", 2, leaf($1, OPERATOR), $2); }
   ;


operator:
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
   ;



/*----------------------------------------------------------------------
 * Exception handling.
 *----------------------------------------------------------------------*/
   
try_block:
     TRY compound_statement handler_seq           { $$ = makeTreeNode(TRY_BLOCK, "try_block1", 3, leaf($1, TRY), $2, $3); }
   ;


function_try_block:
     TRY ctor_initializer_opt function_body handler_seq           { $$ = makeTreeNode(FUNCTION_TRY_BLOCK, "function_try_block1", 4, leaf($1, TRY), $2, $3, $4); }
   ;


handler_seq:
     handler handler_seq_opt           { $$ = makeTreeNode(HANDLER_SEQ, "handler_seq1", 2, $1, $2); }
   ;


handler:
     CATCH LPAREN exception_declaration RPAREN compound_statement           { $$ = makeTreeNode(HANDLER, "handler1", 5, leaf($1, CATCH), leaf($2, LPAREN), $3, leaf($4, RPAREN), $5); }
   ;


exception_declaration:
     type_specifier_seq declarator           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration1", 2, $1, $2); }
   | type_specifier_seq abstract_declarator           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration2", 2, $1, $2); }
   | type_specifier_seq           { $$ = makeTreeNode(EXCEPTION_DECLARATION, "exception_declaration3", 1, $1); }
   | ELLIPSIS           { $$ = leaf($1, ELLIPSIS); }
   ;


throw_expression:
     THROW assignment_expression_opt           { $$ = makeTreeNode(THROW_EXPRESSION, "throw_expression1", 2, leaf($1, THROW), $2); }
   ;


exception_specification:
     THROW LPAREN type_id_list_opt RPAREN           { $$ = makeTreeNode(EXCEPTION_SPECIFICATION, "exception_specification1", 4, leaf($1, THROW), leaf($2, LPAREN), $3, leaf($4, RPAREN)); }
   ;


type_id_list:
     type_id           { $$ = $1; }
   | type_id_list COMMA type_id           { $$ = makeTreeNode(TYPE_ID_LIST, "type_id_list1", 3, $1, leaf($2, COMMA), $3); }
   ;

/*----------------------------------------------------------------------
 * Epsilon (optional) definitions.
 *----------------------------------------------------------------------*/
   
declaration_seq_opt:
     /* epsilon */          { $$ = makeTreeNode(DECLARATION_SEQ_OPT, "declaration_seq_opt1", 0); }
   | declaration_seq           { $$ = $1; }
   ;


nested_name_specifier_opt:
     /* epsilon */          { $$ = makeTreeNode(NESTED_NAME_SPECIFIER_OPT, "nested_name_specifier_opt1", 0); }
   | nested_name_specifier           { $$ = $1; }
   ;


expression_list_opt:
     /* epsilon */          { $$ = makeTreeNode(EXPRESSION_LIST_OPT, "expression_list_opt1", 0); }
   | expression_list           { $$ = $1; }
   ;


COLONCOLON_opt:
     /* epsilon */          { $$ = makeTreeNode(COLONCOLON_OPT, "COLONCOLON_opt1", 0); }
   | COLONCOLON           { $$ = leaf($1, COLONCOLON);}
   ;


new_placement_opt:
     /* epsilon */          { $$ = makeTreeNode(NEW_PLACEMENT_OPT, "new_placement_opt1", 0); }
   | new_placement           { $$ = $1; }
   ;


new_initializer_opt:
     /* epsilon */          { $$ = makeTreeNode(NEW_INITIALIZER_OPT, "new_initializer_opt1", 0); }
   | new_initializer           { $$ = $1; }
   ;


new_declarator_opt:
     /* epsilon */          { $$ = makeTreeNode(NEW_DECLARATOR_OPT, "new_declarator_opt1", 0); }
   | new_declarator           { $$ = $1; }
   ;


expression_opt:
     /* epsilon */          { $$ = makeTreeNode(EXPRESSION_OPT, "expression_opt1", 0); }
   | expression           { $$ = $1; }
   ;


statement_seq_opt:
     /* epsilon */          { $$ = makeTreeNode(STATEMENT_SEQ_OPT, "statement_seq_opt1", 0); }
   | statement_seq           { $$ = $1; }
   ;


condition_opt:
     /* epsilon */          { $$ = makeTreeNode(CONDITION_OPT, "condition_opt1", 0); }
   | condition           { $$ = $1; }
   ;


enumerator_list_opt:
     /* epsilon */          { $$ = makeTreeNode(ENUMERATOR_LIST_OPT, "enumerator_list_opt1", 0); }
   | enumerator_list           { $$ = $1; }
   ;


initializer_opt:
     /* epsilon */          { $$ = makeTreeNode(INITIALIZER_OPT, "initializer_opt1", 0); }
   | initializer           { $$ = $1; }
   ;


constant_expression_opt:
     /* epsilon */          { $$ = makeTreeNode(CONSTANT_EXPRESSION_OPT, "constant_expression_opt1", 0); }
   | constant_expression           { $$ = $1; }
   ;


abstract_declarator_opt:
     /* epsilon */          { $$ = makeTreeNode(ABSTRACT_DECLARATOR_OPT, "abstract_declarator_opt1", 0); }
   | abstract_declarator           { $$ = $1; }
   ;


type_specifier_seq_opt:
     /* epsilon */          { $$ = makeTreeNode(TYPE_SPECIFIER_SEQ_OPT, "type_specifier_seq_opt1", 0); }
   | type_specifier_seq           { $$ = $1; }
   ;


direct_abstract_declarator_opt:
     /* epsilon */          { $$ = makeTreeNode(DIRECT_ABSTRACT_DECLARATOR_OPT, "direct_abstract_declarator_opt1", 0); }
   | direct_abstract_declarator           { $$ = $1; }
   ;


ctor_initializer_opt:
     /* epsilon */          { $$ = makeTreeNode(CTOR_INITIALIZER_OPT, "ctor_initializer_opt1", 0); }
   | ctor_initializer           { $$ = $1; }
   ;


COMMA_opt:
     /* epsilon */          { $$ = makeTreeNode(COMMA_OPT, "COMMA_opt1", 0); }
   | COMMA           { $$ = leaf($1, COMMA); }
   ;


member_specification_opt:
     /* epsilon */          { $$ = makeTreeNode(MEMBER_SPECIFICATION_OPT, "member_specification_opt1", 0); }
   | member_specification           { $$ = $1;}
   ;


SEMICOLON_opt:
     /* epsilon */          { $$ = makeTreeNode(SEMICOLON_OPT, "SEMICOLON_opt1", 0); }
   | SEMIC           { $$ = leaf($1, SEMIC); }
   ;


conversion_declarator_opt:
     /* epsilon */          { $$ = makeTreeNode(CONVERSION_DECLARATOR_OPT, "conversion_declarator_opt1", 0); }
   | conversion_declarator           { $$ = $1; }
   ;




handler_seq_opt:
     /* epsilon */          { $$ = makeTreeNode(HANDLER_SEQ_OPT, "handler_seq_opt1", 0); }
   | handler_seq           { $$ = $1; }
   ;


assignment_expression_opt:
     /* epsilon */          { $$ = makeTreeNode(ASSIGNMENT_EXPRESSION_OPT, "assignment_expression_opt1", 0); }
   | assignment_expression           { $$ = $1; }
   ;


type_id_list_opt:
     /* epsilon */          { $$ = makeTreeNode(TYPE_ID_LIST_OPT, "type_id_list_opt1", 0); }
   | type_id_list           { $$ = $1; }
   ;

%%

/* 
 * standard yyerror to find syntax errors
 * need to add filename and lineno functionality
*/
static void yyerror(const char *s)
{
	fprintf(stderr, "ERROR: line %d, parser.error verbose output: %s\n", lineno, s);
	exit(2);
}
