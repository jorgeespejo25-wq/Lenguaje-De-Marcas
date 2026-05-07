# Preparación del Entorno (Pre-flight Check)

Antes de comenzar la operación técnica, la primera regla es validar el estado del entorno. Verificando que el entorno orquestado con Docker está levantado y estable. Para ello se abre VS Code, voy a la extensión de Docker (o ejecuto *docker-compose ps* en la terminal) y compruebo que los contenedores de Odoo y Postgres-db están en estado *Running*.

Abro la terminal integrada y dejo los logs corriendo mediante el comando docker logs \-f odoo. Esto es crucial, porque cada clic en la interfaz web generará trazas en este log, permitiéndome ver peticiones HTTP, advertencias del ORM y transacciones en tiempo real. Finalmente, debo de tener el **Modo Desarrollador** activado (el icono del insecto en la barra superior debe estar visible). Este modo desactiva ciertas cachés, revela los nombres de los campos de la base de datos al pasar el ratón por encima de la interfaz y desbloquea los menús técnicos avanzados.

# Fase 1: Integración de Módulos

**Contexto**. En la anterior sesión, la arquitectura de la empresa era plana. El usuario comercial solo puede hacer presupuestos (Módulo de Ventas) que no interactúan con nada más. Hoy voy a dotar a la empresa de complejidad operativa integrando un almacén físico y un departamento de contabilidad. Voy a integrar nuevos módulos y observar cómo el ORM (Object-Relational Mapping) de Odoo enlaza las tablas en PostgreSQL automáticamente, aplicando restricciones de integridad referencial.

**Paso a paso descriptivo e Implicaciones**:

1. **Instalación y Alteración del Esquema**. En el  menú principal entro en la aplicación **Aplicaciones** (Apps). Busco e instalo los módulos base de **Inventario** (Inventory) y **Facturación** (Invoicing).  
   1. **Nota técnica y Observación de Logs**. En el momento en que se pulsa "Instalar", al observar la terminal de VS Code. Se ven cientos de consultas *CREATE TABLE*, *ALTER TABLE* y *CREATE INDEX*. Odoo no solo está descargando código *Python*; está inyectando la nueva estructura relacional en *PostgreSQL* en tiempo real. Está creando la tabla *stock\_picking* (para los albaranes), *account\_move* (para los asientos contables) y estableciendo las claves foráneas (*Foreign Keys*) para relacionarlas con nuestros pedidos de venta (*sale\_order*).  
2. **Nuestros clientes**. Para no arrancar una práctica con una base de datos vacía, se ha generado un archivo de datos sintético (*Mock Data*) en formato CSV. Lo importante es que no se introduzca a mano, sino que se utilice la herramienta nativa de importación de Odoo, para ver cómo el sistema lee un formato de marcas/texto plano y lo mapea contra las tablas relacionales de PostgreSQL. Para fijarse hay que seguir los siguientes pasos:  
   1. Copia los datos y crea un archivo llamado *clientes\_mock.csv*  
      Nombre,Correo electrónico,Teléfono,Ciudad,País,Es una compañía  
      Tech Solutions Ibérica,info@techsolutions.es,\+34 611 222 333,Sevilla,España,True  
      María Fernández,maria.fernandez@ejemplo.com,\+34 644 555 666,Madrid,España,False  
      Distribuciones del Sur,ventas@delsur.es,\+34 677 888 999,Málaga,España,True  
      Carlos Ruiz,cruiz.dev@ejemplo.com,\+34 699 111 222,Valencia,España,False  
      Global Logistics S.L.,logistica@global.es,\+34 622 333 444,Barcelona,España,True  
      Laura Gómez,laura.gomez@ejemplo.com,\+34 655 444 333,Bilbao,España,False  
      Sistemas Avanzados,contacto@sistemas.es,\+34 688 777 666,Zaragoza,España,True  
      Pedro Sánchez,psanchez@ejemplo.com,\+34 612 345 678,Murcia,España,False  
      Innovaciones Web,dev@innovaciones.es,\+34 698 765 432,Granada,España,True  
      Elena Torres,etorres.design@ejemplo.com,\+34 633 222 111,Alicante,España,False  
   2. Si se trabaja en VS Code, se debe de instalar la extensión **Rainbow CSV** de **mechatroner**, porque permitirá:  
      1. Resaltar las columnas en archivos CSV, TSV, separados por punto y coma, y por barra vertical con colores distintos.  
      2. Consultar, transformar y filtrar datos utilizando un lenguaje integrado similar a SQL (RBQL).  
      3. Seguimiento mejorado de hasta 3 columnas de interés con decoraciones auxiliares.  
      4. Alinear las columnas gráficamente o con espacios adicionales y reducir el espacio (eliminando los espacios de los campos).  
      5. Línea de encabezado fija opcional.  
      6. Proporcionar información sobre la columna al pasar el cursor por encima.  
      7. Comprobaciones automáticas de coherencia de archivos CSV (CSVLint).  
      8. Colores de fondo de fila alternos opcionales para una mejor legibilidad.  
      9. Edición de columnas con múltiples cursores.  
      10. Copiar en formato Excel y Markdown para su exportación.  
   3. **Ruta en Odoo**. Navego a la aplicación de **Ventas \> Pedidos \> Clientes**.  
   4. **La herramienta de Importación**. En la vista de lista de clientes (icono de rayitas), hago clic en el icono de engranaje (Acción) o en el menú superior **Favoritos** y selecciono **Importar registros**.  
   5. **Mapeo de campos**. Subo el archivo. Odoo es muy inteligente y, como he puesto las cabeceras en español, hará un auto-mapeo (Nombre \-\> Name, Correo electrónico \-\> Email, etc.).  
   6. **Test y carga**. Pulso el botón "**Test/Prueba**" (para validar que el tipo de dato coincide con la base de datos) y, si todo está en azul/correcto, pulso "**Importar**".  
   7. En cuestión de milisegundos, el ORM de Odoo procesará el texto plano, ejecutará los *INSERT INTO res\_partner* en PostgreSQL y tendré 10 clientes con los que jugar a crear presupuestos, facturar y luego exportar de forma masiva.

