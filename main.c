#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);
int main(void){
    AST_expr temp;
    AST_comm arbre = new_command(temp);
    if (!yyparse(&arbre)) {
        print_code(arbre);
    }
    exit(EXIT_SUCCESS);
} 