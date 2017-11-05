#ifndef SYM_H
#define SYM_H
struct entry {
	char *key;
	char *scope;
	int data_type;
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
void ht_set(struct hashtable *, char *, char *, int);
struct hashtable *ht_create( int);

#endif
