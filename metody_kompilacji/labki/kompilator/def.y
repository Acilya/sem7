%{
#include <string.h>
#include <stdio.h>
#define INFILE_ERROR 1
#define OUTFILE_ERROR 2
%}

%union 
{char *text;
int	ival;
float fval};

%type <text> wyr
%token <text> ID
%token <text> SD
%token <ival> LC
%token <fval> LR
%token IF
%token ELSE
%token FOR
%token INT
%token FLOAT
%token EQ
%token NE
%token LT
%token GT
%token ADD
%token SUB
%token MUL
%token DIV
%token INPUTI
%token PRINTI
%token PRINTF
%token INPUTF
%token PRINTS
%left '+' '-'
%left '*' '/'
%start wyr


%%
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
	|LC			{printf("czynnik liczbowy: %s\n", $1);}
	|'(' wyr ')'		{printf("wyrazenie w nawiasach\n");}
	;

%%
int main(int argc, char *argv[])
{
	yyparse();
	return 0;
}
