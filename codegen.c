/* Provided by Dr. J's lecture notes */
#include "codegen.h"
#include <stdio.h>
#include <string.h>

#include <stdlib.h>
#include "tree.h"
#include "tac.h"
#include "globals.h"
#include "gram_rules.h"
#include "120gram.tab.h"
void cg_rules (struct tree *);
void gen_ic_file (FILE *, struct tree *);
void gen_string_region (FILE *, struct tree *);
void gen_data_region (FILE *, struct tree *);
void gen_code_region (FILE *, struct tree *);
void write_ic (FILE *, struct tree *);

/*
int get_address(struct tree *t, char *key){
        int i;
        int flag = 0;
        if (gtable != NULL){
                ht_code_init(gtable);
        }
        printf("hi\n");
        for (i = 0; i < 14; i++){
                if (gtable->ltable[i] != NULL){
                        printf("sup\n");
                        ht_code_init(gtable->ltable[i]);
                }
        }
        return 0;
}
*/
void codegen(struct tree *t){
	char *temp;
	temp = fname;
	char *tac_fname = malloc(strlen(temp)+5);	
	tac_fname = strstr(temp, ".cpp");
	strncpy(tac_fname, "", sizeof(temp));
	strcat(temp, ".ic");
	ic = fopen(temp, "w");
	cg_rules(t);
	gen_ic_file(ic, t);
	fclose(ic);
}

void gen_ic_file(FILE *ic, struct tree *t){
	int i;
        fprintf(ic, ".string\n");
	gen_string_region(ic, t);
        fprintf(ic, ".data\n");
	gen_data_region(ic, t);
	write_ic(ic, t);
	fprintf(ic, ".code\n");
	gen_code_region(ic, t);
}

void write_ic(FILE *ic, struct tree *t){
	while (t->code->next != NULL){
		switch(t->code->opcode){
			case O_ASN:
				fprintf(ic, "asn\tloc:%d,loc:%d\n", t->code->src2, t->code->src1);
				break;
		}
		t->code = t->code->next;
	}
}

void gen_string_region(FILE *ic, struct tree *t){

}

void gen_data_region(FILE *ic, struct tree *t){
        int i;
        for(i=0;i<t->nkids;i++){
                gen_data_region(ic, t->kids[i]);
        }
	// only interested in declarations that are in the global scope
	switch (t->prodrule) {
		case INIT_DECLARATOR:{
		struct instr *g;
		t->address.offset = ht_get_address(gtable, t->kids[0]->leaf->text);
		g = gen(O_ASN, t->address, t->kids[1]->address, t->address);
		t->code = concat(t->code, g);
		break;
		}
                default:
                        t->code = NULL;
                        for(i=0;i<t->nkids;i++){
                                if (t->kids[i]->code != NULL){
                                t->code = concat(t->code, t->kids[i]->code);
                                }	
			}
	}

}

void gen_code_region(FILE *ic, struct tree *t){
        int i;
        if (t->prodrule == FUNCTION_DEFINITION && strcmp(t->kind, "function_definition2") == 0){
                fprintf(ic, "%s:\n", t->kids[1]->kids[0]->leaf->text);
        }
        for(i=0;i<t->nkids;i++){
                gen_code_region(ic, t->kids[i]);
        }
}

void cg_rules(struct tree * t) {
   	int i;
   	if (t==NULL) {
		return;
	}

   /*
 *     * this is a post-order traversal, so visit children first
 *         */
   	for(i=0;i<t->nkids;i++){
      		cg_rules(t->kids[i]);
	}

   /*
 *     * back from children, consider what we have to do with
 *         * this node. The main thing we have to do, one way or
 *             * another, is assign t->code
 *                 */
	switch (t->prodrule) {
		case SIMPLE_DECLARATION: {
			
			break;
		}
   		case ADDITIVE_EXPRESSION: {
			t->loc = newlabel();
      			struct instr *g;
      			t->code = concat(t->kids[0]->code, t->kids[1]->code);
			g = gen(O_ADD, t->address, t->kids[0]->address, t->kids[1]->address);
      			t->code = concat(t->code, g);
      			break;
		}
		case DECL_SPECIFIER_SEQ: {
			
			break;
		}
		case INIT_DECLARATOR_LIST: {

			break;
		}
		case INIT_DECLARATOR: {

			break;
		}
		case DECLARATOR: {
			
			break;
		}
		case DIRECT_DECLARATOR: {
			
			break;
		}
		case PARAMETER_DECLARATION_LIST: {

			break;
		}
		case PARAMETER_DECLARATION: {
			
			break;
		}
		case FUNCTION_DEFINITION: {
			
			break;
		}
		case SELECTION_STATEMENT: {

			break;
		}
		case CONDITION: {

			break;
		}
		case EXPRESSION: {

			break;
		}
		case EXPRESSION_LIST_OPT: {
			
			break;
		}
		case ASSIGNMENT_EXPRESSION: {

			break;
		}
		case LOGICAL_OR_EXPRESSION: {
			
			break;
		}
		case LOGICAL_AND_EXPRESSION: {
			
			break;
		}
		case INCLUSIVE_OR_EXPRESSION: {
			
			break;
		}
		case AND_EXPRESSION: {
		
			break;
		}
		case EQUALITY_EXPRESSION: {

			break;
		}
		case RELATIONAL_EXPRESSION: {
			
			break;
		}
		case SHIFT_EXPRESSION: {
			
			break;
		}
   /*
 *     * ... really, a bazillion cases, up to one for each
 *         * production rule (in the worst case)
 *             */
   		default:
      /* default is: concatenate our children's code */
      			t->code = NULL;
			for(i=0;i<t->nkids;i++){
				if (t->kids[i]->code != NULL){
         			t->code = concat(t->code, t->kids[i]->code);
				}
			}
   	}
}
