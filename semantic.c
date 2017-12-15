#include "tree.h"
#include "symt.h"
#include "semantic.h"
#include "globals.h"
#include "type.h"
#include "tac.h"
#include "120gram.tab.h"
#include "gram_rules.h"
#include <stdlib.h>
#include <string.h>
//struct hashtable *gtable;
struct hashtable *currtable;
char *currscope;
char *func_scope;
int currtype;
// used to list the order of function parameters`
int currorder;
// 1 for lcocal, 2 for param
int currmember;
int numtable = 0;
int temp = 0;
int func_def;
int type;
int func;
int param;
int num_param;
int param_pos;
struct tree *lnode;
struct tree *rnode;
struct tree *nnode;
struct tree * semanticAnalysis (struct tree *t){
	func = 0;
	param = 0;
	currtable = gtable;
	currscope = "global";
	func_scope = "global";
	if (symt_populate(t)){
		if (debug == 1) printf("Symbol table population pass successful. Starting type checking\n");
		if (/*type_check(t)*/ temp == 200){
			if (debug == 1) printf("Type checking successful. Leaving semanticAnalysis.\n"); return 0;
		} else {
			if (debug == 1) printf("DEBUG: Type checking was not successful.\n");
		} 
	} else {
		if (debug == 1) printf("DEBUG: Symbol table population was not successful.\n");
	}
}
struct tree * symt_populate (struct tree *t){
	int i, j, key;
	param_global = 0;
	func_global = 0;
	num_param = 0;
	param = 0;
	param_pos = 0;
	t->address.offset = 0;
	t->address.region = 0;
	t->address.constant = 0;
	gtable->ltable[numtable] = currtable;
	if (!t){
		printf("Warning: Tree is null\n");
		return NULL;
	} else if (t->nkids > 0) {
		switch (t->prodrule){
		if (debug == 1) printf("SEMANTICANALYSIS\n");
		if (debug == 1) printf("%d\n", t->prodrule);
			case SIMPLE_DECLARATION:
				simple_declaration(t);
				break;
			case SELECTION_STATEMENT:
				selection_statement(t);
				break;
			case FUNCTION_DEFINITION:
				function_definition(t);
				numtable++;
				break;
			case EXPRESSION_STATEMENT:
				expression(t);
				break;
			case CLASS_SPECIFIER:
				class_specifier(t);
				break;
			default: 
				break;
		}		
		//numtable++;
		for (j=0; j < t->nkids; j++){
			symt_populate(t->kids[j]);
		}
	}
	temp = 200;
}
struct tree * type_check (struct tree *t){
        int i, j, key;
	/* bottom up traversal */
	for (j = 0; j < t->nkids; j++){
		type_check(t->kids[j]);
	}
        gtable->ltable[numtable] = currtable;
        if (!t){
                printf("Warning: Tree is null\n");
                return NULL;
        } else if (t->nkids > 0) {
                if (debug == 1) printf("SEMANTICANALYSIS\n");
                if (debug == 1) printf("%d\n", t->prodrule);
                if (t->prodrule == SIMPLE_DECLARATION){
                        simple_declaration(t);
                } else if (t->prodrule == SELECTION_STATEMENT){
                        selection_statement(t);
                } else if (t->prodrule == FUNCTION_DEFINITION){
                        function_definition(t);
                } else if (t->prodrule == EXPRESSION_STATEMENT){
                        expression(t);
                } else if (t->prodrule == CLASS_SPECIFIER){
                        class_specifier(t);
                }
                numtable++;
        }
}

/* -----------------------------
 * ----------DECLARATIONS-------
 * -----------------------------
*/

void simple_declaration (struct tree *t){
	if (debug == 1) printf("\tSIMPLE_DECLARATION\n");
	if (t->kids[0]->nkids == 0) {
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
	}
	if (t->kids[1]->prodrule == INIT_DECLARATOR_LIST || t->kids[1]->prodrule == INIT_DECLARATOR){
		
		if (t->kids[1]->kids[0]->kids[0] != NULL && t->kids[1]->kids[0]->kids[0]->leaf != NULL){
		func_scope = t->kids[1]->kids[0]->kids[0]->leaf->text;
		func_def = 1;
		currscope = t->kids[1]->kids[0]->kids[0]->leaf->text;
		gtable->ltable[numtable] = ht_create(numnodes*1.5);
		currtable = gtable->ltable[numtable];
		t->kids[1]->kids[0]->kids[0]->isFunction = 1;
		init_declarator_list(t->kids[1]);
		}
		else {
			init_declarator_list(t->kids[1]);
		}
	}
}

