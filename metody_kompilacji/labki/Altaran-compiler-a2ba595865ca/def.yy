%{
#include <iostream>
#include <string>
#include <stack>
#include <string>
#include <fstream>
#include <vector>
#include <iterator>
#include <map>

#define INFILE_ERROR 1
#define OUTFILE_ERROR 2
extern "C" int yylex();
extern "C" int yyerror(const char *msg, ...);
extern "C" int yylineno;
using namespace std;

//Struktura dla zmiennych
struct svar{
	int type;
	string value;
};

//Compiler stack
stack <svar*> triplet;

//Globals - temporary variable names
string var_name ("__t");
int var_cnt = 0;
//Globals - vector for asm code
vector <string> code;
//Globals - map for symbols
map <string,int> symbols;
//Globals - map for array sizes
map <string,int> sizes;
//Globals - stack for floats and strings
stack <string> float_symbols;
stack <string> text_symbols;
//Counter for temporary floats
int float_cnt = 0;

stack <int> label_cnt;
int label_ctr = -1;
stack <int> slabel_cnt;
int slabel_ctr = -1;

//Funtions for stack extend
void addElementToStack( int type, string value );
void addArrayElementToStack( string arrname );

//Functions for operations
void performArithmeticOperation( char symbol );
void performComparisionOperation( string symbol );

//Funkcje
void genIfEt();
void genForEt();
void genForStart();
void changeValue(string varname,int changer,char operation);
void genElse();
void genElseEt();
void genForBefore();

//Funtions for declaring variables
void declareNewVariable( string value );

//Arrays
void declareArray( int type, string name, int size);
void fillArrayElement( string name );

//Functions for IO
void inputInteger( string name );
void printInteger( string name );
void inputFloat( string name );
void printFloat( string name );
void printString( string name );

%}
%union 
{char *text;
int	ival;
float fval;}
%type  <text> wyr
%token <text> ID
%token <text> SD
%token <ival> LC
%token <fval> LR

%token INPUTI
%token PRINTI
%token PRINTF
%token INPUTF
%token PRINTS
%token IF
%token EQ
%token NE
%token LT
%token GT
%token ADD
%token SUB
%token MUL
%token DIV
%token THEN
%token END
%token FOR
%token ELSE
%token INT
%token FLOAT


%%
multiline
	:wzs
	|multiline wzs
	;
wzs
	: wp ';'			{;}
	| array ';'			{;}
	| function ';'			{;}
	| if_inside 			{;}
	| for_inside			{;}
	| ifelse_inside 		{;}
	;
wp
	: ID '=' wyr		{declareNewVariable($1);
				}
	;
array
	: ID'['wyr']' '=' wyr 	{fillArrayElement($1);
				}
	| INT ID '['LC']'	{declareArray(INT,$2,$4);
				}
	| FLOAT ID '['LC']'	{declareArray(FLOAT,$2,$4);
				}
	;
function
	: INPUTI '('ID')'	{ inputInteger( $3 );
				}
	| PRINTI '('ID')'	{ printInteger( $3 );
				}
	| PRINTF '('ID')'	{ printFloat  ( $3 );
				}
	| INPUTF '('ID')'	{ inputFloat  ( $3 );
				}
	| PRINTS '('SD')'	{ printString ( $3 );
				}
	;
ifelse_inside
	: ifelse_begin multiline END		{genElseEt();}
	;
ifelse_begin
	: if_begin multiline ELSE 		{genIfEt();
					genElse();
					}
	;
if_inside
	: if_begin multiline END	{genIfEt();} 
	;
if_begin
	: IF condit_exp THEN 	{;}
	;

for_inside
	: for_begin condit_exp THEN multiline END	{genForEt();}
	;

for_begin
	: for_one value_change	{genForStart();}
	;

for_one
	: FOR wp 		{genForBefore();}
	;
condit_exp
	: wyr EQ wyr	{performComparisionOperation("==");}
	| wyr NE wyr	{performComparisionOperation("!=");}
	| wyr LT wyr	{performComparisionOperation("<=");}
	| wyr GT wyr	{performComparisionOperation(">=");}
	| wyr '<' wyr	{performComparisionOperation("<");}
	| wyr '>' wyr 	{performComparisionOperation(">");} 
	;
value_change
	: ID ADD LC	{changeValue($1,$3,'+');}
	| ID SUB LC	{changeValue($1,$3,'-');}
	| ID MUL LC	{changeValue($1,$3,'*');}
	| ID DIV LC	{changeValue($1,$3,'/');}
	;
