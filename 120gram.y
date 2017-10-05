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
#include "structset.h"

extern char *yytext;
extern int yylex();
int yydebug=0;

static void yyerror(char *s);


%}
%union {
   struct token *n;
   struct tree *treenode;
}

%type <treenode> typedef_name
%type <treenode> namespace_name
%type <treenode> original_namespace_name
%type <treenode> class_name
%type <treenode> enum_name
%type <treenode> template_name
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
%type <treenode> template_declaration
%type <treenode> template_parameter_list
%type <treenode> template_parameter
%type <treenode> type_parameter
%type <treenode> template_id
%type <treenode> template_argument_list
%type <treenode> template_argument
%type <treenode> explicit_instantiation
%type <treenode> explicit_specialization
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
%type <treenode> EXPORT_opt
%type <treenode> handler_seq_opt
%type <treenode> assignment_expression_opt
%type <treenode> type_id_list_opt

%token <n> IDENTIFIER INTEGER FLOATING CHARACTER STRING
%token <n> TYPEDEF_NAME NAMESPACE_NAME CLASS_NAME ENUM_NAME TEMPLATE_NAME

%token <n> ELLIPSIS COLONCOLON DOTSTAR ADDEQ SUBEQ MULEQ DIVEQ MODEQ
%token <n> XOREQ ANDEQ OREQ SL SR SREQ SLEQ EQ NOTEQ LTEQ GTEQ ANDAND OROR
%token <n> PLUSPLUS MINUSMINUS ARROWSTAR ARROW

%token <n> ASM AUTO BOOL BREAK CASE CATCH CHAR CLASS CONST CONST_CAST CONTINUE
%token <n> DEFAULT DELETE DO DOUBLE DYNAMIC_CAST ELSE ENUM EXPLICIT EXPORT EXTERN
%token <n> FALSE FLOAT FOR FRIEND IF INLINE INT LONG MUTABLE NAMESPACE NEW
%token <n> OPERATOR PRIVATE PROTECTED PUBLIC REGISTER REINTERPRET_CAST RETURN
%token <n> SHORT SIGNED SIZEOF STATIC STATIC_CAST STRUCT SWITCH TEMPLATE THIS
%token <n> THROW TRUE TRY TYPEDEF TYPEID TYPENAME UNION UNSIGNED USING VIRTUAL
%token <n> VOID VOLATILE WCHAR_T WHILE

%start translation_unit



%%

/*
 * makeTreeNode placements helpfully provided by the script gramtree.m
 * gramtree.m was provided by a student in CS445, with a link in Dr. J's
 * lecture notes, at the start of Lecture 23
*/

/*----------------------------------------------------------------------
 * Context-dependent identifiers.
 *----------------------------------------------------------------------*/

typedef_name:
     TYPEDEF_NAME           { $$ = makeTreeNode(def_typedef_name, "typedef_name:", 1, NULL); }
   ;


namespace_name:
     original_namespace_name           { $$ = makeTreeNode(def_namespace_name, "namespace_name:", 1, $1); }
   ;


original_namespace_name:
     NAMESPACE_NAME           { $$ = makeTreeNode(def_original_namespace_name, "original_namespace_name:", 1, NULL); }
   ;


class_name:
     CLASS_NAME           { $$ = makeTreeNode(def_class_name, "class_name:", 1, NULL); }
   | template_id           { $$ = makeTreeNode(def_class_name, "class_name:", 1, $1); }
   ;


enum_name:
     ENUM_NAME           { $$ = makeTreeNode(def_enum_name, "enum_name:", 1, NULL); }
   ;


template_name:
     TEMPLATE_NAME           { $$ = makeTreeNode(def_template_name, "template_name:", 1, NULL); }
   ;


identifier:
     IDENTIFIER           { $$ = makeTreeNode(def_identifier, "identifier:", 1, NULL); }
   ;


literal:
     integer_literal           { $$ = makeTreeNode(def_literal, "literal:", 1, $1); }
   | character_literal           { $$ = makeTreeNode(def_literal, "literal:", 1, $1); }
   | floating_literal           { $$ = makeTreeNode(def_literal, "literal:", 1, $1); }
   | string_literal           { $$ = makeTreeNode(def_literal, "literal:", 1, $1); }
   | boolean_literal           { $$ = makeTreeNode(def_literal, "literal:", 1, $1); }
   ;


integer_literal:
     INTEGER           { $$ = makeTreeNode(def_integer_literal, "integer_literal:", 1, NULL); }
   ;


character_literal:
     CHARACTER           { $$ = makeTreeNode(def_character_literal, "character_literal:", 1, NULL); }
   ;


floating_literal:
     FLOATING           { $$ = makeTreeNode(def_floating_literal, "floating_literal:", 1, NULL); }
   ;


string_literal:
     STRING           { $$ = makeTreeNode(def_string_literal, "string_literal:", 1, NULL); }
   ;


boolean_literal:
     TRUE           { $$ = makeTreeNode(def_boolean_literal, "boolean_literal:", 1, NULL); }
   | FALSE           { $$ = makeTreeNode(def_boolean_literal, "boolean_literal:", 1, NULL); }
   ;

/*----------------------------------------------------------------------
 * Translation unit.
 *----------------------------------------------------------------------*/
   
translation_unit:
     declaration_seq_opt           { $$ = makeTreeNode(def_translation_unit, "translation_unit:", 1, $1); savedTree = $$;}
   ;

/*----------------------------------------------------------------------
 * Expressions.
 *----------------------------------------------------------------------*/
   
primary_expression:
     literal           { $$ = makeTreeNode(def_primary_expression, "primary_expression:", 1, $1); }
   | THIS           { $$ = makeTreeNode(def_primary_expression, "primary_expression:", 1, NULL); }
   | '(' expression ')'           { $$ = makeTreeNode(def_primary_expression, "primary_expression:", 3, NULL, $2, NULL); }
   | id_expression           { $$ = makeTreeNode(def_primary_expression, "primary_expression:", 1, $1); }
   ;


id_expression:
     unqualified_id           { $$ = makeTreeNode(def_id_expression, "id_expression:", 1, $1); }
   | qualified_id           { $$ = makeTreeNode(def_id_expression, "id_expression:", 1, $1); }
   ;


unqualified_id:
     identifier           { $$ = makeTreeNode(def_unqualified_id, "unqualified_id:", 1, $1); }
   | operator_function_id           { $$ = makeTreeNode(def_unqualified_id, "unqualified_id:", 1, $1); }
   | conversion_function_id           { $$ = makeTreeNode(def_unqualified_id, "unqualified_id:", 1, $1); }
   | '~' class_name           { $$ = makeTreeNode(def_unqualified_id, "unqualified_id:", 2, NULL, $2); }
   ;


qualified_id:
     nested_name_specifier unqualified_id           { $$ = makeTreeNode(def_qualified_id, "qualified_id:", 2, $1, $2); }
   | nested_name_specifier TEMPLATE unqualified_id           { $$ = makeTreeNode(def_qualified_id, "qualified_id:", 3, $1, NULL, $3); }
   ;


nested_name_specifier:
     class_name COLONCOLON nested_name_specifier namespace_name COLONCOLON nested_name_specifier           { $$ = makeTreeNode(def_nested_name_specifier, "nested_name_specifier:", 6, $1, NULL, $3, $4, NULL, $6); }
   | class_name COLONCOLON           { $$ = makeTreeNode(def_nested_name_specifier, "nested_name_specifier:", 2, $1, NULL); }
   | namespace_name COLONCOLON           { $$ = makeTreeNode(def_nested_name_specifier, "nested_name_specifier:", 2, $1, NULL); }
   ;


