# Nuestra Casita
La vida de ustedes — Santo Domingo.

Sitio estático sin build; Three.js 0.160.0. Modo invitado sin guardar; online requiere instalar la migración.

## Activar Supabase (Juan)
1. Abrir el proyecto nuestra-casita (pvxxarxbgmjpaciewmml) en su propio navegador.
2. SQL Editor → New query. Copiar TODO supabase/migracion.sql y ejecutar Run UNA VEZ en el proyecto nuevo. No ejecutarlo en otros proyectos. Si aparece un error, guardar el mensaje completo antes de repetir.
3. supabase-config.js ya contiene Project URL y clave pública publishable. Nunca agregar service_role ni contraseña de la base de datos.
4. Abrir el sitio con ?v=7. Registrar dos usuarios distintos de 6–10 caracteres y PIN de 6 dígitos, cada persona en su teléfono.
5. Uno elige MUDARTE SOLO y comparte su código. El otro elige MUDARTE CON ALGUIEN e introduce ese código. No creen dos casas si desean vivir juntos.
6. Verificar en ambos teléfonos movimiento, dinero tras trabajo y compras; recargar para comprobar persistencia.

## Controles
Horizontal; WASD + E, flechas + Enter para segundo invitado local. Controles táctiles en las esquinas. Acercarse a los objetos y pulsar USAR. Invitado no conecta dos dispositivos ni guarda.

## Diseño y límites
Muebles en espacios predefinidos, sin arrastrar ni colisiones interiores. Eventos sencillos. Realtime transmite avisos de cambio; los datos se releen por RPC validada y hay sondeo de respaldo. Las tablas no permiten lectura anónima directa; las RPC públicas validan la sesión de juego. PIN de seis dígitos no es apropiado para datos sensibles.

La migración no se ha ejecutado desde este entorno: las pruebas online de dos cuentas y seguridad en el proyecto real quedan pendientes de instalación. El modo invitado funciona independientemente de Supabase.
