%{
    #include <stdio.h>
    int yylex(void); 
    int yyerror(const char*); 
%}

%token NUMBER
%token BOOLEAN
%token TRUE FALSE AND OR NOT EQ NEQ LE GE LT GT
%start commande

%right NOT
%left '*' '/'
%left '+' '-'
%left LT LE GT GE
%left EQ NEQ
%left AND
%left OR
%right UMOINS


%%
commande : expression ';'
         ;

expression:
    expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression LT expression
    | expression LE expression
    | expression GT expression
    | expression GE expression
    | expression EQ expression
    | expression NEQ expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    | '-' expression %prec UMOINS
    | '(' expression ')'
    | TRUE
    | FALSE
    | NUMBER
    ;
%%
    
int yyerror(const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}