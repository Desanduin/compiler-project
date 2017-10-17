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
hashtable_t *ht_create(int size) {
 	hashtable_t *hashtable = NULL;
	int i;

	if (size < 1) {
		return NULL;
	}

	if ((hashtable = malloc(sizeof(hashtable_t))) == NULL) {
		return NULL;
	}
	if ((hashtable->table = malloc(sizeof(entry_t *) *size)) == NULL) {
		return NULL;
	}
	for (i = 0; i < size; i++) {
		hashtable->table[i] = NULL;
	}
	hashtable->size = size;
	return hashtable;
	
}

/* hash a key value for a particular table */
int ht_hash(hashtable_t *hashtable, char *key){
	unsigned long int hashval;
	int i = 0;
	while (hashval < ULONG_MAX && i < strlen(key)) {
		hashval = hashval << 8;
		hashval += key[i];
		i++;
	}
	return hashval % hashtable->size;
}

/* creates a new "pair" of values */ 
entry_t *ht_newpair(char *key, char *scope, int data_type, char *aux_flag){
	entry_t *newpair;
	if ((newpair = malloc(sizeof(entry_t))) == NULL) {
		return NULL;
	}
	if ((newpair->key = strdup(key)) == NULL) {
		return NULL;
	}
	if ((newpair->scope = strdup(scope)) == NULL) {
		return NULL;
	}
	if ((newpair->data_type == '\0')) {
		return NULL;
	}
	if ((newpair->aux_flag = strdup(aux_flag)) == NULL) {
		return NULL;
	}
	return newpair;
}

/* inserts a key and values into a hash table */
void ht_set(hashtable_t *hashtable, char *key, char *scope, int data_type, char *aux_flag) {
	int bin = 0;
	entry_t *newpair = NULL;
	entry_t *next = NULL;
	entry_t *last = NULL;
	if(debug == 1) printf("DEBUG: Entering ht_hash from ht_set\n");
	bin = ht_hash(hashtable, key);
	if(debug == 1) printf("DEBUG: Exiting ht_hash into ht_set\n");
	next = hashtable->table[bin];
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
		newpair = ht_newpair(key, scope, data_type, aux_flag);
		
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
}	


/* heavily used in semantic checking */
char *ht_get(hashtable_t *hashtable, char *key){
	int bin = 0;
	entry_t * pair;
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
