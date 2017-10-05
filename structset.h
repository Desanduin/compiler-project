#ifndef STRUCTSET_H_
#define STRUCTSET_H_
#include <stdio.h>
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
   }token;               /*    the string (less quotes and after escapes) here */

typedef struct tokenl {
      struct token t;
      struct tokenl *next;
      }tokenlist;
char *fname;
char *funame;
FILE *saved_yyin;
int eof;
int user_include;

int	def_typedef_name	;
int	def_namespace_name	;
int	def_original_namespace_name	;
int	def_class_name	;
int	def_enum_name	;
int	def_template_name	;
int	def_identifier	;
int	def_decl_specifier_seq	;
int	def_decl_specifier	;
int	def_literal	;
int	def_integer_literal	;
int	def_character_literal	;
int	def_floating_literal	;
int	def_string_literal	;
int	def_boolean_literal	;
int	def_translation_unit	;
int	def_primary_expression	;
int	def_id_expression	;
int	def_unqualified_id	;
int	def_qualified_id	;
int	def_nested_name_specifier	;
int	def_postfix_expression	;
int	def_expression_list	;
int	def_unary_expression	;
int	def_unary_operator	;
int	def_new_expression	;
int	def_new_placement	;
int	def_new_type_id	;
int	def_new_declarator	;
int	def_direct_new_declarator	;
int	def_new_initializer	;
int	def_delete_expression	;
int	def_cast_expression	;
int	def_pm_expression	;
int	def_multiplicative_expression	;
int	def_additive_expression	;
int	def_shift_expression	;
int	def_relational_expression	;
int	def_equality_expression	;
int	def_and_expression	;
int	def_exclusive_or_expression	;
int	def_inclusive_or_expression	;
int	def_logical_and_expression	;
int	def_logical_or_expression	;
int	def_conditional_expression	;
int	def_assignment_expression	;
int	def_assignment_operator	;
int	def_expression	;
int	def_constant_expression	;
int	def_statement	;
int	def_labeled_statement	;
int	def_expression_statement	;
int	def_compound_statement	;
int	def_statement_seq	;
int	def_selection_statement	;
int	def_condition	;
int	def_iteration_statement	;
int	def_for_init_statement	;
int	def_jump_statement	;
int	def_declaration_statement	;
int	def_declaration_seq	;
int	def_declaration	;
int	def_block_declaration	;
int	def_simple_declaration	;
int	def_storage_class_specifier	;
int	def_function_specifier	;
int	def_type_specifier	;
int	def_simple_type_specifier	;
int	def_type_name	;
int	def_elaborated_type_specifier	;
int	def_enum_specifier	;
int	def_enumerator_list	;
int	def_enumerator_definition	;
int	def_enumerator	;
int	def_namespace_definition	;
int	def_named_namespace_definition	;
int	def_original_namespace_definition	;
int	def_extension_namespace_definition	;
int	def_unnamed_namespace_definition	;
int	def_namespace_body	;
int	def_namespace_alias_definition	;
int	def_qualified_namespace_specifier	;
int	def_using_declaration	;
int	def_using_directive	;
int	def_asm_definition	;
int	def_linkage_specification	;
int	def_init_declarator_list	;
int	def_init_declarator	;
int	def_declarator	;
int	def_direct_declarator	;
int	def_ptr_operator	;
int	def_cv_qualifier_seq	;
int	def_cv_qualifier	;
int	def_declarator_id	;
int	def_type_id	;
int	def_type_specifier_seq	;
int	def_abstract_declarator	;
int	def_direct_abstract_declarator	;
int	def_parameter_declaration_clause	;
int	def_parameter_declaration_list	;
int	def_parameter_declaration	;
int	def_function_definition	;
int	def_function_body	;
int	def_initializer	;
int	def_initializer_clause	;
int	def_initializer_list	;
int	def_class_specifier	;
int	def_class_head	;
int	def_class_key	;
int	def_member_specification	;
int	def_member_declaration	;
int	def_member_declarator_list	;
int	def_member_declarator	;
int	def_pure_specifier	;
int	def_constant_initializer	;
int	def_base_clause	;
int	def_base_specifier_list	;
int	def_base_specifier	;
int	def_access_specifier	;
int	def_conversion_function_id	;
int	def_conversion_type_id	;
int	def_conversion_declarator	;
int	def_ctor_initializer	;
int	def_mem_initializer_list	;
int	def_mem_initializer	;
int	def_mem_initializer_id	;
int	def_operator_function_id	;
int	def_operator	;
int	def_template_declaration	;
int	def_template_parameter_list	;
int	def_template_parameter	;
int	def_type_parameter	;
int	def_template_id	;
int	def_template_argument_list	;
int	def_template_argument	;
int	def_explicit_instantiation	;
int	def_explicit_specialization	;
int	def_try_block	;
int	def_function_try_block	;
int	def_handler_seq	;
int	def_handler	;
int	def_exception_declaration	;
int	def_throw_expression	;
int	def_exception_specification	;
int	def_type_id_list	;
int	def_declaration_seq_opt	;
int	def_nested_name_specifier_opt	;
int	def_expression_list_opt	;
int	def_COLONCOLON_opt	;
int	def_new_placement_opt	;
int	def_new_initializer_opt	;
int	def_new_declarator_opt	;
int	def_expression_opt	;
int	def_statement_seq_opt	;
int	def_condition_opt	;
int	def_enumerator_list_opt	;
int	def_initializer_opt	;
int	def_constant_expression_opt	;
int	def_abstract_declarator_opt	;
int	def_type_specifier_seq_opt	;
int	def_direct_abstract_declarator_opt	;
int	def_ctor_initializer_opt	;
int	def_COMMA_opt	;
int	def_member_specification_opt	;
int	def_SEMICOLON_opt	;
int	def_conversion_declarator_opt	;
int	def_EXPORT_opt	;
int	def_handler_seq_opt	;
int	def_assignment_expression_opt	;
int	def_type_id_list_opt	;




#endif
