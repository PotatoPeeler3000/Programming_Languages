#include "json.h"
#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
extern FILE *yyin;
extern char *yytext;
char *yyfilename;
struct node *yyroot;

struct node * treenode(int symbol)
{
   struct node *p = (struct node *)calloc(1, sizeof(struct node));
   p->symbol = symbol;
   return p;
}

struct node * alcleaf(int symbol, char *lexeme)
{
   struct node * ret = treenode(symbol);
   ret->u.t.lexeme = strdup(lexeme);
   return ret;
}

struct node * alcternary(int symbol, int prodrule, struct node *k1,
			 struct node *k2, struct node *k3)
{
   struct node *rv = treenode(symbol);
   rv->u.nt.production_rule = prodrule;
   rv->u.nt.child[0] = k1;
   rv->u.nt.child[1] = k2;
   rv->u.nt.child[2] = k3;
   return rv;
}

struct node * alcnary(int symbol, int prodrule, int nkids, ...)
{
   int i;
   va_list mylist;
   struct node *rv = treenode(symbol);
   rv->u.nt.production_rule = prodrule;
   va_start(mylist, nkids);
   for(i=0; i<nkids; i++) {
      rv->u.nt.child[i] = va_arg(mylist, struct node *);
      }
   va_end(mylist);
   return rv;
}


void treeprint(struct node *np)
{
   if (np == NULL) { warn("NULL tree pointer"); return; }

 printf("\nProduct Rule: %d,", np->symbol); 
   if (np->symbol < 1000) {
      printf("\n	- Symbol  %s", np->u.t.lexeme); fflush(stdout);
      }
   else {
      int i;
      for (i=0; np->u.nt.child[i] != NULL; i++ ) {
	 treeprint(np->u.nt.child[i]);
	 }
      }
}

int main(int argc, char *argv[])
{
  int i;
  if (argc < 2) { printf("usage: iscan file.dat\n"); exit(-1); }
  yyin = fopen(argv[1],"r");
  if (yyin == NULL) { printf("can't open/read '%s'\n", argv[1]); exit(-1); }
  yyfilename = argv[1];
  if ((i=yyparse()) != 0) {
    printf("parse failed\n");
  }
  else printf("no errors\n");
	treeprint(yyroot);
  return 0;
}