postfix_expression:
     primary_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 1, $1); }
   | postfix_expression '[' expression ']'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, $3, NULL); }
   | postfix_expression '(' expression_list_opt ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, $3, NULL); }
   | DOUBLE '(' expression_list_opt ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   | INT '(' expression_list_opt ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   | CHAR '(' expression_list_opt ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   | BOOL '(' expression_list_opt ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   | postfix_expression '.' TEMPLATE COLONCOLON id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 5, $1, NULL, NULL, NULL, $5); }
   | postfix_expression '.' TEMPLATE id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, NULL, $4); }
   | postfix_expression '.' COLONCOLON id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, NULL, $4); }
   | postfix_expression '.' id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 3, $1, NULL, $3); }
   | postfix_expression ARROW TEMPLATE COLONCOLON id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 5, $1, NULL, NULL, NULL, $5); }
   | postfix_expression ARROW TEMPLATE id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, NULL, $4); }
   | postfix_expression ARROW COLONCOLON id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, $1, NULL, NULL, $4); }
   | postfix_expression ARROW id_expression           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 3, $1, NULL, $3); }
   | postfix_expression PLUSPLUS           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 2, $1, NULL); }
   | postfix_expression MINUSMINUS           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 2, $1, NULL); }
   | DYNAMIC_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 7, NULL, NULL, $3, NULL, NULL, $6, NULL); }
   | STATIC_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 7, NULL, NULL, $3, NULL, NULL, $6, NULL); }
   | REINTERPRET_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 7, NULL, NULL, $3, NULL, NULL, $6, NULL); }
   | CONST_CAST '<' type_id '>' '(' expression ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 7, NULL, NULL, $3, NULL, NULL, $6, NULL); }
   | TYPEID '(' expression ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   | TYPEID '(' type_id ')'           { $$ = makeTreeNode(def_postfix_expression, "postfix_expression:", 4, NULL, NULL, $3, NULL); }
   ;


expression_list:
     assignment_expression           { $$ = makeTreeNode(def_expression_list, "expression_list:", 1, $1); }
   | expression_list ',' assignment_expression           { $$ = makeTreeNode(def_expression_list, "expression_list:", 3, $1, NULL, $3); }
   ;


unary_expression:
     postfix_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 1, $1); }
   | PLUSPLUS cast_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, NULL, $2); }
   | MINUSMINUS cast_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, NULL, $2); }
   | '*' cast_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, NULL, $2); }
   | '&' cast_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, NULL, $2); }
   | unary_operator cast_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, $1, $2); }
   | SIZEOF unary_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 2, NULL, $2); }
   | SIZEOF '(' type_id ')'           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 4, NULL, NULL, $3, NULL); }
   | new_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 1, $1); }
   | delete_expression           { $$ = makeTreeNode(def_unary_expression, "unary_expression:", 1, $1); }
   ;


unary_operator:
     '+'           { $$ = makeTreeNode(def_unary_operator, "unary_operator:", 1, NULL); }
   | '-'           { $$ = makeTreeNode(def_unary_operator, "unary_operator:", 1, NULL); }
   | '!'           { $$ = makeTreeNode(def_unary_operator, "unary_operator:", 1, NULL); }
   | '~'           { $$ = makeTreeNode(def_unary_operator, "unary_operator:", 1, NULL); }
   ;


new_expression:
     NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(def_new_expression, "new_expression:", 4, NULL, $2, $3, $4); }
   | COLONCOLON NEW new_placement_opt new_type_id new_initializer_opt           { $$ = makeTreeNode(def_new_expression, "new_expression:", 5, NULL, NULL, $3, $4, $5); }
   | NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(def_new_expression, "new_expression:", 6, NULL, $2, NULL, $4, NULL, $6); }
   | COLONCOLON NEW new_placement_opt '(' type_id ')' new_initializer_opt           { $$ = makeTreeNode(def_new_expression, "new_expression:", 7, NULL, NULL, $3, NULL, $5, NULL, $7); }
   ;


new_placement:
     '(' expression_list ')'           { $$ = makeTreeNode(def_new_placement, "new_placement:", 3, NULL, $2, NULL); }
   ;


new_type_id:
     type_specifier_seq new_declarator_opt           { $$ = makeTreeNode(def_new_type_id, "new_type_id:", 2, $1, $2); }
   ;


new_declarator:
     ptr_operator new_declarator_opt           { $$ = makeTreeNode(def_new_declarator, "new_declarator:", 2, $1, $2); }
   | direct_new_declarator           { $$ = makeTreeNode(def_new_declarator, "new_declarator:", 1, $1); }
   ;


direct_new_declarator:
     '[' expression ']'           { $$ = makeTreeNode(def_direct_new_declarator, "direct_new_declarator:", 3, NULL, $2, NULL); }
   | direct_new_declarator '[' constant_expression ']'           { $$ = makeTreeNode(def_direct_new_declarator, "direct_new_declarator:", 4, $1, NULL, $3, NULL); }
   ;


new_initializer:
     '(' expression_list_opt ')'           { $$ = makeTreeNode(def_new_initializer, "new_initializer:", 3, NULL, $2, NULL); }
   ;


delete_expression:
     DELETE cast_expression           { $$ = makeTreeNode(def_delete_expression, "delete_expression:", 2, NULL, $2); }
   | COLONCOLON DELETE cast_expression           { $$ = makeTreeNode(def_delete_expression, "delete_expression:", 3, NULL, NULL, $3); }
   | DELETE '[' ']' cast_expression           { $$ = makeTreeNode(def_delete_expression, "delete_expression:", 4, NULL, NULL, NULL, $4); }
   | COLONCOLON DELETE '[' ']' cast_expression           { $$ = makeTreeNode(def_delete_expression, "delete_expression:", 5, NULL, NULL, NULL, NULL, $5); }
   ;


cast_expression:
     unary_expression           { $$ = makeTreeNode(def_cast_expression, "cast_expression:", 1, $1); }
   | '(' type_id ')' cast_expression           { $$ = makeTreeNode(def_cast_expression, "cast_expression:", 4, NULL, $2, NULL, $4); }
   ;


pm_expression:
     cast_expression           { $$ = makeTreeNode(def_pm_expression, "pm_expression:", 1, $1); }
   | pm_expression DOTSTAR cast_expression           { $$ = makeTreeNode(def_pm_expression, "pm_expression:", 3, $1, NULL, $3); }
   | pm_expression ARROWSTAR cast_expression           { $$ = makeTreeNode(def_pm_expression, "pm_expression:", 3, $1, NULL, $3); }
   ;


multiplicative_expression:
     pm_expression           { $$ = makeTreeNode(def_multiplicative_expression, "multiplicative_expression:", 1, $1); }
   | multiplicative_expression '*' pm_expression           { $$ = makeTreeNode(def_multiplicative_expression, "multiplicative_expression:", 3, $1, NULL, $3); }
   | multiplicative_expression '/' pm_expression           { $$ = makeTreeNode(def_multiplicative_expression, "multiplicative_expression:", 3, $1, NULL, $3); }
   | multiplicative_expression '%' pm_expression           { $$ = makeTreeNode(def_multiplicative_expression, "multiplicative_expression:", 3, $1, NULL, $3); }
   ;


additive_expression:
     multiplicative_expression           { $$ = makeTreeNode(def_additive_expression, "additive_expression:", 1, $1); }
   | additive_expression '+' multiplicative_expression           { $$ = makeTreeNode(def_additive_expression, "additive_expression:", 3, $1, NULL, $3); }
   | additive_expression '-' multiplicative_expression           { $$ = makeTreeNode(def_additive_expression, "additive_expression:", 3, $1, NULL, $3); }
   ;