void decl_specifier_seq (struct tree *t){
	if (debug == 1) printf("\t\tDECL_SPECIFIER_SEQ\n");
	if (t->prodrule == DECL_SPECIFIER_SEQ){
		decl_specifier_seq(t->kids[0]);
		check_ht_get(t->kids[1]);
	} else {
		check_ht_get(t->kids[0]);
	}
}

/* -----------------------------
 * ----------DECLARATORS--------
 * -----------------------------
*/

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
		declarator(t);
	}
}

void declarator(struct tree *t){
	if (debug == 1) printf("\t\tDECLARATOR\n");
	if (t->prodrule == DIRECT_DECLARATOR){
		direct_declarator(t);
	} else {
		if (currtype != 4){
			//fprintf(stderr, "ERROR: Only pointer to char currently supported. Current type %s on line %d\n", typechar(t), t->leaf->lineno);
		} else {
			//direct_declarator(t->kids[1]);
		}
	}
}

void direct_declarator(struct tree *t){
	if (debug == 1) printf("\t\tDIRECT_DECLARATOR\n");
	if (t->kids[0]->nkids == 0){
		check_ht_get(t->kids[0]);
	}
	if (t->kids[0]->prodrule == DECLARATOR){
		declarator(t->kids[0]);
	} else if (t->prodrule == ABSTRACT_DECLARATOR){
		declarator(t);
	} else if (t->kids[2]->prodrule == PARAMETER_DECLARATION_LIST || t->kids[2]->prodrule == PARAMETER_DECLARATION){
		parameter_declaration_list(t->kids[2]);
	}
}

void parameter_declaration_list(struct tree *t){
	if (debug == 1) printf("\t\t\tPARAMETER_DECLARATION_LIST\n");
	if (t->prodrule == PARAMETER_DECLARATION){
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;	
		parameter_declaration(t->kids[1]);
	} else if (t->prodrule == PARAMETER_DECLARATION_LIST){
		if (debug == 1) printf("\t\tLooping through parameter_declaration_list\n");
		parameter_declaration_list(t->kids[0]);
		parameter_declaration_list(t->kids[2]);
	}	
}

void parameter_declaration(struct tree *t){
	if (debug == 1) printf("\t\t\t\tPARAMETER_DECLARATION\n");
	if (t->nkids == 0 && t->prodrule != ABSTRACT_DECLARATOR_OPT){
		num_param++;
		param_pos++;
		param_global = 1;
		check_ht_get(t); 
		ht_update_param(currtable, currscope, currtype, num_param);
	} else if (t->nkids > 0){
		direct_declarator(t);
	}
}

void function_definition (struct tree *t){
	if (debug == 1) printf("\tFUNCTION_DEFINITION\n");
	if (t->kids[0]->prodrule == DIRECT_DECLARATOR){
		direct_declarator(t->kids[0]);
	} else if (t->prodrule == FUNCTION_DEFINITION){
		func_scope = t->kids[1]->kids[0]->leaf->text;
		func_def = 1;
		currscope = t->kids[1]->kids[0]->leaf->text;
		gtable->ltable[numtable] = ht_create(numnodes*1.5);
		currtable = gtable->ltable[numtable];
		assigntype(t->kids[0]);
		currtype = t->kids[0]->type;
		t->kids[1]->kids[0]->isFunction = 1;
		direct_declarator(t->kids[1]);
		}
}

/* -----------------------------
 * ----------STATEMENTS---------
 * -----------------------------
*/

void selection_statement(struct tree *t){
	if (debug == 1) printf("\tSELECTION_STATEMENT\n");
	if (t->kids[0]->leaf->category == SWITCH){
		condition(t->kids[2]);
		symt_populate(t->kids[4]);
	} else if (t->kind == "selection_statement2"){
		condition(t->kids[2]);
		symt_populate(t->kids[4]);
		symt_populate(t->kids[6]);	
	} else {
		condition(t->kids[2]);
		symt_populate(t->kids[4]);
	}
}

