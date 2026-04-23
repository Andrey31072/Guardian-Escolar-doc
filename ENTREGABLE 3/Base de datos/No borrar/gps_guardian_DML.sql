-- =============================================================================
-- DML - GPS Guardian Escolar v3
-- 10 registros por tabla (o los necesarios según dependencias FK)
-- Orden de inserción respeta las claves foráneas
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. Configuracion_Seguridad
-- -----------------------------------------------------------------------------
INSERT INTO Configuracion_Seguridad (NombreConfiguracion, ValorConfiguracion, Descripcion) VALUES
('MAX_INTENTOS_LOGIN',    '5',     'Intentos fallidos antes de bloquear la cuenta'),
('TIEMPO_SESION_MIN',     '30',    'Minutos de inactividad para expirar sesión'),
('JWT_EXPIRACION_H',      '24',    'Horas de validez del token JWT'),
('HTTPS_FORZADO',         'true',  'Forzar uso exclusivo de HTTPS'),
('TOKEN_REFRESCO_H',      '72',    'Horas de validez del token de refresco'),
('BLOQUEO_IP_MINUTOS',    '15',    'Minutos de bloqueo por IP tras intentos fallidos'),
('MAX_SESIONES_ACTIVAS',  '3',     'Máximo de sesiones simultáneas por usuario'),
('LOG_NIVEL',             'INFO',  'Nivel de logging del sistema'),
('ALERTA_GPS_SEG',        '30',    'Intervalo en segundos para actualización GPS'),
('VERSION_APP',           '3.0.0', 'Versión actual de la aplicación');


-- -----------------------------------------------------------------------------
-- 2. Politicas_Contrasenas
-- -----------------------------------------------------------------------------
INSERT INTO Politicas_Contrasenas (MinLongitud, MaxLongitud, RequiereMayusculas, RequiereMinusculas, RequiereNumeros, RequiereSimbolos, CaducidadDias, IntentosFallidosMax) VALUES
(8,  20, TRUE,  TRUE,  TRUE,  TRUE,  90,  5),
(10, 30, TRUE,  TRUE,  TRUE,  TRUE,  60,  3),
(6,  15, FALSE, TRUE,  TRUE,  FALSE, 180, 5),
(8,  25, TRUE,  TRUE,  TRUE,  FALSE, 90,  5),
(12, 40, TRUE,  TRUE,  TRUE,  TRUE,  30,  3),
(8,  20, TRUE,  FALSE, TRUE,  TRUE,  90,  10),
(10, 20, TRUE,  TRUE,  FALSE, TRUE,  120, 5),
(8,  20, FALSE, FALSE, TRUE,  FALSE, 365, 10),
(8,  32, TRUE,  TRUE,  TRUE,  TRUE,  45,  3),
(8,  20, TRUE,  TRUE,  TRUE,  TRUE,  90,  5);


-- -----------------------------------------------------------------------------
-- 3. Roles
-- -----------------------------------------------------------------------------
INSERT INTO Roles (NombreRol, Descripcion) VALUES
('Administrador', 'Control total del sistema'),
('Padre',         'Monitoreo y seguimiento de estudiantes asignados'),
('Estudiante',    'Acceso de consulta al propio historial de trayectos');


-- -----------------------------------------------------------------------------
-- 4. Permisos
-- -----------------------------------------------------------------------------
INSERT INTO Permisos (NombrePermiso, Descripcion) VALUES
('VER_MAPA',              'Ver mapa en tiempo real'),
('GESTIONAR_RUTAS',       'Crear, editar y eliminar rutas'),
('VER_HISTORIAL',         'Consultar historial de trayectos'),
('GESTIONAR_USUARIOS',    'Crear y administrar usuarios'),
('VER_NOTIFICACIONES',    'Recibir y consultar notificaciones'),
('GESTIONAR_ESTUDIANTES', 'Registrar y editar estudiantes'),
('VER_REPORTES',          'Visualizar reportes del sistema'),
('CONFIGURAR_SISTEMA',    'Modificar configuraciones de seguridad'),
('GESTIONAR_PARADAS',     'Crear y editar paradas en rutas'),
('VER_AUDITORIA',         'Consultar logs de auditoría');