wyr
	: wyr '+' skladnik	{
				performArithmeticOperation('+');}
	| wyr '-' skladnik	{
				performArithmeticOperation('-');}
	| skladnik		{printf("wyrazenie pojedyncze \n");}
	;
skladnik
	: skladnik '*' czynnik	{
				performArithmeticOperation('*');}
	| skladnik '/' czynnik	{
				performArithmeticOperation('/');}
	| czynnik		{printf("skladnik pojedynczy \n");}
	;
czynnik
	: ID'['wyr']'		{printf("Dodano element z tablicy z id\n");
				addArrayElementToStack($1);}
	| ID			{
				addElementToStack( ID,$1 );} 
	| LC			{
				addElementToStack( LC,to_string($1) );}
	| LR 			{ 
				addElementToStack( LR,to_string($1) );}
	| '(' wyr ')'		{printf("wyrazenie w nawiasach\n");}
	;
%%


int main(int argc, char *argv[])
{
	label_cnt.push(0);
	
	const char* path="./code.asm";
	ofstream output_file(path);
	ostream_iterator<string> output_iterator(output_file, "\n");
	output_file << ".data" << endl;
	output_iterator++;
	
	yyparse();
	
	for( auto entry = symbols.begin() ; entry != symbols.end() ; entry++ ){
		string var = entry->first;
		if( entry->second == LC )	  
			output_file << var << ": .word 0"  << endl;
		else if( entry->second == LR )
			output_file << var << ": .float 0" << endl;
		else if( entry->second == INT )
			output_file << var << ": .space " << sizes[var]*4 << endl; 
		else if( entry->second == FLOAT )
			output_file << var << ": .space " << sizes[var]*8 << endl;
		output_iterator++;
	}
	int i = float_symbols.size();		
	for (float_symbols; !float_symbols.empty(); float_symbols.pop()){
        	std::cout << float_symbols.top() << '\n';
		output_file << "__f" << --i <<": .float " << float_symbols.top() << endl;
	}
	i = text_symbols.size();		
	for (text_symbols; !text_symbols.empty(); text_symbols.pop()){
        	std::cout << text_symbols.top() << '\n';
		output_file << "__s" << --i <<": .asciiz " << text_symbols.top() << endl;
	}
	for (triplet; !triplet.empty(); triplet.pop()){
		cout << "Koncowy stos" << endl;
        	std::cout << triplet.top()->value << '\n';
		cout << "Koniec koncowego stosu" << endl;
	}
	output_file << ".text" << endl;
	output_iterator++;
	output_file << "main:" << endl;
	output_iterator++;
	copy(code.begin(), code.end(), output_iterator);
	output_file.close();

	return 0;
}

/* STACK EXTEND */
void addElementToStack(int type,string value)
{
	struct svar* tmp = new svar;
	tmp->type = type;
	tmp->value = value;
	triplet.push(tmp);
}

void addArrayElementToStack(string arrname){
	struct svar* component = new svar;
	component = triplet.top();
	triplet.pop();

	string t_varname = var_name+to_string(var_cnt++);	

	if( symbols[arrname] == INT ){	
		code.push_back("la $t6,"+arrname);
		if( component->type == ID )
			code.push_back("lw $t2,"+component->value);
		if( component->type == LC )
			code.push_back("li $t2,"+component->value);
		code.push_back("mul $t2,$t2,4");
		code.push_back("add $t6,$t6,$t2"); 	
		code.push_back("lw $t1,0($t6)");
		code.push_back("sw $t1,"+t_varname);
		symbols[t_varname]=LC;
	}
	else if( symbols[arrname] == FLOAT ){
		code.push_back("la $t6,"+arrname);
		if( component->type == ID )
			code.push_back("lw $t2,"+component->value);
		if( component->type == LC )
			code.push_back("li $t2,"+component->value);
		code.push_back("mul $t2,$t2,8");
		code.push_back("add $t6,$t6,$t2"); 	
		code.push_back("l.s $f1,0($t6)");
		code.push_back("s.s $f1,"+t_varname);
		symbols[t_varname]=LR;
	}

	struct svar* new_variable = new svar;
	new_variable->type = ID;
	new_variable->value = t_varname;
	triplet.push(new_variable);
}

