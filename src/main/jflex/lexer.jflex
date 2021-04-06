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
    double RANGO_FLOAT = 4294967296L;
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
ALPHA_NUMERIC = [a-zA-Z0-9_*/]+
TEXT = {ALPHA_NUMERIC} | {ALPHA_NUMERIC}(\ {ALPHA_NUMERIC})+

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
IDENTIFICADOR = {LETRA} ( ([a-zA-Z0-9]_)+ | [a-zA-Z0-9]*) ({LETRA}|{DIGITO})+ ( ([a-zA-Z0-9]_)+ | [a-zA-Z0-9]*) ({LETRA}|{DIGITO})+
// Punto 6: Constantes en otras bases como las del lenguaje C
CONSTANTES_C = "0x"{DIGITO_HEXA}+ | "0b"{DIGITO_BINARIO}+
// Punto 7: Constantes aritméticas enteras. Controlar el rango permitido.
CONSTANTE_ENTERA =  {DIGITO}+
// Punto 8: Constantes reales con formato xx.xx, controlando el rango permitido.
CONSTANTE_FLOAT =  {DIGITO}+"."{DIGITO}+
// Punto 9: strings del formato "hola"
STRING =  \".*\"
// Punto 10: Palabras reservadas (IF-WHILE-DECVAR-ENDDEC-INTEGER-FLOAT-WRITE)
IF = "IF"
WHILE = "WHILE"
DECVAR = "DECVAR"
ENDDEC = "ENDDEC",
INTEGER = "INTEGER"
FLOAT = "FLOAT"
WRITE = "WRITE"

// Punto 11: Operadores lógicos y ariméticos
OP_GT = ">" 
OP_LT = "<" 
OP_GTE = ">=" 
OP_LTE = "<=" 
OP_NE = "!="
OP_PLUS = "+" 
OP_MINUS = "-" 
OP_MULTI = "*" 
OP_DIVISION = "/"
OP_MODULE = "%" 
OP_INCREMENT = "++" 
OP_DECREMENT = "--"
OP_NOT = "!" 
OP_AND = "&&"
OP_OR = "||" 
OP_ASIG = "="
OP_EQ = "=="

%%
<YYINITIAL> {

// Keywords
{IF}	                       { return symbol(Simbolos.IF); }
{WHILE}	                 { return symbol(Simbolos.WHILE); }
{DECVAR}	                 { return symbol(Simbolos.DECVAR); }
{ENDDEC}	                 { return symbol(Simbolos.ENDDEC); }
{INTEGER}	                 { return symbol(Simbolos.INTEGER); }
{FLOAT}	                 { return symbol(Simbolos.FLOAT); }
{WRITE}	                 { return symbol(Simbolos.WRITE); }

{OP_GT}                      { return symbol(Simbolos.OP_GT); }
{OP_LT}                      { return symbol(Simbolos.OP_LT); }
{OP_GTE}                     { return symbol(Simbolos.OP_GTE); }
{OP_LTE}                     { return symbol(Simbolos.OP_LTE); }
{OP_NE}                      { return symbol(Simbolos.OP_NE); }
{OP_PLUS}                    { return symbol(Simbolos.OP_PLUS); }
{OP_MINUS}                   { return symbol(Simbolos.OP_MINUS); }
{OP_MULTI}                   { return symbol(Simbolos.OP_MULTI); }
{OP_DIVISION}                { return symbol(Simbolos.OP_DIVISION); }
{OP_MODULE}                  { return symbol(Simbolos.OP_MODULE); }
{OP_INCREMENT}               { return symbol(Simbolos.OP_INCREMENT); }
{OP_DECREMENT}               { return symbol(Simbolos.OP_DECREMENT); }
{OP_NOT}                     { return symbol(Simbolos.OP_NOT); }
{OP_AND}                     { return symbol(Simbolos.OP_AND); }
{OP_OR}                      { return symbol(Simbolos.OP_OR); }
{OP_ASIG}                    { return symbol(Simbolos.OP_ASIG); }
{OP_EQ}                      { return symbol(Simbolos.OP_EQ); }

{COD_POSTAL}	           { return symbol(Simbolos.COD_POSTAL); }
{PATENTE_MERCOSUR}	     { return symbol(Simbolos.PATENTE_MERCOSUR); }
{COMMENT}	                 { return symbol(Simbolos.COMMENT); }
{IDENTIFICADOR}	           { return symbol(Simbolos.IDENTIFICADOR); }
{CONSTANTES_C}	           { return symbol(Simbolos.CONSTANTES_C); }
{CONSTANTE_ENTERA}	     {                             
                                    // 2147483647 is the maximum value parseInt() can parse without giving an exception. 
                                    // Here we defined some custom int max value.
                                    Integer constInt = Integer.parseInt(yytext());

                                    if(constInt >= -RANGO_ENTERO && constInt <= RANGO_ENTERO ){
                                          return symbol(Simbolos.CONSTANTE_ENTERA);
                                    }                                          
                                    else
                                          return symbol(Simbolos.NUMBER);
                                          //throw new Error("La constante [" + yytext() + "] esta fuera del limite de los enteros."); 
                             }
{CONSTANTE_FLOAT}             {
                                    Double constFloat = Double.parseDouble(yytext());
                                    if (constFloat >= -RANGO_FLOAT && constFloat <= RANGO_FLOAT)
                                          return symbol(Simbolos.CONSTANTE_FLOAT);
                                    else
                                          throw new Error("La constante [" + yytext() + "] esta fuera del limite de los flotantes");
                              }
{STRING}                       { return symbol(Simbolos.STRING); }                              
{WORD}                       { return symbol(Simbolos.WORD); }
// {NUMBER}                     { return symbol(Simbolos.NUMBER); }
{TEXT}                       { return symbol(Simbolos.TEXT); }
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