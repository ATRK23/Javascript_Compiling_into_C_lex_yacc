CC = gcc
CFLAGS = -Wall -c -g

all: main

main: main.o parseur.tab.o lex.yy.o AST.o
	gcc -Wall $^ -o $@

AST.o: AST.c AST.h
lex.yy.o: lex.yy.c parseur.tab.h AST.h
main.o: main.c AST.h
parseur.tab.o: parseur.tab.c AST.h parseur.tab.h

parseur.tab.c parseur.tab.h: parseur.y
	bison -d parseur.y

lex.yy.c: lexeur.l
	flex lexeur.l

clean:
	rm -rf parseur.tab.* lex.yy.c main.o lex.yy.o AST.o main