shift_expression:
     additive_expression           { $$ = makeTreeNode(def_shift_expression, "shift_expression:", 1, $1); }
   | shift_expression SL additive_expression           { $$ = makeTreeNode(def_shift_expression, "shift_expression:", 3, $1, NULL, $3); }
   | shift_expression SR additive_expression           { $$ = makeTreeNode(def_shift_expression, "shift_expression:", 3, $1, NULL, $3); }
   ;


relational_expression:
     shift_expression           { $$ = makeTreeNode(def_relational_expression, "relational_expression:", 1, $1); }
   | relational_expression '<' shift_expression           { $$ = makeTreeNode(def_relational_expression, "relational_expression:", 3, $1, NULL, $3); }
   | relational_expression '>' shift_expression           { $$ = makeTreeNode(def_relational_expression, "relational_expression:", 3, $1, NULL, $3); }
   | relational_expression LTEQ shift_expression           { $$ = makeTreeNode(def_relational_expression, "relational_expression:", 3, $1, NULL, $3); }
   | relational_expression GTEQ shift_expression           { $$ = makeTreeNode(def_relational_expression, "relational_expression:", 3, $1, NULL, $3); }
   ;


equality_expression:
     relational_expression           { $$ = makeTreeNode(def_equality_expression, "equality_expression:", 1, $1); }
   | equality_expression EQ relational_expression           { $$ = makeTreeNode(def_equality_expression, "equality_expression:", 3, $1, NULL, $3); }
   | equality_expression NOTEQ relational_expression           { $$ = makeTreeNode(def_equality_expression, "equality_expression:", 3, $1, NULL, $3); }
   ;


and_expression:
     equality_expression           { $$ = makeTreeNode(def_and_expression, "and_expression:", 1, $1); }
   | and_expression '&' equality_expression           { $$ = makeTreeNode(def_and_expression, "and_expression:", 3, $1, NULL, $3); }
   ;


exclusive_or_expression:
     and_expression           { $$ = makeTreeNode(def_exclusive_or_expression, "exclusive_or_expression:", 1, $1); }
   | exclusive_or_expression '^' and_expression           { $$ = makeTreeNode(def_exclusive_or_expression, "exclusive_or_expression:", 3, $1, NULL, $3); }
   ;


inclusive_or_expression:
     exclusive_or_expression           { $$ = makeTreeNode(def_inclusive_or_expression, "inclusive_or_expression:", 1, $1); }
   | inclusive_or_expression '|' exclusive_or_expression           { $$ = makeTreeNode(def_inclusive_or_expression, "inclusive_or_expression:", 3, $1, NULL, $3); }
   ;


logical_and_expression:
     inclusive_or_expression           { $$ = makeTreeNode(def_logical_and_expression, "logical_and_expression:", 1, $1); }
   | logical_and_expression ANDAND inclusive_or_expression           { $$ = makeTreeNode(def_logical_and_expression, "logical_and_expression:", 3, $1, NULL, $3); }
   ;


logical_or_expression:
     logical_and_expression           { $$ = makeTreeNode(def_logical_or_expression, "logical_or_expression:", 1, $1); }
   | logical_or_expression OROR logical_and_expression           { $$ = makeTreeNode(def_logical_or_expression, "logical_or_expression:", 3, $1, NULL, $3); }
   ;


conditional_expression:
     logical_or_expression           { $$ = makeTreeNode(def_conditional_expression, "conditional_expression:", 1, $1); }
   | logical_or_expression '?' expression ':' assignment_expression           { $$ = makeTreeNode(def_conditional_expression, "conditional_expression:", 5, $1, NULL, $3, NULL, $5); }
   ;


assignment_expression:
     conditional_expression           { $$ = makeTreeNode(def_assignment_expression, "assignment_expression:", 1, $1); }
   | logical_or_expression assignment_operator assignment_expression           { $$ = makeTreeNode(def_assignment_expression, "assignment_expression:", 3, $1, $2, $3); }
   | throw_expression           { $$ = makeTreeNode(def_assignment_expression, "assignment_expression:", 1, $1); }
   ;


assignment_operator:
     '='           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | MULEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | DIVEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | MODEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | ADDEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | SUBEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | SREQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | SLEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | ANDEQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | XOREQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   | OREQ           { $$ = makeTreeNode(def_assignment_operator, "assignment_operator:", 1, NULL); }
   ;


expression:
     assignment_expression           { $$ = makeTreeNode(def_expression, "expression:", 1, $1); }
   | expression ',' assignment_expression           { $$ = makeTreeNode(def_expression, "expression:", 3, $1, NULL, $3); }
   ;

/*----------------------------------------------------------------------
 * Statements.
 *----------------------------------------------------------------------*/
   
constant_expression:
     conditional_expression           { $$ = makeTreeNode(def_constant_expression, "constant_expression:", 1, $1); }
   ;


statement:
     labeled_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | expression_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | compound_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | selection_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | iteration_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | jump_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | declaration_statement           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   | try_block           { $$ = makeTreeNode(def_statement, "statement:", 1, $1); }
   ;


labeled_statement:
     identifier ':' statement           { $$ = makeTreeNode(def_labeled_statement, "labeled_statement:", 3, $1, NULL, $3); }
   | CASE constant_expression ':' statement           { $$ = makeTreeNode(def_labeled_statement, "labeled_statement:", 4, NULL, $2, NULL, $4); }
   | DEFAULT ':' statement           { $$ = makeTreeNode(def_labeled_statement, "labeled_statement:", 3, NULL, NULL, $3); }
   ;


expression_statement:
     expression_opt ';'           { $$ = makeTreeNode(def_expression_statement, "expression_statement:", 2, $1, NULL); }
   ;


compound_statement:
     '{' statement_seq_opt '}'           { $$ = makeTreeNode(def_compound_statement, "compound_statement:", 3, NULL, $2, NULL); }
   ;


statement_seq:
     statement           { $$ = makeTreeNode(def_statement_seq, "statement_seq:", 1, $1); }
   | statement_seq statement           { $$ = makeTreeNode(def_statement_seq, "statement_seq:", 2, $1, $2); }
   ;


selection_statement:
     IF '(' condition ')' statement           { $$ = makeTreeNode(def_selection_statement, "selection_statement:", 5, NULL, NULL, $3, NULL, $5); }
   | IF '(' condition ')' statement ELSE statement           { $$ = makeTreeNode(def_selection_statement, "selection_statement:", 7, NULL, NULL, $3, NULL, $5, NULL, $7); }
   | SWITCH '(' condition ')' statement           { $$ = makeTreeNode(def_selection_statement, "selection_statement:", 5, NULL, NULL, $3, NULL, $5); }
   ;


condition:
     expression           { $$ = makeTreeNode(def_condition, "condition:", 1, $1); }
   | type_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(def_condition, "condition:", 4, $1, $2, NULL, $4); }
   ;


iteration_statement:
     WHILE '(' condition ')' statement           { $$ = makeTreeNode(def_iteration_statement, "iteration_statement:", 5, NULL, NULL, $3, NULL, $5); }
   | DO statement WHILE '(' expression ')' ';'           { $$ = makeTreeNode(def_iteration_statement, "iteration_statement:", 7, NULL, $2, NULL, NULL, $5, NULL, NULL); }
   | FOR '(' for_init_statement condition_opt ';' expression_opt ')' statement           { $$ = makeTreeNode(def_iteration_statement, "iteration_statement:", 8, NULL, NULL, $3, $4, NULL, $6, NULL, $8); }
   ;


for_init_statement:
     expression_statement           { $$ = makeTreeNode(def_for_init_statement, "for_init_statement:", 1, $1); }
   | simple_declaration           { $$ = makeTreeNode(def_for_init_statement, "for_init_statement:", 1, $1); }
   ;