-- -----------------------------------------------------------------------------
-- 5. Rol_Permiso
-- -----------------------------------------------------------------------------
INSERT INTO Rol_Permiso (RolID, PermisoID) VALUES
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),
(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),
(2, 1),(2, 3),(2, 5),(2, 6),(2, 7),
(3, 1),(3, 3),(3, 5);


-- -----------------------------------------------------------------------------
-- 6. Usuario
-- -----------------------------------------------------------------------------
INSERT INTO Usuario (NombreCompleto, username, Email, Telefono, FechaNacimiento, Genero, ContactoEmergencia, GradoEscolar, Contrasena, TipoAutenticacion, TipoUsuario, EstadoUsuario) VALUES
('Carlos Mendoza Ruiz',    'cmendoza', 'carlos.mendoza@gmail.com',    '3101234567', '1985-03-12', 'M', '3209876543', NULL,          '$2b$12$xHkL9mNpQr7sT3uV5wYz1O', 'LOCAL',  'Padre',      TRUE),
('Laura Gomez Torres',     'lgomez',   'laura.gomez@gmail.com',       '3112345678', '1990-07-25', 'F', '3154321098', NULL,          '$2b$12$aB3cD4eF5gH6iJ7kL8mN9P', 'LOCAL',  'Padre',      TRUE),
('Sofia Mendoza Garcia',   'smendoza', 'sofia.mendoza@gps.edu.co',    '3101234567', '2015-05-10', 'F', '3101234567', '4to Primaria','$2b$12$bC4dE5fG6hI7jK8lM9nO0Q', 'LOCAL',  'Estudiante', TRUE),
('Patricia Vega Morales',  'pvega',    'patricia.vega@gmail.com',     '3134567890', '1992-04-18', 'F', '3211234567', NULL,          '$2b$12$cD5eF6gH7iJ8kL9mN0oP1R', 'LOCAL',  'Padre',      TRUE),
('Administrador Sistema',  'admin',    'admin@gpsguardian.edu.co',    '6012345678', '1980-01-01', 'M', '6019876543', NULL,          '$2b$12$dE6fG7hI8jK9lM0nO1pQ2S', 'LOCAL',  'Admin',      TRUE),
('Tomas Mendoza Garcia',   'tmendoza', 'tomas.mendoza@gps.edu.co',    '3101234567', '2013-09-22', 'M', '3101234567', '6to Primaria','$2b$12$eF7gH8iJ9kL0mN1oP2qR3T', 'LOCAL',  'Estudiante', TRUE),
('Sandra Castro Pena',     'scastro',  'sandra.castro@gmail.com',     '3156789012', '1991-02-14', 'F', '3236789012', NULL,          '$2b$12$fG8hI9jK0lM1nO2pQ3rS4U', 'LOCAL',  'Padre',      TRUE),
('Miguel Angel Herrera',   'mherrera', 'miguel.herrera@gmail.com',    '3167890123', '1987-06-22', 'M', '3247890123', NULL,          '$2b$12$gH9iJ0kL1mN2oP3qR4sT5V', 'GOOGLE', 'Padre',      TRUE),
('Valentina Gomez Ruiz',   'vgomez',   'valentina.gomez@gps.edu.co',  '3112345678', '2017-03-15', 'F', '3112345678', '2do Primaria','$2b$12$hI0jK1lM2nO3pQ4rS5tU6W', 'LOCAL',  'Estudiante', TRUE),
('Roberto Nino Castillo',  'rnino',    'roberto.nino@gmail.com',      '3189012345', '1986-08-17', 'M', '3269012345', NULL,          '$2b$12$iJ1kL2mN3oP4qR5sT6uV7X', 'LOCAL',  'Padre',      TRUE);


