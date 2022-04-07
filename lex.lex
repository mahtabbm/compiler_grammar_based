%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "com.tab.h"
%}

/* Regular definitions */
delim	[ \t\n]
ws	{delim}+
digit   [0-9]
operatorAS [+-]
operatorMD [\*\/]
openParan [(]
closeParan [)]

/* Translation Rules */
%% 
{ws}		    {}
{operatorAS}    {yylval.node.str=strdup(yytext); return(AS);}
{operatorMD}    {yylval.node.str=strdup(yytext); return(MD);}

{openParan}     {yylval.node.str=strdup(yytext); return(OP);}
{closeParan}    {yylval.node.str=strdup(yytext); return(CP);}
{digit}        {yylval.node.str=strdup(yytext); return(DIG);}

%%	

/*
int main(argc, argv)
int argc;
char** argv;
{
    FILE *file;
    file = fopen(argv[1], "r");
    if (!file)
    {
        fprintf(stderr, "Could not open %s\n", argv[1]);
        exit(1);
    }
    yyin = file;

    yylex();
    return 0;
}*/