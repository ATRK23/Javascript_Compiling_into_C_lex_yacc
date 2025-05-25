%{
    #include <stdio.h>
    int yylex(void); 
    int yyerror(const char*); 
%}

%union {
    double num;
    char* string;
}

%token <num> NUMBER
%token BOOLEAN
%token TRUE FALSE AND OR NOT EQ NEQ LE GE LT GT
%token ASSIGN
%token IMPORT
%token DROP
%token DO WHILE
%token <string> IDENT
%token IF ELSE

%start top

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left '+' '-'
%left '*' '/' '%'
%right NOT
%right UMOINS


%%
top : program { ; }
    ;


program : /* vide */ {;}
        | commande program {;}
        ;

block : commande                  { ; }
        | commande block          { ; }
        ;


commande : expression ';'
        | IMPORT IDENT ';' {printf("parse import ident: %s\n", $2);}
        | DROP ';' {printf("parse command drop\n");}
        | DO expression WHILE '(' expression ')' ';' {printf("parse command : do while\n");}
        | DO block WHILE '(' expression ')' ';'    {printf("parse command : do while\n");}
        | IF '(' expression ')' commande ELSE commande   { printf("parse command : if then else\n");}
        | ';' {;}
        | '{' block '}' {;}
         ;

expression:
    expression: expression '+' expression {printf("parse: ADD\n");}
    | expression '-' expression {printf("parse: SUB\n");}
    | expression '*' expression {printf("parse: MUL\n");}
    | expression '/' expression {printf("parse: DIV\n");}
    | expression '%' expression {printf("parse: MOD\n");}
    | expression AND expression {printf("parse: AND\n");}
    | expression OR expression {printf("parse: OR\n");}
    | expression EQ expression {printf("parse: EQ\n");}
    | expression NEQ expression {printf("parse: NEQ\n");}
    | expression LT expression {printf("parse: LT\n");}
    | expression LE expression {printf("parse: LE\n");}
    | expression GT expression {printf("parse: GT\n");}
    | expression GE expression {printf("parse: GE\n");}
    | NOT expression {printf("parse: NOT\n");}
    | '-' expression %prec UMOINS {printf("parse: UMOINS\n");}
    | '(' expression ')' {printf("parse: PAR\n");}
    | TRUE {printf("parse: TRUE\n");}
    | FALSE {printf("parse: FALSE\n");}
    | NUMBER {printf("parse: NUMBER\n");}
    | IDENT ASSIGN expression {printf("parse assignation: %s\n", $1);}
    | IDENT '(' arguments ')' {printf("parse: IDENT with arguments\n");}
    | IDENT {printf("parse: IDENT\n");}
    ;

arguments: /* aucun argument */ {;}
    | argument_list {;}
    ;

argument_list: expression {;}
    | argument_list ',' expression {;}
    ;

%%
    
int yyerror(const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}