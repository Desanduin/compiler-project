/* Provided by Dr. J's lecture notes */
#include "codegen.h"
#include <stdio.h>
#include <string.h>

#include <stdlib.h>
#include "tree.h"
#include "tac.h"
#include "globals.h"
#include "120gram.tab.h"
void cg_rules (struct tree *);

int cg_init(struct tree *t){
        int i;
        int flag = 0;
        for (i = 0; i < 14; i++){
                if ((ht_code_init(gtable) == 1) && (ht_code_init(gtable->ltable[i]) == 1)){
                flag++;
                } else {
                        return 1;
                }
        }
        return 0;
}


void codegen(struct tree *t){
	cg_init(t);
	char *temp;
	temp = fname;
	char *tac_fname = malloc(strlen(temp)+5);	
	tac_fname = strstr(temp, ".");
	strncpy(tac_fname, "", sizeof(temp));
	strcat(temp, ".ic");
	ic = fopen(temp, "w");
	cg_rules(t);
	fclose(ic);
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
	printf("%d\n", t->prodrule);
	switch (t->prodrule) {
   		case PLUS: {
      			struct instr *g;
      			t->code = concat(t->kids[0]->code, t->kids[1]->code);
      			g = gen(O_ADD, t->address, t->kids[0]->address, t->kids[1]->address);
      			t->code = concat(t->code, g);
			printf("%d\n", t->code);
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
