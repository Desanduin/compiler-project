#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "tree.h"


// makeTreeNode modified from Dr J's provided alctree
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

// treeprint provided by Dr. J with some small edits
int treeprint(struct tree *t, int depth){
	int i;
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




