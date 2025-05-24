#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);

int main(void){
    AST_comm arbre = NULL;
    if (!yyparse(&arbre)) {
        if (arbre != NULL) {
            printf("\n");
            print_code(arbre);
        } else {
            fprintf(stderr, "Erreur : arbre non défini par le parseur.\n");
        }
    }
} 