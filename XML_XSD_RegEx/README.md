Actividad UD05.1: Validación de XML con XSD y Expresiones Regulares
Asignatura: Lenguaje de Marcas (LDM)
Autor: Espejo Martínez, Jorge
Fecha: 15/03/2026

Estructura del repositorio
Lenguaje-De-Marcas
├─ XML_XSD_RegEx
    ├─ user.xml
    ├─ valid_user.xsd
    ├─ README.md
    └─ validacion.mp4

Documento XML (user.xml)
El documento XML contiene una lista de 10 usuario de una aplicación web. Posee la siguiente estructura:
usuarios #elemento raiz
├─ usuario (atributo id)
    ├─ nombre
    ├─ email
    ├─ telefono
    ├─ codigoPostal
    └─ password

Esquema XSD y validaciones
El documento XSD contiene la estructura que se ha de seguir y aplica restricciones mediante las expreciones regulares.
1. Nombre de Usuario (userType)
RegEx --> [a-z][a-z0-9_]{3,15}
Comienza con minúscula, seguido de 3 a 15 caracteres alfanuméricos o guión bajo.
Este es el estandar común en nombres de usuario.
2. Email (emailType)
RegEx --> [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
Formato estándar de email (nombre@dominio.extensión).
Sigue el formato definido en RFC 5322.
3. Teléfono (telefonoType)
RegEx --> [6789][0-9]{8}
Son 9 dígitos y el primer dígito debe de ser 6,7,8 o 9.
Se trata de la numeración telefónica española.
4. Código Postal (codigoPostalType)
RegEx --> [0-9]{5}
El código postal español son exactamente 5 dígitos numéricos.
Se trata del formato oficial de códigos postales en España.
5. Contraseña (passwordType)
RegEx --> (?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+.,;:-]).{8,16}
Son mínimo 8 caracteres y máximo 16, debe de tener al menos una minúscula, una mayúscula, un dígito y un símbolo especial.
Se trata de la política de seguridad de nivel medio-alto (recomendación OWASP).

Errores cometidos y que no se han podido solucionar de forma adecuada:
He tenido un error en el archivo valid_user.xsd en la línea 46 se trata del la expreción regular denominada passwordType se encuentran diferentes caracteres espaciales entre ellos el &, los caracteres < y > (que se mencionan en el error pero se confunden con los corchetes que sí están bien escapados) y las llaves. Se ha sustituido el & por &amp; y las llaves {} por &lt; y &gt; respectivamente. Aunque el primer error se haya solucionado, me he encontrado con otro error el cual en resumen dice "no es una correcta expreción regular".

Proceso de Validación
Diseño de RegEx: cada expresión fue probada en regex101.com para asegurar su correcto funcionamiento.
Implementación en XSD: las expresiones se incorporaron al esquema usando <xs:pattern>.
Validación en VSCode: el documento XML se validó contra el XSD, confirmando que todos los datos cumplen las restricciones.

Demostración en vídeo
El archivo validacion.mp4 contiene una grabación de pantalla donde se muestra la validación de las expreciones regulares escritas en el documento XSD.
Además se muestra una prueba modificando algún dato para mostrar cómo el validador detecta incumplimientos.