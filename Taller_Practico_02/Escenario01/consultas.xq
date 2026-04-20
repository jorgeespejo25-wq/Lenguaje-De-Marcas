declare namespace file = "http://expath.org/ns/file";

(:Listado visual de vehículos con batería crítica (< 15%) 
  y estado "En ruta" para enviar aviso de retorno.:)
  $colsulta1
for $EcoLogistics in doc("logistics.xml"),
let $bateria := $Vehiculo/Bateria,
    $estado := $Vehiculo/Estado
where $bateria < 15 and $estado = "En ruta"
return
    file:write(C:\Users\DAM1\Documents\VSC\LDM\Lenguaje-De-Marcas\Taller_Practico_02\Escenario01, $colsulta1)