-- -----------------------------------------------------------------------------
-- 7. Usuario_Rol
-- -----------------------------------------------------------------------------
INSERT INTO Usuario_Rol (UsuarioID, RolID) VALUES
(1,  2),
(2,  2),
(3,  3),
(4,  2),
(5,  1),
(6,  3),
(7,  2),
(8,  2),
(9,  3),
(10, 2);


-- -----------------------------------------------------------------------------
-- 8. Sesion_Usuario
-- -----------------------------------------------------------------------------
INSERT INTO Sesion_Usuario (UsuarioID, FechaInicio, FechaFin, IP_Origen, EstadoSesion) VALUES
(1,  '2025-03-01 07:00:00', '2025-03-01 08:30:00', '192.168.1.10', 'CERRADA'),
(2,  '2025-03-01 07:15:00', '2025-03-01 09:00:00', '192.168.1.11', 'CERRADA'),
(3,  '2025-03-01 06:45:00', '2025-03-01 14:00:00', '192.168.1.12', 'CERRADA'),
(5,  '2025-03-01 08:00:00', '2025-03-01 17:00:00', '192.168.1.20', 'CERRADA'),
(4,  '2025-03-02 07:10:00', '2025-03-02 08:45:00', '192.168.1.13', 'CERRADA'),
(6,  '2025-03-02 06:50:00', '2025-03-02 14:15:00', '192.168.1.14', 'CERRADA'),
(7,  '2025-03-02 07:05:00', NULL,                  '192.168.1.15', 'ACTIVA'),
(8,  '2025-03-02 07:30:00', NULL,                  '192.168.1.16', 'ACTIVA'),
(1,  '2025-03-03 07:00:00', '2025-03-03 08:20:00', '192.168.1.10', 'CERRADA'),
(10, '2025-03-03 07:45:00', NULL,                  '192.168.1.17', 'ACTIVA');


-- -----------------------------------------------------------------------------
-- 9. Registro
-- -----------------------------------------------------------------------------
INSERT INTO Registro (UsuarioID, TipoAccion, Descripcion, FechaHora, IP_Origen, Dispositivo, EstadoDispositivo) VALUES
(1,  'LOGIN',         'Inicio de sesion exitoso',             '2025-03-01 07:00:00', '192.168.1.10', 'Android 13',   'ACTIVO'),
(2,  'LOGIN',         'Inicio de sesion exitoso',             '2025-03-01 07:15:00', '192.168.1.11', 'iOS 17',       'ACTIVO'),
(3,  'LOGIN',         'Inicio de sesion desde app conductor', '2025-03-01 06:45:00', '192.168.1.12', 'Android 12',   'ACTIVO'),
(5,  'CONFIG',        'Modifico configuracion de seguridad',  '2025-03-01 08:05:00', '192.168.1.20', 'Chrome/Win11', 'ACTIVO'),
(1,  'VER_MAPA',      'Consulto mapa en tiempo real',         '2025-03-01 07:35:00', '192.168.1.10', 'Android 13',   'ACTIVO'),
(4,  'LOGIN',         'Inicio de sesion exitoso',             '2025-03-02 07:10:00', '192.168.1.13', 'iOS 16',       'ACTIVO'),
(6,  'INICIO_RUTA',   'Inicio trayecto en Ruta Norte',        '2025-03-02 06:55:00', '192.168.1.14', 'Android 11',   'ACTIVO'),
(2,  'NOTIFICACION',  'Recibio alerta de llegada',            '2025-03-02 07:40:00', '192.168.1.11', 'iOS 17',       'ACTIVO'),
(7,  'VER_HISTORIAL', 'Consulto historial de trayectos',      '2025-03-02 07:05:00', '192.168.1.15', 'Android 13',   'ACTIVO'),
(5,  'LOGOUT',        'Cierre de sesion del administrador',   '2025-03-01 17:00:00', '192.168.1.20', 'Chrome/Win11', 'INACTIVO');


