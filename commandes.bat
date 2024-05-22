flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -lfl -ly -o executable.exe
.\executable<langage.txt