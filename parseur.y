%{
    #include <stdio.h>
    int yylex(void); 
    int yyerror(const char*); 
%}

%token NUMBER
%token BOOLEAN
%token TRUE FALSE AND OR NOT EQ NEQ LE GE LT GT
%start commande

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left '+' '-'
%left '*' '/'
%right NOT
%right UMOINS


%%
commande : expression ';'
         ;

expression:
    expression: expression '+' expression {printf("parse: ADD\n");}
    | expression '-' expression {printf("parse: SUB\n");}
    | expression '*' expression {printf("parse: MUL\n");}
    | expression '/' expression {printf("parse: DIV\n");}
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
    ;
%%
    
int yyerror(const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}