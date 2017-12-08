/*
 * hash table largely provided by: https://gist.github.com/tonious/1377667
*/

#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include "symt.h"
#include "type.h"
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
	if (debug == 2) printf("Entering ht_hash\n");
	unsigned long int hashval = 0;
	unsigned int i = 0;
	while (hashval < ULONG_MAX && i < strlen(key)) {
		hashval = hashval << 8;
		hashval += key[i];
		i++;
	}
	if (debug == 2) printf("Exiting ht_hash\n");
	return hashval % hashtable->size;
}

/* creates a new "pair" of values */ 
static struct entry *ht_newpair(char *key, char *scope, int data_type, int func, int param, int num_param, int param_pos){
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
	memcpy(newpair->scope, scope, sizeof(scope));
	newpair->data_type = data_type;
	newpair->func = func;
	newpair->param = param;
	newpair->num_param = num_param;
	newpair->param_pos = param_pos;
	newpair->size = return_size(data_type);
        if (strcmp(newpair->scope,"global") == 0){
        	newpair->address.region = R_GLOBAL;
                newpair->address.offset = calc_offset(1, newpair->data_type);
                printf("%d\n", newpair->address.offset);
                } else if (newpair->param == 1){
                        newpair->address.region = R_PARAM;
                        newpair->address.offset = calc_offset(2, newpair->data_type);
                } else {
                        newpair->address.region = R_LOCAL;
                        newpair->address.offset = calc_offset(3, newpair->data_type);
                        printf("%d\n", newpair->address.offset);
	}
	//printf("key: %s, func_param: %d\n", key, func_param);
	newpair->next = NULL;
	return newpair;
}

/* inserts a key and values into a hash table */
void ht_set(struct hashtable *hashtable, char *key, char *scope, int data_type, int func, int param, int num_param, int param_pos) {
	int bin = 0;
	struct entry *next = NULL;
	struct entry *last = NULL;
	if(debug == 2) printf("DEBUG: Entering ht_hash from ht_set\n");
	bin = ht_hash(hashtable, key);
	if(debug == 2) printf("DEBUG: Exiting ht_hash into ht_set\n");
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
		printf("ERROR: Symbol '%s' is already defined - ht_set\n", key);
		numErrors++;
	/* yay we couldn't find the key, make one! */ 
	} else {
		if(debug == 2) printf("DEBUG: Entering ht_newpair from ht_set\n");
		struct entry *newpair = NULL;
		newpair = ht_newpair(key, scope, data_type, func, param, num_param, param_pos);
		if(debug == 2) printf("DEBUG: Exiting ht_newpair into ht_set\n");
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
	if (debug == 2) printf("DEBUG: Leaving ht_set\n");
}	


/* heavily used in semantic checking */
char *ht_get(struct hashtable *hashtable, char *key){
	int bin = 0;
	struct entry * pair;
	if (debug == 2) printf("DEBUG: Entering ht_hash from ht_get\n");
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

int ht_get_type(struct hashtable *hashtable, char *key){
        int bin = 0;
        struct entry * pair;
        if (debug == 2) printf("DEBUG: Entering ht_get_type from ht_get\n");
        bin = ht_hash(hashtable, key);
        pair = hashtable->table[bin];
        while (pair != NULL && pair->key != NULL && strcmp(key, pair->key) > 0) {
		pair = pair->next;
        }
	if (pair == NULL || pair->key == NULL || strcmp(key, pair->key) != 0) {
		return 20;
        } else {
                return pair->data_type;
        }
}

// checks if an entry is a function, should be handed the gtable
int ht_function(struct hashtable *hashtable, char *key){
        int bin = 0;
        struct entry * pair;
        if (debug == 2) printf("DEBUG: Entering ht_function\n");
        bin = ht_hash(hashtable, key);
        pair = hashtable->table[bin];
        while (pair != NULL && pair->key != NULL && strcmp(key, pair->key) > 0) {
                pair = pair->next;
        }
        if (pair == NULL || pair->key == NULL || strcmp(key, pair->key) != 0) {
                return 20;
        } else {
                return pair->func;
        }
}

// checks how many parameters an entry has
int ht_param(struct hashtable *hashtable, char *key){
        int bin = 0;
        struct entry * pair;
        if (debug == 2) printf("DEBUG: Entering ht_function\n");
        bin = ht_hash(hashtable, key);
        pair = hashtable->table[bin];
        while (pair != NULL && pair->key != NULL && strcmp(key, pair->key) > 0) {
                pair = pair->next;
        }
        if (pair == NULL || pair->key == NULL || strcmp(key, pair->key) != 0) {
                return 20;
        } else {
                return pair->num_param;
        }
}

int ht_update_param(struct hashtable *hashtable, char *key, int data_type, int num_param){
	int bin = 0;
        struct entry * pair;
        if (debug == 2) printf("DEBUG: Entering ht_update_param\n");
        bin = ht_hash(hashtable, key);
        pair = hashtable->table[bin];
        while (pair != NULL && pair->key != NULL && strcmp(key, pair->key) > 0) {
                pair = pair->next;
        }
        if (pair == NULL || pair->key == NULL || strcmp(key, pair->key) != 0) {
                return 20;
        } else {
                pair->num_param = num_param;
		pair->data_type = data_type;
        }
}

int ht_function_call(struct hashtable *hashtable, char *key){
	

}

int ht_code_init(struct hashtable *hashtable){
	int bin = 0;
	struct entry * pair;
	if (debug == 2) printf("DEBUG: Entering ht_code_init\n");
	pair = hashtable->table[bin];
	while (pair != NULL && pair->key != NULL){
		printf("hi\n");
		if (strcmp(pair->scope,"global") == 0){
			pair->address.region = R_GLOBAL;
			pair->address.offset = calc_offset(o_global, pair->data_type);	
			printf("%d\n", pair->address.offset);
		} else if (pair->param == 1){
			pair->address.region = R_PARAM;
			pair->address.offset = calc_offset(o_param, pair->data_type);
		} else {
			pair->address.region = R_LOCAL;
			pair->address.offset = calc_offset(o_local, pair->data_type);
			printf("%d\n", pair->address.offset);
		}
		pair = pair->next;
	}
	return 1;
}

int calc_offset(int offset, int data_type){
	int i = 0;
	switch (offset){
		case 1:
			i = o_global;
			break;
		case 2:
			i = o_param;
			break;
		case 3:
			i = o_local;
			break;
	}
	switch (data_type){
		case 2:
			i = i + 8;
			break;
		case 4:
			if (i != 0){
				i = i + 1;
			}
			break;
	}
        switch (offset){
                case 1:
                        o_global = i;
                        break;
                case 2:
                        o_param = i;
                        break;
                case 3:
                        o_local = i;
                        break;
        }
	return i;
}		
