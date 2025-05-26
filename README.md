# AST & Génération de Code — Fragment 5.1

## Description

Cette branche contient la définition, l'implémentation des arbres syntaxiques abstraits (AST), utilisés pour représenter les expressions et les commandes du langage ajoute la gestion des **casts implicites à la JavaScript** et du **type `undefined`** dans les contextes booléens (`if`, `while`...).
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

## Ajouts spécifiques du fragment 5.1

**Casts implicites vers booléen** dans :
  - les conditions des `if (...)`
  - les conditions des `do {...} while (...)`
  - les appels de fonctions et les variables numériques
- Nouvelle fonction `print_code_expr_condition()` utilisée dans `AST.c` pour insérer automatiquement :
  - `BoToNb` après toute expression numérique ou `undefined` en contexte booléen
- **Ajout du type `undefined`** :
  - Reconnu comme constante spéciale (`UNDEFINED` dans le parseur)
  - Implémenté dans l’AST avec `rule = 'U'`
  - Génère l’instruction `CsteUn`
  - Se convertit automatiquement en `false` dans les contextes booléens
- Exemples gérés :
  - `if (undefined) { ... }`
  - `x = undefined;`
  - `return undefined;`
  - `while (getU()) { ... }`


---

## Prérequis

- `flex`
- `bison`
- `gcc`
- GNU Make

## Compilation

```bash
make
