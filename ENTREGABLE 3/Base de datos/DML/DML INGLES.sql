-- =============================================
-- DML - GPS GUARDIAN ESCOLAR v3.3.1
-- Datos de ejemplo para pruebas
-- =============================================

-- =============================================
-- 1. DATOS DE SEGURIDAD (RBAC)
-- =============================================

-- Insertar Roles
INSERT INTO Role (RoleName, Description) VALUES
('ADMIN', 'Administrador del sistema - control total'),
('PARENT', 'Padre de familia - acceso a ubicación de hijos');

-- Insertar Permisos
INSERT INTO Permission (PermissionName, Description) VALUES
('USER_CREATE', 'Crear nuevos usuarios'),
('USER_READ', 'Leer información de usuarios'),
('USER_UPDATE', 'Actualizar usuarios'),
('USER_DELETE', 'Eliminar usuarios'),
('STUDENT_CREATE', 'Registrar nuevos estudiantes'),
('STUDENT_READ', 'Ver información de estudiantes'),
('STUDENT_UPDATE', 'Actualizar estudiantes'),
('STUDENT_DELETE', 'Eliminar estudiantes'),
('ROUTE_CREATE', 'Crear rutas escolares'),
('ROUTE_READ', 'Ver rutas'),
('ROUTE_UPDATE', 'Actualizar rutas'),
('ROUTE_DELETE', 'Eliminar rutas'),
('TRACK_VIEW', 'Ver ubicación en tiempo real'),
('ZONE_CREATE', 'Crear zonas seguras'),
('ZONE_READ', 'Ver zonas seguras'),
('ZONE_UPDATE', 'Actualizar zonas seguras'),
('ZONE_DELETE', 'Eliminar zonas seguras'),
('NOTIFICATION_SEND', 'Enviar notificaciones'),
('REPORT_VIEW', 'Ver reportes y estadísticas'),
('AUDIT_VIEW', 'Ver logs de auditoría');

-- Asignar Permisos a Roles (ADMIN - todos los permisos)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.ID, p.ID FROM Role r, Permission p WHERE r.RoleName = 'ADMIN';

-- Asignar Permisos a Roles (PARENT - permisos limitados)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.ID, p.ID FROM Role r, Permission p 
WHERE r.RoleName = 'PARENT' 
AND p.PermissionName IN (
    'STUDENT_READ', 'TRACK_VIEW', 'ZONE_READ', 'ZONE_CREATE', 
    'ZONE_UPDATE', 'NOTIFICATION_SEND', 'REPORT_VIEW'
);

-- =============================================
-- 2. CONFIGURACIONES GLOBALES
-- =============================================

-- Política de contraseñas
INSERT INTO PasswordPolicy (MinLength, MaxLength, RequireUppercase, RequireNumbers, RequireSymbols, ExpirationDays)
VALUES (10, 128, true, true, true, 90);

-- Configuraciones de seguridad
INSERT INTO SecurityConfiguration (ConfigName, ConfigValue, Description) VALUES
('SESSION_TIMEOUT_MINUTES', '30', 'Tiempo máximo de inactividad de sesión en minutos'),
('MAX_LOGIN_ATTEMPTS', '5', 'Número máximo de intentos de login fallidos'),
('LOCKOUT_DURATION_MINUTES', '15', 'Tiempo de bloqueo tras exceder intentos fallidos'),
('GPS_UPDATE_FREQUENCY_SECONDS', '30', 'Frecuencia de actualización GPS en segundos'),
('INACTIVITY_ALERT_THRESHOLD_MINUTES', '10', 'Tiempo de inactividad para alerta en minutos');

-- =============================================
-- 3. USUARIOS
-- =============================================

-- Nota: Las contraseñas aquí son ejemplos. En producción usar hash reales.
-- Para pruebas, estos hashes corresponden a "Password123!" (ejemplo)

INSERT INTO "User" (ID, FullName, Email, Phone, PasswordHash, IsActive, EmailVerified, CreatedAt) VALUES
('11111111-1111-1111-1111-111111111111', 'Carlos Rodríguez', 'carlos.rodriguez@email.com', '+56912345678', 
 '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.cZH.hJ8hF4vX9s7qXqXqXqXqXq', true, true, NOW()),
