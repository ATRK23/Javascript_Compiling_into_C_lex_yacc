#ifndef _AST
#define _AST
/* unary-and-binary tree structure */
struct _expr_tree {
  char rule;                    /* "name" of the rule/operation operation */
  double number;                   /* int  for value */
  struct _expr_tree* left;           /* NULL   if unary node or leaf*/
  struct _expr_tree* right;          /* used for unary node but NULL if leaf */
};

typedef struct _expr_tree* AST_expr;

struct _command_tree {
  char rule;                    /* "name" of the rule/operation operation */
  AST_expr expr1;
  char* import_name;     	        /* used for command with at least one sub-expression */
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


/* delete an AST */
void free_expr(AST_expr t);
void free_comm(AST_comm t);

/* print an AST*/
void print_expr(AST_expr t);
void print_comm(AST_comm t);
void print_code_expr(AST_expr t);
void print_code(AST_comm t);
#endif
