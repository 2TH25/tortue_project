%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "turtle-ast.h"
#include "turtle-parser.h"
%}

%option warn 8bit nodefault noyywrap

DIGIT [0-9]

%%

{DIGIT}+                { yylval.value = strtod(yytext, NULL); return VALUE; }
"print"                 { return PRINT; }
"up"                    { return UP; }
"down"                  { return DOWN; }
"forward"|"fw"          { return FORWARD; }
"backward"|"bw"         { return BACKWARD; }
"position"|"pos"        { return POSITION; }
"right"|"rt"            { return RIGHT; }
"left"|"lt"             { return RIGHT; }
"heading"|"hd"          { return HEADING; } 

[\n\t ]*                /* whitespace */
.                       { fprintf(stderr, "Unknown token: '%s'\n", yytext); exit(EXIT_FAILURE); }

%%
