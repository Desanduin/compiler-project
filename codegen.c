/* Provided by Dr. J's lecture notes */
#include "codegen.h"
#include <stdio.h>
#include <string.h>

#include <stdlib.h>
#include "tree.h"
#include "tac.h"
#include "globals.h"
#include "gram_rules.h"
#include "120gram.tab.h"
void gen_ic_file (FILE *, struct tree *);
void gen_string_region (FILE *, struct tree *);
void gen_data_region (FILE *, struct tree *);
void gen_code_region (FILE *, struct tree *);
void write_ic (struct tree *);
struct addr address_null;
void print_opcodes(struct tree *);
int get_address(char *);
int rConst;
int lConst;

int get_address(char *key){
        int i;
        int flag = 0;
	/*
        if (gtable != NULL){
		if (ht_get(gtable, key) != NULL){
		} else {
			flag++;
		}
       	}
	*/
        for (i = 0; i < 14; i++){
                if (gtable->ltable[i] != NULL){
                        if (ht_get(gtable->ltable[i], key) != NULL){
			} else {
				flag++;
			}
                }
        }
        return flag;
}
void codegen(struct tree *t){
	address_null.region = 0;
	address_null.offset = 0;
	address_null.constant = 0;
	rConst = 0;
	lConst = 0;
	char *temp;
	temp = fname;
	char *tac_fname = malloc(strlen(temp)+5);	
	tac_fname = strstr(temp, ".cpp");
	strncpy(tac_fname, "", sizeof(temp));
	strcat(temp, ".ic");
	ic = fopen(temp, "w");
	printf("Generating intermediate code in file %s in the current directory\n", temp);
	gen_ic_file(ic, t);
	//print_opcodes(t);
	fclose(ic);
}

void gen_ic_file(FILE *ic, struct tree *t){
	int i;
        fprintf(ic, ".string\n");
	gen_string_region(ic, t);
        fprintf(ic, ".data\n");
	//gen_data_region(ic, t);
	gen_code_region(ic, t);
	write_ic(t);
}

