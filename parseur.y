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
%token <number> NUMBER
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
    | expression AND expression {$$ = new_binary_expr('&', $1, $3);}
    | expression OR expression {$$ = new_binary_expr('|', $1, $3);}
    | expression EQ expression {$$ = new_binary_expr('E', $1, $3);}
    | expression NEQ expression {$$ = new_binary_expr('D', $1, $3);}
    | expression LT expression {$$ = new_binary_expr('<', $1, $3);}
    | expression LE expression {$$ = new_binary_expr('l', $1, $3);}
    | expression GT expression {$$ = new_binary_expr('>', $1, $3);}
    | expression GE expression {$$ = new_binary_expr('g', $1, $3);}
    | NOT expression {$$ = new_unary_expr('!', $2);}
    | '-' expression %prec UMOINS {$$ = new_unary_expr('M', $2);}
    | '(' expression ')'{$$ = $2;}
    | TRUE {$$ = new_boolean_expr(1);}
    | FALSE {$$ = new_boolean_expr(0);}
    | NUMBER {$$ = new_number_expr($1);}
    ;
%%
    
int yyerror(AST_comm *rez, const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}
