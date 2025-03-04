all: lexeur.l parseur.y main.c AST.c	
	bison -d parseur.y
	flex lexeur.l
	gcc -o main main.c parseur.tab.c lex.yy.c AST.c

clean:
	rm -rf parseur.tab.* lex.yy.c main