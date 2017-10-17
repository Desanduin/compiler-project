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

extern char *yytext;
extern int yylex();
extern int yylineno;
int yydebug=0;

static void yyerror(char *s);


%}
%union {
   struct tree *treenode;
}

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
     TYPEDEF_NAME           { $$ = $1;; }
   ;


namespace_name:
     original_namespace_name           { $$ = $1;; }
   ;


original_namespace_name:
     NAMESPACE_NAME           { $$ = $1;; }
   ;


class_name:
     CLASS_NAME           { $$ = $1;; }
   ;


enum_name:
     ENUM_NAME           { $$ = $1;; }
   ;




identifier:
     IDENTIFIER           { $$ = $1;; }
   ;


literal:
     integer_literal           { $$ = $1;; }
   | character_literal           { $$ = $1;; }
   | floating_literal           { $$ = $1;; }
   | string_literal           { $$ = $1;; }
   | boolean_literal           { $$ = $1;; }
   ;


integer_literal:
     INTEGER           { $$ = $1; }
   ;


character_literal:
     CHARACTER           { $$ = $1; }
   ;


floating_literal:
     FLOATING           { $$ = $1; }
   ;


string_literal:
     STRING           { $$ = $1; }
   ;


boolean_literal:
     TRUE           { $$ = $1; }
   | FALSE           { $$ = $1; }
   ;

/*----------------------------------------------------------------------
 * Translation unit.
 *----------------------------------------------------------------------*/
   
translation_unit:
     declaration_seq_opt           { $$ = makeTreeNode(5, "translation_unit1", 1, $1); savedTree = $$;}
   ;

/*----------------------------------------------------------------------
 * Expressions.
 *----------------------------------------------------------------------*/
   
primary_expression:
     literal           { $$ = $1;; }
   | THIS           { $$ = $1; }
   | '(' expression ')'           { $$ = makeTreeNode(10, "primary_expression1", 3, $1, $2, $3); }
   | id_expression           { $$ = $1;; }
   ;


id_expression:
     unqualified_id           { $$ = $1; }
   | qualified_id           { $$ = $1; }
   ;


unqualified_id:
     identifier          
   | operator_function_id          
   | conversion_function_id   
   | '~' class_name           { $$ = makeTreeNode(15, "unqualified_id1", 2, $1, $2); }
   ;


qualified_id:
     nested_name_specifier unqualified_id           { $$ = makeTreeNode(20, "qualified_id1", 2, $1, $2); }
   ;


nested_name_specifier:
     class_name COLONCOLON nested_name_specifier namespace_name COLONCOLON nested_name_specifier           { $$ = makeTreeNode(25, "nested_name_specifier1", 6, $1, $2, $3, $4, $5, $6); }
   | class_name COLONCOLON           { $$ = makeTreeNode(25, "nested_name_specifier2", 2, $1, $2); }
   | namespace_name COLONCOLON           { $$ = makeTreeNode(25, "nested_name_specifier3", 2, $1, $2); }
   ;


postfix_expression:
     primary_expression          
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
   ;


expression_list:
     assignment_expression          
   | expression_list ',' assignment_expression           { $$ = makeTreeNode(35, "expression_list1", 3, $1, $2, $3); }
   ;


unary_expression:
     postfix_expression          
   | PLUSPLUS cast_expression           { $$ = makeTreeNode(40, "unary_expression1", 2, $1, $2); }
   | MINUSMINUS cast_expression           { $$ = makeTreeNode(40, "unary_expression2", 2, $1, $2); }
   | '*' cast_expression           { $$ = makeTreeNode(40, "unary_expression3", 2, $1, $2); }
   | '&' cast_expression           { $$ = makeTreeNode(40, "unary_expression4", 2, $1, $2); }
   | unary_operator cast_expression           { $$ = makeTreeNode(40, "unary_expression5", 2, $1, $2); }
   | SIZEOF unary_expression           { $$ = makeTreeNode(40, "unary_expression6", 2, $1, $2); }
   | SIZEOF '(' type_id ')'           { $$ = makeTreeNode(40, "unary_expression7", 4, $1, $2, $3, $4); }
   | new_expression          
   | delete_expression          
   ;


unary_operator:
     '+'          
   | '-'          
   | '!'           
   | '~'           
   ;


