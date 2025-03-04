#include <stdlib.h>
#include <stdio.h>
extern int yyparse(double *);
int main(void){
    double rez;
    if (!yyparse(&rez)) {
        printf("\nParsing:: c'est bien une expression artihmétique\n);");
    }
    exit(EXIT_SUCCESS);
} 