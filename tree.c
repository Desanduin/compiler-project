#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "tree.h"
#include "globals.h"

#define getName(var) #var

/*
 * makeTreeNode modified from Dr J's provided alctree
 *
 * Need to remove char *kind and use prodrule correctly. This will require
 * a new fucntion that takes prodrule and finds the right grammar rule
 *
*/
struct tree * makeTreeNode(int prodrule, char *kind, int nkids, ...){
	numnodes++;
	int i;
	va_list ap;
	struct tree * ptr = malloc(sizeof(struct tree) + (nkids-1)*sizeof(struct tree *) + sizeof(struct token));
	if (ptr == NULL){
		fprintf(stderr, "tree ran out of memory\n");
		exit(1);
	}
	initializePTR(ptr);
	ptr->prodrule = prodrule;
	ptr->kind = kind;
	ptr->nkids = nkids;
	if (nkids == 0) {
		ptr->epsilonMatched = 1;
	} else {
	va_start(ap, nkids);
   	for(i=0; i < nkids; i++){
      		ptr->kids[i] = va_arg(ap, struct tree *);
	}
   	va_end(ap);
	}
	return ptr;
}
struct tree * leaf (struct token *tokennode, int prodrule){
	struct tree *ptr = malloc(sizeof(struct tree) + sizeof(struct token));
	initializePTR(ptr);
	ptr->prodrule = prodrule;
	ptr->nkids = 0;
	ptr->leaf = tokennode;
	return ptr;
}
void initializePTR(struct tree *init){
	init->prodrule = 0;
	init->nkids = -1;
	init->kind = NULL;
	init->numChildren = 0;
	init->epsilonMatched = 0;
	init->isFunction = 0;
	init->leaf = NULL;
	init->type = 1;
	int i;
	for (i = 0; i < 9; i++){
		init->kids[i] = NULL;
	}
}

// treeprint provided by Dr. J with some small edits
int treeprint(struct tree *t, int depth){
	int i;
	if (t->leaf != NULL){
	}
	if (new_file == 1){
		//printf("Filename: %s\n", t->leaf.filename);
		new_file--;
	}
	if (new_file == 0){
	printf("%*s %s %d\n", depth*2, " ", t->kind, t->nkids);
	for(i=0; i < t->nkids; i++){
		if (t->kids[i] != NULL){
		treeprint(t->kids[i], depth+1);
		}
	}
	}
}