('22222222-2222-2222-2222-222222222222', 'Ana Martínez', 'ana.martinez@email.com', '+56987654321', 
 '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.cZH.hJ8hF4vX9s7qXqXqXqXqXq', true, true, NOW()),
('33333333-3333-3333-3333-333333333333', 'Admin Sistema', 'admin@gpsguardian.com', '+56911111111', 
 '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.cZH.hJ8hF4vX9s7qXqXqXqXqXq', true, true, NOW());

-- Asignar Roles a Usuarios
INSERT INTO User_Role (UserID, RoleID) VALUES
('11111111-1111-1111-1111-111111111111', (SELECT ID FROM Role WHERE RoleName = 'PARENT')),
('22222222-2222-2222-2222-222222222222', (SELECT ID FROM Role WHERE RoleName = 'PARENT')),
('33333333-3333-3333-3333-333333333333', (SELECT ID FROM Role WHERE RoleName = 'ADMIN'));

-- =============================================
-- 4. ESTUDIANTES
-- =============================================

INSERT INTO Student (ID, UserID, FullName, SchoolGrade, BirthDate, IsActive) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Mateo Rodríguez Martínez', 'FIFTH', '2014-05-15', true),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'Valentina Rodríguez Martínez', 'SECOND', '2017-08-22', true),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '22222222-2222-2222-2222-222222222222', 'Sofía Martínez López', 'SEVENTH', '2012-03-10', true);

-- =============================================
-- 5. CONTACTOS DE EMERGENCIA
-- =============================================

INSERT INTO EmergencyContact (StudentID, FullName, Phone, Relationship, IsPrimary) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Laura Martínez', '+56922223333', 'Madre', true),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'José Rodríguez', '+56933334444', 'Padre', false),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Miguel López', '+56944445555', 'Padre', true);

-- =============================================
-- 6. RUTAS
-- =============================================

INSERT INTO Route (ID, RouteName, Description, OriginLat, OriginLon, DestinationLat, DestinationLon) VALUES
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Ruta Norte - Mañana', 'Recoge estudiantes zona norte hacia colegio', 
 -33.456940, -70.648270, -33.456940, -70.648270),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ruta Sur - Tarde', 'Regreso zona sur desde colegio', 
 -33.456940, -70.648270, -33.500000, -70.650000),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Ruta Oriente - Mañana', 'Servicio express zona oriente', 
 -33.456940, -70.648270, -33.440000, -70.620000);

-- =============================================
-- 7. ASIGNACIÓN ESTUDIANTES A RUTAS
-- =============================================

INSERT INTO Student_Route (StudentID, RouteID, IsActive) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'dddddddd-dddd-dddd-dddd-dddddddddddd', true),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', true),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'dddddddd-dddd-dddd-dddd-dddddddddddd', true),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'ffffffff-ffff-ffff-ffff-ffffffffffff', true);

-- =============================================
-- 8. PARADAS
-- =============================================

INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
('dddddddd-dddd-dddd-dddd-dddddddddddd', 1, 'Parada Los Pinos', -33.460000, -70.650000),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 2, 'Parada El Golf', -33.455000, -70.648000),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 3, 'Parada Centro', -33.450000, -70.647000),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 1, 'Colegio (Salida)', -33.456940, -70.648270),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 2, 'Parada Plaza Sur', -33.470000, -70.649000),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 3, 'Parada Los Presidentes', -33.490000, -70.650000);

-- =============================================
-- 9. ZONAS SEGURAS
-- =============================================

INSERT INTO SafeZone (StudentID, ZoneName, Latitude, Longitude, RadiusMeters, InactivityThresholdSeconds) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Casa Familiar', -33.460000, -70.650000, 100, 600),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Colegio', -33.456940, -70.648270, 50, 300),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Casa Abuelos', -33.455000, -70.655000, 80, 600),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Casa Sofía', -33.470000, -70.640000, 100, 600);

-- =============================================
-- 10. CONFIGURACIÓN DE NOTIFICACIONES POR USUARIO
-- =============================================

INSERT INTO NotificationConfig (UserID, DelayAlert, RouteChangeAlert, ArrivalAlert, InactivityAlert) VALUES
('11111111-1111-1111-1111-111111111111', true, true, true, true),
('22222222-2222-2222-2222-222222222222', true, false, true, true),
('33333333-3333-3333-3333-333333333333', false, true, true, false);

