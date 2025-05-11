%{
    #include <stdio.h> // printf
    #include "parseur.tab.h" // token constants defined in parseur.y via #define
%}

%%
0|[1-9][0-9]* { printf("lex: création token NUMBER %s\n",yytext);
    return NUMBER; }
True    {return BOOLEAN; }
False   {return BOOLEAN; }
"=="   { return EQ; }
"<="   { return LEQ; }
[ \t\r] { ; } // separator
\n { printf("lex: fin de lecture");
    return 0; }
. { printf("lex: création token %s\n",yytext);
    return yytext[0]; }
%%
int yywrap(void){ return 1; } // function called at the end of the file