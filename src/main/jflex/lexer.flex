package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;
import java.util.ArrayList;
import java.util.Vector;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import static java.lang.Math. *;


%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{

  public class Simbolo {
        public String nombre;
        public String tipo;
        public String valor;
        public int longitud;

         public Simbolo(){
         }

        public Simbolo(String nombre, String tipo,String valor,int longitud) {
            this.nombre = nombre;
            this.tipo = tipo;
            this.valor = valor;
            this.longitud = longitud;
        }

        public String getNombre() {
                return nombre;
            }

            public String getTipo() {
                          return tipo;
                      }

                      public String getValor() {
                          return valor;
                      }

                      public int getLongitud() {
                          return longitud;
                      }
                      public void setValor(String valor){
                        this.valor=valor;
                      }

                      public void mostrar_vector(){

                      System.out.println("Nombre: " + nombre +" Tipo: " + tipo + " Valor: " + valor + " Longitud: " + longitud+ "\n");

                      }
 }
    ArrayList<Simbolo> elemento = new ArrayList<Simbolo>();
      int cant=0;

         public void guardar_TS(String tipo, String nombre){
                 boolean x;
                 String nom;
                 String lexema = "_";
                 if(tipo.equals("ID")){
                   nom = nombre;
                 }
                 else{
                  //Armamos el lexema a las constantes agregandole el guion bajo al principio
                 nom = lexema + nombre;
                 }
                 x=buscar_lexema(nom); //Buscamos si el lexema ya existe en la tabla
                 if(x == false)  // si no existe lo agregamos
                 {
                          Simbolo s;
                          s= new Simbolo(nom,"",nombre,0);
                          elemento.add(s);
                          //elemento.get(cant).mostrar_vector();
                         //cant++;
                 }
                  for(int i=0;i<elemento.size();i++) //Si es un ID le borramos la columna valor en la T.S.
                  {
                     String token = elemento.get(i).getNombre();
                     String letra = token.substring(0,1);
                     if(letra.compareTo(lexema)!=0)
                        elemento.get(i).setValor("-");
                  }
         }
         public boolean buscar_lexema(String nombre) {
           boolean existe=false;

               for(int i=0;i<elemento.size();i++)
               {
                  if(nombre.equals(elemento.get(i).getNombre()))
                   existe=true;
               }
               return existe;
         }
         public void escribir_ts(){

                            try {
                                         String ruta = "./Tabla_de_simbolos.txt";
                                         File file = new File(ruta);
                                         // Si el archivo no existe es creado
                                         if (!file.exists()) {
                                             file.createNewFile();
                                         }
                                         FileWriter fw = new FileWriter(file);
                                         BufferedWriter bw = new BufferedWriter(fw);
                                         bw.write("Nombre "+ "\t  "+ "Tipo "+ "\t  "+ "valor " + " \t   "+ "Longitud "+ "\n");
                                          bw.newLine();
                                         for(int i=0;i<elemento.size();i++)
                                           {
                                              bw.write(elemento.get(i).getNombre() + "\t " + elemento.get(i).getTipo() + "\t " + elemento.get(i).getValor() + "\t " + elemento.get(i).getLongitud() +"\n");
                                              bw.newLine();
                                           }

                                         bw.close();
                                  }
                                     catch (Exception e) {
                                         e.printStackTrace();
                                     }
         }
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }

  public void validar_rango_entero(String str)
      {
       int num = Integer.parseInt(str);

               try{

                  if(num <-32768 || num > 32767){
                    System.out.println("Entero fuera de Rango \n");
                    throw new Exception("El entero "+ num+  " esta fuera de rango");
                    }

                  }
               catch(Exception e){
                  System.out.println(e + " Entero fuera de Rango \n");
               }

       }
  public void validar_rango_real(String str)
        {
         float num = Float.parseFloat(str);

                 try{

                    if(num <-3.4 * Math.pow(10,-38)|| num > 3.4* Math.pow(10,38)){
                      System.out.println("Real fuera de Rango \n");
                      throw new Exception("El Real " + num+  " esta fuera de rango");
                      }

                    }
                 catch(Exception e){
                    System.out.println(e + " Real fuera de Rango \n");
                 }

         }
  public void validar_cantidad_caracteres(String str)  {
       try{
       int longitud = str.length();
       if(longitud >40)
        throw new Exception("El String "+ str +  " esta fuera de rango");
       }
       catch(Exception e){
          System.out.println(e + " String fuera de Rango \n");
       }
  }
