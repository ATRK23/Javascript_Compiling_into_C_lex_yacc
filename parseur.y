%code requires { #include "AST.h" }

%{ // the code between %{ and %} is copied at the start of the generated .c
    #include <stdio.h>
    #include "AST.h"
    int yylex(void); // declared to avoid implicit call
    int yyerror(AST_comm *rez, const char*); // on generated functions
%}

%union {
  double number;
  char* string;
  struct _expr_tree* ast;
  struct _command_tree* comm;
}

%token BOOLEAN
%token TRUE FALSE AND OR NOT EQ NEQ LE GE LT GT
%token ASSIGN
%token IMPORT
%token DROP
%token DO WHILE
%token <string> IDENT
%token IF ELSE
%token IF ELSE

%start top

%token <number> NUMBER
%type <ast> expression
%type <comm> program commande top
%type <comm> block
%type <ast> arguments
%type <ast> argument_list


%parse-param {AST_comm *rez}

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left '+' '-'
%left '*' '/' '%'
%right NOT
%right UMOINS


%%
top : program { *rez = $1; }
    ;

program : commande { $$ = $1; }
        | commande program { $$ = append_comm($1, $2); }
        ;

block :
    commande                { $$ = $1; }
  | commande block          { $$ = append_comm($1, $2); }
  ;

commande : expression ';'                    { $$ = new_command($1); }
  | IDENT ASSIGN expression ';'       { $$ = new_command(new_assign_expr($1, $3)); }
  | IF '(' expression ')' commande ELSE commande   { $$ = make_if_command($3, $5, $7); }
  | DROP ';' {printf("parse command drop\n");}
  | DO commande WHILE '(' expression ')' ';' { $$ = make_do_while_command($2, $5); }
  | DO block WHILE '(' expression ')' ';'    { $$ = make_do_while_command($2, $5); }
  | ';' { $$ = NULL; }
  | '{' block '}' { $$ = $2; }
  ;

expression:
    expression '+' expression {$$ = new_binary_expr('+',$1,$3);}
    | expression '-' expression {$$ = new_binary_expr('-',$1,$3);}
    | expression '*' expression {$$ = new_binary_expr('*',$1,$3);}
    | expression '/' expression {$$ = new_binary_expr('/', $1, $3);}
    | expression '%' expression {$$ = new_binary_expr('%', $1, $3);}
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
    | IDENT ASSIGN expression {printf("parse assignation: %s\n", $1);}
    | IDENT { $$ = new_var_expr($1); }
    | IDENT '(' arguments ')' { $$ = new_call_expr($1, $3->args, $3->arg_count); }
    ;

arguments:
    /* aucun argument */ {
        $$ = malloc(sizeof(struct _expr_tree));
        $$->args = NULL;
        $$->arg_count = 0;
    }
  | argument_list {
        $$ = malloc(sizeof(struct _expr_tree));
        $$->args = $1->args;
        $$->arg_count = $1->arg_count;
    }
  ;

argument_list:
    expression {
        $$ = malloc(sizeof(struct _expr_tree));
        $$->args = malloc(sizeof(AST_expr) * 1);
        $$->args[0] = $1;
        $$->arg_count = 1;
    }
  | argument_list ',' expression {
        $1->args = realloc($1->args, sizeof(AST_expr) * ($1->arg_count + 1));
        $1->args[$1->arg_count++] = $3;
        $$ = $1;
    }
  ;
  
%%
    
int yyerror(AST_comm *rez, const char *msg){
    printf("Parsing:: syntax error\n");
    return 1;
}
