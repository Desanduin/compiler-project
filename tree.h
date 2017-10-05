#ifndef TREE_H_
#define TREE_H_
#include "structset.h"
typedef struct tree {
	int prodrule;
	int nkids;
	char *kind;
	char *text;
	struct token *token;
	struct tree *kids[9];
	struct tree *sibling;
	struct token *leaf;
}tree;
int depth;
int new_file;
extern tree *savedTree;
tree *makeTreeNode(int prodrule, char *kind, int nkids, ...);  
int treeprint(struct tree *t, int depth);
char * humanreadable(int prodrule);
char * findsvalue(struct tree *t);
#endif