new_expression:
     NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(45, "new_expression1", 4, $1, $2, $3, $4); }
   | COLONCOLON NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(45, "new_expression2", 5, $1, $2, $3, $4, $5); }
   | NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(45, "new_expression3", 6, $1, $2, $3, $4, $5, $6); }
   | COLONCOLON NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(45, "new_expression4", 7, $1, $2, $3, $4, $5, $6, $7); }
   ;


new_placement:
     '(' expression_list ')'           { $$ = makeTreeNode(50, "new_placement1", 3, $1, $2, $3); }
   ;


new_type_id:
     type_specifier_seq new_declarator_opt           { $$ = makeTreeNode(55, "new_type_id1", 2, $1, $2); }
   ;


new_declarator:
     ptr_operator new_declarator_opt           { $$ = makeTreeNode(60, "new_declarator1", 2, $1, $2); }
   | direct_new_declarator           { $$ = $1; }
   ;


direct_new_declarator:
     '[' expression ']'           { $$ = makeTreeNode(65, "direct_new_declarator1", 3, $1, $2, $3); }
   | direct_new_declarator '[' constant_expression ']'           { $$ = makeTreeNode(65, "direct_new_declarator2", 4, $1, $2, $3, $4); }
   ;


new_initializer:
     '(' expression_list_opt ')'           { $$ = makeTreeNode(70, "new_initializer1", 3, $1, $2, $3); }
   ;


delete_expression:
     DELETE cast_expression           { $$ = makeTreeNode(75, "delete_expression1", 2, $1, $2); }
   | COLONCOLON DELETE cast_expression           { $$ = makeTreeNode(75, "delete_expression2", 3, $1, $2, $3); }
   | DELETE '[' ']' cast_expression           { $$ = makeTreeNode(75, "delete_expression3", 4, $1, $2, $3, $4); }
   | COLONCOLON DELETE '[' ']' cast_expression           { $$ = makeTreeNode(75, "delete_expression4", 5, $1, $2, $3, $4, $5); }
   ;


cast_expression:
     unary_expression           { $$ = makeTreeNode(80, "cast_expression1", 1, $1); }
   | '(' type_id ')' cast_expression           { $$ = makeTreeNode(80, "cast_expression2", 4, $1, $2, $3, $4); }
   ;


pm_expression:
     cast_expression           { $$ = $1; }
   | pm_expression DOTSTAR cast_expression           { $$ = makeTreeNode(85, "pm_expression1", 3, $1, $2, $3); }
   | pm_expression ARROWSTAR cast_expression           { $$ = makeTreeNode(85, "pm_expression2", 3, $1, $2, $3); }
   ;


multiplicative_expression:
     pm_expression           { $$ = $1; }
   | multiplicative_expression '*' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression1", 3, $1, $2, $3); }
   | multiplicative_expression '/' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression2", 3, $1, $2, $3); }
   | multiplicative_expression '%' pm_expression           { $$ = makeTreeNode(90, "multiplicative_expression3", 3, $1, $2, $3); }
   ;


additive_expression:
     multiplicative_expression           { $$ = $1; }
   | additive_expression '+' multiplicative_expression           { $$ = makeTreeNode(100, "additive_expression1", 3, $1, $2, $3); }
   | additive_expression '-' multiplicative_expression           { $$ = makeTreeNode(100, "additive_expression2", 3, $1, $2, $3); }
   ;


shift_expression:
     additive_expression           { $$ = $1; }
   | shift_expression SL additive_expression           { $$ = makeTreeNode(105, "shift_expression1", 3, $1, $2, $3); }
   | shift_expression SR additive_expression           { $$ = makeTreeNode(105, "shift_expression2", 3, $1, $2, $3); }
   ;


relational_expression:
     shift_expression           { $$ = $1; }
   | relational_expression '<' shift_expression           { $$ = makeTreeNode(110, "relational_expression1", 3, $1, $2, $3); }
   | relational_expression '>' shift_expression           { $$ = makeTreeNode(110, "relational_expression2", 3, $1, $2, $3); }
   | relational_expression LTEQ shift_expression           { $$ = makeTreeNode(110, "relational_expression3", 3, $1, $2, $3); }
   | relational_expression GTEQ shift_expression           { $$ = makeTreeNode(110, "relational_expression4", 3, $1, $2, $3); }
   ;


equality_expression:
     relational_expression           { $$ = $1; }
   | equality_expression EQ relational_expression           { $$ = makeTreeNode(115, "equality_expression1", 3, $1, $2, $3); }
   | equality_expression NOTEQ relational_expression           { $$ = makeTreeNode(115, "equality_expression2", 3, $1, $2, $3); }
   ;


