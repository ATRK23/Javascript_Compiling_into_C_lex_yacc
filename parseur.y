%{ // the code between %{ and %} is copied at the start of the generated .c
    #include <stdio.h>
    int yylex(void); // declared to avoid implicit call
    int yyerror(const char*); // on generated functions
%}

%token NUMBER
%token BOOLEAN
%token EQ LEQ
%start commande

%left '+' '-'
%left '*'
%nonassoc UMOINS

%%
commande : expression ';'

expression:
    expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | '(' expression ')'
    | '-' expression %prec UMOINS
    | NUMBER
    ;

%% // denotes the end of the grammar
    // everything after %% is copied at the end of the generated .c
int yyerror(const char *msg){ // called by the parser if the parsing fails
    printf("Parsing:: syntax error\n");
    return 1; // to distinguish with the 0 retured by the success
}