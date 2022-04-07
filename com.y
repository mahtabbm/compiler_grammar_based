%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int t_count;
int varNUM=1;

int yylex (void);
char* newVar();
void yyerror (char const *s);
char *digitF(char* dig);

%}

%union 
{
	struct AST{
		char* str;
		char* label;
		int is_a_num;
		int is_MD;
	}node;
}

%type <node> statement
%type <node> expr
%type <node> term
%type <node> factor
%type <node> NUM

%token <node> DIG
%token <node> AS
%token <node> MD
%token <node> OP
%token <node> CP

%%

statement : expr {
			if (t_count == 1) {$1.str = malloc(100);
							   char *temp = newVar();
							   sprintf($1.str, "Assign %s to %s\n",$1.label, temp);
							   $1.label = temp;
						 	   }

			printf("%sprint %s", $1.str, $1.label);}
		  ;

expr	: expr AS term { $$.str = malloc(strlen($1.str)+strlen($3.str)+100);
						 $$.label = newVar();
						 char temp[10] = "+";
						 if(temp[0] == $2.str[0]) strcpy(temp, "Plu"); else strcpy(temp, "Min");
						 sprintf($$.str, "%s%sAssign %s %s %s to %s\n",$1.str, $3.str, $1.label, temp, $3.label, $$.label);
						 } 

		| term { 
				 $$.label = $1.label;
				 $$.str = $1.str;}
		;


term	: term MD factor { $$.str = malloc(strlen($1.str)+strlen($3.str)+100);
						 $$.label = newVar();
						   char temp[10] = "*";
						   if(temp[0] == $2.str[0]) strcpy(temp, "Mul"); else strcpy(temp, "Div");
						   sprintf($$.str, "%s%sAssign %s %s %s to %s\n",$1.str, $3.str, $1.label, temp, $3.label, $$.label); } 

		| factor {$$.str = $1.str;
				  $$.label = $1.label;
				  }
		;


factor	: OP expr CP {$$.str = $2.str;$$.label = $2.label;} 
		| NUM {$$.str = "";$$.label = $1.str;t_count++;}
		;


NUM 	: DIG DIG DIG DIG DIG DIG {$$.str = malloc(50); sprintf($$.str, "(%sHun_%sTen_%s)Tou_%sHun_%sTen_%s" , digitF($1.str), digitF($2.str),digitF($3.str), digitF($4.str),digitF($5.str), digitF($6.str));}   
		| DIG DIG DIG DIG DIG {$$.str = malloc(50); sprintf($$.str, "(%sTen_%s)Tou_%sHun_%sTen_%s" , digitF($1.str), digitF($2.str), digitF($3.str), digitF($4.str),digitF($5.str));}  
		| DIG DIG DIG DIG {$$.str = malloc(50); sprintf($$.str, "(%s)Tou_%sHun_%sTen_%s" , digitF($1.str), digitF($2.str), digitF($3.str), digitF($4.str));}
		| DIG DIG DIG {$$.str = malloc(50); sprintf($$.str, "%sHun_%sTen_%s" , digitF($1.str), digitF($2.str),digitF($3.str));} 
		| DIG DIG {$$.str = malloc(50); sprintf($$.str, "%sTen_%s" , digitF($1.str), digitF($2.str)); } 
		| DIG {$$.str = malloc(50); strcpy($$.str, digitF($1.str));}
		;

%%

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}
extern FILE *yyin;



char *newVar(){
	char *label = malloc(sizeof(char)*10);
	strcpy(label, "t");
	char num[10];
	itoa(varNUM, num, 10);
	strcat(label, num);
	varNUM++;
	return label;
}

char *digitF(char *dig){
	int dig_val = dig[0] - '0';
	char  *arr[] = {"Zer", "One", "Two", "Thr", "Fou", "Fiv", "Six", "Sev", "Eig", "Nin"};
	return arr[dig_val];
}

int main(int argc,char **argv)
{
	//printf("hiiiiiiiiiiiii");
	t_count = 0;
	++argv, --argc;  /* skip over program name */
	yyin = fopen( argv[0], "r" );
	yyparse();
} 



