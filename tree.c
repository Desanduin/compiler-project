#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "tree.h"
#include "globals.h"
#include "gram_rules.h"
#include "120gram.tab.h"


#define getName(var) #var

/*
 * makeTreeNode modified from Dr J's provided alctree
 *
 * Need to remove char *kind and use prodrule correctly. This will require
 * a new fucntion that takes prodrule and finds the right grammar rule
 *
*/
struct tree * makeTreeNode(int prodrule, char *kind, int nkids, ...){
	numnodes++;
	int i;
	va_list ap;
	struct tree * ptr = malloc(sizeof(struct tree) + (nkids-1)*sizeof(struct tree *) + sizeof(struct token));
	if (ptr == NULL){
		fprintf(stderr, "tree ran out of memory\n");
		exit(1);
	}
	initializePTR(ptr);
	ptr->prodrule = prodrule;
	ptr->kind = kind;
	ptr->nkids = nkids;
	if (nkids == 0) {
		ptr->epsilonMatched = 1;
	} else {
	va_start(ap, nkids);
   	for(i=0; i < nkids; i++){
      		ptr->kids[i] = va_arg(ap, struct tree *);
	}
   	va_end(ap);
	}
	return ptr;
}
struct tree * leaf (struct token *tokennode, int prodrule){
	struct tree *ptr = malloc(sizeof(struct tree) + sizeof(struct token));
	initializePTR(ptr);
	ptr->prodrule = prodrule;
	ptr->nkids = 0;
	ptr->leaf = tokennode;
	return ptr;
}
void initializePTR(struct tree *init){
	init->prodrule = 0;
	init->nkids = -1;
	init->kind = NULL;
	init->numChildren = 0;
	init->epsilonMatched = 0;
	init->isFunction = 0;
	init->leaf = NULL;
	init->code = NULL;
	init->isFunction = 0;
	init->isArray = 0;
	//init.address = NULL;
	init->type = 1;
	int i;
	for (i = 0; i < 9; i++){
		init->kids[i] = NULL;
	}
}

// treeprint provided by Dr. J with some small edits
int treeprint(struct tree *t, int depth){
	int i;
	if (t->leaf != NULL){
	}
	if (new_file == 1){
		//printf("Filename: %s\n", t->leaf.filename);
		new_file--;
	}
	if (new_file == 0){
		printf("%*s Prodrule: %s # of children: %d\n", depth*2, " ", t->kind, t->nkids);
		for(i=0; i < t->nkids; i++){
			if (t->kids[i] != NULL){
				treeprint(t->kids[i], depth+1);
			}
		}
	}
}