and_expression:
     equality_expression           { $$ = $1;}
   | and_expression '&' equality_expression           { $$ = makeTreeNode(120, "and_expression1", 3, $1, $2, $3); }
   ;


exclusive_or_expression:
     and_expression           { $$ = $1;}
   | exclusive_or_expression '^' and_expression           { $$ = makeTreeNode(125, "exclusive_or_expression1", 3, $1, $2, $3); }
   ;


inclusive_or_expression:
     exclusive_or_expression           { $$ = $1;}
   | inclusive_or_expression '|' exclusive_or_expression           { $$ = makeTreeNode(130, "inclusive_or_expression1", 3, $1, $2, $3); }
   ;


logical_and_expression:
     inclusive_or_expression           { $$ = $1;}
   | logical_and_expression ANDAND inclusive_or_expression           { $$ = makeTreeNode(135, "logical_and_expression1", 3, $1, $2, $3); }
   ;


logical_or_expression:
     logical_and_expression           { $$ = $1;}
   | logical_or_expression OROR logical_and_expression           { $$ = makeTreeNode(140, "logical_or_expression1", 3, $1, $2, $3); }
   ;


conditional_expression:
     logical_or_expression           { $$ = $1;}
   | logical_or_expression '?' expression ':' assignment_expression           { $$ = makeTreeNode(145, "conditional_expression1", 5, $1, $2, $3, $4, $5); }
   ;


assignment_expression:
     conditional_expression           { $$ = $1;}
   | logical_or_expression assignment_operator assignment_expression           { $$ = makeTreeNode(150, "assignment_expression1", 3, $1, $2, $3); }
   | throw_expression           { $$ = $1;}
   ;


assignment_operator:
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
   ;


expression:
     assignment_expression           { $$ = $1;}
   | expression ',' assignment_expression           { $$ = makeTreeNode(155, "expression1", 3, $1, $2, $3); }
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
     identifier ':' statement           { $$ = makeTreeNode(160, "labeled_statement1", 3, $1, $2, $3); }
   | CASE constant_expression ':' statement           { $$ = makeTreeNode(160, "labeled_statement2", 4, $1, $2, $3, $4); }
   | DEFAULT ':' statement           { $$ = makeTreeNode(160, "labeled_statement3", 3, $1, $2, $3); }
   ;


expression_statement:
     expression_opt ';'           { $$ = makeTreeNode(165, "expression_statement1", 2, $1, $2); }
   ;


compound_statement:
     '{' statement_seq_opt '}'           { $$ = makeTreeNode(170, "compound_statement1", 3, $1, $2, $3); }
   ;


statement_seq:
     statement           { $$ = $1;}
   | statement_seq statement           { $$ = makeTreeNode(175, "statement_seq1", 2, $1, $2); }
   ;


selection_statement:
     IF '(' condition ')' statement           { $$ = makeTreeNode(180, "selection_statement1", 5, $1, $2, $3, $4, $5); }
   | IF '(' condition ')' statement ELSE statement           { $$ = makeTreeNode(180, "selection_statement2", 7, $1, $2, $3, $4, $5, $6, $7); }
   | SWITCH '(' condition ')' statement           { $$ = makeTreeNode(180, "selection_statement3", 5, $1, $2, $3, $4, $5); }
   ;


condition:
     expression           { $$ = $1;}
   | type_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(185, "condition1", 4, $1, $2, $3, $4); }
   ;


iteration_statement:
     WHILE '(' condition ')' statement           { $$ = makeTreeNode(190, "iteration_statement1", 5, $1, $2, $3, $4, $5); }
   | DO statement WHILE '(' expression ')' ';'           { $$ = makeTreeNode(190, "iteration_statement2", 7, $1, $2, $3, $4, $5, $6, $7); }
   | FOR '(' for_init_statement condition_opt ';' expression_opt ')' statement           { $$ = makeTreeNode(190, "iteration_statement3", 8, $1, $2, $3, $4, $5, $6, $7, $8); }
   ;


for_init_statement:
     expression_statement           { $$ = $1;}
   | simple_declaration           { $$ = $1;}
   ;


jump_statement:
     BREAK ';'           { $$ = makeTreeNode(200, "jump_statement1", 2, $1, $2); }
   | CONTINUE ';'           { $$ = makeTreeNode(200, "jump_statement2", 2, $1, $2); }
   | RETURN expression_opt ';'           { $$ = makeTreeNode(200, "jump_statement3", 3, $1, $2, $3); }
   ;