jump_statement:
     BREAK ';'           { $$ = makeTreeNode(def_jump_statement, "jump_statement:", 2, NULL, NULL); }
   | CONTINUE ';'           { $$ = makeTreeNode(def_jump_statement, "jump_statement:", 2, NULL, NULL); }
   | RETURN expression_opt ';'           { $$ = makeTreeNode(def_jump_statement, "jump_statement:", 3, NULL, $2, NULL); }
   ;


declaration_statement:
     block_declaration           { $$ = makeTreeNode(def_declaration_statement, "declaration_statement:", 1, $1); }
   ;

/*----------------------------------------------------------------------
 * Declarations.
 *----------------------------------------------------------------------*/
   
declaration_seq:
     declaration           { $$ = makeTreeNode(def_declaration_seq, "declaration_seq:", 1, $1); }
   | declaration_seq declaration           { $$ = makeTreeNode(def_declaration_seq, "declaration_seq:", 2, $1, $2); }
   ;


declaration:
     block_declaration           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | function_definition           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | template_declaration           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | explicit_instantiation           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | explicit_specialization           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | linkage_specification           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   | namespace_definition           { $$ = makeTreeNode(def_declaration, "declaration:", 1, $1); }
   ;


block_declaration:
     simple_declaration           { $$ = makeTreeNode(def_block_declaration, "block_declaration:", 1, $1); }
   | asm_definition           { $$ = makeTreeNode(def_block_declaration, "block_declaration:", 1, $1); }
   | namespace_alias_definition           { $$ = makeTreeNode(def_block_declaration, "block_declaration:", 1, $1); }
   | using_declaration           { $$ = makeTreeNode(def_block_declaration, "block_declaration:", 1, $1); }
   | using_directive           { $$ = makeTreeNode(def_block_declaration, "block_declaration:", 1, $1); }
   ;


simple_declaration:
     decl_specifier_seq init_declarator_list ';'           { $$ = makeTreeNode(def_simple_declaration, "simple_declaration:", 3, $1, $2, NULL); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(def_simple_declaration, "simple_declaration:", 2, $1, NULL); }
   ;


decl_specifier:
     storage_class_specifier           { $$ = makeTreeNode(def_decl_specifier, "decl_specifier:", 1, $1); }
   | type_specifier           { $$ = makeTreeNode(def_decl_specifier, "decl_specifier:", 1, $1); }
   | function_specifier           { $$ = makeTreeNode(def_decl_specifier, "decl_specifier:", 1, $1); }
   | FRIEND           { $$ = makeTreeNode(def_decl_specifier, "decl_specifier:", 1, NULL); }
   | TYPEDEF           { $$ = makeTreeNode(def_decl_specifier, "decl_specifier:", 1, NULL); }
   ;


decl_specifier_seq:
     decl_specifier           { $$ = makeTreeNode(def_decl_specifier_seq, "decl_specifier_seq:", 1, $1); }
   | decl_specifier_seq decl_specifier           { $$ = makeTreeNode(def_decl_specifier_seq, "decl_specifier_seq:", 2, $1, $2); }
   ;


storage_class_specifier:
     AUTO           { $$ = makeTreeNode(def_storage_class_specifier, "storage_class_specifier:", 1, NULL); }
   | REGISTER           { $$ = makeTreeNode(def_storage_class_specifier, "storage_class_specifier:", 1, NULL); }
   | STATIC           { $$ = makeTreeNode(def_storage_class_specifier, "storage_class_specifier:", 1, NULL); }
   | EXTERN           { $$ = makeTreeNode(def_storage_class_specifier, "storage_class_specifier:", 1, NULL); }
   | MUTABLE           { $$ = makeTreeNode(def_storage_class_specifier, "storage_class_specifier:", 1, NULL); }
   ;


function_specifier:
     INLINE           { $$ = makeTreeNode(def_function_specifier, "function_specifier:", 1, NULL); }
   | VIRTUAL           { $$ = makeTreeNode(def_function_specifier, "function_specifier:", 1, NULL); }
   | EXPLICIT           { $$ = makeTreeNode(def_function_specifier, "function_specifier:", 1, NULL); }
   ;


type_specifier:
     simple_type_specifier           { $$ = makeTreeNode(def_type_specifier, "type_specifier:", 1, $1); }
   | class_specifier           { $$ = makeTreeNode(def_type_specifier, "type_specifier:", 1, $1); }
   | enum_specifier           { $$ = makeTreeNode(def_type_specifier, "type_specifier:", 1, $1); }
   | elaborated_type_specifier           { $$ = makeTreeNode(def_type_specifier, "type_specifier:", 1, $1); }
   | cv_qualifier           { $$ = makeTreeNode(def_type_specifier, "type_specifier:", 1, $1); }
   ;


simple_type_specifier:
     type_name           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, $1); }
   | nested_name_specifier type_name           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 2, $1, $2); }
   | COLONCOLON nested_name_specifier_opt type_name           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 3, NULL, $2, $3); }
   | CHAR           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | WCHAR_T           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | BOOL           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | SHORT           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | INT           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | LONG           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | SIGNED           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | UNSIGNED           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | FLOAT           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | DOUBLE           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   | VOID           { $$ = makeTreeNode(def_simple_type_specifier, "simple_type_specifier:", 1, NULL); }
   ;


type_name:
     class_name           { $$ = makeTreeNode(def_type_name, "type_name:", 1, $1); }
   | enum_name           { $$ = makeTreeNode(def_type_name, "type_name:", 1, $1); }
   | typedef_name           { $$ = makeTreeNode(def_type_name, "type_name:", 1, $1); }
   ;


elaborated_type_specifier:
     class_key COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 4, $1, NULL, $3, $4); }
   | class_key COLONCOLON identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 3, $1, NULL, $3); }
   | ENUM COLONCOLON nested_name_specifier identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 4, NULL, NULL, $3, $4); }
   | ENUM COLONCOLON identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 3, NULL, NULL, $3); }
   | ENUM nested_name_specifier identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 3, NULL, $2, $3); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 4, NULL, $2, $3, $4); }
   | TYPENAME COLONCOLON_opt nested_name_specifier identifier '<' template_argument_list '>'           { $$ = makeTreeNode(def_elaborated_type_specifier, "elaborated_type_specifier:", 7, NULL, $2, $3, $4, NULL, $6, NULL); }
   ;


enum_specifier:
     ENUM identifier '{' enumerator_list_opt '}'           { $$ = makeTreeNode(def_enum_specifier, "enum_specifier:", 5, NULL, $2, NULL, $4, NULL); }
   ;


enumerator_list:
     enumerator_definition           { $$ = makeTreeNode(def_enumerator_list, "enumerator_list:", 1, $1); }
   | enumerator_list ',' enumerator_definition           { $$ = makeTreeNode(def_enumerator_list, "enumerator_list:", 3, $1, NULL, $3); }
   ;


enumerator_definition:
     enumerator           { $$ = makeTreeNode(def_enumerator_definition, "enumerator_definition:", 1, $1); }
   | enumerator '=' constant_expression           { $$ = makeTreeNode(def_enumerator_definition, "enumerator_definition:", 3, $1, NULL, $3); }
   ;


enumerator:
     identifier           { $$ = makeTreeNode(def_enumerator, "enumerator:", 1, $1); }
   ;


namespace_definition:
     named_namespace_definition           { $$ = makeTreeNode(def_namespace_definition, "namespace_definition:", 1, $1); }
   | unnamed_namespace_definition           { $$ = makeTreeNode(def_namespace_definition, "namespace_definition:", 1, $1); }
   ;


named_namespace_definition:
     original_namespace_definition           { $$ = makeTreeNode(def_named_namespace_definition, "named_namespace_definition:", 1, $1); }
   | extension_namespace_definition           { $$ = makeTreeNode(def_named_namespace_definition, "named_namespace_definition:", 1, $1); }
   ;