3. **El ciclo de negocio**.  
   1. Entro con el usuario comercial y creo un **Presupuesto** para un nuevo cliente. Añado un producto que sea de tipo "Almacenable/Bienes", es decir, físico (por ejemplo, "mouse rojo", pero se tiene que crear primero con el modo administrador).  
      *Nota*: Si el producto fuera un "Servicio", el sistema inteligente de Odoo no generaría una orden de entrega, ya que los servicios no ocupan espacio físico.  
   2. **Hago clic en Confirmar**. Observo la máquina de estados: el documento pasa de 'Presupuesto' a 'Pedido de Venta'. Me fijo en la esquina superior derecha del formulario: acaba de aparecer un "*Smart Button*" con el icono de un camión que indica *1 Entrega*.  
   3. **¡Aquí está la integración en acción\!** El módulo de Ventas se ha comunicado de forma transparente con el de Inventario. Al hacer clic en ese camión. Veo que el producto está en estado "**Reservado**". Valido la entrega (simulando que el mozo de almacén ha cogido la caja, la ha escaneado y se la ha entregado al transportista).  
   4. **Vuelvo al pedido de ventas original** utilizando las migas de pan (*breadcrumbs*) superiores. Ahora veo que el botón **Crear Factura** se ha habilitado. Odoo aplica políticas de facturación estrictas: por defecto, no deja facturar algo que no se ha entregado. El módulo de Inventario acaba de enviar un *trigger* lógico al de **Facturación** confirmando la entrega.  
   5. Hago clic en él y **creo una "Factura normal"**. Confirmo la factura. Al hacerlo, habré generado un asiento contable real. He completado y orquestado un ciclo de vida completo de un ERP sin escribir una sola consulta SQL manual.

# Fase 2: Elaboración de Informes

**Contexto**. La Gerencia ha detectado un riesgo legal y ha solicitado que todos los presupuestos en PDF lleven impreso un texto de protección de datos específico y el CIF de la empresa destacado en rojo. No voy a generar el PDF desde cero; sino a **modificar la plantilla XML original** utilizando el motor de plantillas de Odoo (QWeb). Con esto cumpliré directamente con el criterio de evaluación g) Se han generado informes.

**Paso a paso descriptivo e Implicaciones**:

1. **El Peligro de Modificar el *Core* y la Solución**. La regla de oro en Odoo y en cualquier framework MVC[^1] es nunca modificar el código fuente original (*core*). Si lo hago, en la próxima actualización del sistema, los cambios se sobrescribirán. Por ello, Odoo usa un sistema de "*Herencia de vistas*" basado en *XPath*. Al tener el **Modo Desarrollador activo**, voy a *Ajustes \> Técnico \> Interfaz de Usuario \> Vistas* (*Views*).  
2. **Búsqueda del Informe Base**. En la caja de búsqueda, **filtro por Clave (Key)** y busco *sale.report\_saleorder\_document*. Esta es la vista base que renderiza el esqueleto HTML que luego el motor *wkhtmltopdf* convierte a PDF.  
3. **Modificación del XML mediante Herencia (Práctica directa)**:  
   1. **Abro el registro de la vista**. Veo un editor de código integrado, donde puedo observar etiquetas como *\<div\>*, *\<span\>* o *\<table\>*, pero fuertemente mezcladas con el motor **QWeb** (etiquetas dinámicas *\<t\>*, como *\<t t-if="..." \>* para condicionales lógicos o *\<t t-esc="..." \>* para imprimir variables de la base de datos).  
   2. Voy a localizar la sección final del documento, buscando visualmente el cierre principal (justo antes de la etiqueta de cierre *\</div\>* que corresponde a *\<div class="page"\>*).  
   3. **Inyección de código de marcas**. Inserto el siguiente bloque de marcado *HTML/XML*. Si me fijo que estoy utilizando clases nativas de *Bootstrap* (el framework CSS que usa Odoo por debajo), como *row* para el *grid*, *col-12* para ocupar todo el ancho, y *mt32 mb32* (*margin-top* y *margin-bottom* de *32 píxeles*). También usamos *CSS inline*, ya que los renderizadores de PDF a menudo ignoran las hojas de estilo externas:

        \<div class\="row mt32 mb32" id\="legal\_warning"\>

          \<div class\="col-12"\>

              \<p style\="color: red; font-weight: bold; border-top: 1px solid black; padding-top: 10px;"\>

                  Atención: Este documento vinculante está sujeto a las condiciones generales de venta de DAM/DAW S.L. (CIF: B-12345678).

              \</p\>

              \<p class\="text-muted" style\="font-size: 10px; text-align: justify;"\>

                  Protección de datos: En cumplimiento de la Ley Orgánica 3/2018 y el RGPD europeo, le informamos que sus datos serán tratados de forma estrictamente confidencial. Puede ejercer sus derechos ARCO dirigiéndose a nuestro DPO.

              \</p\>

          \</div\>

        \</div\>

   4. **Guardo los cambios en la vista**. Si hay un error de sintaxis en el XML (como no cerrar una etiqueta *\<p\>*), el sistema lanzará una excepción y te lo impedirá, protegiendo así la integridad de la base de datos.  
   5. **Validación del Renderizado**. Vuelvo a la aplicación de Ventas, abre el pedido que creé en la **Fase 1**. Hago clic en el botón de la tuerca superior (Acción) o en el menú de "Imprimir", y descargo el "Presupuesto / Pedido". Abre el PDF y verifico que tus etiquetas de marcado se han transformado en texto enriquecido con los márgenes, colores y grosores correctos.

