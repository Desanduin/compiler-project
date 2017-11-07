#ifndef SEMANTIC_H_
#define SEMANTIC_H
#include "tree.h"
#include "symt.h"
struct tree * semanticAnalysis (struct tree *);
void simple_declaration(struct tree *);
void decl_specifier_seq(struct tree *);
void init_declarator_list(struct tree*);
void init_declarator(struct tree *);
void declarator(struct tree *);
void direct_declarator(struct tree *);
void parameter_declaration_list(struct tree *);
void parameter_declaration(struct tree *);
void function_definition(struct tree *);
void selection_statement(struct tree *);
void condition(struct tree *);
void expression(struct tree *);
void expression_list_opt(struct tree *);
void assignment_expression(struct tree *);
void logical_or_expression(struct tree *);
void logical_and_expression(struct tree *);
void inclusive_or_expression(struct tree *);
void and_expression(struct tree *);
void equality_expression(struct tree *);
void relational_expression(struct tree *);
void shift_expression(struct tree *);
void additive_expression(struct tree *);
void multiplicative_expression(struct tree *);
void cast_expression(struct tree *);
void postfix_expression(struct tree *);
void class_specifier(struct tree *);
void class_head(struct tree *);
void member_specification_opt(struct tree *);
void member_specification(struct tree *);
void member_declaration(struct tree *);
void check_ht_get(struct tree *);
void check_all_tables(struct tree *);
void get_type(struct tree *);
struct tree *traverse(struct tree *);
#endif
