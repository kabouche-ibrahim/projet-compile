%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"

int current_line = 1;
int current_column = 1;

extern YYSTYPE yylval;
%}

%option noyywrap

lettres [a-zA-Z]
chiffres [0-9]
idf {lettres}({lettres}|{chiffres}|_)*
commentaire  "%%".*
espace [ \t\n\r]+

reel ^(\((-)?[0-9]+\.[0-9]+)\)|(-)?[0-9]+\.[0-9]+$
entier ^(\((-)?[0-9]+\))|(-)?[0-9]+$

%%

{espace}       { 
    int i;
    for(i = 0; yytext[i] != '\0'; i++) {
        if(yytext[i] == '\n') { 
            current_line++; 
            current_column = 1; 
        } else {
            current_column++;
        }
    }
}

{commentaire} ;

"VAR_GLOBAL"           { printf("%s\n", yytext); return VAR_GLOBAL; }
"DECLARATION"          { printf("%s\n", yytext); return DECLARATION; }
"INSTRUCTION"          { printf("%s\n", yytext); return INSTRUCTION; }
"IF"                   { printf("%s\n", yytext); return IF;}
"ELSE"                 { printf("%s\n", yytext); return ELSE; }
"CONST"                { printf("%s\n", yytext); return CONST; }
"INTEGER"              { printf("%s\n", yytext); return INTEGER; }
"FLOAT"                { printf("%s\n", yytext); return FLOAT; }
"FOR"                  { printf("%s\n", yytext); return FOR; }
"WHILE"                { printf("%s\n", yytext); return WHILE; }
"WRITE"                { printf("%s\n", yytext); yylval.str = strdup(yytext); return WRITE; }
"READ"                 { printf("%s\n", yytext); yylval.str = strdup(yytext); return READ; }
"&&"                   { printf("%s\n", yytext); return AND; }
"||"                   { printf("%s\n", yytext); return OR; }
"!"                    { printf("%s\n", yytext); return NOT; }
">="                   { printf("%s\n", yytext); return GE; }
"<="                   { printf("%s\n", yytext); return LE; }
"=="                   { printf("%s\n", yytext); return EQ; }
"!="                   { printf("%s\n", yytext); return NE; }
">"                    { printf("%s\n", yytext); return GT; }
"<"                    { printf("%s\n", yytext); return LT; }
"+"                    { printf("%s\n", yytext); return ADD; }
"-"                    { printf("%s\n", yytext); return SUB; }
"*"                    { printf("%s\n", yytext); return MUL; }
"/"                    { printf("%s\n", yytext); return DIV; }
"="                    { printf("%s\n", yytext); return EQ; }
";"                    { printf("%s\n", yytext); return SEMICOLON; }
","                    { printf("%s\n", yytext); return COMMA; }
":"                    { printf("%s\n", yytext); return COLON; }
"("                    { printf("%s\n", yytext); return LPAREN; }
")"                    { printf("%s\n", yytext); return RPAREN; }
"{"                    { printf("%s\n", yytext); return LBRACE; }
"}"                    { printf("%s\n", yytext); return RBRACE; }

{idf} {
    printf("%s\n", yytext);
    yylval.str = strdup(yytext);
    return IDF;
}

{entier} { 
    printf("%s\n", yytext);
    yylval.num = atoi(yytext);
    if((yylval.num>32767) || (yylval.num<-32768)){
        printf("Erreur lexicale : entier trop grand à la ligne %d, colonne %d\n", current_line, current_column);
        exit(EXIT_FAILURE);
    } else {
        return V_INTEGER; 
    }
}

{reel} { printf("%s\n", yytext); yylval.real = atof(yytext); return V_FLOAT; }

. {
    printf("Erreur lexicale : caractère non reconnu '%c' à la ligne %d, colonne %d\n", yytext[0], current_line, current_column);
    exit(EXIT_FAILURE);
}

%%
