# Parser 4.2

## Description
Ce parser implémente la gestion des appels de fonctions, qu'avec les arguments et la gestion des déclarations de fonctions ( il sert uniquement à vérifier la validité des expressions )

## Prérequis
- `flex`
- `bison`
- `gcc`
- GNU Make
---

## 2. Tests unitaires

Crée un dossier `tests/` contenant plusieurs fichiers `.txt`, chacun vérifiant une fonctionnalité :

- `assign.txt` → `x = 3 + 2;`
- `if_else.txt` → `if (1 < 2) x = 1; else x = 2;`
- `function_call.txt` → `f(2, 3 + 1);`
- `boolean.txt` → `true && false;`
- `function.txt` → `function foo(a, b) { return a + b; } x = foo(2, 3);`

Et un petit script `test.sh` pour les lancer :

```bash
#!/bin/bash

for test in tests/*.txt; do
  echo "==> $test"
  ./main < "$test"
  echo ""
done
```

## Compilation

```bash
make
```