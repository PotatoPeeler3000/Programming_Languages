%{
#include "tree.h"
#include "prodrules.h"
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *s);
#define YYSTYPE struct node *
struct node *yyroot;
%}

%token   COMMA
%token   COLON
%token   SLASH
%token   ASTERISK
%token   LCURLY
%token   RCURLY
%token   QUOTE
%token   TRUE
%token   FALSE
%token   LBRACKET
%token   RBRACKET
%token   NUMBER
%token   PERIOD
%token   STRINGLIT
%token   null

%%

end : value { yyroot = $1 ; printf("setting yyroot to %p\n", yyroot);};

object  : LCURLY RCURLY { $$ = alcnary(1100, 1101, 2, $1, $2);}
        | LCURLY multobject RCURLY { $$ = alcnary(1100, 1102, 3, $1, $2, $3);}
	;

multobject : string COLON value { $$ = alcnary( 1103, 1104, 3, $1, $2, $3);} 
	   | string COLON value COMMA  multobject { $$ = alcnary( 1103, 1105, 5, $1, $2, $3, $4, $5);}
           ;

array : LBRACKET RBRACKET { $$ = alcnary( 1200, 1201, 2, $1, $2);}
      | LBRACKET multvalue RBRACKET { $$ = alcnary( 1200, 1202, 3, $1, $2, $3);}
      ; 

multvalue : value { $$ = alcnary(1001, 1004, 1, $1);}
          | value COMMA multvalue { $$ = alcnary( 1001, 1002, 3, $1, $2, $3);}
          ;

value : string { $$ = alcnary(1400, 1401, 1, $1);}
      | number { $$ = alcnary(1400 ,1402, 1, $1);}
      | object { $$ = alcnary(1400, 1403, 1, $1);}
      | array  { $$ = alcnary(1400, 1404, 1, $1);}
      | TRUE   { $$ = alcleaf(1400, TRUE);}
      | FALSE  { $$ = alcleaf(1400, FALSE);}
      | null   { $$ = alcleaf(1400, null);}
	;
 
string : STRINGLIT { $$ = $1; }
       | STRINGLIT string { $$ = alcnary( 1500, 1501, 2, $1, $2);}
       ;

number : NUMBER { $$ = $1; }
       | NUMBER number { $$ = alcnary( 1600, 1601, 2, $1, $2);}
       ;

%%
extern FILE *yyin;

void yyerror(char *s)
{
  printf("%s\n", s);
}