void condition(struct tree *t){
	if (debug == 1) printf("\t\tCONDITION\n");
	expression(t);	
}

/* -----------------------------
 * ----------EXPRESSIONS--------
 * -----------------------------
*/  

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

void expression_list_opt(struct tree *t){
	if (debug == 1) printf("EXPRESSION_LIST_OPT\n");
	if (t->prodrule == EXPRESSION_LIST_OPT){
	} else {
		expression(t);
	}
}	

void assignment_expression(struct tree *t){
	if (debug == 1) printf("\t\tASSIGNMENT_EXPRESSION\n");
	if (t->prodrule == ASSIGNMENT_EXPRESSION){
		/*lnode = traverse(t->kids[0]);
		get_type(lnode);
		rnode = traverse(t->kids[2]);
                get_type(rnode);
                if (lnode->type != rnode->type){
                        printf("ERROR: Attempting to equate two symbols together of differing types: lsymbol - %s, rsymbol - %s on lineno - %d\n", lnode->leaf->text, rnode->leaf->text, lnode->leaf->lineno);
                        numErrors++;
                }*/
		assignment_expression(t->kids[2]);
		logical_or_expression(t->kids[0]);
		get_type(nnode);
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
		lnode = traverse(t->kids[0]);
		rnode = traverse(t->kids[2]);
		get_type(lnode);
		get_type(rnode);
		if (lnode->type != rnode->type){
			fprintf(stderr, "ERROR: Attempting to compare two symbols together of differing types. lsymbol type - %s | text - %s | lineno %d, rsymbol type - %s | text - %s | lineno %d\n", typechar(lnode), lnode->leaf->text, lnode->leaf->lineno, typechar(rnode), rnode->leaf->text, rnode->leaf->lineno);
			numErrors++;
		}
		relational_expression(t->kids[0]);
		shift_expression(t->kids[2]);
	} else {
		shift_expression(t);
	}
}

void shift_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\tSHIFT_EXPRESSION\n");
	if (t->prodrule == SHIFT_EXPRESSION){
		/*lnode = traverse(t->kids[0]);
		rnode = traverse(t->kids[2]);
		get_type(lnode);
		get_type(rnode);
		if (lnode->type != rnode->type){
			printf("ERROR: Attempting to compare two symbols together of differing types: lsymbol - %s, rsymbol - %s, on lineno - %d\n", lnode->leaf->text, rnode->leaf->text, lnode->leaf->lineno);
			numErrors++;
		}*/
		shift_expression(t->kids[0]);
		additive_expression(t->kids[2]);
	} else {
		additive_expression(t);
	}	
}

void additive_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\t\tADDITIVE_EXPRESSION\n");
	if (t->prodrule == ADDITIVE_EXPRESSION){
		if (t->kids[0]->prodrule == MULTIPLICATIVE_EXPRESSION){
			multiplicative_expression(t->kids[0]);
		} else if (t->kids[2]->prodrule == MULTIPLICATIVE_EXPRESSION){
			multiplicative_expression(t->kids[2]);
		} else {
		get_type(t->kids[0]->kids[0]);
		get_type(t->kids[2]->kids[0]);
		lnode = t->kids[0]->kids[0];
		rnode = t->kids[2]->kids[0];
		if (lnode->type != rnode->type && rnode->leaf != NULL && lnode->leaf != NULL){
                        fprintf(stderr, "ERROR: Attempting to add or subtract two symbols together of differing types. lsymbol type - %s | text - %s | lineno %d, rsymbol type - %s | text - %s | lineno %d\n", typechar(lnode), lnode->leaf->text, lnode->leaf->lineno, typechar(rnode), rnode->leaf->text, rnode->leaf->lineno);
			numErrors++;
		}
		additive_expression(t->kids[0]);
		multiplicative_expression(t->kids[2]);
		}
	} else {
		multiplicative_expression(t);
	}
}

