package Analizadores;
import java_cup.runtime.*;

/* Directivas */
%%     

%public
%class AnalizadorLexicoPunto2
%column
%cup
%line
%ignorecase
%unicode

%{
    int RANGO_ENTERO = 65536;
    double RANGO_FLOAT = 4294967296L;
%}

/* Declaraciones de REGEX utiles */
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

DIGITO 	    =	[0-9]
LETRA 	    =	[a-zA-Z]

/* Palabras claves */

DECVAR = "DECVAR"
ENDDEC = "ENDDEC"
INTEGER = "INTEGER"
FLOAT = "FLOAT"
WRITE = "WRITE"
WHILE = "WHILE"
IF = "IF"
ELSE = "ELSE"

/* Caracteres especiales */

OP_ASIGNACION =  ":" 
OP_LINEBREAK = ";"
OP_COMA = ","
LLAVE_ABIERTA = "{"
LLAVE_CERRADA = "}"
PARENT_ABIERTA = "("
PARENT_CERRADA = ")"

/* Operadores logicos */

OP_SUMA = "+"
OP_RESTA = "-"
OP_MULTI = "*"
OP_DIVISION = "/"
OP_LTE = "<="
OP_GTE = ">="
OP_GT = ">"
OP_LT = "<"
OP_EQ = "=="
OP_DIF = "!="

/* Constantes */
IDENTIFICADOR = {LETRA}+
CONSTANTE_ENTERA = {DIGITO}+
FLOAT = {DIGITO}+"."{DIGITO}+
STRING =  \".*\"

%%
<YYINITIAL> {

{IF}	                 { System.out.println("[LEX] TOKEN < IF > : " + yytext());  }
{ELSE}	                 { System.out.println("[LEX] TOKEN < ELSE > : " + yytext()); }
{WHILE}	                 { System.out.println("[LEX] TOKEN < WHILE > : " + yytext()); }
{DECVAR}	             { System.out.println("[LEX] TOKEN < DECVAR > : " + yytext()); }
{ENDDEC}	             { System.out.println("[LEX] TOKEN < ENDDEC > : " + yytext()); }
{INTEGER}	             { System.out.println("[LEX] TOKEN < INTEGER > : " + yytext()); }
{FLOAT}	                 { System.out.println("[LEX] TOKEN < FLOAT > : " + yytext()); }
{WRITE}	                 { System.out.println("[LEX] TOKEN < WRITE > : " + yytext()); }

{OP_ASIGNACION}     { System.out.println("[LEX] TOKEN < OP_ASIGNACION > : " + yytext()); }
{OP_LINEBREAK}      { System.out.println("[LEX] TOKEN < OP_LINEBREAK > : " + yytext()); }
{OP_COMA}           { System.out.println("[LEX] TOKEN < OP_COMA > : " + yytext()); }
{LLAVE_ABIERTA}     { System.out.println("[LEX] TOKEN < LLAVE_ABIERTA > : " + yytext()); }
{LLAVE_CERRADA}     { System.out.println("[LEX] TOKEN < LLAVE_CERRADA > : " + yytext()); }
{PARENT_ABIERTA}    { System.out.println("[LEX] TOKEN < PARENT_ABIERTA > : " + yytext()); }
{PARENT_CERRADA}    { System.out.println("[LEX] TOKEN < PARENT_CERRADA > : " + yytext()); }

{OP_SUMA}       { System.out.println("[LEX] TOKEN < OP_SUMA > : " + yytext()); }
{OP_RESTA}      { System.out.println("[LEX] TOKEN < OP_RESTA > : " + yytext()); }
{OP_MULTI}      { System.out.println("[LEX] TOKEN < OP_MULTI > : " + yytext()); }
{OP_DIVISION}   { System.out.println("[LEX] TOKEN < OP_DIVISION > : " + yytext()); }
{OP_LTE}        { System.out.println("[LEX] TOKEN < OP_LTE > : " + yytext()); }
{OP_GTE}        { System.out.println("[LEX] TOKEN < OP_GTE > : " + yytext()); }
{OP_GT}         { System.out.println("[LEX] TOKEN < OP_GT > : " + yytext()); }
{OP_LT}         { System.out.println("[LEX] TOKEN < OP_LT > : " + yytext()); }
{OP_EQ}         { System.out.println("[LEX] TOKEN < OP_EQ > : " + yytext()); }
{OP_DIF}        { System.out.println("[LEX] TOKEN < OP_DIF > : " + yytext()); }

{IDENTIFICADOR} { System.out.println("[LEX] TOKEN < IDENTIFICADOR > : " + yytext()); }
{CONSTANTE_ENTERA}  {                             
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
{FLOAT}             {
                        Double constFloat = Double.parseDouble(yytext());
                        if (constFloat >= -RANGO_FLOAT && constFloat <= RANGO_FLOAT)
                                return symbol(Simbolos.CONSTANTE_FLOAT);
                        else
                                throw new Error("La constante [" + yytext() + "] esta fuera del limite de los flotantes");
                    }
{STRING} { System.out.println("[LEX] TOKEN < STRING > : " + yytext()); }
{WhiteSpace}                 { /* do nothing */ }

}

//--------> Errores Lexicos
[^]   {
            System.out.println("Error Léxico: --> " + yytext() + " <-- Linea " + (yyline+1) + " Columna " + yycolumn);
            throw new Error("Error léxico");
      }
<<EOF>>                          { /*return symbol(Simbolos.EOF);*/ throw new Error("END OF FILE"); }