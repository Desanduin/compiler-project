/* Provided by Dr. J's lecture notes */
#include <stdio.h>
#include "tree.h"
#include "tac.h"
void codegen(struct tree * t)
{
   int i;
   if (t==NULL) return;

   /*
 *     * this is a post-order traversal, so visit children first
 *         */
   for(i=0;i<t->nkids;i++)
      codegen(t->kids[i]);

   /*
 *     * back from children, consider what we have to do with
 *         * this node. The main thing we have to do, one way or
 *             * another, is assign t->code
 *                 */
   switch (t->prodrule) {
   case O_ADD: {
      struct instr *g;
      t->code = concat(t->kids[0]->code, t->kids[1]->code);
      g = gen(O_ADD, t->address, t->kids[0]->address, t->kids[1]->address);
      t->code = concat(t->code, g);
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
         t->code = concat(t->code, t->kids[i]->code);
	}
   }
}
