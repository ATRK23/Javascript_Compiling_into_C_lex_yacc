#ifndef _AST
#define _AST
/* unary-and-binary tree structure */
struct _expr_tree {
  char rule;                    /* "name" of the rule/operation operation */
  double number;                   /* int  for value */
  int taille;
  char* varname;                     /* contenir le nom de la variable*/
  struct _expr_tree* left;           /* NULL   if unary node or leaf*/
  struct _expr_tree* right;          /* used for unary node but NULL if leaf */
};

typedef struct _expr_tree* AST_expr;

struct _command_tree {
  char rule;                    /* "name" of the rule/operation operation */
  AST_expr expr1;
  char* import_name;     	        /* used for command with at least one sub-expression */
  struct _command_tree* next;
  struct _command_tree* if_block;
  struct _command_tree* else_block;
};

typedef struct _command_tree* AST_comm;

/* create an AST from a root value and two AST sons */
AST_expr new_binary_expr(char rule, AST_expr left, AST_expr right);

/* create an AST from a root value and one AST son */
AST_expr new_unary_expr(char rule, AST_expr son);

/* create an AST leaf from a value */
AST_expr new_number_expr(double number);

/* create an AST leaf from a value */
AST_comm new_command(AST_expr expression);

AST_comm make_import_command(char* name);

/* function for boolean expression */
AST_expr new_boolean_expr(int value);

/* fusionner arbres */
AST_comm append_comm(AST_comm c1, AST_comm c2);

/* créer noeud pour une affectation (ex: x = expr) */
AST_expr new_assign_expr(char* name, AST_expr expr);

/* Crée noeud pour une variable utilisée (ex: x dans x + 1) */
AST_expr new_var_expr(char* name);

//Simplifie l’arbre en évaluant les expressions constantes 
AST_expr fold_constants(AST_expr t);

//Fonction pour gerer le if 
AST_comm make_if_command(AST_expr cond, AST_comm if_cmd, AST_comm else_cmd);

AST_comm make_do_while_command(AST_comm body, AST_expr cond);

// Cette fonction vérifie si une expression est 100% constante
int is_const_expr(AST_expr t);

/* delete an AST */
void free_expr(AST_expr t);
void free_comm(AST_comm t);

/* print an AST*/
void print_expr(AST_expr t);
void print_comm(AST_comm t);
void print_code_expr(AST_expr t);
void print_code(AST_comm t);
#endif
