%code requires { #include "AST.h" }

%{ // the code between %{ and %} is copied at the start of the generated .c
    #include <stdio.h>
    #include "AST.h"
    int yylex(void); // declared to avoid implicit call
    int yyerror(AST_comm *rez, const char*); // on generated functions
%}

%token NUMBER
%token BOOLEAN
%token TRUE FALSE AND OR NOT EQ NEQ LE GE LT GT
%start commande

%union { int number; AST_expr ast; };
%type <number> NUMBER
%type <ast> expression

%parse-param {AST_comm *rez}

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left '+' '-'
%left '*' '/'
%right NOT
%right UMOINS


%%
commande : 
    expression ';'
        { *rez = new_command($1);}

expression:
    expression: expression '+' expression {printf("parse: ADD\n");
    $$ = new_binary_expr('+',$1,$3);}
    | expression '-' expression {printf("parse: SUB\n");
    $$ = new_binary_expr('-',$1,$3);}
    | expression '*' expression {printf("parse: MUL\n");
    $$ = new_binary_expr('*',$1,$3);}
    | expression '/' expression {printf("parse: DIV\n");
    $$ = new_binary_expr('/', $1, $3);}
    | expression AND expression {printf("parse: AND\n");}
    | expression OR expression {printf("parse: OR\n");}
    | expression EQ expression {printf("parse: EQ\n");}
    | expression NEQ expression {printf("parse: NEQ\n");}
    | expression LT expression {printf("parse: LT\n");}
    | expression LE expression {printf("parse: LE\n");}
    | expression GT expression {printf("parse: GT\n");}
    | expression GE expression {printf("parse: GE\n");}
    | NOT expression {printf("parse: NOT\n");}
    | '-' expression %prec UMOINS {printf("parse: UMOINS\n");
    $$ = new_unary_expr('M', $2);}
    | '(' expression ')' {printf("parse: PAR\n");
    $$ = $2;}
    | TRUE {printf("parse: TRUE\n");}
    | FALSE {printf("parse: FALSE\n");}
    | NUMBER {printf("parse: NUMBER\n");
    $$ = new_number_expr($1);}
    ;
%%
    
int yyerror(AST_comm *rez, const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}
