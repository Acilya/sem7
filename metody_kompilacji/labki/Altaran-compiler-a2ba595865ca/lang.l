%{
#include <stdlib.h>
#include <string.h>
#include "def.tab.hh"
extern int yylineno;
int yyerror(char *msg,...);
void prints(char* msg);
%}

%%
\+			{return '+';} 
\*			{return '*';}
\(			{prints("(");
			return '(';}
\)			{prints(")");
			return ')';}
\/			{return '/';}
\-			{return '-';}
\^			{return '^';}
\=			{return '=';}
\;			{return ';';}
\<			{return '<';}
\>			{return '>';}
\[			{return '[';}
\]			{return ']';}
\=\=			{return EQ;}
\!\=			{return NE;}
\<\=			{return LT;}
\>\=			{return GT;}
\+\=			{return ADD;}
\-\=			{return SUB;}
\*\=			{return MUL;}
\/\=			{return DIV;}
inputi			{prints("input");
			return INPUTI;
			} 
inputf			{prints("finput");
			return INPUTF;
			}
printi			{prints("print");
			return PRINTI;
			}
printf			{prints("fprint");
			return PRINTF;
			}
prints			{prints("sprint");
			return PRINTS;
			}
if			{prints("if");
			return IF;
			}
end			{prints("end");
			return END;
			}
then			{prints("then");
			return THEN;
			}
else 			{prints("else");
			return ELSE;
			}
for			{prints("for");
			return FOR;
			}
int			{prints("int");
			return INT;}
float 			{prints("float");
			return FLOAT;}
[1-9][0-9]*|0		{prints("liczba\n"); 
			yylval.ival = atoi(yytext);
			return LC;
			}
	
[0-9]+[.][0-9]*+	{prints("liczba rzeczywista\n");
			yylval.fval = atof(yytext);
			return LR; 
			}	

[A-Za-z_][A-Za-z0-9_]*	{prints("nazwa\n"); 
			yylval.text = strdup(yytext);
			return ID;}
\"[^\"]*\"		{prints("string\n");
			yylval.text = strdup(yytext);
			return SD;}
\ |\t			{;}
\n			{yylineno++ ;}
.			{yyerror("Błąd leksykalny\n");}
%%

int yyerror(char *msg,...)
{
	printf("%d: %s", yylineno, msg);
	exit(1);
}

void prints(char* msg){
	printf("%s", msg);
}
