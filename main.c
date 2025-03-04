#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);
int main(void){
    AST_expr temp;
    AST_comm arbre = new_command(temp);
    if (!yyparse(&arbre)) {
        printf("\nParsing:: c'est bien une expression artihmétique\n");
        print_comm(arbre);
    }
    exit(EXIT_SUCCESS);
} 