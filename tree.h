#ifndef TREE_H_
#define TREE_H_
#include "globals.h"
struct tree {
	int prodrule;
	int nkids;
	char *kind;
	int numChildren;
	int epsilonMatched;
	int declaredMatched;
	int type;
	struct token *leaf;
	struct tree *kids[10];
};
int depth;
int numnodes;
int new_file;
struct tree * makeTreeNode(int, char *, int, ...);  
struct tree * leaf(struct token *, int);
void initializePTR(struct tree *);
int treeprint(struct tree *, int);
#endif