void multiplicative_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\t\t\t\tMULTIPLICATIVE_EXPRESSION\n");
	if (t->prodrule == MULTIPLICATIVE_EXPRESSION){
		get_type(t->kids[0]->kids[0]);
		get_type(t->kids[2]->kids[0]);
		lnode = t->kids[0]->kids[0];
		rnode = t->kids[2]->kids[0];
		if (lnode->type != rnode->type && rnode->leaf != NULL && lnode->leaf != NULL){
                        fprintf(stderr, "ERROR: Attempting to multiply, divide, or mod two symbols together of differing types. lsymbol type - %s | text - %s | lineno %d, rsymbol type - %s | text - %s | lineno %d\n", typechar(lnode), lnode->leaf->text, lnode->leaf->lineno, typechar(rnode), rnode->leaf->text, rnode->leaf->lineno);

			numErrors++;
		}
		//currtype = lnode->
		multiplicative_expression(t->kids[0]);
		postfix_expression(t->kids[2]);
	} else {
		cast_expression(t);
	}
}
//skipped pm_expression - multiplicative_exp -> pm_exp -> unary_exp
void cast_expression(struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\tCAST_EXPRESSION\n");
	if (t->prodrule == CAST_EXPRESSION){
		postfix_expression(t->kids[0]);
	} else {
		get_type(t);
	}
}


void postfix_expression (struct tree *t){
	if (debug == 1) printf("\t\t\t\t\t\t\t\tPOSTFIX_EXPRESSION\n");
	if (t->prodrule == POSTFIX_EXPRESSION){
		if (strcmp(t->kind, "postfix_expression1") == 0){
			t->isArray = 1;
		}
		check_all_tables(t->kids[0]);
		postfix_expression(t->kids[0]);
		expression_list_opt(t->kids[2]);
	} else {
		nnode = t;
		if (param_global == 1){
			if (debug == 1) printf("this is a param\n");
		}
		
	}
}

/* -----------------------------
 * ----------CLASSES------------
 * -----------------------------
*/

void class_specifier (struct tree *t){
	class_head(t->kids[0]);
	member_specification_opt(t->kids[2]);
}

void class_head (struct tree *t){
	check_ht_get(t->kids[1]);
}

void member_specification_opt (struct tree *t){
	if (t->prodrule == MEMBER_SPECIFICATION){
		member_specification(t);
	} else {
	}
}

void member_specification (struct tree *t){
	if (t->kind == "member_specification1"){
		member_declaration(t->kids[0]);
		member_specification_opt(t->kids[1]);
	} else {
		//access_specifier(t->kids[0]);
		member_specification_opt(t->kids[2]);
	}	
}

void member_declaration(struct tree *t){

}

/* -----------------------------
 * ----TYPE-CHECK-FUNCTIONS-----
 * -----------------------------
*/

/* primary function to do simple ht lookups */
void check_ht_get(struct tree *t){
	if (ht_get(currtable, t->leaf->text) != NULL){
			if (strcmp(func_scope, ht_get(currtable, t->leaf->text)) == 0){
			fprintf(stderr, "ERROR: Symbol %s is already defined. Duplicate declaration on line %d\n", t->leaf->text, t->leaf->lineno);
        		numErrors++;
		}
	} else {
		if (t->isFunction == 1){
			func = 1;
			currscope = func_scope;
			func_scope = "global";
		}
        	t->type = currtype;
		//if(t->type == 1){
        		//fprintf(stderr, "ERROR: Symbol %s is being defined as void on line %d\n", t->leaf->text, t->leaf->lineno);
   			//numErrors++;
		//} else {
			if (debug == 1) printf("---------\nPUTTING NEW SYMBOL INTO A TABLE\n---------\n");
        		if (debug==1) printf("Current symbol %s\n", t->leaf->text);
			if(debug == 1) printf("Current scope %s\n", func_scope);
        		if (debug == 1)printf("Current type %d\n", t->type);
			if (debug == 1)printf("Is function %d\n",func);
			if (debug == 1) printf("Is array %d\n", t->isArray);
			if (debug == 1)printf("Num params %d\n", num_param);
			ht_set(currtable, t->leaf->text, func_scope, t->type, func, param, num_param, param_pos);
		//}		
		func = 0;
		func_def = 0;
		func_scope = currscope;
	}
}

