%{
/*Nick Kitchel
  CS 210
  Jeffery Clinton*/
%}
%option yylineno
%option noyywrap

%%
[	 \n]				        	                { /* skip */ }
"/"             	                			        { return '/'; }
"*"         					                        { return '*'; }
"{"                             	        			{ return '{'; }
"}"                                     				{ return '}'; }
":"                                     				{ return ':'; }
"\""                                    				{ return '"'; }
","                                     				{ return ','; }
"["                                     				{ return '['; }
"]"                                    					{ return ']'; }
true									{ return 1; }
false									{ return 2; }
null									{ return 3; }
([-]?([1-9][0-9]*)?([0]?[.]?[0-9]+)?([eE][-+]?[0-9]+)?)			{ return 6; }
(\"[ a-zA-Z0-9:.,_'/()=*&?@;-]*(\\["\\/bfnrt])*(\\u[0-9A-F]{4})*\")*	{ return 4; }
"."                                      				{ return '.'; }
.                                               			{ printf("lexical error, line %d\n", yylineno); }
