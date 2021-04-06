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

/* Declaraciones de REGEX utiles */
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

DIGITO 	    =	[0-9]
LETRA 	    =	[a-zA-Z]
DIGITO_BINARIO  = [0-1]
DIGITO_HEXA     = [a-fA-F0-9]
WORD = {LETRA}+
NUMBER = {DIGITO}+
ALPHA_NUMERIC = 	[a-zA-Z0-9_*/]+
STRING = {ALPHA_NUMERIC} | {ALPHA_NUMERIC}(\ {ALPHA_NUMERIC})+

/* Puntos de la prática */

// Punto 1: códigos postales 1234
COD_POSTAL = [1-9][0-9]{3}
// Punto 2: Patentes mercosur
PATENTE_MERCOSUR = [A-Z]{2}[0-9]{3}[A-Z]{2} | [A-Z]{2}\ [0-9]{3}\ [A-Z]{2} 
// Punto 3: Comentarios acotados por /* */
COMMENT = "/*" ~"*/"
// Punto 4: Identificadores (nombres de variables) de cualquier longitud, del tipo _var1
// IDENTIFICADOR = {LETRA}[a-zA-Z0-9_]*({LETRA}|{DIGITO})+
// Punto 5: Idem anterior pero que no tengan dos guiones seguidos
IDENTIFICADOR = {LETRA}[a-zA-Z0-9_]*({LETRA}|{DIGITO})+

%%
<YYINITIAL> {
{COD_POSTAL}	           { return symbol(Simbolos.COD_POSTAL); }
{PATENTE_MERCOSUR}	     { return symbol(Simbolos.PATENTE_MERCOSUR); }
{COMMENT}	                 { return symbol(Simbolos.COMMENT); }
{IDENTIFICADOR}	           { return symbol(Simbolos.IDENTIFICADOR); }
{WORD}                       { return symbol(Simbolos.WORD); }
{NUMBER}                     { return symbol(Simbolos.NUMBER); }
{STRING}                     { return symbol(Simbolos.STRING); }
{WhiteSpace}                 { /* do nothing */ }

}

//--------> Simbolos Exp Reg
//[\ \t\r\n\f]          {/*Espacios en blanco, se ignoran*/}


//--------> Errores Lexicos
[^]   {
            System.out.println("Error Léxico: --> " + yytext() + " <-- Linea " + (yyline+1) + " Columna " + yycolumn);
            throw new Error("Error léxico");
      }
<<EOF>>                          { /*return symbol(Simbolos.EOF);*/ throw new Error("END OF FILE"); }