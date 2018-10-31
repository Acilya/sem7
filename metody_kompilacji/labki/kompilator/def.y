%{
#include <string.h>
#include <stdio.h>
#define INFILE_ERROR 1
#define OUTFILE_ERROR 2
%}

%union 
{char *text;
int	ival;
float fval;};

%type <text> wyr
%token <text> ID
%token <ival> LC
%token <fval> LR
%token IF ELSE FOR
%token INT FLOAT
%token EQ NE LT GT
%token INPUTI INPUTF PRINTI PRINTF PRINTS
%left '+' '-'
%left '*' '/'


%%
warunek 
	:wyr EQ wyr		{printf("porownanie ==\n");}
	|wyr NE wyr		{printf("porownanie !=\n");}
	|wyr LT wyr		{printf("porownanie <=\n");}
	|wyr GT wyr		{printf("porownanie >=\n");}
	|wyr '>' wyr		{printf("porownanie >\n");}
	|wyr '<' wyr		{printf("porownanie <\n");}
wyr
	:wyr '+' skladnik	{printf("wyrazenie z + \n");}
	|wyr '-' skladnik	{printf("wyrazenie z - \n");}
	|skladnik		{printf("wyrazenie pojedyncze \n");}
	;
skladnik
	:skladnik '*' czynnik	{printf("skladnik z * \n");}
	|skladnik '/' czynnik	{printf("skladnik z / \n");}
	|czynnik		{printf("skladnik pojedynczy \n");}
	;
czynnik
	:ID			{printf("czynnik znakowy id: %s\n", $1);} 
	|LC			{printf("czynnik liczbowy: %d\n", $1);}
	|LR			{printf("liczba rzeczywista: %f\n", $1);}
	|'(' wyr ')'		{printf("wyrazenie w nawiasach\n");}
	;

%%
int main(int argc, char *argv[])
{
	yyparse();
	return 0;
}
