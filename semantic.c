#include "tree.h"
#include "symt.h"
#include "semantic.h"
#include "120gram.tab.h"
#include <stdlib.h>
tree semanticAnalysis (tree t, hashtable_t *typetable){
	int i, j, key;
	tree temp = t;
	if (!temp){
	} else if (temp->nkids == 0){
		if (t->leaf->category == IDENTIFIER){
			if(debug == 1) printf("DEBUG: Found an IDENTIFIER to put into hashtable\n");
			if(debug == 1) printf("DEBUG: Entering ht_set from semanticAnalysis\n");
			if (ht_get(typetable, temp->leaf->text) == NULL){
				ht_set(typetable, temp->leaf->text, "global", 0, "test");
			} else {
				printf("ERROR: Symbol '%s' is already defined at line %d\n", temp->leaf->text, temp->leaf->lineno);
			}
			if(debug == 1) printf("DEBUG: Exiting ht_set from semanticAnalysis\n");
			return t;
		}
	} else if (temp->nkids > 0){
		printf("nkids > 0\n");
		if (temp->leaf->text == "function_definition2") {
			if(debug == 1) printf("DEBUG: Found 'function_definition2' to force a local scope\n");
			for (i = 0; i < temp->nkids; i++){
				semanticAnalysis(temp->kids[i], typetable);
			}
			ht_set(typetable, temp->leaf->text, "local", 0, "test");
		} else if (temp->leaf->text == "direct_declarator4"){
			if(debug == 1) printf("DEBUG: Found 'direct_declarator4' to force a custom scope\n");	
		} else {
			printf("looping\n");
			for (j=0; j < temp->nkids; j++){
				semanticAnalysis(temp->kids[j], typetable);
			}
		}
	} else {
		return NULL;
	}
	 
}


