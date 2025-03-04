%code requires { #include "AST.h" }

%{ // the code between %{ and %} is copied at the start of the generated .c
    #include <stdio.h>
    #include "AST.h"
    int yylex(void); // declared to avoid implicit call
    int yyerror(AST_comm *rez, const char*); // on generated functions
%}

%token NUMBER
%start commande

%union { int number; AST_expr ast; };
%type <number> NUMBER
%type <ast> expression

%parse-param {AST_comm *rez}

%left '+' '-'
%left '*'
%nonassoc UMOINS

%%
commande : 
    expression ';'
        { *rez = new_command($1);}

expression:
    expression '+' expression
        { $$ = new_binary_expr('+',$1,$3);}
    | expression '-' expression
        { $$ = new_binary_expr('-',$1,$3);}
    | expression '*' expression
        { $$ = new_binary_expr('*',$1,$3);}
    | '(' expression ')'
        { $$ = $2;}
    | '-' expression %prec UMOINS
        { $$ = new_unary_expr('M', $2);}
    | NUMBER
        { $$ = new_number_expr($1);}
    ;

%% // denotes the end of the grammar
    // everything after %% is copied at the end of the generated .c
int yyerror(AST_comm *rez, const char *msg){ // called by the parser if the parsing fails
    printf("Parsing:: syntax error\n");
    return 1; // to distinguish with the 0 retured by the success
}
