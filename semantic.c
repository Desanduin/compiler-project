#include "tree.h"
#include "symt.h"
#include "semantic.h"
#include "globals.h"
#include "type.h"
#include "120gram.tab.h"
#include "gram_rules.h"
#include <stdlib.h>
#include <string.h>
struct hashtable *symboltable;
char *currscope;
int currtype;
struct tree * semanticAnalysis (struct tree *t){
	int i, j, key;	
	if (!t){
		return NULL;
	} else if (t->nkids > 0) {
		printf("%d\n", t->prodrule);
		
		if (t->prodrule == SIMPLE_DECLARATION) {
		if(debug == 1) printf("DEBUG: Found a simple_declaration in semanticAnalysis.\n");
			simple_declaration(t);
		} else if (t->prodrule == FUNCTION_DEFINITION){
			if(debug == 1) printf("DEBUG: Found a function_definition in semanticAnalysis.\n");
			function_definition(t);
		} else if (t->prodrule == EXPRESSION_STATEMENT){
			if(debug == 1) printf("DEBUG: Found an expression_statement in semanticAnalysis.\n");
			expression(t->kids[0]);
		} 
			for (j=0; j < t->nkids; j++){
				semanticAnalysis(t->kids[j]);
			} 
	}
}
void simple_declaration (struct tree *t){
	if (t->kids[0]->nkids == 0) {
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
		if(debug == 1) printf("DEBUG: simple_declaration text: %s\n", t->kids[0]->leaf->text);
		if (t->kids[1]->prodrule == INIT_DECLARATOR_LIST || t->kids[1]->prodrule == INIT_DECLARATOR){
			init_declarator_list(t->kids[1]);
		}		
	}
}

void init_declarator_list(struct tree *t){
	if (t->prodrule == INIT_DECLARATOR){
		init_declarator(t->kids[0]);
	} else if (t->prodrule == INIT_DECLARATOR_LIST){
		//if(debug == 1) printf("DEBUG: init_declarator_list text: %s\n", t->kids[0]->leaf->text);
		init_declarator_list(t->kids[2]);	
		init_declarator_list(t->kids[0]);
	}
}

void init_declarator(struct tree *t){
	if (t->nkids == 0){
		if(debug == 1) printf("DEBUG: init_declarator_list text: %s\n", t->leaf->text);
		check_ht_get(t);	
	} else if (t->nkids > 0){
		direct_declarator(t);
	}
}

void direct_declarator(struct tree *t){
	if (t->kids[0]->nkids == 0){
		check_ht_get(t->kids[0]);
	}
	if (t->kids[2]->prodrule == PARAMETER_DECLARATION_LIST || t->kids[2]->prodrule == PARAMETER_DECLARATION){
			parameter_declaration_list(t->kids[2]);
		}
}

void parameter_declaration_list(struct tree *t){
	if (t->prodrule == PARAMETER_DECLARATION){
		parameter_declaration(t->kids[1]);
	} else if (t->prodrule == PARAMETER_DECLARATION_LIST){
		parameter_declaration_list(t->kids[2]);
		parameter_declaration_list(t->kids[0]);
	}	
}

void parameter_declaration(struct tree *t){
	if (t->nkids == 0){
		if(debug == 1) printf("DEBUG: parameter_declaration_list text: %s\n", t->leaf->text);
		check_ht_get(t);
	} else if (t->nkids > 0){
		printf("check\n");
		direct_declarator(t);
	}
}

void function_definition (struct tree *t){
	if (t->kids[0]->prodrule == DIRECT_DECLARATOR){
		if(debug == 1) printf("DEBUG: Found a direct_declarator in function_definition.\n");
	} else if (t->prodrule == FUNCTION_DEFINITION){
		if(debug == 1) printf("DEBUG: Found standard function definition in function_definition\n");	
		currscope = t->kids[1]->kids[0]->leaf->text;
		if(debug == 1) printf("DEBUG: Entering ht_set from function_definition\n");
		//ht_set(symboltable, currscope, currscope, 1);
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;		
		direct_declarator(t->kids[1]);
	}			
}

/* note that we skip past expression_opt, since it only has one prod rule
 * expression_statement->expression_opt->expression */
void expression (struct tree *t){
	if (t->prodrule == ASSIGNMENT_EXPRESSION){
		assignment_expression(t->kids[0]);
	} else if (t->prodrule == CONDITIONAL_EXPRESSION){
	} else if (t->prodrule == THROW_EXPRESSION){
	} else if (t->prodrule == EXPRESSION){
		expression(t->kids[2]);
		expression(t->kids[0]);
	}

}

void assignment_expression (struct tree *t){
//	if (t->prodrule == 
}

void check_ht_get(struct tree *t){
	//printf("%d\n", strcmp(currscope, ht_get(symboltable, t->leaf->text)));
	if (ht_get(symboltable, t->leaf->text) != NULL){
		if (strcmp(currscope, ht_get(symboltable, t->leaf->text)) == 0){
			printf("ERROR: Symbol %s is already defined on line %d\n", t->leaf->text, t->leaf->lineno);
        		numErrors++;
		}
	} else {
        	t->type = currtype;
		if(t->type == 1){
        		numErrors++;
        		printf("ERROR: Symbol %s is being defined as void on line %d\n", t->leaf->text, t->leaf->lineno);
   		} else {
        		printf("DEBUG: Current symbol %s\n", t->leaf->text);
			printf("DEBUG: Current scope %s\n", currscope);
        		printf("DEBUG: Current type %d\n", currtype);
			ht_set(symboltable, t->leaf->text, currscope, t->type);
      		}
	}
}

