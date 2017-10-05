#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "tree.h"

tree *makeTreeNode(int prodrule, char *kind, int nkids, ...){
	int i;
	va_list ap;
	tree *ptr = malloc(sizeof(struct tree) + (nkids-1)*sizeof(struct tree*));
	if (ptr == NULL){
		fprintf(stderr, "tree ran out of memory\n");
		exit(1);
	}
	ptr->prodrule = prodrule;
	ptr->kind = kind;
	ptr->nkids = nkids;
	va_start(ap, nkids);
   	for(i=0; i < nkids; i++){
      		ptr->kids[i] = va_arg(ap, tree *);
	}
   	va_end(ap);
   	return ptr;
}

// treeprint provided by Dr. J
int treeprint(struct tree *t, int depth){
	tree *printTree = t;
	int i;
	printf("%*s %s %d\n", depth*2, " ", printTree->kind, printTree->nkids);
	for(i=0; i < printTree->nkids; i++){
		if (printTree->kids[i] != NULL){
		treeprint(printTree->kids[i], depth+1);
		}
	}
}




