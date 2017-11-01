<<<<<<< HEAD
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
	struct entry **table;
};


char *ht_get(struct hashtable *, char *);
void ht_set(struct hashtable *, char *, char *, int);
struct hashtable *ht_create( int);

#endif
=======
typedef struct entry_s {
	char *key;
	char *scope;
	int data_type;
	char *aux_flag;
	struct entry_s *next;
} *entry_s;

typedef struct entry_s entry_t; 

typedef struct hashtable_s {
	char *scope;
	int size;
	struct entry_s **table;
} *hashtable_s;

typedef struct hashtable_s hashtable_t;

char *ht_get(hashtable_t *, char *);

hashtable_t *ht_create( int);

>>>>>>> 01a1ed476c1c35d8cd4fd7dd0786a4263eb4ab56
