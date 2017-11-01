/*
 * hash table largely provided by: https://gist.github.com/tonious/1377667
*/

#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include "symt.h"
#include "globals.h"
/* 
 * create a new table, should be called a few times
 * global, one per class for member variables and functions
 * and one per function for parameters and locals
 *
*/
struct hashtable *ht_create(int size) {
 	struct hashtable *hashtable = NULL;
	int i;
	if (size < 1) {
		return NULL;
	}

	if ((hashtable = malloc(sizeof(struct hashtable))) == NULL) {
		return NULL;
	}
	if ((hashtable->table = malloc(sizeof(struct entry *) *size)) == NULL) {
		return NULL;
	}
	for (i = 0; i < size; i++) {
		hashtable->table[i] = NULL;
	}
	hashtable->size = size;
	return hashtable;
	
}

/* hash a key value for a particular table */
static int ht_hash(struct hashtable *hashtable, char *key){
	unsigned long int hashval;
	unsigned int i = 0;
	while (hashval < ULONG_MAX && i < strlen(key)) {
		hashval = hashval << 8;
		hashval += key[i];
		i++;
	}
	return hashval % hashtable->size;
}

/* creates a new "pair" of values */ 
static struct entry *ht_newpair(char *key, char *scope, int data_type){
	struct entry *newpair;
	if ((newpair = malloc(sizeof(struct entry))) == NULL) {
		return NULL;
	}
	if ((newpair->key = strdup(key)) == NULL) {
		return NULL;
	}
	if ((newpair->scope = strdup(scope)) == NULL) {
		return NULL;
	}
	/*if ((newpair->data_type == 0)) {
		printf("hey4\n");
		return NULL;
	}*/
	memcpy(newpair->scope, scope, data_type);
	newpair->next = NULL;
	return newpair;
}

/* inserts a key and values into a hash table */
void ht_set(struct hashtable *hashtable, char *key, char *scope, int data_type) {
	int bin = 0;
	if(debug == 1) printf("DEBUG: Entering ht_hash from ht_set\n");
	bin = ht_hash(hashtable, key);
	struct entry *next = NULL;
	if(debug == 1) printf("DEBUG: Exiting ht_hash into ht_set\n");
	next = hashtable->table[bin];
	struct entry *last = NULL;
	while (next != NULL && next->key != NULL && strcmp(key, next->key) > 0) {
		last = next;
		next = next->next;
	}

	/* 
 	* if this true, a pair already exists with the same key
 	* we shouldn't do anything with that, that would be an error
 	*
	*/
	if (next != NULL && next->key != NULL && strcmp(key, next->key) == 0){
		printf("ERROR: Symbol '%s' is already defined at line .\n", key);
	/* yay we couldn't find the key, make one! */ 
	} else {
		if(debug == 1) printf("DEBUG: Entering ht_newpair from ht_set\n");
		struct entry *newpair = NULL;
		newpair = ht_newpair(key, scope, data_type);
		if(debug == 1) printf("DEBUG: Exiting ht_newpair into ht_set\n");
		if (next == hashtable->table[bin]) {
			newpair->next = next;
			hashtable->table[bin] = newpair;
		} else if (next == NULL) {
			last->next = newpair;
		} else {
			newpair->next = next;
			last->next = newpair;
		}
	}
	if (debug == 1) printf("DEBUG: Leaving ht_set\n");
}	


/* heavily used in semantic checking */
char *ht_get(struct hashtable *hashtable, char *key){
	int bin = 0;
	struct entry * pair;
	if (debug == 1) printf("DEBUG: Entering ht_hash from ht_get\n");
	bin = ht_hash(hashtable, key);
	pair = hashtable->table[bin];
	while (pair != NULL && pair->key != NULL && strcmp(key, pair->key) > 0) {
		pair = pair->next;
	}

	if (pair == NULL || pair->key == NULL || strcmp(key, pair->key) != 0) {
		return NULL;
	} else {
		return pair->scope;
	}
}	
