%{
    #include <stdio.h> 
    #include "parseur.tab.h" 
%}

%%
0|[1-9][0-9]* { printf("lex: création token NUMBER %s\n", yytext);
    yylval.number = atoi(yytext);
    return NUMBER; }

[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?|[0-9]+([eE][-+]?[0-9]+)? { printf("lex: création token NUMBER %s\n", yytext); yylval.number = atof(yytext); return NUMBER; }

NaN|nan { yylval.number = 0.0/0.0; return NUMBER; }

"true"      { printf("lex: TRUE\n"); return TRUE; }
"false"     { printf("lex: FALSE\n"); return FALSE; }
"&&"        { printf("lex: AND\n"); return AND; }
"||"        { printf("lex: OR\n"); return OR; }
"!"         { printf("lex: NOT\n"); return NOT; }
"=="        { printf("lex: EQ\n"); return EQ; }
"!="        { printf("lex: NEQ\n"); return NEQ; }
"<="        { printf("lex: LE\n"); return LE; }
">="        { printf("lex: GE\n"); return GE; }
"<"         { printf("lex: LT\n"); return LT; }
">"         { printf("lex: GT\n"); return GT; }

[ \t\r] { ; }

"//".*                          { /* commentaire monoligne : ignoré */ }
"/*"([^*]*|\*+[^*/])*"*"+"/"    { /* commentaire multiligne : ignoré */ }

"=" {return ASSIGN;}
"import" {return IMPORT; }

"drop"|"DROP" { printf("lex: drop\n"); return DROP; }

"if"    { return IF; }
"else"  { return ELSE; }
"("     { return '('; }
")"     { return ')'; }

"do"    { return DO; }
"while" { return WHILE; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.string = strdup(yytext); return IDENT; }

\n { printf("lex: fin de lecture\n\n");
    return 0; }

. { printf(" lex: création token %s\n",yytext);
    return yytext[0]; }
%%
int yywrap(void){ return 1; } 