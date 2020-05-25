%{
#include "json.tab.h"
#include "tree.h"
int yywrap();
YYSTYPE yylval;
%}

%option yylineno

%%

[\t \n]				{ /* skip */ }
"*"				{ yylval = alcleaf('*', yytext); return ASTERISK; }
"{"				{ yylval = alcleaf('{', yytext); return LCURLY; }
"}"				{ yylval = alcleaf('}', yytext); return RCURLY; }
"["				{ yylval = alcleaf('[', yytext); return LBRACKET; }
"]"				{ yylval = alcleaf(']', yytext); return RBRACKET; }
"/"				{ yylval = alcleaf('/', yytext); return SLASH; }
","				{ yylval = alcleaf(',', yytext); return COMMA; }
":"				{ yylval = alcleaf(':', yytext); return COLON; }
"\""				{ yylval = alcleaf('\"', yytext); return QUOTE; }
"."				{ yylval = alcleaf('.', yytext); return PERIOD; }
true				{ yylval = alcleaf('true', yytext); return TRUE; }
false				{ yylval = alcleaf('false', yytext); return FALSE; }
null				{ yylval = alcleaf('null', yytext); return NULL; }
(\"[ a-zA-Z0-9:.,_'/()=*&?@;-]*(\\["\\/bfnrt])*(\\u[0-9A-F]{4})*\")*    { yylval = alcleaf(STRINGLIT, yytext);  return STRINGLIT; }
([-]?([1-9][0-9]*)?([0]?[.]?[0-9]+)?([eE][-+]?[0-9]+)?)                 { yylval = alcleaf(NUMBER, yytext); return NUMBER; }

%%

int yywrap() { return 1; }