# Fase 3: Exportación de Información

**Contexto**. Un sistema cerrado es un sistema inútil. El departamento de Marketing quiere hacer una campaña masiva de correos a todos los clientes facturados este año utilizando una herramienta externa de *Business Intelligence* o *Mailing* (como *Mailchimp* o *PowerBI*). Así que necesitan extraer los datos de forma limpia. Voy a cumplir de forma estricta el criterio h) Procedimientos de extracción de información.

**Paso a paso descriptivo e Implicaciones**:

1. **Preparación de la Vista de Lista (Tree View)**. Me dirijo a la aplicación de *Facturación \> Clientes \> Clientes*. Las listas en Odoo están paginadas para no colapsar la memoria del navegador.  
2. **Selección Masiva de Registros**. Me aseguro de estar en la vista de lista (icono de rayitas horizontales). Marco la casilla global superior izquierda para seleccionar a todos los clientes de la pantalla actual.  
3. **El Asistente Avanzado de Exportación**:  
   1. Al seleccionar los registros, aparece un menú de "Acción" (icono de engranaje) en la parte superior central. Selecciono **Exportar**.  
   2. Se abre una ventana modal de extracción de datos. Aquí es crucial entender lo qué estoy haciendo:  
      1. **Tipo de exportación**. Selecciono "Exportar datos compatibles con importación". Esto es vital. Si elijo esto, Odoo exportará los *IDs* externos (*Primary Keys*), permitiéndome editar el archivo en Excel y volver a subirlo para actualizar masivamente la base de datos sin duplicar clientes.  
      2. **Formato**. Selecciono CSV (*Comma Separated Values*). Es el estándar universal (RFC 4180). Olvido el formato *.xlsx* de Excel, ya que a menudo introduce formatos ocultos que rompen las integraciones automatizadas.  
      3. **La Magia de las Relaciones**. En la columna izquierda, busco **Nombre** (*name*), **Correo electrónico** (*email*) y **Teléfono** (*phone*). Ahora, busco **País** (*country\_id*). Y si me fijo Odoo me permite desplegar un signo *\+* al lado del país. Esto es porque el **País** no es un simple texto, es una relación *Many2one* a otra tabla de la base de datos (*res.country*). Despliego y selecciono **Nombre del país** (*country\_id/name*). De esta forma, Odoo hará un **JOIN** SQL por debajo y exportará la palabra "España" en lugar del *ID* numérico *68*.  
4. **Extracción y Validación de Codificación**:  
   1. Hago clic en el botón **Exportar**. Se descarga mi archivo de extracción.  
   2. **Paso crítico**. Abre el archivo *.csv* directamente con tu editor *VS Code* (no hago doble clic para abrirlo con Excel de primeras). Excel tiende a cambiar la codificación UTF-8 a ANSI por defecto, **rompiendo tildes y eñes**.  
   3. **Observa en VS Code el texto en bruto**. Compruebo que la codificación es *UTF-8*, que los datos están delimitados por comillas dobles (para proteger textos que ya contengan comas en su interior) y perfectamente separados por comas. Mis datos acaban de ser liberados con éxito, listos para integrarse en cualquier otro sistema del mundo.

[^1]:  El Modelo-Vista-Controlador (MVC) es un patrón de arquitectura de software que separa la aplicación en tres componentes distintos —Modelo (datos), Vista (interfaz) y Controlador (lógica)— para organizar el código, facilitar el mantenimiento y mejorar la escalabilidad. Esta estructura evita el «código espagueti» al dividir responsabilidades, común en frameworks como Laravel, Ruby on Rails, Django o AngularJS.