declaration_statement:
     block_declaration           { $$ = $1;}
   ;

/*----------------------------------------------------------------------
 * Declarations.
 *----------------------------------------------------------------------*/
   
declaration_seq:
     declaration           { $$ = $1;}
   | declaration_seq declaration           { $$ = makeTreeNode(205, "declaration_seq1", 2, $1, $2); }
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
     decl_specifier_seq init_declarator_list ';'           { $$ = makeTreeNode(210, "simple_declaration1", 3, $1, $2, $3); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(215, "simple_declaration2", 2, $1, $2); }
   ;


decl_specifier:
     storage_class_specifier           { $$ = $1;}
   | type_specifier           { $$ = $1;}
   | function_specifier           { $$ = $1;}
   | FRIEND           { $$ = $1;}
   | TYPEDEF           { $$ = $1;}
   ;


decl_specifier_seq:
     decl_specifier           { $$ = $1;}
   | decl_specifier_seq decl_specifier           { $$ = makeTreeNode(220, "decl_specifier_seq1", 2, $1, $2); }
   ;


storage_class_specifier:
     AUTO           { $$ = $1;}
   | REGISTER           { $$ = $1; }
   | STATIC           { $$ = $1; }
   | EXTERN           { $$ = $1; }
   | MUTABLE           { $$ = $1; }
   ;


function_specifier:
     INLINE           { $$ = $1; }
   | VIRTUAL           { $$ = $1; }
   | EXPLICIT           { $$ = $1; }
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
   ;


type_name:
     class_name           { $$ = $1; }
   | enum_name           { $$ = $1; }
   | typedef_name           { $$ = $1; }
   ;


elaborated_type_specifier:
     class_key COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier1", 4, $1, $2, $3, $4); }
   | class_key COLONCOLON identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier2", 3, $1, $2, $3); }
   | ENUM COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier3", 4, $1, $2, $3, $4); }
   | ENUM COLONCOLON identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier4", 3, $1, $2, $3); }
   | ENUM nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier5", 3, $1, $2, $3); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier           { $$ = makeTreeNode(230, "elaborated_type_specifier6", 4, $1, $2, $3, $4); }
   ;


enum_specifier:
     ENUM identifier '{' enumerator_list_opt '}'           { $$ = makeTreeNode(235, "enum_specifier1", 5, $1, $2, $3, $4, $5); }
   ;


enumerator_list:
     enumerator_definition           { $$ = $1;}
   | enumerator_list ',' enumerator_definition           { $$ = makeTreeNode(240, "enumerator_list1", 3, $1, $2, $3); }
   ;


enumerator_definition:
     enumerator           { $$ = $1; }
   | enumerator '=' constant_expression           { $$ = makeTreeNode(245, "enumerator_definition1", 3, $1, $2, $3); }
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
     NAMESPACE identifier '{' namespace_body '}'           { $$ = makeTreeNode(250, "original_namespace_definition1", 5, $1, $2, $3, $4, $5); }
   ;


extension_namespace_definition:
     NAMESPACE original_namespace_name '{' namespace_body '}'           { $$ = makeTreeNode(255, "extension_namespace_definition1", 5, $1, $2, $3, $4, $5); }
   ;


unnamed_namespace_definition:
     NAMESPACE '{' namespace_body '}'           { $$ = makeTreeNode(260, "unnamed_namespace_definition1", 4, $1, $2, $3, $4); }
   ;


namespace_body:
     declaration_seq_opt           { $$ = $1;}
   ;


namespace_alias_definition:
     NAMESPACE identifier '=' qualified_namespace_specifier ';'           { $$ = makeTreeNode(265, "namespace_alias_definition1", 5, $1, $2, $3, $4, $5); }
   ;


qualified_namespace_specifier:
     COLONCOLON nested_name_specifier namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier1", 3, $1, $2, $3); }
   | COLONCOLON namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier2", 2, $1, $2); }
   | nested_name_specifier namespace_name           { $$ = makeTreeNode(270, "qualified_namespace_specifier3", 2, $1, $2); }
   | namespace_name           { $$ = $1; }
   ;


