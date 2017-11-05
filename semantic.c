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
struct hashtable *currtable;
char *currscope;
int currtype;
// used to list the order of function parameters`
int currorder;
// 1 for lcocal, 2 for param
int currmember;
int numtable = 0;
int temp = 0;
struct tree *lnode;
struct tree *rnode;
extern struct tree *savedTree;
struct tree * semanticAnalysis (struct tree *t){
	int i, j, key;
	if (temp == 0){
		currtable = gtable;
		currscope = "global";
		temp++;
	}
	if (!t){
		printf("Warning: Tree is null\n");
		return NULL;
	} else if (t->nkids > 0) {
		if (debug == 1) printf("SEMANTICANALYSIS\n");
		printf("%d\n", t->prodrule);
		if (t->prodrule == SIMPLE_DECLARATION){
			simple_declaration(t);
		} else if (t->prodrule == FUNCTION_DEFINITION){
			function_definition(t);
		} else if (t->prodrule == EXPRESSION_STATEMENT){
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
		gtable->ltable[numtable] = ht_create(numnodes*1.5);
		currtable = gtable->ltable[numtable];
		numtable++;
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
		direct_declarator(t->kids[1]);
		}
}

/* note that we skip past expression_opt, since it only has one prod rule
 * expression_statement->expression_opt->expression */
void expression (struct tree *t){
	if (debug == 1) printf("\tEXPRESSION\n");
	if (t->prodrule == EXPRESSION){
		expression(t->kids[0]);
		assignment_expression(t->kids[2]);
	} else {
		assignment_expression(t->kids[0]);
	}
}

void assignment_expression(struct tree *t){
	if (debug == 1) printf("\t\tASSIGNMENT_EXPRESSION\n");
	if (t->prodrule == ASSIGNMENT_EXPRESSION){
		assignment_expression(t->kids[2]);
		logical_or_expression(t->kids[0]);
	} else {
		logical_or_expression(t);
	}
}

// logical_or_expression OROR logical_and_expression
void logical_or_expression (struct tree *t){
	if (debug == 1) printf("\t\t\tLOGICAL_OR_EXPRESSION\n");
	if (t->prodrule == LOGICAL_OR_EXPRESSION){
		logical_or_expression(t->kids[0]);
		logical_and_expression(t->kids[2]);
	} else {
		logical_and_expression(t);
	}
}

// logical_and_expression && inclusive_or_expression
void logical_and_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\tLOGICAL_AND_EXPRESSION\n");
	if (t->prodrule == LOGICAL_AND_EXPRESSION){
		logical_and_expression(t->kids[0]);
		inclusive_or_expression(t->kids[2]);
	} else {
		inclusive_or_expression (t);
	}
}

void inclusive_or_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\tINCLUSIVE_OR_EXPRESSION\n");
	if (t->prodrule == INCLUSIVE_OR_EXPRESSION){
		inclusive_or_expression(t->kids[0]);
		and_expression(t->kids[2]);
	} else {
		and_expression(t);
	}
}

void and_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\tAND_EXPRESSION\n");
	if (t->prodrule == AND_EXPRESSION){
		and_expression(t->kids[0]);
		equality_expression(t->kids[2]);
	} else {
		equality_expression(t);
	}
}

void equality_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\tEQUALITY_EXPRESSION\n");
	if (t->prodrule == EQUALITY_EXPRESSION){
	} else {
		relational_expression(t);
	}
}

void relational_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\tRELATIONAL_EXPRESSION\n");
	if (t->prodrule == RELATIONAL_EXPRESSION){
		relational_expression(t->kids[0]);
		shift_expression(t->kids[2]);
	} else {
		shift_expression(t);
	}
}

void shift_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\tSHIFT_EXPRESSION\n");
	if (t->prodrule == SHIFT_EXPRESSION){
		shift_expression(t->kids[0]);
		additive_expression(t->kids[2]);
	} else {
		additive_expression(t);
	}	
}

void additive_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\t\tADDITIVE_EXPRESSION\n");
	if (t->prodrule == ADDITIVE_EXPRESSION){
		get_type(t->kids[0]->kids[0]);
		get_type(t->kids[2]->kids[0]);
		lnode = t->kids[0]->kids[0];
		rnode = t->kids[2]->kids[0];
		if (lnode->type != rnode->type){
			printf("ERROR: Attempting to add or subtract two symbols together of differing types: lsymbol - %s, rsymbol - %s on lineno - %d\n", lnode->leaf->text, rnode->leaf->text, lnode->leaf->lineno);
			numErrors++;
		}
		additive_expression(t->kids[0]);
		multiplicative_expression(t->kids[2]);
	} else {
		multiplicative_expression(t);
	}
}

void multiplicative_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\t\t\tMULTIPLICATIVE_EXPRESSION\n");
	if (t->prodrule == MULTIPLICATIVE_EXPRESSION){
		printf("%d\n", t->kids[0]->type);
		get_type(t->kids[0]->kids[0]);
		get_type(t->kids[2]->kids[0]);
		lnode = t->kids[0]->kids[0];
		rnode = t->kids[2]->kids[0];
		if (lnode->type != rnode->type){
			printf("ERROR: Attempting to multiply, divide, or mod two symbols of differing types: lsymbol - %s, rsymbol - %s on lineno %d\n", lnode->leaf->text, rnode->leaf->text, lnode->leaf->lineno);
			numErrors++;
		}
		multiplicative_expression(t->kids[0]);
		pm_expression(t->kids[2]);
	} else {
		pm_expression(t);
	}
}

void pm_expression(struct tree *t){
	check_type(t->kids[0]);
}

void postfix_expression (struct tree *t){
	if (t->kids[2]->leaf->category == LPAREN){
		check_ht_get(t->kids[0]);
	}
		check_ht_get(t->kids[0]);
}

void check_ht_get(struct tree *t){
	if (ht_get(currtable, t->leaf->text) != NULL){
			if (strcmp(currscope, ht_get(currtable, t->leaf->text)) == 0){
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
			ht_set(currtable, t->leaf->text, currscope, t->type);
		}	
	}
}

void check_type(struct tree *t){

}

void get_type(struct tree *t){
	if (ht_get_type(currtable, t->leaf->text) == 20){
		printf("ERROR: Attempting to use symbol that is not defined: %s | line %d\n", t->leaf->text, t->leaf->lineno);
		numErrors++;
	} else {
		t->type = ht_get_type(currtable, t->leaf->text);
	}
}
