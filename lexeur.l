%{
    #include <stdio.h> 
    #include "parseur.tab.h" 
%}

%%
0|[1-9][0-9]* { printf("lex: création token NUMBER %s\n",yytext);
    return NUMBER; }
"true"      { return TRUE; }
"false"     { return FALSE; }
"&&"        { return AND; }
"||"        { return OR; }
"!"         { return NOT; }
"=="        { return EQ; }
"!="        { return NEQ; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }
[ \t\r] { ; } 
\n { printf("lex: fin de lecture");
    return 0; }
. { printf("lex: création token %s\n",yytext);
    return yytext[0]; }
%%
int yywrap(void){ return 1; } 