using_declaration:
     USING TYPENAME COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration1", 6, $1, $2, $3, $4, $5, $6); }
   | USING TYPENAME nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration2", 5, $1, $2, $3, $4, $5); }
   | USING COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration3", 5, $1, $2, $3, $4, $5); }
   | USING nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration4", 4, $1, $2, $3, $4); }
   | USING COLONCOLON unqualified_id ';'           { $$ = makeTreeNode(275, "using_declaration5", 4, $1, $2, $3, $4); }
   ;


using_directive:
     USING NAMESPACE COLONCOLON nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(280, "using_directive1", 6, $1, $2, $3, $4, $5, $6); }
   | USING NAMESPACE COLONCOLON namespace_name ';'           { $$ = makeTreeNode(280, "using_directive2", 5, $1, $2, $3, $4, $5); }
   | USING NAMESPACE nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(280, "using_directive3", 5, $1, $2, $3, $4, $5); }
   | USING NAMESPACE namespace_name ';'           { $$ = makeTreeNode(280, "using_directive4", 4, $1, $2, $3, $4); }
   ;


asm_definition:
     ASM '(' string_literal ')' ';'           { $$ = makeTreeNode(285, "asm_definition1", 5, $1, $2, $3, $4, $5); }
   ;


linkage_specification:
     EXTERN string_literal '{' declaration_seq_opt '}'           { $$ = makeTreeNode(290, "linkage_specification1", 5, $1, $2, $3, $4, $5); }
   | EXTERN string_literal declaration           { $$ = makeTreeNode(290, "linkage_specification2", 3, $1, $2, $3); }
   ;

/*----------------------------------------------------------------------
 * Declarators.
 *----------------------------------------------------------------------*/
   
init_declarator_list:
     init_declarator           { $$ = $1;}
   | init_declarator_list ',' init_declarator           { $$ = makeTreeNode(295, "init_declarator_list1", 3, $1, $2, $3); }
   ;


init_declarator:
     declarator initializer_opt           { $$ = makeTreeNode(300, "init_declarator1", 2, $1, $2); }
   ;


declarator:
     direct_declarator           { $$ = $1;}
   | ptr_operator declarator           { $$ = makeTreeNode(305, "declarator1", 2, $1, $2); }
   ;


direct_declarator:
     declarator_id           { $$ = $1; }
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(310, "direct_declarator1", 6, $1, $2, $3, $4, $5, $6); }
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(310, "direct_declarator2", 5, $1, $2, $3, $4, $5); }
   | direct_declarator '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(310, "direct_declarator3", 5, $1, $2, $3, $4, $5); }
   | direct_declarator '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator4", 4, $1, $2, $3, $4); }
   | CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator5", 4, $1, $2, $3, $4); }
   | CLASS_NAME COLONCOLON declarator_id '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator6", 6, $1, $2, $3, $4, $5, $6); }
   | CLASS_NAME COLONCOLON CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(310, "direct_declarator7", 6, $1, $2, $3, $4, $5, $6); }
   | direct_declarator '[' constant_expression_opt ']'           { $$ = makeTreeNode(310, "direct_declarator8", 4, $1, $2, $3, $4); }
   | '(' declarator ')'           { $$ = makeTreeNode(310, "direct_declarator9", 3, $1, $2, $3); }
   ;


ptr_operator:
     '*'           { $$ = $1;}
   | '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator1", 2, $1, $2); }
   | '&'           { $$ = $1; }
   | nested_name_specifier '*'           { $$ = makeTreeNode(315, "ptr_operator2", 2, $1, $2); }
   | nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator3", 3, $1, $2, $3); }
   | COLONCOLON nested_name_specifier '*'           { $$ = makeTreeNode(315, "ptr_operator4", 3, $1, $2, $3); }
   | COLONCOLON nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(315, "ptr_operator5", 4, $1, $2, $3, $4); }
   ;


cv_qualifier_seq:
     cv_qualifier           { $$ = $1; }
   | cv_qualifier cv_qualifier_seq           { $$ = makeTreeNode(320, "cv_qualifier_seq1", 2, $1, $2); }
   ;


cv_qualifier:
     CONST           { $$ = $1; }
   | VOLATILE           { $$ = $1; }
   ;


declarator_id:
     id_expression           { $$ = $1; }
   | COLONCOLON id_expression           { $$ = makeTreeNode(325, "declarator_id1", 2, $1, $2); }
   | COLONCOLON nested_name_specifier type_name           { $$ = makeTreeNode(325, "declarator_id2", 3, $1, $2, $3); }
   | COLONCOLON type_name           { $$ = makeTreeNode(325, "declarator_id3", 2, $1, $2); }
   ;


