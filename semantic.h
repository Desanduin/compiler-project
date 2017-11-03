#ifndef SEMANTIC_H_
#define SEMANTIC_H
#include "tree.h"
#include "symt.h"
struct tree * semanticAnalysis (struct tree *);
void simple_declaration(struct tree *);
void init_declarator_list(struct tree*);
void init_declarator(struct tree *);
void direct_declarator(struct tree *);
void parameter_declaration_list(struct tree *);
void parameter_declaration(struct tree *);
void function_definition(struct tree *);
void expression(struct tree *);
void assignment_expression(struct tree *);
void postfix_expression(struct tree *);
void check_ht_get(struct tree *);
#endif