void write_ic(struct tree *t){
	int temp = 0;
	int i;	
	

	while (t->code != NULL){
/* TODO: create a function for constant checks for common math operators */
		switch(t->code->opcode){
			case O_ASN:
				if (t->code->rConst == 1){
				fprintf(ic, "asn\tloc:%d,const:%d\n", t->code->dest.offset, t->code->src2.constant);
				} else {
				fprintf(ic, "asn\tloc:%d,loc:%d\n", t->code->dest.offset, t->code->src1.offset);
				}
				break;
			case O_ADD:
				if (t->code->rConst == 1){
					fprintf(ic, "add\tloc:%d,loc:%d,const::%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.constant);
				} else if (t->code->lConst == 1){
					fprintf(ic, "add\tloc:%d,const:%d,loc:%d\n", t->code->dest.offset, t->code->src1.constant, t->code->src1.offset);
				} else {
				fprintf(ic, "add\tloc:%d,loc:%d,loc:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.offset);
				}
			break;
                        case O_SUB:
				if (t->code->rConst == 1){
					fprintf(ic, "sub\tloc:%d,loc:%d,const:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.constant);
				} else if (t->code->lConst == 1){
					fprintf(ic, "sub\tcons:%d,loc:%d\n", t->code->dest.offset, t->code->src1.constant, t->code->src2.offset);
				} else {
                                	fprintf(ic, "sub\tloc:%d,loc:%d,loc:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.offset);
                        	}
			break;
                        case O_MUL:
                                if (t->code->rConst == 1){
                                        fprintf(ic, "mul\tloc:%d,loc:%d,const:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.constant);
                                } else if (t->code->lConst == 1){
                                        fprintf(ic, "mul\tconst:%d,loc:%d\n", t->code->dest.offset, t->code->src1.constant, t->code->src2.offset);
                                } else {
                                        fprintf(ic, "mul\tloc:%d,loc:%d,loc:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.offset);
                                }

                        break;
                        case O_DIV:
                                if (t->code->rConst == 1){
                                        fprintf(ic, "div\tloc:%d,loc:%d,const:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.constant);
                                } else if (t->code->lConst == 1){
                                        fprintf(ic, "div\tconst:%d,loc:%d\n", t->code->dest.offset, t->code->src1.constant, t->code->src2.offset);
                                } else {
                                        fprintf(ic, "div\tloc:%d,loc:%d,loc:%d\n", t->code->dest.offset, t->code->src1.offset, t->code->src2.offset);
                                }

                        break;

			case O_RET:
				fprintf(ic, "return\tconst:%d\n", t->code->dest.constant);
			break;
			case D_LABEL:
				fprintf(ic, "label\tlab:%d\n", t->code->dest.lab);
			break;
			case O_BLT:
				fprintf(ic, "blt\tloc:%d,const:%d,lab:%d\n", t->code->dest.offset, t->code->src2.constant, t->code->dest.lab);
			break;
			default: 
			break;
		}
		t->code = t->code->next;	
	}
        for(i=0;i<t->nkids;i++){
                write_ic(t->kids[i]);
        }

}

void print_opcodes(struct tree *t){
	while (t->code != NULL){
		printf("opcodes %d\n", t->code->opcode);
		t->code = t->code->next;
	}
}

void gen_string_region(FILE *ic, struct tree *t){

}

void gen_data_region(FILE *ic, struct tree *t){
        int i;
        for(i=0;i<t->nkids;i++){
                gen_data_region(ic, t->kids[i]);
        }
	// only interested in declarations that are in the global scope
	switch (t->prodrule) {
		case INIT_DECLARATOR:{
			struct instr *g;
			if (t->kids[0]->nkids == 0){
			t->address.offset = ht_get_address(gtable, t->kids[0]->leaf->text);
			g = gen(O_ASN, t->address, t->kids[1]->address, t->address);
			t->code = concat(t->code, g);
			}
			break;
		}
                default:
                        t->code = NULL;
                        for(i=0;i<t->nkids;i++){
                                if (t->kids[i]->code != NULL){
                                	t->code = concat(t->code, t->kids[i]->code);
                                }	
			}
	}

}

void gen_code_region(FILE *ic, struct tree *t){
        int i;
	int bin = 0;
	int temp = 0;
	rConst = 0;
	lConst = 0;
        if (t->prodrule == FUNCTION_DEFINITION && strcmp(t->kind, "function_definition2") == 0 && temp == 0){
                if (temp == 0){
                        fprintf(ic, ".code\n");
                        temp++;
                }
                fprintf(ic, "%s:\n", t->kids[1]->kids[0]->leaf->text);

		bin = get_address(t->kids[1]->kids[0]->leaf->text);
        }
        for(i=0;i<t->nkids;i++){
                gen_code_region(ic, t->kids[i]);
        }
	switch (t->prodrule) {
                case INIT_DECLARATOR:{
                        struct instr *g;
                        if (t->kids[0]->nkids == 0){
                        //t->address.offset = ht_get_address(gtable, t->kids[0]->leaf->text);
                        //g = gen(O_ASN, t->address, t->kids[1]->address, t->address);
                        //t->code = concat(t->code, g);
                        }
                        break;
                }
		// x+x or x-x
		case ADDITIVE_EXPRESSION: {
			t->loc = newtemp();
			struct instr *g;
			if (t->kids[0]->prodrule == MULTIPLICATIVE_EXPRESSION){
			
			} else if (t->kids[2]->prodrule == MULTIPLICATIVE_EXPRESSION){
	
			} else {
				if (t->kids[0]->kids[0]->leaf->category == INTEGER){
				t->kids[0]->kids[0]->address.constant = atoi(t->kids[0]->kids[0]->leaf->text);
				lConst = 1;
			} else {
				t->kids[0]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[0]->kids[0]->leaf->text);
			}
			if (t->kids[2]->kids[0]->leaf != NULL){
				if (t->kids[2]->kids[0]->leaf->category == INTEGER){
					t->kids[2]->kids[0]->address.constant = atoi(t->kids[2]->kids[0]->leaf->text);
					rConst = 1;
				} else {
					t->kids[2]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[2]->kids[0]->leaf->text);
				}
			}
			t->code = concat(t->kids[0]->kids[0]->code, t->kids[2]->kids[0]->code);
			if (strcmp(t->kind, "additive_expression1") == 0){
				g = gen(O_ADD, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			} else {
			g = gen(O_SUB, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			}
			t->code = concat(t->code, g);
			t->code->rConst = rConst;
			t->code->lConst = lConst;
			}
			break;
		}
		// x*x or x/x
		case MULTIPLICATIVE_EXPRESSION: {
                        t->loc = newtemp();
                        struct instr *g;
			if (t->kids[0]->prodrule == PM_EXPRESSION){
			
			} else if (t->kids[2]->prodrule == PM_EXPRESSION){
	
			} else {
			if (t->kids[0]->kids[0]->leaf->category == INTEGER){
				t->kids[0]->kids[0]->address.constant = atoi(t->kids[0]->kids[0]->leaf->text);	
				t->code->lConst = 1;
			} else {
				t->kids[0]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[0]->kids[0]->leaf->text);
			}
			if (t->kids[2]->kids[0]->leaf != NULL){
				if (t->kids[2]->kids[0]->leaf->category == INTEGER){
					t->kids[2]->kids[0]->address.constant = atoi(t->kids[0]->kids[0]->leaf->text);
					rConst = 1;
				} else {
                                        t->kids[2]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[2]->kids[0]->leaf->text);	
				}
			}
			t->code = concat(t->kids[0]->kids[0]->code, t->kids[2]->kids[0]->code);
			if (strcmp(t->kind, "multiplicative_expression1") == 0){	
                        g = gen(O_MUL, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			} else if (strcmp(t->kind, "multiplicative_expression2") == 0){
			g = gen(O_DIV, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			} else {
			//g = gen(O_MOD, t->address, t->kids[0]->address, t->kids[2]->address);
			}
                        t->code = concat(t->code, g);
			t->code->lConst = lConst;
			t->code->rConst = rConst;
			}
			break;
		}
		case UNARY_EXPRESSION: {
			t->loc = newtemp();
                        struct instr *g;
			g = gen(O_NEG, t->address, t->kids[0]->address, address_null);
			t->code = concat(t->code, g);
			break;
		}
		case JUMP_STATEMENT: {
			struct instr *g;
			if (strcmp(t->kind, "jump_statement3") == 0){
			t->address.constant = atoi(t->kids[1]->kids[0]->leaf->text);
			g = gen(O_RET, t->address, t->kids[1]->address, address_null);
			t->code = concat(t->code, g);
			}
			break;
		}
		case ITERATION_STATEMENT: {
			struct instr *g;
			t->first = newlabel();
			t->kids[2]->success = newlabel();
			//t->kids[2]->false = parent.follow;
			t->kids[4]->follow = t->kids[2]->first;
			t->address.region = R_LABEL;
			t->address.lab = t->first;
			g = gen(D_LABEL, t->address, t->kids[2]->address, t->kids[4]->address);
			t->code = concat(t->code, g);
			break;
		}
		case SELECTION_STATEMENT: {
			t->follow = newlabel();
			if (strcmp(t->kind, "selection_statement3") == 0){
			t->kids[4]->first = newlabel();
			} else {
			t->kids[4]->first = newlabel();
			}
			break;
		}
		case RELATIONAL_EXPRESSION: {
			struct instr *g;
			if (t->kids[2]->kids[0] != NULL){
				if (t->kids[2]->kids[0]->leaf->category == INTEGER){
					t->kids[2]->kids[0]->address.constant = atoi(t->kids[2]->kids[0]->leaf->text);
				}
			}
			t->kids[0]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[0]->kids[0]->leaf->text);
			g = gen(O_BLT, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			t->code = concat(t->code, g);
			break;
		}
		case EQUALITY_EXPRESSION: {
			t->first = newlabel();
			break;
		}
		case ASSIGNMENT_EXPRESSION: {
			struct instr *g;
			if (t->kids[2]->kids[0]->leaf != NULL){
				if (t->kids[2]->kids[0]->leaf->category == INTEGER){
					t->kids[2]->kids[0]->address.constant = atoi(t->kids[2]->kids[0]->leaf->text);
					rConst = 1;
				} else if (t->kids[2]->kids[0]->leaf->category == FLOATING){
					//TODO: constant is an int. This doesn't work as intended, fix
					t->kids[2]->kids[0]->address.constant = atof(t->kids[2]->kids[0]->leaf->text);	
					rConst = 1;			
				} else {
				t->kids[2]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[2]->kids[0]->leaf->text);
				}
			}
			t->kids[0]->kids[0]->address.offset = ht_get_address(gtable->ltable[bin], t->kids[0]->kids[0]->leaf->text);			
			t->address.offset = ht_get_address(gtable->ltable[bin], t->kids[0]->kids[0]->leaf->text);
			// push dest offset down to children
			// push to additive_exp
			if (t->kids[2]->code != NULL){
			t->kids[2]->code->dest.offset = t->address.offset;
			}
			// push to multi_exp
			if (t->kids[2]->kids[0]->code != NULL){
				t->kids[2]->kids[0]->code->dest.offset = t->address.offset;
			}
			if (t->kids[2]->kids[2] != NULL){
			if (t->kids[2]->kids[2]->code != NULL){
				t->kids[2]->kids[2]->code->dest.offset = t->address.offset;
			}	
			}
			t->code = concat(t->code, t->kids[2]->kids[0]->code);
			g = gen(O_ASN, t->address, t->kids[0]->kids[0]->address, t->kids[2]->kids[0]->address);
			t->code = concat(t->code, g);
			t->code->rConst = rConst;
			break;
		}
		// end goal is to always concat code	
		default:
                        t->code = NULL;
                        /*for(i=0;i<t->nkids;i++){
                                if (t->kids[i]->code != NULL){
                                        t->code = concat(t->code, t->kids[i]->code);
                                }
                        }
			*/
		break;
	}
}

