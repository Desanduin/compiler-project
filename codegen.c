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
void gen_ic_file (FILE *);

int cg_init(struct tree *t){
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


void codegen(struct tree *t){
	//cg_init(t);
	printf("sui\n");
	char *temp;
	temp = fname;
	char *tac_fname = malloc(strlen(temp)+5);	
	tac_fname = strstr(temp, ".cpp");
	strncpy(tac_fname, "", sizeof(temp));
	strcat(temp, ".ic");
	ic = fopen(temp, "w");
	cg_rules(t);
	gen_ic_file(ic);
	fclose(ic);
}

void gen_ic_file(FILE *ic){
	fprintf(ic, "\t parm loc:0\n");
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
		case STATEMENT_SEQ:
			
			break;
   		case ADDITIVE_EXPRESSION: {
      			struct instr *g;
      			t->code = concat(t->kids[0]->code, t->kids[1]->code);
			g = gen(O_ADD, t->address, t->kids[0]->address, t->kids[1]->address);
      			t->code = concat(t->code, g);
      			break;
		}
		case DASH: {
		
		}
		case MUL: {

		}

		case DIV: {
			struct instr *g;
			t->code = concat(t->kids[0]->code, t->kids[1]->code);
			g = gen(O_DIV, t->address, t->kids[0]->address, t->kids[1]->address);
			t->code = concat(t->code, g);
			break;
		}
		case EQ: {

		}
		case AND: {
	
		}
   /*
 *     * ... really, a bazillion cases, up to one for each
 *         * production rule (in the worst case)
 *             */
   		default:
      /* default is: concatenate our children's code */
      			t->code = NULL;
			for(i=0;i<t->nkids;i++){
         			t->code = concat(t->code, t->kids[i]->code);
			}
   	}
}
