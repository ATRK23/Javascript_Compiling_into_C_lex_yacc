#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);

int main(void){
    AST_comm arbre = NULL;
    if (!yyparse(&arbre)) {
        print_code(arbre);
    }
    return 0;
}