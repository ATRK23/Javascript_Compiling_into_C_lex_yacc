#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);

int main(void){
    AST_comm arbre = NULL;
    if (!yyparse(&arbre)) {
        AST_comm current = arbre;
        while (current != NULL) {
            print_code(current);
            current = current->next;
            printf("\n");
        }
    }
} 