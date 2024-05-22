%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex();
    void yyerror(char* s);
%}

%union {
    int num;
    float real;      
    char *str;  
}

%token INTEGER FLOAT IF ELSE CONST READ WRITE FOR WHILE
%token <str>IDF <real>V_FLOAT <num>V_INTEGER 
%token ADD SUB MUL DIV AND OR NOT
%token EQ NE GT LT GE LE
%token SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA COLON
%token DECLARATION INSTRUCTION IDENTIFIER VAR_GLOBAL

%left OR
%left AND
%left EQ NE GT LT GE LE
%left ADD SUB
%left MUL DIV
%right NOT

%%

program : VAR_GLOBAL LBRACE RBRACE declarations instructions
        ;

declarations : 
               | declarations declaration
               ;

declaration : DECLARATION LBRACE declaration_list RBRACE ;

declaration_list : 
                 | declaration_list simple_declaration
                 ;

simple_declaration : TYPE identifier_list SEMICOLON ;

TYPE : INTEGER
     | FLOAT
     ;

identifier_list : IDF
                | identifier_list COMMA IDF
                ;

instructions : 
             | instructions instruction
             ;

instruction : INSTRUCTION LBRACE instruction_list RBRACE ;

instruction_list : 
                 | instruction_list statement
                 ;

statement : assignment
          | condition
          | io
          | loop
          ;

assignment : IDF EQ expression SEMICOLON ;

condition : IF LPAREN expression RPAREN LBRACE instruction_list RBRACE ELSE LBRACE instruction_list RBRACE
          | IF LPAREN expression RPAREN LBRACE instruction_list RBRACE
          ;

io : READ LPAREN IDF RPAREN SEMICOLON
   | WRITE LPAREN IDF RPAREN SEMICOLON
   ;

loop : FOR LPAREN IDF COLON expression COLON expression RPAREN LBRACE instruction_list RBRACE
     | WHILE LPAREN expression RPAREN LBRACE instruction_list RBRACE
     ;

expression : term
           | expression ADD term
           | expression SUB term
           | expression AND term
           | expression OR term
           | NOT expression
           ;

term : factor
     | term MUL factor
     | term DIV factor
     | term EQ factor
     | term NE factor
     | term GT factor
     | term LT factor
     | term GE factor
     | term LE factor
     ;

factor : IDF
       | V_INTEGER
       | V_FLOAT
       | LPAREN expression RPAREN
       ;

%%

int main() {
    yyparse();
    return 0;
}
int yywrap () {}

void yyerror(char *s) {
    printf("Error: %s\n", s);
}