%}


LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]
Space = " "

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = "="

Letter = [a-zA-Z]
Digit = [0-9]

WhiteSpace = {LineTerminator} | {Identation} |{Space}
QuotationMark = \"
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = -?{Digit}+
RealConstant =  ({Digit})*"."({Digit})*
Coma = ","
PyC = ";"
D_P = ":"
P_A = "("
P_C = ")"
C_A = "["
C_C = "]"
LL_A = "{"
LL_C = "}"
Menor_Ig = "<="
Menor = "<"
Mayor_Ig = ">="
Mayor = ">"
Igual = "=="
and = "&"
or = "||"
not = "not"
distinto = "!="
if = "if"
ciclo = "ciclo"
else = "else"
read = "read"
write = "write"
int = "int"
float = "Float"
String = "String"
init = "init"
end = "end"
ElementInTheMiddle = "ElementInTheMiddle"
IntegerConstant = {Digit}+
RealConstant =  ({Digit})*"."({Digit})*
AllowedSymbols = {Plus} | {Mult} | {Sub} | {Div} |{Space}| {Assig}|{P_A}|{P_C}|{Coma}
|{PyC}|{D_P}|{C_A}|{C_C}|{LL_A}|{LL_C}|{Menor}|{Menor_Ig}|{Mayor}|{Mayor_Ig}|{and}|{or}|{distinto}
StringConstant = StringConstant = {QuotationMark} ({Letter}|{Digit}|{Space}|{AllowedSymbols})* {QuotationMark}
Comment = {Mult}{Sub} ({Letter}|{Digit}|{AllowedSymbols})* {Sub}{Mult}


%%


/* keywords */

<YYINITIAL> {
/* reserverd words */
  {if}                                      { return symbol(ParserSym.IF); }
  {init}                                    { return symbol(ParserSym.INIT); }
  {ciclo}                                   { return symbol(ParserSym.CICLO); }
  {else}                                    { return symbol(ParserSym.ELSE); }
  {read}                                    { return symbol(ParserSym.READ); }
  {write}                                   { return symbol(ParserSym.WRITE); }
  {end}                                     { escribir_ts();return symbol(ParserSym.END); }
  {int}                                     { return symbol(ParserSym.INT); }
  {float}                                   { return symbol(ParserSym.FLOAT); }
  {String}                                  { return symbol(ParserSym.STRING); }
  {ElementInTheMiddle}                      { return symbol(ParserSym.ELEMENT_IN_THE_MIDDLE); }

  /* identifiers */
  {Identifier}                             { validar_cantidad_caracteres(yytext());guardar_TS("ID",yytext());return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */
  {IntegerConstant}                        {validar_rango_entero(yytext());guardar_TS("Cte_entera",yytext()); return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
  {RealConstant}                           { validar_rango_real(yytext());guardar_TS("Cte_real",yytext());return symbol(ParserSym.REAL_CONSTANT, yytext()); }
  {StringConstant}                         { validar_cantidad_caracteres(yytext());guardar_TS("Cte_String",yytext());return symbol(ParserSym.STRING_CONSTANT, yytext()); }

  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {P_A}                                     { return symbol(ParserSym.P_A); }
  {P_C}                                     { return symbol(ParserSym.P_C); }
  {Coma}                                    { return symbol(ParserSym.COMA); }
  {PyC}                                     { return symbol(ParserSym.PUNTO_COMA); }
  {D_P}                                     { return symbol(ParserSym.D_P); }
  {C_A}                                     { return symbol(ParserSym.CORCH_ABRE); }
  {C_C}                                     { return symbol(ParserSym.CORCH_CIERRA); }
  {LL_A}                                    { return symbol(ParserSym.LL_A); }
  {LL_C}                                    { return symbol(ParserSym.LL_C); }
  {Menor_Ig}                                { return symbol(ParserSym.MENOR_IGUAL); }
  {Menor}                                   { return symbol(ParserSym.MENOR); }
  {Mayor_Ig}                                { return symbol(ParserSym.MAYOR_IGUAL); }
  {Mayor}                                   { return symbol(ParserSym.MAYOR); }
  {Igual}                                   { return symbol(ParserSym.IGUAL); }
  {and}                                     { return symbol(ParserSym.AND); }
  {or}                                      { return symbol(ParserSym.OR); }
  {not}                                     { return symbol(ParserSym.NOT); }
  {distinto}                                { return symbol(ParserSym.DISTINTO); }



  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