original_namespace_definition:
     NAMESPACE identifier '{' namespace_body '}'           { $$ = makeTreeNode(def_original_namespace_definition, "original_namespace_definition:", 5, NULL, $2, NULL, $4, NULL); }
   ;


extension_namespace_definition:
     NAMESPACE original_namespace_name '{' namespace_body '}'           { $$ = makeTreeNode(def_extension_namespace_definition, "extension_namespace_definition:", 5, NULL, $2, NULL, $4, NULL); }
   ;


unnamed_namespace_definition:
     NAMESPACE '{' namespace_body '}'           { $$ = makeTreeNode(def_unnamed_namespace_definition, "unnamed_namespace_definition:", 4, NULL, NULL, $3, NULL); }
   ;


namespace_body:
     declaration_seq_opt           { $$ = makeTreeNode(def_namespace_body, "namespace_body:", 1, $1); }
   ;


namespace_alias_definition:
     NAMESPACE identifier '=' qualified_namespace_specifier ';'           { $$ = makeTreeNode(def_namespace_alias_definition, "namespace_alias_definition:", 5, NULL, $2, NULL, $4, NULL); }
   ;


qualified_namespace_specifier:
     COLONCOLON nested_name_specifier namespace_name           { $$ = makeTreeNode(def_qualified_namespace_specifier, "qualified_namespace_specifier:", 3, NULL, $2, $3); }
   | COLONCOLON namespace_name           { $$ = makeTreeNode(def_qualified_namespace_specifier, "qualified_namespace_specifier:", 2, NULL, $2); }
   | nested_name_specifier namespace_name           { $$ = makeTreeNode(def_qualified_namespace_specifier, "qualified_namespace_specifier:", 2, $1, $2); }
   | namespace_name           { $$ = makeTreeNode(def_qualified_namespace_specifier, "qualified_namespace_specifier:", 1, $1); }
   ;


using_declaration:
     USING TYPENAME COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(def_using_declaration, "using_declaration:", 6, NULL, NULL, NULL, $4, $5, NULL); }
   | USING TYPENAME nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(def_using_declaration, "using_declaration:", 5, NULL, NULL, $3, $4, NULL); }
   | USING COLONCOLON nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(def_using_declaration, "using_declaration:", 5, NULL, NULL, $3, $4, NULL); }
   | USING nested_name_specifier unqualified_id ';'           { $$ = makeTreeNode(def_using_declaration, "using_declaration:", 4, NULL, $2, $3, NULL); }
   | USING COLONCOLON unqualified_id ';'           { $$ = makeTreeNode(def_using_declaration, "using_declaration:", 4, NULL, NULL, $3, NULL); }
   ;


using_directive:
     USING NAMESPACE COLONCOLON nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(def_using_directive, "using_directive:", 6, NULL, NULL, NULL, $4, $5, NULL); }
   | USING NAMESPACE COLONCOLON namespace_name ';'           { $$ = makeTreeNode(def_using_directive, "using_directive:", 5, NULL, NULL, NULL, $4, NULL); }
   | USING NAMESPACE nested_name_specifier namespace_name ';'           { $$ = makeTreeNode(def_using_directive, "using_directive:", 5, NULL, NULL, $3, $4, NULL); }
   | USING NAMESPACE namespace_name ';'           { $$ = makeTreeNode(def_using_directive, "using_directive:", 4, NULL, NULL, $3, NULL); }
   ;


asm_definition:
     ASM '(' string_literal ')' ';'           { $$ = makeTreeNode(def_asm_definition, "asm_definition:", 5, NULL, NULL, $3, NULL, NULL); }
   ;


linkage_specification:
     EXTERN string_literal '{' declaration_seq_opt '}'           { $$ = makeTreeNode(def_linkage_specification, "linkage_specification:", 5, NULL, $2, NULL, $4, NULL); }
   | EXTERN string_literal declaration           { $$ = makeTreeNode(def_linkage_specification, "linkage_specification:", 3, NULL, $2, $3); }
   ;

/*----------------------------------------------------------------------
 * Declarators.
 *----------------------------------------------------------------------*/
   
init_declarator_list:
     init_declarator           { $$ = makeTreeNode(def_init_declarator_list, "init_declarator_list:", 1, $1); }
   | init_declarator_list ',' init_declarator           { $$ = makeTreeNode(def_init_declarator_list, "init_declarator_list:", 3, $1, NULL, $3); }
   ;


init_declarator:
     declarator initializer_opt           { $$ = makeTreeNode(def_init_declarator, "init_declarator:", 2, $1, $2); }
   ;


declarator:
     direct_declarator           { $$ = makeTreeNode(def_declarator, "declarator:", 1, $1); }
   | ptr_operator declarator           { $$ = makeTreeNode(def_declarator, "declarator:", 2, $1, $2); }
   ;


direct_declarator:
     declarator_id           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 1, $1); }
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 6, $1, NULL, $3, NULL, $5, $6); }
   | direct_declarator '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 5, $1, NULL, $3, NULL, $5); }
   | direct_declarator '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 5, $1, NULL, $3, NULL, $5); }
   | direct_declarator '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 4, $1, NULL, $3, NULL); }
   | CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 4, NULL, NULL, $3, NULL); }
   | CLASS_NAME COLONCOLON declarator_id '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 6, NULL, NULL, $3, NULL, $5, NULL); }
   | CLASS_NAME COLONCOLON CLASS_NAME '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 6, NULL, NULL, NULL, NULL, $5, NULL); }
   | direct_declarator '[' constant_expression_opt ']'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 4, $1, NULL, $3, NULL); }
   | '(' declarator ')'           { $$ = makeTreeNode(def_direct_declarator, "direct_declarator:", 3, NULL, $2, NULL); }
   ;


ptr_operator:
     '*'           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 1, NULL); }
   | '*' cv_qualifier_seq           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 2, NULL, $2); }
   | '&'           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 1, NULL); }
   | nested_name_specifier '*'           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 2, $1, NULL); }
   | nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 3, $1, NULL, $3); }
   | COLONCOLON nested_name_specifier '*'           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 3, NULL, $2, NULL); }
   | COLONCOLON nested_name_specifier '*' cv_qualifier_seq           { $$ = makeTreeNode(def_ptr_operator, "ptr_operator:", 4, NULL, $2, NULL, $4); }
   ;


cv_qualifier_seq:
     cv_qualifier           { $$ = makeTreeNode(def_cv_qualifier_seq, "cv_qualifier_seq:", 1, $1); }
   | cv_qualifier cv_qualifier_seq           { $$ = makeTreeNode(def_cv_qualifier_seq, "cv_qualifier_seq:", 2, $1, $2); }
   ;


cv_qualifier:
     CONST           { $$ = makeTreeNode(def_cv_qualifier, "cv_qualifier:", 1, NULL); }
   | VOLATILE           { $$ = makeTreeNode(def_cv_qualifier, "cv_qualifier:", 1, NULL); }
   ;


declarator_id:
     id_expression           { $$ = makeTreeNode(def_declarator_id, "declarator_id:", 1, $1); }
   | COLONCOLON id_expression           { $$ = makeTreeNode(def_declarator_id, "declarator_id:", 2, NULL, $2); }
   | COLONCOLON nested_name_specifier type_name           { $$ = makeTreeNode(def_declarator_id, "declarator_id:", 3, NULL, $2, $3); }
   | COLONCOLON type_name           { $$ = makeTreeNode(def_declarator_id, "declarator_id:", 2, NULL, $2); }
   ;


type_id:
     type_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(def_type_id, "type_id:", 2, $1, $2); }
   ;


type_specifier_seq:
     type_specifier type_specifier_seq_opt           { $$ = makeTreeNode(def_type_specifier_seq, "type_specifier_seq:", 2, $1, $2); }
   ;


