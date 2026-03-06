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
%token            COLOR       "color"
%token            HOME        "home"
%token            REPEAT      "repeat"

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
    PRINT expr        { $$ = make_cmd_print($2); }
  | UP expr           { $$ = make_cmd_up($2); }
  | DOWN              { $$ = make_cmd_down($2); }
  | FORWARD expr      { $$ = make_cmd_forward($2); }
  | BACKWARD expr     { $$ = make_cmd_backward($2); }
  | POSITION expr     { $$ = make_cmd_position($2); }
  | RIGHT expr        { $$ = make_cmd_right($2); }
  | LEFT expr         { $$ = make_cmd_left($2); }
  | HEADING expr      { $$ = make_cmd_heading($2); }
  | COLOR expr        { $$ = make_cmd_color($2); }
  | HOME expr         { $$ = make_cmd_home($2); }
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
