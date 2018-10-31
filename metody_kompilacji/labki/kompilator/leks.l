%{
#include <stdlib.h>
#include <string.h>
#include "def.tab.h"
extern int yylineno;
int yyerror(char *msg,...);
%}

%%
"int"			{printf("int\n"); return INT;}
"float" 		{printf("float\n"); return FLOAT;}
"if"			{printf("if\n"); return IF; }
"else" 			{printf("else\n"); return ELSE;}
"for"			{printf("for"); return FOR;}
"input_int"		{printf("input_int\n"); return INPUTI;} 
"input_float"		{printf("input_float\n"); return INPUTF;}
"print_int"		{printf("print_int\n"); return PRINTI;}
"print_float"		{printf("print_float\n"); return PRINTF;}
"print_str"		{printf("print_string\n"); return PRINTS;}
[ \t]+			; 
\n			{yylineno++;}		
\+			{printf("+\n"); return '+';} 
\-			{printf("-\n"); return '-';}
\=			{printf("=\n"); return '=';}
\*			{printf("*\n"); return '*';}
\/			{printf("/\n"); return '/';}
\^			{printf("^\n"); return '^';}
\(			{printf("(\n"); return '(';}
\)			{printf(")\n"); return ')';}
\[			{printf("[\n"); return '[';}
\]			{printf("]\n"); return ']';}
\{			{printf("{\n"); return '{';}
\}			{printf("}\n"); return '}';}
\;			{printf(";\n"); return ';';}
\<			{printf("<\n"); return '<';}
\>			{printf(">\n"); return '>';}
\=\=			{printf("==\n"); return EQ;}
\!\=			{printf("!=\n"); return NE;}
\<\=			{printf("<=\n"); return LT;}
\>\=			{printf(">=\n"); return GT;}
0|[1-9][0-9]*		{printf("liczba\n"); yylval.ival = atoi(yytext); return LC;}
[0-9]+[.][0-9]+		{printf("liczba rzeczywista\n"); yylval.fval = atof(yytext); return LR;}	
[A-Za-z_][A-Za-z0-9_]*	{printf("nazwa\n"); yylval.text = strdup(yytext); return ID;}
.			{char msg[25]; sprintf(msg, "Niedozwolony znak '%s'", yytext); yyerror(msg);}
%%

int yyerror(char *msg,...)
{
	printf("%d: %s", yylineno, msg);
	exit(1);
}