-- -----------------------------------------------------------------------------
-- 10. Auditoria
-- -----------------------------------------------------------------------------
INSERT INTO Auditoria (UsuarioID, Accion, Fecha, Descripcion, IP_Origen, Aplicacion) VALUES
(5, 'CREAR_USUARIO',    '2025-02-28 10:00:00', 'Creo usuario Carlos Mendoza',           '192.168.1.20', 'GPS Guardian Admin'),
(5, 'CREAR_USUARIO',    '2025-02-28 10:05:00', 'Creo usuario Laura Gomez',              '192.168.1.20', 'GPS Guardian Admin'),
(5, 'CREAR_USUARIO',    '2025-02-28 10:10:00', 'Creo usuario Sofia Mendoza (Estudiante)', '192.168.1.20', 'GPS Guardian Admin'),
(5, 'MODIFICAR_CONFIG', '2025-03-01 08:05:00', 'Modifico MAX_INTENTOS_LOGIN a 5',        '192.168.1.20', 'GPS Guardian Admin'),
(5, 'ASIGNAR_ROL',      '2025-02-28 10:30:00', 'Asigno rol Estudiante a Sofia Mendoza',  '192.168.1.20', 'GPS Guardian Admin'),
(5, 'CREAR_RUTA',       '2025-02-28 11:00:00', 'Creo Ruta Norte Kennedy',               '192.168.1.20', 'GPS Guardian Admin'),
(5, 'CREAR_RUTA',       '2025-02-28 11:05:00', 'Creo Ruta Sur Usme',                    '192.168.1.20', 'GPS Guardian Admin'),
(3, 'INICIAR_TRAYECTO', '2025-03-01 06:55:00', 'Inicio trayecto ID 1',                  '192.168.1.12', 'GPS Guardian App'),
(1, 'VER_UBICACION',    '2025-03-01 07:35:00', 'Consulto ubicacion de estudiante',      '192.168.1.10', 'GPS Guardian App'),
(5, 'DESACTIVAR_USER',  '2025-03-02 09:00:00', 'Desactivo cuenta de usuario inactivo',  '192.168.1.20', 'GPS Guardian Admin');


-- -----------------------------------------------------------------------------
-- 11. Log_Errores
-- -----------------------------------------------------------------------------
INSERT INTO Log_Errores (Fecha, UsuarioID, TipoError, Descripcion, IP_Origen) VALUES
('2025-03-01 07:02:00', 1,    'AUTH_FAIL',       'Contrasena incorrecta en intento de login',      '192.168.1.10'),
('2025-03-01 07:20:00', NULL, 'GPS_TIMEOUT',     'Dispositivo GPS sin respuesta por 60 segundos',  '192.168.1.12'),
('2025-03-01 08:15:00', 4,    'SESSION_EXPIRED', 'Token de sesion expirado',                       '192.168.1.13'),
('2025-03-01 09:00:00', NULL, 'DB_CONN',         'Fallo momentaneo en conexion a base de datos',   '192.168.1.1'),
('2025-03-02 06:50:00', 6,    'GPS_SIGNAL',      'Senal GPS debil al inicio del trayecto',         '192.168.1.14'),
('2025-03-02 07:30:00', 2,    'NOTIF_FAIL',      'Error al enviar notificacion push',              '192.168.1.11'),
('2025-03-02 10:00:00', 5,    'AUTH_FAIL',       'Intento de acceso con credenciales invalidas',   '10.0.0.99'),
('2025-03-02 11:15:00', NULL, 'API_ERROR',       'Timeout en llamada a API de mapas',              '192.168.1.1'),
('2025-03-03 07:05:00', 8,    'SYNC_ERROR',      'Error de sincronizacion de coordenadas',         '192.168.1.16'),
('2025-03-03 08:30:00', NULL, 'STORAGE_WARN',    'Espacio en disco al 85% de capacidad',           '192.168.1.1');


