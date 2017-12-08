/*
 *  * Three Address Code - skeleton for CS 445
 *   */
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
#include "tac.h"
int label;
struct instr *gen(int op, struct addr a1, struct addr a2, struct addr a3)
{
  struct instr *rv = malloc(sizeof (struct instr));
  if (rv == NULL) {
     fprintf(stderr, "out of memory\n");
     exit(4);
     }
  rv->opcode = op;
  rv->dest = a1;
  rv->src1 = a2;
  rv->src2 = a3;
  rv->next = NULL;
  return rv;
}

struct instr *copylist(struct instr *l)
{
   if (l == NULL) return NULL;
   struct instr *lcopy = gen(l->opcode, l->dest, l->src1, l->src2);
   lcopy->next = copylist(l->next);
   return lcopy;
}

struct instr *append(struct instr *l1, struct instr *l2)
{
   if (l1 == NULL) return l2;
   struct instr *ltmp = l1;
   while(ltmp->next != NULL) ltmp = ltmp->next;
   ltmp->next = l2;
   return l1;
}

struct instr *concat(struct instr *l1, struct instr *l2)
{
   	return append(copylist(l1), l2);
}

struct addr create_address(struct addr t, int region){
	switch(region){
		case R_GLOBAL:
			t.region = R_GLOBAL;
			t.offset = t.offset + o_global;
			o_global = o_global + 8;
			return t;
		break;
		case R_LOCAL:
			t.region = R_LOCAL;
			t.offset = t.offset + o_local;
			o_local = o_local + 8;
			return t;
		break;
		default:
			if (debug == 1) printf("ERROR: Hit default in create_addres\n");
		break;
	}	
}

int newlabel(){
	label++;
	return label;
}

struct addr newtemp(){
	struct addr temp;
	temp.region = R_LOCAL;
	temp.offset = o_local + 8;
	return temp;
}

char *human_readable_op(int opcode){
	switch(opcode){
		case O_ADD:
			return "add";
		case O_SUB:
			return "sub";
		case O_MUL:
			return "mul";
		case O_DIV:
			return "div";
		case O_NEG:
			return "neg";
		case O_ASN:
			return "asn";
		case O_ADDR:
			return "addr";
		case O_LCONT:
			return "lcont";
		case O_SCONT:
			return "scont";
		case O_GOTO:
			return "goto";
		case O_BLT:
			return "blt";
		case O_BLE:
			return "ble";
		case O_BGT:
			return "bgt";
		case O_BGE:
			return "bge";
		case O_BEQ:
			return "beq";
		case O_BNE:
			return "bne";
		case O_BIF:
			return "bif";
		case O_BNIF:
			return "bnif";
		case O_PARM:
			return "parm";
		case O_CALL:
			return "call";
		case O_RET:
			return "ret";
		default:
			if (debug == 1) printf("ERROR, calling human_readable_op with an unknown code\n");
			break;
	}
}	