type_id:
     type_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(330, "type_id1", 2, $1, $2); }
   ;


type_specifier_seq:
     type_specifier type_specifier_seq_opt           { $$ = makeTreeNode(335, "type_specifier_seq1", 2, $1, $2); }
   ;


abstract_declarator:
     ptr_operator abstract_declarator_opt           { $$ = makeTreeNode(340, "abstract_declarator1", 2, $1, $2); }
   | direct_abstract_declarator           { $$ = $1;}
   ;


direct_abstract_declarator:
     direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(345, "direct_abstract_declarator1", 6, $1, $2, $3, $4, $5, $6); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(345, "direct_abstract_declarator2", 5, $1, $2, $3, $4, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(345, "direct_abstract_declarator3", 5, $1, $2, $3, $4, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(345, "direct_abstract_declarator4", 4, $1, $2, $3, $4); }
   | direct_abstract_declarator_opt '[' constant_expression_opt ']'           { $$ = makeTreeNode(345, "direct_abstract_declarator5", 4, $1, $2, $3, $4); }
   | '(' abstract_declarator ')'           { $$ = makeTreeNode(345, "direct_abstract_declarator6", 3, $1, $2, $3); }
   ;


parameter_declaration_clause:
     parameter_declaration_list ELLIPSIS           { $$ = NULL;}
   | parameter_declaration_list           { $$ = $1;}
   | ELLIPSIS           { $$ = NULL;}
   |     /* epsilon */          { $$ = NULL; }
   | parameter_declaration_list ',' ELLIPSIS           { $$ = NULL; }
   ;


parameter_declaration_list:
     parameter_declaration           { $$ = $1;}
   | parameter_declaration_list ',' parameter_declaration           { $$ = makeTreeNode(350, "parameter_declaration_list1", 3, $1, $2, $3); }
   ;


parameter_declaration:
     decl_specifier_seq declarator           { $$ = makeTreeNode(355, "parameter_declaration1", 2, $1, $2); }
   | decl_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(355, "parameter_declaration2", 4, $1, $2, $3, $4); }
   | decl_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(355, "parameter_declaration3", 2, $1, $2); }
   | decl_specifier_seq abstract_declarator_opt '=' assignment_expression           { $$ = makeTreeNode(355, "parameter_declaration4", 4, $1, $2, $3, $4); }
   ;


function_definition:
     declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(360, "function_definition1", 3, $1, $2, $3); }
   | decl_specifier_seq declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(360, "function_definition2", 4, $1, $2, $3, $4); }
   | declarator function_try_block           { $$ = makeTreeNode(360, "function_definition3", 2, $1, $2); }
   | decl_specifier_seq declarator function_try_block           { $$ = makeTreeNode(360, "function_definition4", 3, $1, $2, $3); }
   ;


function_body:
     compound_statement           { $$ = $1;}
   ;


initializer:
     '=' initializer_clause           { $$ = makeTreeNode(365, "initializer1", 2, $1, $2); }
   | '(' expression_list ')'           { $$ = makeTreeNode(365, "initializer2", 3, $1, $2, $3); }
   ;


initializer_clause:
     assignment_expression           { $$ = $1; }
   | '{' initializer_list COMMA_opt '}'           { $$ = makeTreeNode(370, "initializer_clause1", 4, $1, $2, $3, $4); }
   | '{' '}'           { $$ = makeTreeNode(370, "initializer_clause2", 2, $1, $2); }
   ;


initializer_list:
     initializer_clause           { $$ = $1; }
   | initializer_list ',' initializer_clause           { $$ = makeTreeNode(375, "initializer_list1", 3, $1, $2, $3); }
   ;


/*----------------------------------------------------------------------
 * Classes.
 *----------------------------------------------------------------------*/
   
class_specifier:
     class_head '{' member_specification_opt '}'           { $$ = makeTreeNode(380, "class_specifier1", 4, $1, $2, $3, $4); }
   ;