-- -----------------------------------------------------------------------------
-- 12. Ruta
-- -----------------------------------------------------------------------------
INSERT INTO Ruta (NombreRuta, Descripcion, HorarioSalida, EstadoRuta, OriginLatitud, OriginLongitud, creado_por) VALUES
('Ruta Norte - Kennedy',   'Recorrido norte desde Kennedy hasta el colegio',  '06:30:00', 'Activa',     4.629849, -74.064148, 5),
('Ruta Sur - Usme',        'Recorrido sur desde Usme hasta el colegio',       '06:45:00', 'Activa',     4.481456, -74.113780, 5),
('Ruta Oriente - Bosa',    'Recorrido desde Bosa hasta el colegio',           '07:00:00', 'Activa',     4.621123, -74.185320, 5),
('Ruta Centro - Martires', 'Recorrido desde Los Martires hasta el colegio',   '06:50:00', 'Activa',     4.601234, -74.081234, 5),
('Ruta Occidente - Fonti', 'Recorrido desde Fontibón hasta el colegio',       '06:40:00', 'Activa',     4.672345, -74.148567, 5),
('Ruta Retorno A',         'Retorno tarde hacia zona norte',                  '13:00:00', 'Activa',     4.690123, -74.052341, 5),
('Ruta Retorno B',         'Retorno tarde hacia zona sur',                    '13:15:00', 'Activa',     4.481456, -74.113780, 5),
('Ruta Especial Sabados',  'Ruta especial para actividades de fin de semana', '08:00:00', 'Inactiva',   4.629849, -74.064148, 5),
('Ruta Emergencia',        'Ruta alterna en caso de contingencia',            '07:00:00', 'Suspendida', 4.620000, -74.080000, 5),
('Ruta Noroccidente',      'Recorrido desde Engativa hasta el colegio',       '06:55:00', 'Activa',     4.703456, -74.110234, 5);


-- -----------------------------------------------------------------------------
-- 13. User_Route
-- -----------------------------------------------------------------------------
INSERT INTO User_Route (UsuarioID, RutaID) VALUES
(3,  1),
(3,  6),
(6,  2),
(6,  7),
(9,  3),
(9,  4),
(1,  1),
(2,  2),
(4,  3),
(7,  5);


-- -----------------------------------------------------------------------------
-- 14. Parada
-- -----------------------------------------------------------------------------
INSERT INTO Parada (RutaID, NombreParada, Latitud, Longitud, HorarioEstimado, Orden) VALUES
(1, 'Paradero Kennedy Central',  4.629849, -74.064148, '06:30:00', 1),
(1, 'Calle 38 Sur con Av. 68',   4.635210, -74.078234, '06:40:00', 2),
(1, 'Portal Kennedy',            4.645320, -74.089123, '06:48:00', 3),
(2, 'Paradero Usme Centro',      4.481456, -74.113780, '06:45:00', 1),
(2, 'Calle 93 Sur con Cra. 14',  4.512345, -74.105678, '06:55:00', 2),
(2, 'Gran Yomasa',               4.543210, -74.098765, '07:05:00', 3),
(3, 'Paradero Bosa Nova',        4.621123, -74.185320, '07:00:00', 1),
(3, 'Supermanzana 6 Bosa',       4.629456, -74.175432, '07:10:00', 2),
(4, 'Carrera 19 con Calle 19',   4.601234, -74.081234, '06:50:00', 1),
(5, 'Fontibon Cra. 100',         4.672345, -74.148567, '06:40:00', 1);


