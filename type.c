#include "globals.h"
#include "type.h"
#include "tree.h"
#include <stdlib.h>

struct tree *assigntype(struct tree *t){
	if (strcmp(t->leaf->text, "void") == 0){
		t->type = 1;
	} else if (strcmp(t->leaf->text, "int") == 0){
		t->type = 2;
	} else if (strcmp(t->leaf->text, "double") == 0){
		t->type = 3;
	} else if (strcmp(t->leaf->text, "char") == 0){
		t->type = 4;
	} else if (strcmp(t->leaf->text, "bool") == 0){
		t->type = 5;
	} else if (strcmp(t->leaf->text, "short") == 0){
		t->type = 6;
	} else if (strcmp(t->leaf->text, "long") == 0){
		t->type = 7;
	} else if (strcmp(t->leaf->text, "float") == 0){
		t->type = 8;
	} else if (strcmp(t->leaf->text, "unsigned") == 0){
		t->type = 9;
	} else if (strcmp(t->leaf->text, "string") == 0){
		t->type = 10;
	}
}

char *typechar(struct tree *t){
	if (t->type == 1){
		return "void";
	} else if (t->type == 2){
		return "int";
        } else if (t->type == 3){
                return "double";
        } else if (t->type == 4){
                return "char";
        } else if (t->type == 5){
                return "bool";
        } else if (t->type == 6){
                return "short";
        } else if (t->type == 7){
                return "long";
        } else if (t->type == 8){
                return "float";
        } else if (t->type == 9){
                return "unsigned";
        } else if (t->type == 10){
                return "string";
        }
}

// hardcoding these since we're in a rush
int return_size(int data_type){
	switch (data_type){
		// integers are size 8
		case 2:
			return 8;
		// characters are size 1
		case 4:
			return 1;
		// integers are size 8
		case 10:
			return 8;
		default:
			return;
	}
}
