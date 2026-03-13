%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "turtle-ast.h"
#include "turtle-parser.h"
%}

%option warn 8bit nodefault noyywrap


/* TODO: Trouver expression qui permettrait de faire les décimaux et notations scientifiques */
DIGIT [0-9]

%%

{DIGIT}+                { yylval.value = strtod(yytext, NULL); return VALUE; }
","                     { return ','; }
"print"                 { return PRINT; }
"up"                    { return UP; }
"down"                  { return DOWN; }
"forward"|"fw"          { return FORWARD; }
"backward"|"bw"         { return BACKWARD; }
"position"|"pos"        { return POSITION; }
"right"|"rt"            { return RIGHT; }
"left"|"lt"             { return LEFT; }
"heading"|"hd"          { return HEADING; }
"color"                 { return COLOR; }
"home"                  { return HOME; }
"repeat"                { return REPEAT; }

[A-Za-z][A-Za-z0-9]*    { yylval.name = strdup(yytext); return NAME; }

[\n\t ]*                /* whitespace */
.                       { fprintf(stderr, "Unknown token: '%s'\n", yytext); exit(EXIT_FAILURE); }

%%
