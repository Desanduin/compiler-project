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
tree makeTreeNode(int prodrule, char *kind, int nkids, ...){
	numnodes++;
	int i;
	va_list ap;
	tree ptr = malloc(sizeof(struct tree) + (nkids-1)*sizeof(struct tree*));
	if (ptr == NULL){
		fprintf(stderr, "tree ran out of memory\n");
		exit(1);
	}
	ptr->prodrule = prodrule;
	ptr->kind = kind;
	ptr->nkids = nkids;
	if (nkids > 0) {
	va_start(ap, nkids);
   	for(i=0; i < nkids; i++){
      		ptr->kids[i] = va_arg(ap, tree *);
	}
   	va_end(ap);
	}
   	return ptr;
}

// treeprint provided by Dr. J with some small edits
int treeprint(struct tree *t, int depth){
	int i;
	if (t->leaf != NULL){
	printf("%s\n", t->leaf->text);
	}
	if (new_file == 1){
		//printf("Filename: %s\n", t->leaf.filename);
		new_file--;
	}
	if (new_file == 0){
	printf("%*s %s %d\n", depth*2, " ", t->kind, t->nkids);
	for(i=0; i < t->nkids; i++){
		if (t->kids[i] != NULL){
		printf("prodrule value: %d\n", t->prodrule);
		treeprint(t->kids[i], depth+1);
		}
	}
	}
}