class_head:
     class_key identifier           { $$ = makeTreeNode(385, "class_head1", 2, $1, $2); }
   | class_key identifier base_clause           { $$ = makeTreeNode(385, "class_head2", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier           { $$ = makeTreeNode(385, "class_head3", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier base_clause           { $$ = makeTreeNode(385, "class_head4", 4, $1, $2, $3, $4); }
   ;


class_key:
     CLASS           { $$ = $1; }
   | STRUCT           { $$ = $1; }
   | UNION           { $$ = $1; }
   ;


member_specification:
     member_declaration member_specification_opt           { $$ = makeTreeNode(390, "member_specification1", 2, $1, $2); }
   | access_specifier ':' member_specification_opt           { $$ = makeTreeNode(390, "member_specification2", 3, $1, $2, $3); }
   ;


member_declaration:
     decl_specifier_seq member_declarator_list ';'           { $$ = makeTreeNode(400, "member_declaration1", 3, $1, $2, $3); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(400, "member_declaration2", 2, $1, $2); }
   | member_declarator_list ';'           { $$ = makeTreeNode(400, "member_declaration3", 2, $1, $2); }
   | ';'           { $$ = $1; }
   | function_definition SEMICOLON_opt           { $$ = makeTreeNode(400, "member_declaration4", 2, $1, $2); }
   | qualified_id ';'           { $$ = makeTreeNode(400, "member_declaration5", 2, $1, $2); }
   | using_declaration           { $$ = $1; }
   ;


member_declarator_list:
     member_declarator           { $$ = $1; }
   | member_declarator_list ',' member_declarator           { $$ = makeTreeNode(405, "member_declarator_list1", 3, $1, $2, $3); }
   ;


member_declarator:
     declarator           { $$ = $1;}
   | declarator pure_specifier           { $$ = makeTreeNode(410, "member_declarator1", 2, $1, $2); }
   | declarator constant_initializer           { $$ = makeTreeNode(410, "member_declarator2", 2, $1, $2); }
   | identifier ':' constant_expression           { $$ = makeTreeNode(410, "member_declarator3", 3, $1, $2, $3); }
   ;


pure_specifier:
     '=' '0'           { $$ = NULL; }
   ;


constant_initializer:
     '=' constant_expression           { $$ = makeTreeNode(415, "constant_initializer1", 2, $1, $2); }
   ;


/*----------------------------------------------------------------------
 * Derived classes.
 *----------------------------------------------------------------------*/
   
base_clause:
     ':' base_specifier_list           { $$ = makeTreeNode(420, "base_clause1", 2, $1, $2); }
   ;


base_specifier_list:
     base_specifier           { $$ = $1; }
   | base_specifier_list ',' base_specifier           { $$ = makeTreeNode(425, "base_specifier_list1", 3, $1, $2, $3); }
   ;


base_specifier:
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
   ;


access_specifier:
     PRIVATE           { $$ = $1; }
   | PROTECTED           { $$ = $1; }
   | PUBLIC           { $$ = $1; }
   ;

/*----------------------------------------------------------------------
 * Special member functions.
 *----------------------------------------------------------------------*/
   
conversion_function_id:
     OPERATOR conversion_type_id           { $$ = makeTreeNode(435, "conversion_function_id1", 2, $1, $2); }
   ;


conversion_type_id:
     type_specifier_seq conversion_declarator_opt           { $$ = makeTreeNode(440, "conversion_type_id1", 2, $1, $2); }
   ;


conversion_declarator:
     ptr_operator conversion_declarator_opt           { $$ = makeTreeNode(445, "conversion_declarator1", 2, $1, $2); }
   ;


ctor_initializer:
     ':' mem_initializer_list           { $$ = makeTreeNode(450, "ctor_initializer1", 2, $1, $2); }
   ;


mem_initializer_list:
     mem_initializer           { $$ = $1; }
   | mem_initializer ',' mem_initializer_list           { $$ = makeTreeNode(455, "mem_initializer_list1", 3, $1, $2, $3); }
   ;


mem_initializer:
     mem_initializer_id '(' expression_list_opt ')'           { $$ = makeTreeNode(450, "mem_initializer1", 4, $1, $2, $3, $4); }
   ;


mem_initializer_id:
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(500, "mem_initializer_id1", 3, $1, $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(500, "mem_initializer_id2", 2, $1, $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(500, "mem_initializer_id3", 2, $1, $2); }
   | class_name           { $$ = $1; }
   | identifier           { $$ = $1; }
   ;

/*----------------------------------------------------------------------
 * Overloading.
 *----------------------------------------------------------------------*/
   
operator_function_id:
     OPERATOR operator           { $$ = makeTreeNode(505, "operator_function_id1", 2, $1, $2); }
   ;


operator:
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
   ;



/*----------------------------------------------------------------------
 * Exception handling.
 *----------------------------------------------------------------------*/
   
try_block:
     TRY compound_statement handler_seq           { $$ = makeTreeNode(515, "try_block1", 3, $1, $2, $3); }
   ;


function_try_block:
     TRY ctor_initializer_opt function_body handler_seq           { $$ = makeTreeNode(520, "function_try_block1", 4, $1, $2, $3, $4); }
   ;


handler_seq:
     handler handler_seq_opt           { $$ = makeTreeNode(525, "handler_seq1", 2, $1, $2); }
   ;


handler:
     CATCH '(' exception_declaration ')' compound_statement           { $$ = makeTreeNode(530, "handler1", 5, $1, $2, $3, $4, $5); }
   ;


exception_declaration:
     type_specifier_seq declarator           { $$ = makeTreeNode(535, "exception_declaration1", 2, $1, $2); }
   | type_specifier_seq abstract_declarator           { $$ = makeTreeNode(535, "exception_declaration2", 2, $1, $2); }
   | type_specifier_seq           { $$ = makeTreeNode(535, "exception_declaration3", 1, $1); }
   | ELLIPSIS           { $$ = $1; }
   ;


throw_expression:
     THROW assignment_expression_opt           { $$ = makeTreeNode(540, "throw_expression1", 2, $1, $2); }
   ;


exception_specification:
     THROW '(' type_id_list_opt ')'           { $$ = makeTreeNode(545, "exception_specification1", 4, $1, $2, $3, $4); }
   ;


type_id_list:
     type_id           { $$ = $1; }
   | type_id_list ',' type_id           { $$ = makeTreeNode(550, "type_id_list1", 3, $1, $2, $3); }
   ;

/*----------------------------------------------------------------------
 * Epsilon (optional) definitions.
 *----------------------------------------------------------------------*/
   
declaration_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | declaration_seq           { $$ = $1; }
   ;


nested_name_specifier_opt:
     /* epsilon */          { $$ = NULL; }
   | nested_name_specifier           { $$ = $1; }
   ;


expression_list_opt:
     /* epsilon */          { $$ = NULL; }
   | expression_list           { $$ = $1; }
   ;


COLONCOLON_opt:
     /* epsilon */          { $$ = NULL; }
   | COLONCOLON           { $$ = $1;}
   ;


new_placement_opt:
     /* epsilon */          { $$ = NULL; }
   | new_placement           { $$ = $1; }
   ;


new_initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | new_initializer           { $$ = $1; }
   ;


new_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | new_declarator           { $$ = $1; }
   ;


expression_opt:
     /* epsilon */          { $$ = NULL; }
   | expression           { $$ = $1; }
   ;


statement_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | statement_seq           { $$ = $1; }
   ;


condition_opt:
     /* epsilon */          { $$ = NULL; }
   | condition           { $$ = $1; }
   ;


enumerator_list_opt:
     /* epsilon */          { $$ = NULL; }
   | enumerator_list           { $$ = $1; }
   ;


initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | initializer           { $$ = $1; }
   ;


constant_expression_opt:
     /* epsilon */          { $$ = NULL; }
   | constant_expression           { $$ = $1; }
   ;


abstract_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | abstract_declarator           { $$ = $1; }
   ;


type_specifier_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | type_specifier_seq           { $$ = $1; }
   ;


direct_abstract_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | direct_abstract_declarator           { $$ = $1; }
   ;


ctor_initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | ctor_initializer           { $$ = $1; }
   ;


COMMA_opt:
     /* epsilon */          { $$ = NULL; }
   | ','           { $$ = $1; }
   ;


member_specification_opt:
     /* epsilon */          { $$ = NULL; }
   | member_specification           { $$ = $1;}
   ;


SEMICOLON_opt:
     /* epsilon */          { $$ = NULL; }
   | ';'           { $$ = $1; }
   ;


conversion_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | conversion_declarator           { $$ = $1; }
   ;




handler_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | handler_seq           { $$ = $1; }
   ;


assignment_expression_opt:
     /* epsilon */          { $$ = NULL; }
   | assignment_expression           { $$ = $1; }
   ;


type_id_list_opt:
     /* epsilon */          { $$ = NULL; }
   | type_id_list           { $$ = $1; }
   ;

%%

/* 
 * standard yyerror to find syntax errors
 * need to add filename and lineno functionality
*/
static void yyerror(char *s)
{
	fprintf(stderr, "syntax error on line %d, string: %s\n", yylineno, s);
	exit(2);
}
