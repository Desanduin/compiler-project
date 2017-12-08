#ifndef SYM_H
#define SYM_H
#include "tac.h"
struct entry {
	char *key;
	char *scope;
	int data_type;
	int func;
	int param;
	int size;
	int num_param;
	struct addr address;
	int param_pos;
	struct entry *next;
}; 


struct hashtable {
	char *scope;
	int size;
	struct hashtable *ltable[15];
	struct entry **table;
};


char *ht_get(struct hashtable *, char *);
int ht_get_type(struct hashtable *, char *);
void ht_set(struct hashtable *, char *, char *, int, int, int, int, int);
struct hashtable *ht_create( int);
int ht_function(struct hashtable *, char *);
int ht_param(struct hashtable *, char *);
int ht_get_address(struct hashtable *, char *);
int ht_update_param(struct hashtable *, char *, int, int);
#endif
