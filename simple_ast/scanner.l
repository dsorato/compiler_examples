%{
#include <string>
#include "st.h"
#include "parser.h"
extern int yylineno;
void yyerror(const char* s, ...);
%}

%option noyywrap nodefault yylineno

digs [0-9]+
dig [0-9]
chars [a-z]+
doubleval ({digs}\.{dig}*)|({dig}*\.{digs})

%%

[ \t]               ; //ignores spaces
{digs}              {yylval.integer = std::atoi(yytext); return T_INT;}
{doubleval}         {yylval.doubleval = std::atof(yytext); return T_DOUBLE;}
"+"                 {return T_PLUS;}
"*"                 {return T_TIMES;}
","                 {return T_COMMA;}
"="                 {return T_ASSIGN;}
\n                  {return T_NL;}
"double"            {yylval.vartype = ST::Type::tdouble; return T_TDOUBLE;}
"int"               {yylval.vartype = ST::Type::tinteger; return T_TINT;}
{chars}             {yylval.name = strdup(yytext); return T_ID;}
.                   {yyerror("Unknown token! %c\n", *yytext);} /*complains about every unknown character*/

%%

void yyerror(const char *s, ...){
    va_list ap;
    va_start(ap, s);
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::vfprintf(stderr, s, ap);
}