-- =============================================
-- 11. VIAJES DE EJEMPLO
-- =============================================

INSERT INTO Trip (ID, StudentID, RouteID, StartDateTime, Status, HasDetour) VALUES
('gggggggg-gggg-gggg-gggg-gggggggggggg', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 
 NOW() - INTERVAL '2 hours', 'COMPLETED', false),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 
 NOW() - INTERVAL '1 hour', 'IN_PROGRESS', false),
('iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 
 NOW() - INTERVAL '30 minutes', 'PENDING', false);

-- =============================================
-- 12. COORDENADAS (Historial de ubicaciones)
-- =============================================

INSERT INTO Coordinate (TripID, Latitude, Longitude, RecordedAt, SpeedKmh) VALUES
('gggggggg-gggg-gggg-gggg-gggggggggggg', -33.460000, -70.650000, NOW() - INTERVAL '2 hours', 0),
('gggggggg-gggg-gggg-gggg-gggggggggggg', -33.458000, -70.649000, NOW() - INTERVAL '1 hour 55 minutes', 30),
('gggggggg-gggg-gggg-gggg-gggggggggggg', -33.456940, -70.648270, NOW() - INTERVAL '1 hour 50 minutes', 0),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', -33.456940, -70.648270, NOW() - INTERVAL '55 minutes', 0),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', -33.460000, -70.649000, NOW() - INTERVAL '45 minutes', 25),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', -33.470000, -70.649000, NOW() - INTERVAL '35 minutes', 28);

-- =============================================
-- 13. NOTIFICACIONES
-- =============================================

INSERT INTO Notification (TripID, EventType, Message, IsSent) VALUES
('gggggggg-gggg-gggg-gggg-gggggggggggg', 'TRIP_START', 'Viaje iniciado - Mateo está en camino al colegio', true),
('gggggggg-gggg-gggg-gggg-gggggggggggg', 'ARRIVAL', 'Mateo ha llegado al colegio', true),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', 'DELAY', 'Ruta con retraso de 10 minutos - Valentina viene en camino', true),
(NULL, 'ZONE_ALERT', 'Sofía ha salido de la zona segura (Casa)', false);

-- =============================================
-- 14. RECIBOS DE NOTIFICACIONES
-- =============================================

INSERT INTO NotificationReceipt (NotificationID, UserID, IsRead, ReceivedAt) 
SELECT n.ID, u.ID, false, NOW()
FROM Notification n, "User" u
WHERE u.Email IN ('carlos.rodriguez@email.com', 'ana.martinez@email.com')
LIMIT 5;

-- =============================================
-- 15. SESIONES DE USUARIO
-- =============================================

INSERT INTO UserSession (UserID, Token, OriginIp, SessionStatus) VALUES
('11111111-1111-1111-1111-111111111111', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...', '192.168.1.100', 'ACTIVE'),
('33333333-3333-3333-3333-333333333333', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...', '10.0.0.1', 'ACTIVE');

-- =============================================
-- 16. LOGS DE EJEMPLO
-- =============================================

INSERT INTO ActivityLog (UserID, ActionType, Description, OriginIp, Metadata) VALUES
('11111111-1111-1111-1111-111111111111', 'LOGIN', 'Usuario inició sesión', '192.168.1.100', '{"browser": "Chrome", "os": "Windows"}'::jsonb),
('11111111-1111-1111-1111-111111111111', 'VIEW_TRACKING', 'Visualizó ubicación de Mateo', '192.168.1.100', '{"student": "Mateo Rodríguez"}'::jsonb),
('33333333-3333-3333-3333-333333333333', 'CREATE_ROUTE', 'Administrador creó nueva ruta', '10.0.0.1', '{"route": "Ruta Norte"}'::jsonb);

INSERT INTO AuditLog (UserID, Action, Description, OriginIp, Metadata) VALUES
('33333333-3333-3333-3333-333333333333', 'ROLE_ASSIGNMENT', 'Asignó rol PARENT a usuario', '10.0.0.1', '{"target_user": "ana.martinez@email.com"}'::jsonb),
(NULL, 'FAILED_LOGIN', 'Intento de login fallido - contraseña incorrecta', '192.168.1.200', '{"email": "invalido@email.com"}'::jsonb);

-- =============================================
-- FIN DML ESPAÑOL
-- =============================================