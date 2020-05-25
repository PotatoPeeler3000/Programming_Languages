 struct node {
   int symbol;		/* <1000 is terminal, >=1000 is non-terminal */
    union {
       struct leaf {
         char *lexeme;  /* saved copy of yytext */
         int val;       /* saved copy of val */
         } t;
       struct nonleaf {
         int production_rule;
         struct node *child[9]; /* 9 not big enough for some grammars */
         } nt;
   } u;
};

struct node * treenode(int symbol);
struct node * alcleaf(int symbol, char *lexeme);
struct node * alcternary(int symbol, int prodrule, struct node *k1,
			 struct node *k2, struct node *k3);
struct node *alcnary(int symbol, int prodrule, int nkids, ...);
void treeprint(struct node *np);