abstract_declarator:
     ptr_operator abstract_declarator_opt           { $$ = makeTreeNode(def_abstract_declarator, "abstract_declarator:", 2, $1, $2); }
   | direct_abstract_declarator           { $$ = makeTreeNode(def_abstract_declarator, "abstract_declarator:", 1, $1); }
   ;


direct_abstract_declarator:
     direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq exception_specification           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 6, $1, NULL, $3, NULL, $5, $6); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' cv_qualifier_seq           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 5, $1, NULL, $3, NULL, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')' exception_specification           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 5, $1, NULL, $3, NULL, $5); }
   | direct_abstract_declarator_opt '(' parameter_declaration_clause ')'           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 4, $1, NULL, $3, NULL); }
   | direct_abstract_declarator_opt '[' constant_expression_opt ']'           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 4, $1, NULL, $3, NULL); }
   | '(' abstract_declarator ')'           { $$ = makeTreeNode(def_direct_abstract_declarator, "direct_abstract_declarator:", 3, NULL, $2, NULL); }
   ;


parameter_declaration_clause:
     parameter_declaration_list ELLIPSIS           { $$ = makeTreeNode(def_parameter_declaration_clause, "parameter_declaration_clause:", 2, $1, NULL); }
   | parameter_declaration_list           { $$ = makeTreeNode(def_parameter_declaration_clause, "parameter_declaration_clause:", 1, $1); }
   | ELLIPSIS           { $$ = makeTreeNode(def_parameter_declaration_clause, "parameter_declaration_clause:", 1, NULL); }
   |     /* epsilon */          { $$ = NULL; }
   | parameter_declaration_list ',' ELLIPSIS           { $$ = makeTreeNode(def_parameter_declaration_clause, "parameter_declaration_clause:", 3, $1, NULL, NULL); }
   ;


parameter_declaration_list:
     parameter_declaration           { $$ = makeTreeNode(def_parameter_declaration_list, "parameter_declaration_list:", 1, $1); }
   | parameter_declaration_list ',' parameter_declaration           { $$ = makeTreeNode(def_parameter_declaration_list, "parameter_declaration_list:", 3, $1, NULL, $3); }
   ;


parameter_declaration:
     decl_specifier_seq declarator           { $$ = makeTreeNode(def_parameter_declaration, "parameter_declaration:", 2, $1, $2); }
   | decl_specifier_seq declarator '=' assignment_expression           { $$ = makeTreeNode(def_parameter_declaration, "parameter_declaration:", 4, $1, $2, NULL, $4); }
   | decl_specifier_seq abstract_declarator_opt           { $$ = makeTreeNode(def_parameter_declaration, "parameter_declaration:", 2, $1, $2); }
   | decl_specifier_seq abstract_declarator_opt '=' assignment_expression           { $$ = makeTreeNode(def_parameter_declaration, "parameter_declaration:", 4, $1, $2, NULL, $4); }
   ;


function_definition:
     declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(def_function_definition, "function_definition:", 3, $1, $2, $3); }
   | decl_specifier_seq declarator ctor_initializer_opt function_body           { $$ = makeTreeNode(def_function_definition, "function_definition:", 4, $1, $2, $3, $4); }
   | declarator function_try_block           { $$ = makeTreeNode(def_function_definition, "function_definition:", 2, $1, $2); }
   | decl_specifier_seq declarator function_try_block           { $$ = makeTreeNode(def_function_definition, "function_definition:", 3, $1, $2, $3); }
   ;


function_body:
     compound_statement           { $$ = makeTreeNode(def_function_body, "function_body:", 1, $1); }
   ;


initializer:
     '=' initializer_clause           { $$ = makeTreeNode(def_initializer, "initializer:", 2, NULL, $2); }
   | '(' expression_list ')'           { $$ = makeTreeNode(def_initializer, "initializer:", 3, NULL, $2, NULL); }
   ;


initializer_clause:
     assignment_expression           { $$ = makeTreeNode(def_initializer_clause, "initializer_clause:", 1, $1); }
   | '{' initializer_list COMMA_opt '}'           { $$ = makeTreeNode(def_initializer_clause, "initializer_clause:", 4, NULL, $2, $3, NULL); }
   | '{' '}'           { $$ = makeTreeNode(def_initializer_clause, "initializer_clause:", 2, NULL, NULL); }
   ;


initializer_list:
     initializer_clause           { $$ = makeTreeNode(def_initializer_list, "initializer_list:", 1, $1); }
   | initializer_list ',' initializer_clause           { $$ = makeTreeNode(def_initializer_list, "initializer_list:", 3, $1, NULL, $3); }
   ;


/*----------------------------------------------------------------------
 * Classes.
 *----------------------------------------------------------------------*/
   
class_specifier:
     class_head '{' member_specification_opt '}'           { $$ = makeTreeNode(def_class_specifier, "class_specifier:", 4, $1, NULL, $3, NULL); }
   ;


class_head:
     class_key identifier           { $$ = makeTreeNode(def_class_head, "class_head:", 2, $1, $2); }
   | class_key identifier base_clause           { $$ = makeTreeNode(def_class_head, "class_head:", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier           { $$ = makeTreeNode(def_class_head, "class_head:", 3, $1, $2, $3); }
   | class_key nested_name_specifier identifier base_clause           { $$ = makeTreeNode(def_class_head, "class_head:", 4, $1, $2, $3, $4); }
   ;


class_key:
     CLASS           { $$ = makeTreeNode(def_class_key, "class_key:", 1, NULL); }
   | STRUCT           { $$ = makeTreeNode(def_class_key, "class_key:", 1, NULL); }
   | UNION           { $$ = makeTreeNode(def_class_key, "class_key:", 1, NULL); }
   ;


member_specification:
     member_declaration member_specification_opt           { $$ = makeTreeNode(def_member_specification, "member_specification:", 2, $1, $2); }
   | access_specifier ':' member_specification_opt           { $$ = makeTreeNode(def_member_specification, "member_specification:", 3, $1, NULL, $3); }
   ;


member_declaration:
     decl_specifier_seq member_declarator_list ';'           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 3, $1, $2, NULL); }
   | decl_specifier_seq ';'           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 2, $1, NULL); }
   | member_declarator_list ';'           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 2, $1, NULL); }
   | ';'           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 1, NULL); }
   | function_definition SEMICOLON_opt           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 2, $1, $2); }
   | qualified_id ';'           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 2, $1, NULL); }
   | using_declaration           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 1, $1); }
   | template_declaration           { $$ = makeTreeNode(def_member_declaration, "member_declaration:", 1, $1); }
   ;


member_declarator_list:
     member_declarator           { $$ = makeTreeNode(def_member_declarator_list, "member_declarator_list:", 1, $1); }
   | member_declarator_list ',' member_declarator           { $$ = makeTreeNode(def_member_declarator_list, "member_declarator_list:", 3, $1, NULL, $3); }
   ;


member_declarator:
     declarator           { $$ = makeTreeNode(def_member_declarator, "member_declarator:", 1, $1); }
   | declarator pure_specifier           { $$ = makeTreeNode(def_member_declarator, "member_declarator:", 2, $1, $2); }
   | declarator constant_initializer           { $$ = makeTreeNode(def_member_declarator, "member_declarator:", 2, $1, $2); }
   | identifier ':' constant_expression           { $$ = makeTreeNode(def_member_declarator, "member_declarator:", 3, $1, NULL, $3); }
   ;


pure_specifier:
     '=' '0'           { $$ = makeTreeNode(def_pure_specifier, "pure_specifier:", 2, NULL, NULL); }
   ;


