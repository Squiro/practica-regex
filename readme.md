# Pruebas de JFLEX y CUP

El objetivo de este repo es resolver los ejercicios de prática de regex y realizar pruebas con JFLEX y CUP. Por eso mismo nada de lo que veas acá es 100% fiable.

Para "hacer andar" esto podés hacer lo siguiente:

* Abrir tu IDE de Java preferido, importá todo esto como un proyecto, y ejecutá el archivo Main.java.
* Ejecutar el archivo Main.java a través una commandline.

El archivo main tiene una función bastante simple que va recorriendo todos los tokens con los que se encuentra el lexer, hasta llegar al EOF.

En caso de modificar el archivo lexer.jflex, para que los resultados del analizador léxico empiecen a tomarse en cuenta, vas a tener que volver a compilar las clases de java que genera JFLEX y CUP. Para esto, ejecutá run.bat. Una vez creadas al ejecutar el Main.java vas a notar los cambios en el léxico.