-- -----------------------------------------------------------------------------
-- 15. Estudiante
-- -----------------------------------------------------------------------------
INSERT INTO Estudiante (UsuarioID, RutaID, NombreEstudiante, GradoEscolar, ContactoEmergencia, EstadoEstudiante, FechaNacimiento) VALUES
(1,  1, 'Sofia Mendoza Garcia',     '4to Primaria',   '3101234567', TRUE,  '2015-05-10'),
(1,  1, 'Tomas Mendoza Garcia',     '6to Primaria',   '3101234567', TRUE,  '2013-09-22'),
(2,  2, 'Valentina Gomez Ruiz',     '2do Primaria',   '3112345678', TRUE,  '2017-03-15'),
(4,  3, 'Samuel Castro Vega',       '8vo Secundaria', '3134567890', TRUE,  '2011-11-08'),
(7,  5, 'Isabella Castro Pena',     '3ro Primaria',   '3156789012', TRUE,  '2016-07-20'),
(8,  1, 'Martin Herrera Lopez',     '5to Primaria',   '3167890123', TRUE,  '2014-01-30'),
(10, 2, 'Luciana Nino Vargas',      '1ro Primaria',   '3189012345', TRUE,  '2018-04-12'),
(1,  1, 'Sebastian Mendoza Garcia', '9no Secundaria', '3101234567', FALSE, '2010-08-05'),
(2,  2, 'Camila Gomez Ruiz',        '7mo Secundaria', '3112345678', TRUE,  '2012-02-18'),
(4,  3, 'Daniela Castro Vega',      '4to Primaria',   '3134567890', TRUE,  '2015-12-25');


-- -----------------------------------------------------------------------------
-- 16. Trayecto
-- -----------------------------------------------------------------------------
INSERT INTO Trayecto (RutaID, EstudianteID, FechaInicio, FechaFin, EstadoTrayecto, DuracionEstimada) VALUES
(1, 1,  '2025-03-01 06:30:00', '2025-03-01 07:45:00', 'Completado',  75),
(2, 3,  '2025-03-01 06:45:00', '2025-03-01 08:00:00', 'Completado',  75),
(3, 4,  '2025-03-01 07:00:00', '2025-03-01 08:10:00', 'Completado',  70),
(1, 2,  '2025-03-02 06:30:00', '2025-03-02 07:50:00', 'Completado',  80),
(2, 7,  '2025-03-02 06:45:00', '2025-03-02 08:05:00', 'Completado',  80),
(5, 5,  '2025-03-02 06:40:00', '2025-03-02 07:55:00', 'Completado',  75),
(1, 6,  '2025-03-03 06:30:00', NULL,                  'En Progreso', 75),
(2, 9,  '2025-03-03 06:45:00', NULL,                  'En Progreso', 75),
(4, 10, '2025-03-03 06:50:00', '2025-03-03 07:40:00', 'Completado',  50),
(3, 4,  '2025-03-03 07:00:00', '2025-03-03 07:55:00', 'Cancelado',   70);


-- -----------------------------------------------------------------------------
-- 17. Coordenadas
-- -----------------------------------------------------------------------------
INSERT INTO Coordenadas (TrayectoID, Latitud, Longitud, FechaHora, Velocidad) VALUES
(1, 4.629849, -74.064148, '2025-03-01 06:30:00',  0.00),
(1, 4.633210, -74.070234, '2025-03-01 06:35:00', 35.50),
(1, 4.638456, -74.078912, '2025-03-01 06:42:00', 42.30),
(1, 4.645789, -74.085634, '2025-03-01 06:50:00', 38.70),
(1, 4.652341, -74.090123, '2025-03-01 07:00:00', 28.90),
(2, 4.481456, -74.113780, '2025-03-01 06:45:00',  0.00),
(2, 4.495678, -74.108345, '2025-03-01 06:52:00', 40.10),
(2, 4.513234, -74.101234, '2025-03-01 07:05:00', 45.60),
(3, 4.621123, -74.185320, '2025-03-01 07:00:00',  0.00),
(3, 4.628456, -74.177890, '2025-03-01 07:08:00', 38.20);


