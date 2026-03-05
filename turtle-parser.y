%{
#include <stdio.h>

#include "turtle-ast.h"

int yylex();
void yyerror(struct ast *ret, const char *);

%}

%debug
%defines

%define parse.error verbose

%parse-param { struct ast *ret }

%union {
  double value;
  char *name;
  struct ast_node *node;
}

%token <value>    VALUE       "value"
%token <name>     NAME        "name"

/* TODO: add other tokens */
%token            PRINT       "print"
%token            UP          "up"
%token            DOWN        "down"
%token            FORWARD     "forward"
%token            BACKWARD    "backward"
%token            POSITION    "position"
%token            RIGHT       "right"
%token            LEFT        "left"
%token            HEADING     "heading"

%type <node> unit cmds cmd expr

%%

unit:
    cmds              { $$ = $1; ret->unit = $$; }
;

cmds:
    cmd cmds          { $1->next = $2; $$ = $1; }
  | /* empty */       { $$ = NULL; }
;

cmd:
    FORWARD expr   { /* TODO */ }
  | UP             { struct ast ret; ast_destroy(&ret); }
;

expr:
    VALUE             { $$ = make_expr_value($1); }
    /* TODO: add identifier */
;

%%

void yyerror(struct ast *ret, const char *msg) {
  (void) ret;
  fprintf(stderr, "%s\n", msg);
}
