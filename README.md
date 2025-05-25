# AST & Génération de Code — Fragment 4.2

## Description

Cette branche contient la définition et l'implémentation des arbres syntaxiques abstraits (AST), utilisés pour représenter les expressions et les commandes du langage.
Elle inclut également la génération de pseudo-code à partir de ces arbres (`print_code`), permettant d'interpréter ou de compiler le programme analysé.

## Contenu principal

- `AST.h` : définitions des structures de nœuds pour les expressions (`AST_expr`) et les commandes (`AST_comm`).
- `AST.c` : fonctions de création, simplification, impression et génération de code pour ces arbres.
- `main.c` : point d'entrée du programme, appelle le parser et imprime le pseudo-code généré.

## Fonctionnalités

- Construction des arbres syntaxiques pour :
  - Expressions arithmétiques et booléennes
  - Affectations et variables
  - Appels de fonctions avec arguments
  - Import de fichiers `.jsm`
  - Structures de contrôle (`if/else`, `do/while`)
- Simplification des expressions constantes (`fold_constants`)
- Génération d’un pseudo-code interprétable (`print_code`)

---

## Ajouts spécifiques du fragment 4.2

- Implémentation des **déclarations de fonctions**, avec :
  - Nouveau type de commande `rule = 'X'` pour `AST_comm`
  - Enregistrement du nom de la fonction, de la liste de ses paramètres et de son corps
- Extension de la structure `AST_comm` :
  - Champs `args` (`char**`) et `arg_count` ajoutés
- Nouvelle fonction : `make_function_declaration(...)`
- Génération d’instructions spécifiques :
  - `NewClot nom`
  - `DclArg param`
  - `Return`
- Support complet des **fonctions imbriquées, appels en cascade, et passage d’arguments**

---

## Prérequis

- `flex`
- `bison`
- `gcc`
- GNU Make

## Compilation

```bash
make