-- -----------------------------------------------------------------------------
-- 18. Notificacion
-- -----------------------------------------------------------------------------
INSERT INTO Notificacion (TrayectoID, ReportadoPor, TipoEvento, Mensaje, FechaHora, EsDesvioRuta, EstadoEnvio) VALUES
(1,  3, 'Llegada',    'El estudiante ha llegado al colegio',                   '2025-03-01 07:45:00', FALSE, 'Enviado'),
(2,  6, 'Retraso',    'La ruta presenta retraso de 10 minutos',                '2025-03-01 07:20:00', FALSE, 'Enviado'),
(3,  9, 'CambioRuta', 'Se ha modificado el recorrido por obras en la via',     '2025-03-01 07:30:00', TRUE,  'Enviado'),
(4,  3, 'Llegada',    'El estudiante ha llegado al colegio',                   '2025-03-02 07:50:00', FALSE, 'Enviado'),
(5,  6, 'Llegada',    'El estudiante ha llegado al colegio',                   '2025-03-02 08:05:00', FALSE, 'Enviado'),
(6,  9, 'Emergencia', 'Alerta: vehiculo detuvo marcha de forma inesperada',    '2025-03-02 07:15:00', FALSE, 'Enviado'),
(7,  3, 'Info',       'Trayecto iniciado, se espera llegada a las 07:45',      '2025-03-03 06:30:00', FALSE, 'Enviado'),
(8,  6, 'Retraso',    'Trafico en via principal, retraso estimado 15 minutos', '2025-03-03 07:10:00', FALSE, 'Pendiente'),
(10, 9, 'CambioRuta', 'Trayecto cancelado por condiciones climaticas',         '2025-03-03 07:05:00', FALSE, 'Enviado'),
(9,  5, 'Info',       'Trayecto completado sin novedades',                     '2025-03-03 07:40:00', FALSE, 'Enviado');


-- -----------------------------------------------------------------------------
-- 19. Notificacion_Recibe
-- -----------------------------------------------------------------------------
INSERT INTO Notificacion_Recibe (NotificacionID, ReceptorID, ReceptorTipo, FechaRecibo, Leida) VALUES
(1,  1,  'Padre', '2025-03-01 07:45:10', TRUE),
(2,  2,  'Padre', '2025-03-01 07:20:05', TRUE),
(3,  4,  'Padre', '2025-03-01 07:30:08', FALSE),
(4,  1,  'Padre', '2025-03-02 07:50:12', TRUE),
(5,  2,  'Padre', '2025-03-02 08:05:15', TRUE),
(6,  5,  'Admin', '2025-03-02 07:15:20', TRUE),
(6,  4,  'Padre', '2025-03-02 07:15:25', FALSE),
(7,  1,  'Padre', '2025-03-03 06:30:10', TRUE),
(8,  2,  'Padre', '2025-03-03 07:10:08', FALSE),
(10, 5,  'Admin', '2025-03-03 07:05:15', TRUE);


-- -----------------------------------------------------------------------------
-- 20. ConfigNotificacion
-- -----------------------------------------------------------------------------
INSERT INTO ConfigNotificacion (UsuarioID, AlertaRetraso, AlertaCambioRuta, AlertaLlegada) VALUES
(1,  TRUE,  TRUE,  TRUE),
(2,  TRUE,  TRUE,  TRUE),
(4,  TRUE,  FALSE, TRUE),
(7,  FALSE, TRUE,  TRUE),
(8,  TRUE,  TRUE,  FALSE),
(10, TRUE,  TRUE,  TRUE),
(3,  FALSE, FALSE, TRUE),
(6,  TRUE,  TRUE,  TRUE),
(9,  TRUE,  FALSE, FALSE),
(5,  TRUE,  TRUE,  TRUE);
