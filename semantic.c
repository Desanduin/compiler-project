#include "tree.h"
#include "symt.h"
#include "semantic.h"
#include "globals.h"
#include "type.h"
#include "120gram.tab.h"
#include "gram_rules.h"
#include <stdlib.h>
#include <string.h>
struct hashtable *gtable;
char *currscope;
int currtype;
// used to list the order of function parameters`
int currorder;
// 1 for lcocal, 2 for param
int currmember;
int numtable;
extern struct tree *savedTree;
struct tree * semanticAnalysis (struct tree *t){
	int i, j, key;
	currscope = "global";
	if (!t){
		printf("Warning: Tree is null\n");
		return NULL;
	} else if (t->nkids > 0) {
		if (debug == 1) printf("SEMANTICANALYSIS\n");
		if (t->prodrule == SIMPLE_DECLARATION){
			simple_declaration(t);
		} else if (t->prodrule == FUNCTION_DEFINITION){
			function_definition(t);
		} else if (t->prodrule == EXPRESSION){
			expression(t);
		}
		for (j=0; j < t->nkids; j++){
			semanticAnalysis(t->kids[j]);
		}
	}
}
void simple_declaration (struct tree *t){
	if (debug == 1) printf("\tSIMPLE_DECLARATION\n");
	if (t->kids[0]->nkids == 0) {
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
	}
	if (t->kids[1]->prodrule == INIT_DECLARATOR_LIST || t->kids[1]->prodrule == INIT_DECLARATOR){
		init_declarator_list(t->kids[1]);
	}		
}

void init_declarator_list(struct tree *t){
	if (debug == 1) printf("\t\tINIT_DECLARATOR_LIST\n");
	if (t->prodrule == INIT_DECLARATOR){
		init_declarator(t->kids[0]);
	} else if (t->prodrule == INIT_DECLARATOR_LIST){
		if (debug == 1) printf("\tLooping through init_declarator_list\n");
		init_declarator_list(t->kids[2]);	
		init_declarator_list(t->kids[0]);
	}
}

void init_declarator(struct tree *t){
	if (debug == 1) printf("\t\t\tINIT_DECLARATOR\n");
	if (t->nkids == 0){
		check_ht_get(t);	
	} else if (t->nkids > 0){
		direct_declarator(t);
	}
}

void direct_declarator(struct tree *t){
	if (debug == 1) printf("\t\tDIRECT_DECLARATOR\n");
	if (t->kids[0]->nkids == 0){
		check_ht_get(t->kids[0]);
	} 
	if (t->kids[2]->prodrule == PARAMETER_DECLARATION_LIST || t->kids[2]->prodrule == PARAMETER_DECLARATION){
			parameter_declaration_list(t->kids[2]);
		}
}

void parameter_declaration_list(struct tree *t){
	if (debug == 1) printf("\t\t\tPARAMETER_DECLARATION_LIST\n");
	if (t->prodrule == PARAMETER_DECLARATION){
		parameter_declaration(t->kids[1]);
	} else if (t->prodrule == PARAMETER_DECLARATION_LIST){
		if (debug == 1) printf("\t\tLooping through parameter_declaration_list\n");
		parameter_declaration_list(t->kids[2]);
		parameter_declaration_list(t->kids[0]);
	}	
}

void parameter_declaration(struct tree *t){
	if (debug == 1) printf("\t\t\t\tPARAMETER_DECLARATION\n");
	if (t->nkids == 0 && t->prodrule != ABSTRACT_DECLARATOR_OPT){
		check_ht_get(t); 
	}else if (t->nkids > 0){
		direct_declarator(t);
	}
}

void function_definition (struct tree *t){
	if (debug == 1) printf("\tFUNCTION_DEFINITION\n");
	if (t->kids[0]->prodrule == DIRECT_DECLARATOR){
		direct_declarator(t->kids[0]);
	} else if (t->prodrule == FUNCTION_DEFINITION){
		currscope = t->kids[1]->kids[0]->leaf->text;
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
		direct_declarator(t->kids[1]);
		}
}

/* note that we skip past expression_opt, since it only has one prod rule
 * expression_statement->expression_opt->expression */
void expression (struct tree *t){
	printf("expression\n");
	if (t->prodrule == ASSIGNMENT_EXPRESSION){
		printf("assignment_exp\n");
		assignment_expression(t->kids[0]);
	} else if (t->prodrule == CONDITIONAL_EXPRESSION){
		printf("conditional_exp\n");
	} else if (t->prodrule == POSTFIX_EXPRESSION){
		printf("postfix_exp\n");
		postfix_expression(t->kids[0]);
	} else if (t->prodrule == THROW_EXPRESSION){
	} else if (t->prodrule == EXPRESSION){
		printf("exp\n");
		expression(t->kids[2]);
		expression(t->kids[0]);
	}

}

void assignment_expression (struct tree *t){
}

void postfix_expression (struct tree *t){
	if (t->kids[2]->leaf->category == LPAREN){
		check_ht_get(t->kids[0]);
	}
}

void check_ht_get(struct tree *t){
	if (t->leaf->text != NULL){
		printf("%s\n", t->leaf->text);
	}
	printf("ht_get %s\n", ht_get(gtable, t->leaf->text));
	if (ht_get(gtable, t->leaf->text) != NULL){
		printf("teeeeeeeeeeeeeeeeeeeeeeessst\n\n\n\n\n\n");
			if (strcmp(currscope, ht_get(gtable, t->leaf->text)) == 0){
			printf("%d\n", t->leaf->lineno);
			printf("ERROR: Symbol %s is already defined on line %d\n", t->leaf->text, t->leaf->lineno);
        		numErrors++;
		}
	} else {
        	t->type = currtype;
		if(t->type == 1){
        		printf("ERROR: Symbol %s is being defined as void on line %d\n", t->leaf->text, t->leaf->lineno);
   			numErrors++;
		} else {
			if (debug == 1) printf("---------\nPUTTING NEW SYMBOL INTO A TABLE\n---------\n");
        		if (debug==1) printf("Current symbol %s\n", t->leaf->text);
			if(debug == 1) printf("Current scope %s\n", currscope);
        		if (debug == 1)printf("Current type %d\n", t->type);
			ht_set(gtable, t->leaf->text, currscope, t->type);
		}	
	}
}

