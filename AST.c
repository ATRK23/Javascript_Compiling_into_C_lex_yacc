#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AST.h"

/* create an AST from a root value and two AST sons */
AST_expr new_binary_expr(char rule, AST_expr left, AST_expr right) {
  AST_expr t=(struct _expr_tree*) malloc(sizeof(struct _expr_tree));
  if (t!=NULL){	/* malloc ok */
    t->rule=rule;
    t->left=left;
    t->right=right;
    t->taille = 1 + (left ? left->taille : 0) + (right ? right->taille : 0);
  } else printf("ERR : MALLOC ");
  return t;
}

/* create an AST from a root value and one AST son */
AST_expr new_unary_expr(char rule, AST_expr son)
{
  return new_binary_expr(rule, NULL,son);
}

/* create an AST leaf from a value */
AST_expr new_number_expr(double number)
{
  AST_expr t=(struct _expr_tree*) malloc(sizeof(struct _expr_tree));
  if (t!=NULL){	/* malloc ok */
    t->rule='N';
    t->number=number;
    t->left=NULL;
    t->right=NULL;
    t->taille = 1;
  } else printf("ERR : MALLOC ");
  return t;
}

AST_comm new_command(AST_expr expression){
  AST_comm t = malloc(sizeof(struct _command_tree));
  if (t!=NULL){
    expression = fold_constants(expression); //construire l'AST optimise 
    t->expr1 = expression;
    t->rule = 'v';
    t->next = NULL;
    t->import_name = NULL;
  } else {
    printf("ERR : MALLOC ");
  }
  return t;
}


/* delete an AST */
void free_expr(AST_expr t)
{
  if (t!=NULL) {
    free_expr(t->left);
    free_expr(t->right);
    free(t);
  }
}

void free_comm(AST_comm t)
{
  if (t!=NULL) {
    free_expr(t->expr1);
    free(t);
  }
}

/* infix print an AST*/
void print_expr(AST_expr t){
  if (t!=NULL) {
    printf("[ ");
    print_expr(t->left);
    if (t->left==NULL) printf(":%f: ",t->number); else printf(":%c: ",t->rule);
    print_expr(t->right);
    printf("] ");
  }
}

void print_comm(AST_comm t){
  if (t!=NULL) {
    printf("[ ");
    printf(":%c: ",t->rule);
    print_expr(t->expr1);
    printf("] ");
  }
}

void print_code_expr(AST_expr ex){
  if (ex == NULL) return;

  if (ex->rule == '&') {
    print_code_expr(ex->left); 
    printf("ConJmp %d\n", ex->right->taille + 1);
    print_code_expr(ex->right);
    printf("Jump 1\n");
    printf("CsteBool false\n");
    return;
  }

  if (ex->rule == '=') {
    print_code_expr(ex->left);  // valeur à affecter
    printf("SetVar %s\n", ex->varname);
    return;
  }

  print_code_expr(ex->left);
  print_code_expr(ex->right);

  switch (ex->rule) {
    case 'N' : printf("CsteNb %f\n", ex->number); break;
    case '+' : printf("AddiNb\n"); break;
    case '*' : printf("MultNb\n"); break;
    case '-' : printf("SubiNb\n"); break;
    case '/' : printf("DiviNb\n"); break;
    case '%' : printf("ModuNb\n"); break;
    case 'M' : printf("NegaNb\n"); break;
    case 'T' : printf("CsteBool true\n"); break;
    case 'F' : printf("CsteBool false\n"); break;
    case '|' : printf("OrBool\n"); break;
    case '!' : printf("NotBool\n"); break;
    case 'E' : printf("EqBool\n"); break;
    case 'D' : printf("NeqBool\n"); break;
    case '<' : printf("LtBool\n"); break;
    case 'l' : printf("LeBool\n"); break;
    case '>' : printf("GtBool\n"); break;
    case 'g' : printf("GeBool\n"); break;
    case 'V' : printf("GetVar %s\n", ex->varname); break;
  }
}