/* OPERATIONS */
void performArithmeticOperation(char symbol){
	string t_varname = var_name+to_string(var_cnt);	
	
	struct svar* component1 = new svar;
	component1 = triplet.top();
	triplet.pop();
	struct svar* component2 = new svar;
	component2 = triplet.top();
	triplet.pop();

	if( component1->type == ID && symbols[component1->value] == LR ||
	component2->type == ID && symbols[component2->value] == LR ||
	component1->type == LR || component2->type == LR )
	{
		if( component1->type == ID )	
			code.push_back("lwc1 $f1,"+component1->value);
		else{
			float_symbols.push(component1->value);
			code.push_back("l.s $f1,__f"+to_string(float_cnt++));
		}
		if( component2->type == ID )
			code.push_back("lwc1 $f2,"+component2->value);
		else{
			float_symbols.push(component2->value);
			code.push_back("l.s $f2,__f"+to_string(float_cnt++));
		}

		if( symbol == '+' )
			code.push_back("add.s $f1,$f1,$f2");	
		else if( symbol == '-' )
			code.push_back("sub.s $f1,$f2,$f1");
		else if( symbol == '*' )
			code.push_back("mul.s $f1,$f1,$f2");
		else if ( symbol == '/' )
			code.push_back("div.s $f1,$f2,$f1");

		code.push_back("s.s $f1,"+t_varname);
		symbols[t_varname]=LR;
	}
	else{
		if( component1->type == ID )
			code.push_back("lw $t1,"+component1->value);
		else
			code.push_back("li $t1,"+component1->value);

		if ( component2->type == ID )
			code.push_back("lw $t2,"+component2->value);
		else 
			code.push_back("li $t2,"+component2->value);

		if( symbol == '+' )
			code.push_back("add $t1,$t1,$t2");	
		else if( symbol == '-' )
			code.push_back("sub $t1,$t2,$t1");
		else if( symbol == '*' )
			code.push_back("mul $t1,$t1,$t2");
		else if ( symbol == '/' )
			code.push_back("div $t1,$t2,$t1");

		code.push_back("sw $t1,"+t_varname);
		symbols[t_varname]=LC;
	}		
	struct svar* new_variable = new svar;
	new_variable->type = ID;
	new_variable->value = t_varname;
	triplet.push(new_variable);
	
	var_cnt++;
}

void performComparisionOperation(string symbol){

        struct svar* component1 = new svar;
        component1 = triplet.top();
        triplet.pop();
        struct svar* component2 = new svar;
        component2 = triplet.top();
        triplet.pop();

	if( component1->type == ID ){
		code.push_back("lw $t1,"+component1->value);
	}
	else if( component1->type == LC ){
		code.push_back("li $t1,"+component1->value);
	}

	if ( component2->type == ID ){
		code.push_back("lw $t2,"+component2->value);
	}
	else if ( component2->type == LC ){
		code.push_back("li $t2,"+component2->value);
	}

	if ( symbol == ">" )	
		code.push_back("ble $t2,$t1,label"+to_string(++label_ctr));
	else if ( symbol == "<" )
		code.push_back("bge $t2,$t1,label"+to_string(++label_ctr));
	else if ( symbol == ">=" )
		code.push_back("blt $t2,$t1,label"+to_string(++label_ctr));
	else if ( symbol == "<=" )
		code.push_back("bgt $t2,$t1,label"+to_string(++label_ctr));
	else if ( symbol == "==" )
		code.push_back("bne $t1,$t2,label"+to_string(++label_ctr));
	else if ( symbol == "!=" )
		code.push_back("beq $t1,$t2,label"+to_string(++label_ctr));	
	label_cnt.push(label_ctr);
}

void changeValue(string varname,int changer,char operation){
	code.push_back("lw $t1,"+varname);
	code.push_back("li $t2,"+to_string(changer));
	switch( operation ){
	case '+':
		code.push_back("add $t1,$t1,$t2");
		break;
	case '-':
		code.push_back("sub $t1,$t1,$t2");
		break;
	case '*':
		code.push_back("mul $t1,$t1,$t2");
		break;
	case '/':
		code.push_back("div $t1,$t1,$t2");
		break;
	}
	code.push_back("sw $t1,"+varname);
}

