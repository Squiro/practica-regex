package Analizadores;
import java_cup.runtime.*;

/* Directivas */
%%     

%public
%class AnalizadorLexico
%cupsym Simbolos
%cup
%column
%line
%ignorecase
%unicode

%{
    int RANGO_ENTERO = 65536;
    private Symbol symbol(int type) {
          System.out.println("[LEX] TOKEN < " + Simbolos.terminalNames[type] + " > : " + yytext());
          return new Symbol(type, yyline, yycolumn, yytext());
    }
    private Symbol symbol(int type, Object value) {
          return new Symbol(type, yyline, yycolumn, value);
    }
%}

DIGITO 	    =	[0-9]
LETRA 	    =	[a-zA-Z]
DIGITO_BINARIO  = [0-1]
DIGITO_HEXA     = [a-fA-F0-9]

COD_POSTAL = [1-9][0-9]{3}
WORD = {LETRA}+
NUMBER = {DIGITO}+

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

%%
<YYINITIAL> {
{COD_POSTAL}	     { return symbol(Simbolos.COD_POSTAL); }
{WORD}                 { return symbol(Simbolos.WORD); }
{NUMBER}                 { return symbol(Simbolos.NUMBER); }
{WhiteSpace}           { /* do nothing */ }

}

//--------> Simbolos Exp Reg
//[\ \t\r\n\f]          {/*Espacios en blanco, se ignoran*/}


//--------> Errores Lexicos
[^]   {
            System.out.println("Error Léxico " + yytext() + " Linea " + yyline + " Columna " + yycolumn);
            throw new Error("Error léxico");
      }
<<EOF>>                          { /*return symbol(Simbolos.EOF);*/ throw new Error("END OF FILE"); }