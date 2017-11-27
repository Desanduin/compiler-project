#ifndef TREE_H_
#define TREE_H_
#include "globals.h"
#include "tac.h"
struct tree {
	int prodrule;
	int nkids;
	char *kind;
	struct instr *code;
	struct addr address;
	int numChildren;
	int type;
	int epsilonMatched;
	int isFunction;
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
