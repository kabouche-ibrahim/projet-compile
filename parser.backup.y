%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char* // Type pour les valeurs de l'analyseur syntaxique, 
//ici on utilise des chaînes de caractères pour simplifier

%}

%token INTEGER FLOAT IF ELSE CONST TYPE READ WRITE FOR WHILE
%token <str> IDF
%token ADD SUB MUL DIV AND OR NOT
%token EQ NE GT LT GE LE
%token SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA COLON

%left OR
%left AND
%left EQ NE GT LT GE LE
%left ADD SUB
%left MUL DIV
%right NOT

%%

program : VAR_GLOBAL declarations instructions
        ;

VAR_GLOBAL : "VAR_GLOBAL" ;
declarations : DECLARATION
             | declarations DECLARATION
             ;

DECLARATION : "DECLARATION" LBRACE declaration_list RBRACE ;

declaration_list : declaration
                 | declaration_list declaration
                 ;

declaration : simple_declaration
            | array_declaration
            | const_declaration
            ;

simple_declaration : TYPE identifier_list SEMICOLON ;
array_declaration : TYPE IDF LBRACE INTEGER RBRACE SEMICOLON ;
const_declaration : CONST IDF EQ CONST SEMICOLON ;

identifier_list : IDF
                | identifier_list COMMA IDF
                ;

instructions : INSTRUCTION
             | instructions INSTRUCTION
             ;

INSTRUCTION : "INSTRUCTION" LBRACE instruction_list RBRACE ;

instruction_list : assignment
                 | condition
                 | io
                 | loop
                 ;

assignment : IDF "=" expression SEMICOLON ;

condition : IF LPAREN expression RPAREN LBRACE instruction_list RBRACE ELSE LBRACE instruction_list RBRACE
          | IF LPAREN expression RPAREN LBRACE instruction_list RBRACE
          ;

io : READ LPAREN IDF RPAREN SEMICOLON
   | WRITE LPAREN CONST COMMA IDF COMMA CONST RPAREN SEMICOLON
   ;

loop : FOR LPAREN IDF COLON expression COLON expression RPAREN LBRACE instruction_list RBRACE
     | WHILE LPAREN expression RPAREN LBRACE instruction_list RBRACE
     ;

expression : term
           | expression ADD term
           | expression SUB term
           | expression MUL term
           | expression DIV term
           | expression AND term
           | expression OR term
           | NOT expression
           ;

term : IDF
     | CONST
     | LPAREN expression RPAREN
     | expression EQ expression
     | expression NE expression
     | expression GT expression
     | expression LT expression
     | expression GE expression
     | expression LE expression
     ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}