/* checks all possible tables (limit 15 functions) for an etnry */
int check_all_tables(struct tree *t){
	if (debug == 1) printf("DEBUG: In check_all_tables \n");
	int i;
	if (gtable != NULL){
	if (ht_get(gtable, t->leaf->text) == NULL){
	} else {
		return 1;
	}
	}
	for (i = 0; i < 14; i++){
		if (gtable->ltable[i] != NULL && t->leaf != NULL){
			if (ht_get(gtable->ltable[i], t->leaf->text) == NULL){
			} else {
				return 1;
			}
		}
	}
	return 0;	
}		

int find_function(struct tree *t){
	int i;
	int flag = 0;
	for (i = 0; i < 15; i++){
		if (gtable->ltable[i] != NULL && t->leaf != NULL){
			if ((ht_function(gtable, t->leaf->text) != 1) && (ht_function(gtable->ltable[i], t->leaf->text) != 1)){
			flag++;
			} else {
				func_global = 1;
				return 1;
			}
		}
	}/*
        if (flag == 15){
                fprintf(stderr, "ERROR: Undefined function being called. Function name - %s | lineno - %d\n", t->leaf->text, t->leaf->lineno);
                numErrors++;
                return 0;
        }*/
	return 0;
}

int find_param(struct tree *t){
	int i; 
	int x = 0;
	int flag = 0;
	for (i = 0; i < 15; i++){
		if (gtable->ltable[i] != NULL){
		if (ht_param(gtable, t->leaf->text) == 20){
		} else {
			x = ht_param(gtable, t->leaf->text); 
			return x;
		}
		if (ht_param(gtable->ltable[i], t->leaf->text) == 20){
		} else {
			x = ht_param(gtable->ltable[i], t->leaf->text); 
			return x;
		}
		}
	}
}

/* returns a ht success/fail based on data_type, rather than scope */
void get_type(struct tree *t){
	if (t->kind != NULL){
		if (strcmp(t->kind, "postfix_expression2") == 0){
			param_global = 1;
			expression_list_opt(t->kids[2]);
			param_global = 0;
		}
	}
	if (t->prodrule != INTEGER && t->prodrule != POSTFIX_EXPRESSION){
		find_function(t);
		if (func_global == 0){
			if (t->leaf != NULL){
				if ((ht_get_type(currtable, t->leaf->text) == 20) && (ht_get_type(gtable, t->leaf->text) == 20)){
					fprintf(stderr, "ERROR: Attempting to use symbol that is not defined: %s | line %d\n", t->leaf->text, t->leaf->lineno);
					numErrors++;
				} else {
					if (ht_get_type(currtable, t->leaf->text) != 20){
						t->type = ht_get_type(currtable, t->leaf->text);
					} else if (ht_get_type(gtable, t->leaf->text) != 20){
						t->type = ht_get_type(gtable, t->leaf->text);
					}
			if (ht_get_type(currtable, t->leaf->text) == ht_get_type(gtable, t->leaf->text)){
				//fprintf(stderr, "ERROR: Attempting to use a symbol that is already defined globally. Duplicate entry: %s | line %d\n", t->leaf->text, t->leaf->lineno);
				//numErrors++;
			} 
			}
			}
		}
	}
	if (t->prodrule == INTEGER){
		t->type = 2;
	}
	if (func_global == 1 && param_global == 1){
		fprintf(stderr, "ERROR: Function being called within another function: %s | line %d\n", t->leaf->text, t->leaf->lineno);
		numErrors++;
	}
	if (func_global == 1 && param_global == 0 && find_param(t) > 0){
		fprintf(stderr, "ERROR: Attempting to use a function without including parameters: %s | line %d\n", t->leaf->text, t->leaf->lineno);
		numErrors++;
	}	
	func_global = 0;
}

/* pushes down the tree to a leaf, should only be used with care, for when you know the 
 * grammar has a kid[0] leaf you're trying to push down to.
*/
struct tree *traverse(struct tree *t){
	int i;
	while (t->prodrule != IDENTIFIER){
		t = t->kids[0];
	}
	return t;
}