void print_code(AST_comm t) {
  if (t->rule == 'I') {
    char path[256];
    snprintf(path, sizeof(path), "%s.jsm", t->import_name);
    FILE* f = fopen(path, "r");
    if (!f) {
      fprintf(stderr, "Erreur : fichier d'import introuvable : %s\n", path);
      exit(1);
    }
    char buffer[512];
    while (fgets(buffer, sizeof(buffer), f)) {
      if (strncmp(buffer, "Halt", 4) != 0) {  // Optionnel : ignorer Halt
        printf("%s", buffer);
      }
    }
    fclose(f);
  } else {
    print_code_expr(t->expr1);
  }
}

AST_expr new_boolean_expr(int value)
{
  AST_expr t=(struct _expr_tree*) malloc(sizeof(struct _expr_tree));
  if (t!=NULL){
    t->rule = (value ? 'T' : 'F');
    t->left = NULL;
    t->right = NULL;
    t->taille = 1;
  } else printf("ERR : MALLOC ");
  return t;
}

AST_comm make_import_command(char* name) {  //Importer les fichiers xjsm
  AST_comm t = malloc(sizeof(struct _command_tree));
  if (t != NULL) {
    t->rule = 'I'; // I pour Import
    t->import_name = name;
    t->expr1 = NULL;
    t->next = NULL;
  } else {
    printf("ERR : MALLOC ");
  }
  return t;
}

AST_comm append_comm(AST_comm c1, AST_comm c2) { //Fusionner arbres
  if (!c1) return c2;
  AST_comm current = c1;
  while (current->next) current = current->next;
  current->next = c2;
  return c1;
}

AST_expr new_var_expr(char* name) {
  AST_expr t = malloc(sizeof(struct _expr_tree));
  if (t != NULL) {
    t->rule = 'V';  // V pour variable utilisée
    t->varname = strdup(name);
    t->left = NULL;
    t->right = NULL;
    t->taille = 1;
  } else printf("ERR : MALLOC ");
  return t;
}

AST_expr new_assign_expr(char* name, AST_expr expr) {
  AST_expr t = malloc(sizeof(struct _expr_tree));
  if (t != NULL) {
    t->rule = '=';
    t->varname = strdup(name);
    t->left = expr;
    t->right = NULL;
    t->taille = 1 + (expr ? expr->taille : 0);
  } else printf("ERR : MALLOC ");
  return t;
}

//cette fonction vérifie si une expression est 100% constante
int is_const_expr(AST_expr t) {
  if (!t) return 1;
  if (t->rule == 'N' || t->rule == 'T' || t->rule == 'F') return 1;
  if (t->rule == 'V') return 0; // c’est une variable
  return is_const_expr(t->left) && is_const_expr(t->right);
}


//simplifie l’arbre en évaluant les expressions constantes 
AST_expr fold_constants(AST_expr t) {
  if (!t) return NULL;

  // d’abord on simplifie récursivement les sous-expressions
  t->left = fold_constants(t->left);
  t->right = fold_constants(t->right);

  // si ce n’est PAS une expression 100% constante, on ne fait rien
  if (!is_const_expr(t)) return t;

  // on calcule la valeur
  double l = t->left ? t->left->number : 0;
  double r = t->right ? t->right->number : 0;

  switch (t->rule) {
    case '+': return new_number_expr(l + r);
    case '-': return new_number_expr(l - r);
    case '*': return new_number_expr(l * r);
    case '/': return new_number_expr(r != 0 ? l / r : 0);
    case '%': return new_number_expr((int)l % (int)r);
    case 'E': return new_boolean_expr(l == r);
    case 'D': return new_boolean_expr(l != r);
    case '<': return new_boolean_expr(l < r);
    case 'l': return new_boolean_expr(l <= r);
    case '>': return new_boolean_expr(l > r);
    case 'g': return new_boolean_expr(l >= r);
    case 'M': return new_number_expr(-r); // -x
    case '!': return new_boolean_expr(!r); // !x
    default: return t;
  }
}


