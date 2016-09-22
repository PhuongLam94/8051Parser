%{
#include <iostream>
#include <string.h>
#include "AssParser.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
char *pEnd;
%}
%option noyywrap
%%
#DEFINE {return DEFINE;}
(\;BEGIN) {return BEGINDEFINE;}
"\;DEFINE BYTE" {return DEFINEBYTE;}
"\;DEFINE BITS" {return DEFINEBITS;}
"\;END DEFINE" {return ENDDEFINE;}
[ \t] ;
\$ {return END_OF_LINE;}
\#	{return '#';}
@ {return '@';}
\. {return '.';}
[0-9A-Fa-f]+[hH]		{yylval.ival = strtoull(yytext, &pEnd, 16);return HECXA;}
[0-7]+[oO]	{yylval.ival = strtoull(yytext, &pEnd, 8);return OCTAL;}
[0-1]+[bB]	{yylval.ival = strtoull(yytext, &pEnd, 2);return BINARY;}
(PUBLIC|public) {return PUBLIC;}
\n        { return END_LINE; }
(\;.*)           { 
	string beginDefine = ";BEGIN DEFINE";
	string endDefine = ";END DEFINE";
	string defineByte = ";DEFINE BYTE";
	string defineBits = ";DEFINE BITS";
	string val = strdup(yytext);
	if (beginDefine== val.substr(0, beginDefine.length()))
		return BEGINDEFINE;
	else if (endDefine== val.substr(0, endDefine.length()))
		return ENDDEFINE;
	else if (defineByte== val.substr(0, defineByte.length()))
		return DEFINEBYTE;
	else if (defineBits== val.substr(0, defineBits.length()))
		return DEFINEBITS;
	else return COMMENT;
	

}
[A-Za-z_][A-Za-z_$0-9]*  {yylval.sval=strdup(yytext);return ID;}
\:			{return COLON;}
\,			{return COMMA;}
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+         { yylval.ival = atoi(yytext); return INT; }
\"(\\.|[^\\"])*\"  { yylval.sval = strdup(yytext); return STRING;}
\(				{return '(';}
\)				{return ')';}
[\+\-\*\\]			{yylval.sval = strdup(yytext); return OPERATOR;}
.              ;
%%
