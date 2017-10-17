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