constant_initializer:
     '=' constant_expression           { $$ = makeTreeNode(def_constant_initializer, "constant_initializer:", 2, NULL, $2); }
   ;


/*----------------------------------------------------------------------
 * Derived classes.
 *----------------------------------------------------------------------*/
   
base_clause:
     ':' base_specifier_list           { $$ = makeTreeNode(def_base_clause, "base_clause:", 2, NULL, $2); }
   ;


base_specifier_list:
     base_specifier           { $$ = makeTreeNode(def_base_specifier_list, "base_specifier_list:", 1, $1); }
   | base_specifier_list ',' base_specifier           { $$ = makeTreeNode(def_base_specifier_list, "base_specifier_list:", 3, $1, NULL, $3); }
   ;


base_specifier:
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 3, NULL, $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 2, NULL, $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 2, $1, $2); }
   | class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 1, $1); }
   | VIRTUAL access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 5, NULL, $2, NULL, $4, $5); }
   | VIRTUAL access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 4, NULL, $2, $3, $4); }
   | VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 4, NULL, NULL, $3, $4); }
   | VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 3, NULL, $2, $3); }
   | access_specifier VIRTUAL COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 5, $1, NULL, NULL, $4, $5); }
   | access_specifier VIRTUAL nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 4, $1, NULL, $3, $4); }
   | access_specifier COLONCOLON nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 4, $1, NULL, $3, $4); }
   | access_specifier nested_name_specifier_opt class_name           { $$ = makeTreeNode(def_base_specifier, "base_specifier:", 3, $1, $2, $3); }
   ;


access_specifier:
     PRIVATE           { $$ = makeTreeNode(def_access_specifier, "access_specifier:", 1, NULL); }
   | PROTECTED           { $$ = makeTreeNode(def_access_specifier, "access_specifier:", 1, NULL); }
   | PUBLIC           { $$ = makeTreeNode(def_access_specifier, "access_specifier:", 1, NULL); }
   ;

/*----------------------------------------------------------------------
 * Special member functions.
 *----------------------------------------------------------------------*/
   
conversion_function_id:
     OPERATOR conversion_type_id           { $$ = makeTreeNode(def_conversion_function_id, "conversion_function_id:", 2, NULL, $2); }
   ;


conversion_type_id:
     type_specifier_seq conversion_declarator_opt           { $$ = makeTreeNode(def_conversion_type_id, "conversion_type_id:", 2, $1, $2); }
   ;


conversion_declarator:
     ptr_operator conversion_declarator_opt           { $$ = makeTreeNode(def_conversion_declarator, "conversion_declarator:", 2, $1, $2); }
   ;


ctor_initializer:
     ':' mem_initializer_list           { $$ = makeTreeNode(def_ctor_initializer, "ctor_initializer:", 2, NULL, $2); }
   ;


mem_initializer_list:
     mem_initializer           { $$ = makeTreeNode(def_mem_initializer_list, "mem_initializer_list:", 1, $1); }
   | mem_initializer ',' mem_initializer_list           { $$ = makeTreeNode(def_mem_initializer_list, "mem_initializer_list:", 3, $1, NULL, $3); }
   ;


mem_initializer:
     mem_initializer_id '(' expression_list_opt ')'           { $$ = makeTreeNode(def_mem_initializer, "mem_initializer:", 4, $1, NULL, $3, NULL); }
   ;


mem_initializer_id:
     COLONCOLON nested_name_specifier class_name           { $$ = makeTreeNode(def_mem_initializer_id, "mem_initializer_id:", 3, NULL, $2, $3); }
   | COLONCOLON class_name           { $$ = makeTreeNode(def_mem_initializer_id, "mem_initializer_id:", 2, NULL, $2); }
   | nested_name_specifier class_name           { $$ = makeTreeNode(def_mem_initializer_id, "mem_initializer_id:", 2, $1, $2); }
   | class_name           { $$ = makeTreeNode(def_mem_initializer_id, "mem_initializer_id:", 1, $1); }
   | identifier           { $$ = makeTreeNode(def_mem_initializer_id, "mem_initializer_id:", 1, $1); }
   ;

/*----------------------------------------------------------------------
 * Overloading.
 *----------------------------------------------------------------------*/
   
operator_function_id:
     OPERATOR operator           { $$ = makeTreeNode(def_operator_function_id, "operator_function_id:", 2, NULL, $2); }
   ;


operator:
     NEW           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | DELETE           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | NEW '[' ']'           { $$ = makeTreeNode(def_operator, "operator:", 3, NULL, NULL, NULL); }
   | DELETE '[' ']'           { $$ = makeTreeNode(def_operator, "operator:", 3, NULL, NULL, NULL); }
   | '+'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '_'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '*'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '/'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '%'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '^'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '&'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '|'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '~'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '!'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '='           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '<'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '>'           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ADDEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | SUBEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | MULEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | DIVEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | MODEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | XOREQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ANDEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | OREQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | SL           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | SR           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | SREQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | SLEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | EQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | NOTEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | LTEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | GTEQ           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ANDAND           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | OROR           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | PLUSPLUS           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | MINUSMINUS           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ','           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ARROWSTAR           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | ARROW           { $$ = makeTreeNode(def_operator, "operator:", 1, NULL); }
   | '(' ')'           { $$ = makeTreeNode(def_operator, "operator:", 2, NULL, NULL); }
   | '[' ']'           { $$ = makeTreeNode(def_operator, "operator:", 2, NULL, NULL); }
   ;

/*----------------------------------------------------------------------
 * Templates.
 *----------------------------------------------------------------------*/
   
template_declaration:
     EXPORT_opt TEMPLATE '<' template_parameter_list '>' declaration           { $$ = makeTreeNode(def_template_declaration, "template_declaration:", 6, $1, NULL, NULL, $4, NULL, $6); }
   ;


template_parameter_list:
     template_parameter           { $$ = makeTreeNode(def_template_parameter_list, "template_parameter_list:", 1, $1); }
   | template_parameter_list ',' template_parameter           { $$ = makeTreeNode(def_template_parameter_list, "template_parameter_list:", 3, $1, NULL, $3); }
   ;


template_parameter:
     type_parameter           { $$ = makeTreeNode(def_template_parameter, "template_parameter:", 1, $1); }
   | parameter_declaration           { $$ = makeTreeNode(def_template_parameter, "template_parameter:", 1, $1); }
   ;


type_parameter:
     CLASS identifier           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 2, NULL, $2); }
   | CLASS identifier '=' type_id           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 4, NULL, $2, NULL, $4); }
   | TYPENAME identifier           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 2, NULL, $2); }
   | TYPENAME identifier '=' type_id           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 4, NULL, $2, NULL, $4); }
   | TEMPLATE '<' template_parameter_list '>' CLASS identifier           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 6, NULL, NULL, $3, NULL, NULL, $6); }
   | TEMPLATE '<' template_parameter_list '>' CLASS identifier '=' template_name           { $$ = makeTreeNode(def_type_parameter, "type_parameter:", 8, NULL, NULL, $3, NULL, NULL, $6, NULL, $8); }
   ;


template_id:
     template_name '<' template_argument_list '>'           { $$ = makeTreeNode(def_template_id, "template_id:", 4, $1, NULL, $3, NULL); }
   ;


template_argument_list:
     template_argument           { $$ = makeTreeNode(def_template_argument_list, "template_argument_list:", 1, $1); }
   | template_argument_list ',' template_argument           { $$ = makeTreeNode(def_template_argument_list, "template_argument_list:", 3, $1, NULL, $3); }
   ;


template_argument:
     assignment_expression           { $$ = makeTreeNode(def_template_argument, "template_argument:", 1, $1); }
   | type_id           { $$ = makeTreeNode(def_template_argument, "template_argument:", 1, $1); }
   | template_name           { $$ = makeTreeNode(def_template_argument, "template_argument:", 1, $1); }
   ;