/* DECLARING */
void declareNewVariable(string name){
		
	struct svar* asm_var = triplet.top();
	triplet.pop();
	
	if( asm_var->type == ID ){
		if(symbols[asm_var->value] == LC ){
			code.push_back("lw $t1,"+asm_var->value);
			code.push_back("sw $t1,"+name);
			symbols[name]=LC;
		}
		else if(symbols[asm_var->value] == LR ){
			code.push_back("l.s $f1,"+asm_var->value);
			code.push_back("s.s $f1,"+name);
			symbols[name]=LR;
		}
	}
	else if( asm_var->type == LC ){
		code.push_back("li $t1, "+asm_var->value);
		code.push_back("sw $t1, "+name);
		symbols[name]=LC;
	}
	else if( asm_var->type == LR ){
		float_symbols.push(asm_var->value);
		code.push_back("l.s $f1,__f"+to_string(float_cnt++));
		code.push_back("s.s $f1, "+name);
		symbols[name]=LR;
	}
}

/* IO */
void inputInteger(string name){
	code.push_back("li $v0,5");
	code.push_back("syscall");
	code.push_back("sw $v0,"+name);
	symbols[name]=LC;
}

void inputFloat(string name){
	float_symbols.push(to_string(1.0));
	code.push_back("li $v0,6");
	code.push_back("syscall");
	code.push_back("s.s $f0,"+name); 
	symbols[name]=LR;
	float_cnt++;
}

void printInteger(string name){
	code.push_back("li $v0,1");
	code.push_back("lw $a0,"+name);
	code.push_back("syscall");
	symbols[name]=LC;
}

void printFloat(string name){
	code.push_back("l.s $f12,"+name);
	code.push_back("li $v0,2");
	code.push_back("syscall");
}

void printString(string text){
	static string name = "__s";
	static int text_cnt = 0;
	string tname = name+to_string(text_cnt++);
	text_symbols.push(text);
	code.push_back("li $v0,4");
	code.push_back("la $a0,"+tname);
	code.push_back("syscall");
}
/* LABELS */
void genIfEt(){
	code.push_back("label"+to_string(label_cnt.top())+":");
	label_cnt.pop();
}
void genForBefore(){
	code.push_back("b start"+to_string(slabel_ctr+2));
	code.push_back("start"+to_string(++slabel_ctr)+":");
}
void genForStart(){
	code.push_back("start"+to_string(++slabel_ctr)+":");
	slabel_cnt.push(slabel_ctr);
}
void genForEt(){
	code.push_back("b start"+to_string(slabel_cnt.top()-1));
	slabel_cnt.pop();
	code.push_back("label"+to_string(label_cnt.top())+":");
	label_cnt.pop();
}


void genElse(){
	string tmp = code.back();
	code.pop_back();
	label_cnt.pop();
	code.push_back("b label"+to_string(++label_ctr));
	label_cnt.push(label_ctr);
	code.push_back(tmp);
}

void genElseEt(){
	genIfEt();
}

/* ARRAYS */
void declareArray(int type,string name,int size){
	symbols[name]=type;
	sizes[name]=size;	
}

void fillArrayElement(string name){
	struct svar* asm_var = triplet.top();
	triplet.pop();

	struct svar* component1 = triplet.top();
	triplet.pop();
	
	if( symbols[name] == INT ){
		if( asm_var->type == ID ) 
			code.push_back("lw $t1,"+asm_var->value);
		if( asm_var->type == LC )
			code.push_back("li $t1,"+asm_var->value);
		code.push_back("la $t6,"+name);
		if( component1->type == ID )
			code.push_back("lw $t2,"+component1->value);
		else if ( component1->type == LC )
			code.push_back("li $t2,"+component1->value);
		code.push_back("mul $t2,$t2,4");
		code.push_back("add $t6,$t6,$t2"); 	
		code.push_back("sw $t1,0($t6)");
	}
	else if( symbols[name] == FLOAT ){
		code.push_back("#zjebane_cus");
		if( asm_var->type == ID )
			code.push_back("l.s $f1,"+asm_var->value); 
		else{
			code.push_back("l.s $f1,__f"+to_string(float_cnt++));
			float_symbols.push(asm_var->value);
		}

		code.push_back("la $t6,"+name);
		if( component1->type == ID )
			code.push_back("lw $t2,"+component1->value);
		else if ( component1->type == LC )
			code.push_back("li $t2,"+component1->value);
		code.push_back("mul $t2,$t2,8");
		code.push_back("add $t6,$t6,$t2"); 	
		code.push_back("s.s $f1,0($t6)");
	}
}
