
/* unary-and-binary tree structure */
struct _expr_tree {
  char rule;                    /* "name" of the rule/operation operation */
  int number;                   /* int  for value */
  struct _expr_tree* left;           /* NULL if unary node or leaf*/
  struct _expr_tree* right;          /* used for unary node but NULL if leaf */
};

typedef struct _expr_tree* AST_expr;

struct _command_tree {
  char rule;                    /* "name" of the rule/operation operation */
  AST_expr expr1;     	        /* used for command with at least one sub-expression */
};

typedef struct _command_tree* AST_comm;

/* create an AST from a root value and two AST sons */
AST_expr new_binary_expr(char rule, AST_expr left, AST_expr right);

/* create an AST from a root value and one AST son */
AST_expr new_unary_expr(char rule, AST_expr son);

/* create an AST leaf from a value */
AST_expr new_number_expr(int number);

/* create an AST leaf from a value */
AST_comm new_command(AST_expr expression);

/* delete an AST */
void free_expr(AST_expr t);
void free_comm(AST_comm t);

/* print an AST*/
void print_expr(AST_expr t);
void print_comm(AST_comm t);
