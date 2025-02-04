#include <stdlib.h>
#include <stdio.h>
extern int yyparse(void);
int main(void){
    if (!yyparse()) {
        printf("\nParsing:: c'est bien une expression artihmétique\n);");
    }
    exit(EXIT_SUCCESS);
} 