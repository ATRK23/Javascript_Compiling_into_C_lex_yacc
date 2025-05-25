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

/* create an AST leaf from a value */
AST_comm new_command(AST_expr expression){
  AST_comm t =  malloc(sizeof(struct _command_tree));
  if (t!=NULL){	/* malloc ok */
    t->expr1 = expression;
  } else printf("ERR : MALLOC ");
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
  if(ex == NULL) {
    return;
  }

  if(ex->rule == '&'){
    print_code_expr(ex->left); 
    printf("ConJmp %d\n", ex->right->taille + 1);
    print_code_expr(ex->right);
    printf("Jump 1\n");
    printf("CsteBool false\n");
    return;
  }

  print_code_expr(ex->left);
  print_code_expr(ex->right);

  switch (ex->rule){
    case 'N' : printf("CsteNb %f\n", ex->number);break;
    case '+' : printf("AddiNb\n");break;
    case '*' : printf("MultNb\n");break;
    case '-' : printf("SubiNb\n");break;
    case '/' : printf("DiviNb\n");break;
    case '%' : printf("ModuNb\n");break;
    case 'M' : printf("NegaNb\n");break;
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

AST_comm make_import_command(char* name) {
  printf("Import command for: %s\n", name);
  AST_comm t = malloc(sizeof(struct _command_tree));
  if (t != NULL) {
    t->rule = 'I'; // I pour Import
    t->import_name = name;
    t->expr1 = NULL;
  } else {
    printf("ERR : MALLOC ");
  }
  return t;
}

