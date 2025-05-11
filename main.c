#include <stdlib.h>
#include <stdio.h>
#include "AST.h"
extern int yyparse(void*);
extern FILE* yyin;

int main(int argc, char *argv[]){
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <fichier en entrée>\n", argv[0]);
        return EXIT_FAILURE;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erreur ouverture fichier");
        return EXIT_FAILURE;
    }

    AST_expr temp;
    AST_comm arbre = new_command(temp);
    if (!yyparse(&arbre)) {
        printf("\n");
        print_code(arbre);
    }
    
    fclose(yyin);
    exit(EXIT_SUCCESS);
}