explicit_instantiation:
     TEMPLATE declaration           { $$ = makeTreeNode(def_explicit_instantiation, "explicit_instantiation:", 2, NULL, $2); }
   ;


explicit_specialization:
     TEMPLATE '<' '>' declaration           { $$ = makeTreeNode(def_explicit_specialization, "explicit_specialization:", 4, NULL, NULL, NULL, $4); }
   ;


/*----------------------------------------------------------------------
 * Exception handling.
 *----------------------------------------------------------------------*/
   
try_block:
     TRY compound_statement handler_seq           { $$ = makeTreeNode(def_try_block, "try_block:", 3, NULL, $2, $3); }
   ;


function_try_block:
     TRY ctor_initializer_opt function_body handler_seq           { $$ = makeTreeNode(def_function_try_block, "function_try_block:", 4, NULL, $2, $3, $4); }
   ;


handler_seq:
     handler handler_seq_opt           { $$ = makeTreeNode(def_handler_seq, "handler_seq:", 2, $1, $2); }
   ;


handler:
     CATCH '(' exception_declaration ')' compound_statement           { $$ = makeTreeNode(def_handler, "handler:", 5, NULL, NULL, $3, NULL, $5); }
   ;


exception_declaration:
     type_specifier_seq declarator           { $$ = makeTreeNode(def_exception_declaration, "exception_declaration:", 2, $1, $2); }
   | type_specifier_seq abstract_declarator           { $$ = makeTreeNode(def_exception_declaration, "exception_declaration:", 2, $1, $2); }
   | type_specifier_seq           { $$ = makeTreeNode(def_exception_declaration, "exception_declaration:", 1, $1); }
   | ELLIPSIS           { $$ = makeTreeNode(def_exception_declaration, "exception_declaration:", 1, NULL); }
   ;


throw_expression:
     THROW assignment_expression_opt           { $$ = makeTreeNode(def_throw_expression, "throw_expression:", 2, NULL, $2); }
   ;


exception_specification:
     THROW '(' type_id_list_opt ')'           { $$ = makeTreeNode(def_exception_specification, "exception_specification:", 4, NULL, NULL, $3, NULL); }
   ;


type_id_list:
     type_id           { $$ = makeTreeNode(def_type_id_list, "type_id_list:", 1, $1); }
   | type_id_list ',' type_id           { $$ = makeTreeNode(def_type_id_list, "type_id_list:", 3, $1, NULL, $3); }
   ;

/*----------------------------------------------------------------------
 * Epsilon (optional) definitions.
 *----------------------------------------------------------------------*/
   
declaration_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | declaration_seq           { $$ = makeTreeNode(def_declaration_seq_opt, "declaration_seq_opt:", 1, $1); }
   ;


nested_name_specifier_opt:
     /* epsilon */          { $$ = NULL; }
   | nested_name_specifier           { $$ = makeTreeNode(def_nested_name_specifier_opt, "nested_name_specifier_opt:", 1, $1); }
   ;


expression_list_opt:
     /* epsilon */          { $$ = NULL; }
   | expression_list           { $$ = makeTreeNode(def_expression_list_opt, "expression_list_opt:", 1, $1); }
   ;


COLONCOLON_opt:
     /* epsilon */          { $$ = NULL; }
   | COLONCOLON           { $$ = makeTreeNode(def_COLONCOLON_opt, "COLONCOLON_opt:", 1, NULL); }
   ;


new_placement_opt:
     /* epsilon */          { $$ = NULL; }
   | new_placement           { $$ = makeTreeNode(def_new_placement_opt, "new_placement_opt:", 1, $1); }
   ;


new_initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | new_initializer           { $$ = makeTreeNode(def_new_initializer_opt, "new_initializer_opt:", 1, $1); }
   ;


new_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | new_declarator           { $$ = makeTreeNode(def_new_declarator_opt, "new_declarator_opt:", 1, $1); }
   ;


expression_opt:
     /* epsilon */          { $$ = NULL; }
   | expression           { $$ = makeTreeNode(def_expression_opt, "expression_opt:", 1, $1); }
   ;


statement_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | statement_seq           { $$ = makeTreeNode(def_statement_seq_opt, "statement_seq_opt:", 1, $1); }
   ;


condition_opt:
     /* epsilon */          { $$ = NULL; }
   | condition           { $$ = makeTreeNode(def_condition_opt, "condition_opt:", 1, $1); }
   ;


enumerator_list_opt:
     /* epsilon */          { $$ = NULL; }
   | enumerator_list           { $$ = makeTreeNode(def_enumerator_list_opt, "enumerator_list_opt:", 1, $1); }
   ;


initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | initializer           { $$ = makeTreeNode(def_initializer_opt, "initializer_opt:", 1, $1); }
   ;


constant_expression_opt:
     /* epsilon */          { $$ = NULL; }
   | constant_expression           { $$ = makeTreeNode(def_constant_expression_opt, "constant_expression_opt:", 1, $1); }
   ;


abstract_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | abstract_declarator           { $$ = makeTreeNode(def_abstract_declarator_opt, "abstract_declarator_opt:", 1, $1); }
   ;


type_specifier_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | type_specifier_seq           { $$ = makeTreeNode(def_type_specifier_seq_opt, "type_specifier_seq_opt:", 1, $1); }
   ;


direct_abstract_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | direct_abstract_declarator           { $$ = makeTreeNode(def_direct_abstract_declarator_opt, "direct_abstract_declarator_opt:", 1, $1); }
   ;


ctor_initializer_opt:
     /* epsilon */          { $$ = NULL; }
   | ctor_initializer           { $$ = makeTreeNode(def_ctor_initializer_opt, "ctor_initializer_opt:", 1, $1); }
   ;


COMMA_opt:
     /* epsilon */          { $$ = NULL; }
   | ','           { $$ = makeTreeNode(def_COMMA_opt, "COMMA_opt:", 1, NULL); }
   ;


member_specification_opt:
     /* epsilon */          { $$ = NULL; }
   | member_specification           { $$ = makeTreeNode(def_member_specification_opt, "member_specification_opt:", 1, $1); }
   ;


SEMICOLON_opt:
     /* epsilon */          { $$ = NULL; }
   | ';'           { $$ = makeTreeNode(def_SEMICOLON_opt, "SEMICOLON_opt:", 1, NULL); }
   ;


conversion_declarator_opt:
     /* epsilon */          { $$ = NULL; }
   | conversion_declarator           { $$ = makeTreeNode(def_conversion_declarator_opt, "conversion_declarator_opt:", 1, $1); }
   ;


EXPORT_opt:
     /* epsilon */          { $$ = NULL; }
   | EXPORT           { $$ = makeTreeNode(def_EXPORT_opt, "EXPORT_opt:", 1, NULL); }
   ;


handler_seq_opt:
     /* epsilon */          { $$ = NULL; }
   | handler_seq           { $$ = makeTreeNode(def_handler_seq_opt, "handler_seq_opt:", 1, $1); }
   ;


assignment_expression_opt:
     /* epsilon */          { $$ = NULL; }
   | assignment_expression           { $$ = makeTreeNode(def_assignment_expression_opt, "assignment_expression_opt:", 1, $1); }
   ;


type_id_list_opt:
     /* epsilon */          { $$ = NULL; }
   | type_id_list           { $$ = makeTreeNode(def_type_id_list_opt, "type_id_list_opt:", 1, $1); }
   ;

%%

/* 
 * standard yyerror to find syntax errors
 * need to add filename and lineno functionality
*/
static void yyerror(char *s)
{
	fprintf(stderr, "syntax error on line , file , string: %s\n", s);
	exit(2);
}
