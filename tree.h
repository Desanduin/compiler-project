#ifndef TREE_H_
#define TREE_H_
#include "globals.h"
<<<<<<< HEAD
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
=======
typedef struct tree {
	int prodrule;
	int nkids;
	char *kind;
	char *text;
	int numChildren;
	struct tree *kids[9];
	struct tree *sibling;
	struct token *leaf;
}*tree;
int depth;
int numnodes;
int new_file;
extern tree *savedTree;
tree makeTreeNode(int prodrule, char *kind, int nkids, ...);  
int treeprint(struct tree *t, int depth);
char * humanreadable(int prodrule);
char * findsvalue(struct tree *t);
>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
#endif
