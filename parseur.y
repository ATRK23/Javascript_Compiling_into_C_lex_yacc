%{ // the code between %{ and %} is copied at the start of the generated .c
    #include <stdio.h>
    int yylex(void); // declared to avoid implicit call
    int yyerror(const char*); // on generated functions
%}

%union { double number } ;
%token <number> NUMBER
%type <number> expression
%start commande

%left '+' '-'
%left '*' '/'
%nonassoc UMOINS

%%
commande:
    expression ';'
                { printf("Resultat= %f\n", $1); }
expression:
    expression '+' expression
                { $$ = $1+$3; }
    | expression '-' expression
                { $$ = $1-$3; }
    | expression '*' expression
                { $$ = $1*$3; }
    | expression '/' expression
    | '(' expression ')'
                { $$ = $2; }
    | '-' expression %prec UMOINS
                { $$ = -$2; }
    | NUMBER
                { $$ = $1; } // default semantic value
;

%% // denotes the end of the grammar
    // everything after %% is copied at the end of the generated .c
int yyerror(const char *msg){ // called by the parser if the parsing fails
    printf("Parsing:: syntax error\n");
    return 1; // to distinguish with the 0 retured by the success
}