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

%left '+' '-'
%left '*' '/'
%right UMINUS

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
  | UP                { $$ = make_cmd_up(); }
  | DOWN              { $$ = make_cmd_down(); }
  | FORWARD expr      { $$ = make_cmd_forward($2); }
  | BACKWARD expr     { $$ = make_cmd_backward($2); }
  | POSITION expr ',' expr  { $$ = make_cmd_position($2, $4); }
  | RIGHT expr        { $$ = make_cmd_right($2); }
  | LEFT expr         { $$ = make_cmd_left($2); }
  | HEADING expr      { $$ = make_cmd_heading($2); }
  | COLOR NAME        { $$ = make_cmd_color_name(make_expr_name($2)); }
  | COLOR expr ',' expr ',' expr { $$ = make_cmd_color($2, $4, $6); }
  | HOME              { $$ = make_cmd_home(); }
;

/* TODO: Régler bug, tu fais des opérations avec des ast_node donc ça plante
expr:
    VALUE                     { $$ = make_expr_value($1); }
  | NAME                      { $$ = make_expr_name($1); }
  | expr '+' expr             { $$ = make_expr_value($1 + $3); }
  | expr '-' expr             { $$ = make_expr_value($1 - $3); }
  | expr '*' expr             { $$ = make_expr_value($1 * $3); }
  | expr '/' expr             { $$ = make_expr_value($1 / $3); }
  | '-' expr %prec UMINUS     { $$ = make_expr_value(- $2) ; }
  | expr '^' expr             { $$ = make_expr_value($1 / $3); }
;

%%

void yyerror(struct ast *ret, const char *msg) {
  (void) ret;
  fprintf(stderr, "%s\n", msg);
}