/* should be used for treeprint, if implemented */
/*
char *human_readable(int prodrule){
	switch (prodrule){
		// gram_rules.h, nonterminals 
		case PRIMARY_EXPRESSION:
			return "PRIMARY_EXPRESSION";
		case UNQUALIFIED_ID:
			return "UNQUALIFIED_ID";
		case QUALIFIED_ID:
			return "QUALIFIED_ID";
		case NESTED_NAME_SPECIFIER:
			return "NESTED_NAME_SPECIFIER";
		case POSTFIX_EXPRESSION:
			return "POSTFIX_EXPRESSION";
		case EXPRESSION_LIST:
			return "EXPRESSION_LIST";
		case UNARY_EXPRESSION:
			return "UNARY_EXPRESSION";
		case NEW_EXPRESSION:
			return "NEW_EXPRESSION";
		case NEW_PLACEMENT:
			return "NEW_PLACEMENT";
		case NEW_TYPE_ID:	
			return "NEW_TYPE_ID";
		case NEW_DECLARATOR:
			return "NEW_DECLARATOR";
		case DIRECT_NEW_DECLARATOR:
			return "DIRECT_NEW_DECLARATOR";
		case NEW_INITIALIZER:
			return "NEW_INITIALIZER";
		case DELETE_EXPRESSION:
			return "DELETE_EXPRESSION";
		case CAST_EXPRESSION:
			return "CAST_EXPRESSION";
		case PM_EXPRESSION:
			return "PM_EXPRESSION";
		case MULTIPLICATIVE_EXPRESSION:
			return "MULTIPLICATIVE_EXPRESSION";
		case ADDITIVE_EXPRESSION:
			return "ADDITIVE_EXPRESSION";
		case SHIFT_EXPRESSION:
			return "SHIFT_EXPRESSION";
		case RELATIONAL_EXPRESSION:
			return "RELATIONAL_EXPRESSION";
		case EQUALITY_EXPRESSION:
			return "EQUALITY_EXPRESSION";
		case AND_EXPRESSION:
			return "AND_EXPRESSION";
		case EXCLUSIVE_OR_EXPRESSION:
			return "EXCLUSIVE_OR_EXPRESSION";
		case INCLUSIVE_OR_EXPRESSION:
			return "INCLUSIVE_OR_EXPRESSION";
		case LOGICAL_AND_EXPRESSION:
			return "LOGICAL_AND_EXPRESSION";
		case LOGICAL_OR_EXPRESSION:
			return "LOGICAL_OR_EXPRESSION";
		case CONDITIONAL_EXPRESSION:
			return "CONDITIONAL_EXPRESSION";
		case ASSIGNMENT_EXPRESSION:
			return "ASSIGNMENT_EXPRESSION";
		case EXPRESSION:
			return "EXPRESSION";
		case LABELED_STATEMENT:
			return "LABELED_STATEMENT";
		case EXPRESSION_STATEMENT:
			return "EXPRESSION_STATEMENT";
		case COMPOUND_STATEMENT:
			return "COMPOUND_STATEMENT";
		case STATEMENT_SEQ:
			return "STATEMENT_SEQ";
		case SELECTION_STATEMENT:
			return "SELECTION_STATEMENT";
		case CONDITION:
			return "CONDITION";
		case ITERATION_STATEMENT:
			return "ITERATION_STATEMENT";
		case JUMP_STATEMENT:
			return "JUMP_STATEMENT";
		case DECLARATION_SEQ:
			return "DECLARATION_SEQ";
		case SIMPLE_DECLARATION:
			return "SIMPLE_DECLARATION";
		case DECL_SPECIFIER_SEQ:
			return "DECL_SPECIFIER_SEQ";
		case SIMPLE_TYPE_SPECIFIER:
			return "SIMPLE_TYPE_SPECIFIER";
		case ELABORATED_TYPE_SPECIFIER:
			return "ELABORATED_TYPE_SPECIFIER";
		case ENUM_SPECIFIER:
			return "ENUM_SPECIFIER";
		case ENUMERATOR_LIST:
			return "ENUMERATOR_LIST";
		case ENUMERATOR_DEFINITION:
			return "ENUMERATOR_DEFINITION";
		case ORIGINAL_NAMESPACE_DEFINITION:
			return "ORIGINAL_NAMESPACE_DEFINITION";
		case EXTENSION_NAMESPACE_DEFINITION:
			return "EXTENSION_NAMESPACE_DEFINTION";
		case UNNAMED_NAMESPACE_DEFINITION:
			return "UNNAMED_NAMESPACE_DEFINTION";
		case NAMESPACE_ALIAS_DEFINITION:
			return "NAMESPACE_ALIAS_DEFINTION";
		case QUALIFIED_NAMESPACE_SPECIFIER:
			return "QUALIFIED_NAMESPACE_SPECIFIER";
		case USING_DECLARATION:
			return "USING_DECLARATION";
		case USING_DIRECTIVE:
			return "USING_DIRECTIVE";
		case ASM_DEFINITION:
			return "ASM_DEFINITION";
		case LINKAGE_SPECIFICATION:
			return "LINKAGE_SPECIFICATION";
		case INIT_DECLARATOR_LIST:
			return "INIT_DECLARATOR_LIST";
		case INIT_DECLARATOR:
			return "INIT_DECLARATOR";
		case DECLARATOR:
			return "DECLARATOR";
		case DIRECT_DECLARATOR:
			return "DIRECT_DECLARATOR";
		case PTR_OPERATOR:
			return "PTR_OPERATOR";
		case CV_QUALIFIER_SEQ:
			return "CV_QUALIFIER_SEQ";
		case DECLARATOR_ID:
			return "DECLARATOR_ID";
		case TYPE_ID:
			return "TYPE_ID";
		case TYPE_SPECIFIER_SEQ:
			return "TYPE_SPECIFIER_SEQ";
		case ABSTRACT_DECLARATOR:
			return "ABSTRACT_DECLARATOR";
		case DIRECT_ABSTRACT_DECLARATOR:
			return "DIRECT_ABSTRACT_DECLARATOR";
		case PARAMETER_DECLARATION_CLAUSE:
			return "PARAMETER_DECLARATION_CLAUSE";
		case PARAMETER_DECLARATION_LIST:
			return "PARAMETER_DECLARATION_LIST";
		case PARAMETER_DECLARATION:
			return "PARAMETER_DECLARATION";
		case FUNCTION_DEFINITION:
			return "FUNCTION_DEFINITION";
		case INITIALIZER:
			return "INITIALIZER";
		case INITIALIZER_CLAUSE:
			return "INITIALIZER_CLAUSE";
		case INITIALIZER_LIST:
			return "INITIALIZER_LIST";
		case CLASS_SPECIFIER:
			return "CLASS_SPECIFIER";
		case CLASS_HEAD:
			return "CLASS_HEAD";
		case MEMBER_SPECIFICATION:
			return "MEMBER_SPECIFICATION";
		case MEMBER_DECLARATION:
			return "MEMBER_DECLARATION";
		case MEMBER_DECLARATOR_LIST:
			return "MEMBER_DECLARATOR_LIST";
		case MEMBER_DECLARATOR:
			return "MEMBER_DECLARATOR";
		case PURE_SPECIFIER:
			return "PURE_SPECIFIER";
		case CONSTANT_INITIALIZER:
			return "CONSTANT_INITALIZER";
		case BASE_CLAUSE:
			return "BASE_CLAUSE";
		case BASE_SPECIFIER_LIST:
			return "BASE_SPECIFIER_LIST";
		case BASE_SPECIFIER:
		case CONVERSION_FUNCTION_ID:
		case CONVERSION_TYPE_ID:
		case CONVERSION_DECLARATOR:
		case CTOR_INITIALIZER:
		case MEM_INITIALIZER_LIST:
		case MEM_INITIALIZER:
			break;
		case MEM_INITIALIZER_ID:
			break;
		case OPERATOR_FUNCTION_ID:
			break;
		case OPERATOR_VALUE:
			break;
		case TRY_BLOCK:
			break;
		case FUNCTION_TRY_BLOCK:
			break;
		case HANDLER_SEQ:
			break;
		case HANDLER:
			break;
		case EXCEPTION_DECLARATION:
			break;
		case THROW_EXPRESSION:
			break;
		case EXCEPTION_SPECIFICATION:
			break;
		case TYPE_ID_LIST:
			break;
		case DECLARATION_SEQ_OPT:
			break;
		case NESTED_NAME_SPECIFIER_OPT:
			break;
		case EXPRESSION_LIST_OPT:
			break;
		case COLONCOLON_OPT:
			break;
		case NEW_PLACEMENT_OPT:
			break;
		case NEW_INITIALIZER_OPT:
			break;
		case NEW_DECLARATOR_OPT:
			break;
		case EXPRESSION_OPT:
			break;
		case STATEMENT_SEQ_OPT:
			break;
		case CONDITION_OPT:
			break;
		case ENUMERATOR_LIST_OPT:
			break;
		case INITIALIZER_OPT:
			break;
		case CONSTANT_EXPRESSION_OPT:
			break;
		case ABSTRACT_DECLARATOR_OPT:
			break;
		case TYPE_SPECIFIER_SEQ_OPT:
			break;
		case DIRECT_ABSTRACT_DECLARATOR_OPT:
			break;
		case CTOR_INITIALIZER_OPT:
			break;
		case COMMA_OPT:
			break;
		case MEMBER_SPECIFICATION_OPT:
			break;
		case SEMICOLON_OPT:
			break;
		case CONVERSION_DECLARATOR_OPT:
			break;
		case HANDLER_SEQ_OPT:
			break;
		case ASSIGNMENT_EXPRESSION_OPT:
			break;
		case TYPE_ID_LIST_OPT:
			break;
		// 120gram.tab.h, terminals 
		case IDENTIFIER:
			break;
		case INTEGER:
			break;
		case FLOATING:
			break;
		case CHARACTER:
			break;
		case STRING:
			break;
		case TYPEDEF_NAME:
			break;
		case NAMESPACE_NAME:
			break;
		case CLASS_NAME:
			break;
		case ENUM_NAME:
			break;
		case ELLIPSIS:
			break;
		case COLONCOLON:
			break;
		case DOTSTAR:
			break;
		case ADDEQ:
			break;
		case SUBEQ:
			break;
		case MULEQ:
			break;
		case DIVEQ:
			break;
		case MODEQ:
			break;
		case XOREQ:
			break;
		case ANDEQ:
			break;
		case OREQ:
			break;
		case SL:
			break;
		case SR:
			break;
		case SREQ:
			break;
		case SLEQ:
			break;
		case EQEQ:
			break;
		case NOTEQ:
			break;
		case LTEQ:
			break;
		case GTEQ:
			break;
		case ANDAND:
			break;
		case OROR:
			break;
		case PLUSPLUS:
			break;
		case MINUSMINUS:
			break;
		case ARROWSTAR:
			break;
		case ARROW:
			break;
		case ASM:
			break;
		case AUTO:
			break;
		case BOOL:
			break;
		case BREAK:
			break;
		case CASE:
			break;
		case CATCH:
			break;
		case CHAR:
			break;
		case CLASS:
			break;
		case CONST:
			break;
		case CONST_CAST:
			break;
		case CONTINUE:
			break;
		case DEFAULT:
			break;
		case DELETE:
			break;
		case DO:
			break;
		case DOUBLE:
			break;
		case DYNAMIC_CAST:
			break;
		case ELSE:
			break;
		case ENUM:
			break;
		case EXPLICIT:
			break;
		case EXPORT:
			break;
		case EXTERN:
			break;
		case FALSE:
			break;
		case FLOAT:
			break;
		case FOR:
			break;
		case FRIEND:
			break;
		case IF:
			break;
		case INLINE:
			break;
		case INT:
			break;
		case LONG:
			break;
		case MUTABLE:
			break;
		case NAMESPACE:
			break;
		case NEW:
			break;
		case OPERATOR:
			break;
		case PRIVATE:
			break;
		case PROTECTED:
			break;
		case PUBLIC:
			break;
		case REGISTER:
			break;
		case REINTERPRET_CAST:
			break;
		case RETURN:
			break;
		case SHORT:
			break;
		case SIGNED:
			break;
		case SIZEOF:
			break;
		case STATIC:
			break;
		case STATIC_CAST:
			break;
		case STRUCT:
			break;
		case SWITCH:
			break;
		case THIS:
			break;
		case THROW:
			break;
		case TRUE:
			break;
		case TRY:
			break;
		case TYPEDEF:
			break;
		case TYPEID:
			break;
		case TYPENAME:
			break;
		case UNION:
			break;
		case UNSIGNED:
			break;
		case USING:
			break;
		case VIRTUAL:
			break;
		case VOID:
			break;
		case VOLATILE:
			break;
		case WCHAR_T:
			break;
		case WHILE:
			break;
		case SEMIC:
			break;
		case LPAREN:
			break;
		case RPAREN:
			break;
		case COMMA:
			break;
		case LCURLY:
			break;
		case RCURLY:
			break;
		case LBRAK:
			break;
		case RBRAK:
			break;
		case AND:
			break;
		case DOT:
			break;
		case LT:
			break;
		case GT:
			break;
		case UNDER:
			break;
		case PLUS:
			break;
		case EQ:
			break;
		case DASH:
			break;
		case MOD:
			break;
		case MUL:
			break;
		case DIV:
			break;
		case OR:
			break;
		case QUEST:
			break;
		case KARAT:
			break;
		case EXPOINT:
			break;
		case TILDE:
			break;
		case COLON:
			break;
		case ZERO:
			break;
	}
}
*/
