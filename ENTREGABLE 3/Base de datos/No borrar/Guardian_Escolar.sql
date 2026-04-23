CREATE TABLE Usuario (
    UsuarioID SERIAL PRIMARY KEY,
    NombreCompleto VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL,
    TipoUsuario VARCHAR(20) DEFAULT 'PADRE' CHECK (TipoUsuario IN ('ADMIN', 'PADRE')),
    Estado BOOLEAN DEFAULT true,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UltimoAcceso TIMESTAMP,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Estudiante (
    EstudianteID SERIAL PRIMARY KEY,
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE RESTRICT,
    NombreCompleto VARCHAR(255) NOT NULL,
    GradoEscolar VARCHAR(50),
    FechaNacimiento DATE,
    ContactoEmergencia VARCHAR(100),
    Estado BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Ruta (
    RutaID SERIAL PRIMARY KEY,
    NombreRuta VARCHAR(255) NOT NULL,
    Descripcion TEXT,
    OrigenLat DECIMAL(10,8),
    OrigenLon DECIMAL(11,8),
    DestinoLat DECIMAL(10,8),
    DestinoLon DECIMAL(11,8),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Parada (
    ParadaID SERIAL PRIMARY KEY,
    RutaID INTEGER NOT NULL REFERENCES Ruta(RutaID) ON DELETE CASCADE,
    Orden INTEGER NOT NULL,
    NombreParada VARCHAR(100),
    Latitud DECIMAL(10,8) NOT NULL,
    Longitud DECIMAL(11,8) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ZonaSegura (
    ZonaID SERIAL PRIMARY KEY,
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    EstudianteID INTEGER NOT NULL REFERENCES Estudiante(EstudianteID) ON DELETE CASCADE,
    NombreZona VARCHAR(100) NOT NULL,
    Latitud DECIMAL(10,8) NOT NULL,
    Longitud DECIMAL(11,8) NOT NULL,
    RadioMetros INTEGER NOT NULL CHECK (RadioMetros > 0),
    Activa BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE ConfigNotificacion (
    ConfigID SERIAL PRIMARY KEY,
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    AlertaRetraso BOOLEAN DEFAULT true,
    AlertaCambioRuta BOOLEAN DEFAULT true,
    AlertaLlegada BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Trayecto (
    TrayectoID SERIAL PRIMARY KEY,
    EstudianteID INTEGER NOT NULL REFERENCES Estudiante(EstudianteID) ON DELETE CASCADE,
    RutaID INTEGER NOT NULL REFERENCES Ruta(RutaID) ON DELETE RESTRICT,
    FechaHoraInicio TIMESTAMP NOT NULL,
    FechaHoraFin TIMESTAMP,
    Estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (Estado IN ('PENDIENTE','EN_CURSO','FINALIZADO','CANCELADO')),
    HayDesvio BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Coordenada (
    CoordID SERIAL PRIMARY KEY,
    TrayectoID INTEGER NOT NULL REFERENCES Trayecto(TrayectoID) ON DELETE CASCADE,
    Latitud DECIMAL(10,8) NOT NULL,
    Longitud DECIMAL(11,8) NOT NULL,
    FechaHora TIMESTAMP NOT NULL,
    Velocidad DECIMAL(5,2),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Notificacion (
    NotificacionID SERIAL PRIMARY KEY,
    TrayectoID INTEGER REFERENCES Trayecto(TrayectoID) ON DELETE SET NULL,
    ZonaID INTEGER REFERENCES ZonaSegura(ZonaID) ON DELETE SET NULL,
    TipoEvento VARCHAR(50) NOT NULL,
    Mensaje TEXT NOT NULL,
    FechaHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EstadoEnvio BOOLEAN DEFAULT false
);

-- =============================================
-- 2. TABLAS DE RELACIÓN
-- =============================================

CREATE TABLE User_Ruta (
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    RutaID INTEGER NOT NULL REFERENCES Ruta(RutaID) ON DELETE CASCADE,
    PRIMARY KEY (UsuarioID, RutaID),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ReciboNotificacion (
    ReciboID SERIAL PRIMARY KEY,
    NotificacionID INTEGER NOT NULL REFERENCES Notificacion(NotificacionID) ON DELETE CASCADE,
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    Leida BOOLEAN DEFAULT false,
    FechaRecibo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FechaLeida TIMESTAMP,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 3. SEGURIDAD
-- =============================================

CREATE TABLE Role (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(20) UNIQUE NOT NULL CHECK (RoleName IN ('ADMIN', 'PADRE')),
    Description VARCHAR(255),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Permission (
    PermissionID SERIAL PRIMARY KEY,
    PermissionName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE User_Role (
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    RoleID INTEGER NOT NULL REFERENCES Role(RoleID) ON DELETE CASCADE,
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UsuarioID, RoleID)
);

CREATE TABLE Role_Permission (
    RoleID INTEGER NOT NULL REFERENCES Role(RoleID) ON DELETE CASCADE,
    PermissionID INTEGER NOT NULL REFERENCES Permission(PermissionID) ON DELETE CASCADE,
    PRIMARY KEY (RoleID, PermissionID)
);

CREATE TABLE User_Session (
    SessionID SERIAL PRIMARY KEY,
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    Token VARCHAR(500) NOT NULL,
    StartedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndedAt TIMESTAMP,
    OriginIp INET,
    SessionStatus VARCHAR(20) DEFAULT 'ACTIVE' CHECK (SessionStatus IN ('ACTIVE', 'EXPIRED', 'LOGOUT')),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 4. TABLAS GLOBALES Y LOGS
-- =============================================

CREATE TABLE Password_Policy (
    PolicyID SERIAL PRIMARY KEY,
    MinLength INT DEFAULT 10,
    MaxLength INT DEFAULT 128,
    RequireUppercase BOOLEAN DEFAULT true,
    RequireNumbers BOOLEAN DEFAULT true,
    RequireSymbols BOOLEAN DEFAULT true,
    ExpirationDays INT DEFAULT 90,
    
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Security_Configuration (
    ConfigurationID SERIAL PRIMARY KEY,
    ConfigurationName VARCHAR(100) UNIQUE NOT NULL,
    ConfigurationValue TEXT,
    Description TEXT,
    
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Activity_Log (
    LogID BIGSERIAL PRIMARY KEY,
    UsuarioID INTEGER REFERENCES Usuario(UsuarioID),
    ActionType VARCHAR(50) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Audit (
    AuditID BIGSERIAL PRIMARY KEY,
    UsuarioID INTEGER REFERENCES Usuario(UsuarioID),
    Action VARCHAR(255) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Application VARCHAR(100) DEFAULT 'GPS_Guardian',
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Error_Log (
    ErrorID BIGSERIAL PRIMARY KEY,
    UsuarioID INTEGER REFERENCES Usuario(UsuarioID),
    ErrorType VARCHAR(100) NOT NULL,
    Description TEXT,
    StackTrace TEXT,
    OriginIp INET,
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 5. ÍNDICES RECOMENDADOS
-- =============================================

-- Usuario
CREATE INDEX idx_usuario_email ON Usuario(Email);
CREATE INDEX idx_usuario_tipo ON Usuario(TipoUsuario);
CREATE INDEX idx_usuario_estado ON Usuario(Estado);

-- Estudiante
CREATE INDEX idx_estudiante_usuario ON Estudiante(UsuarioID);
CREATE INDEX idx_estudiante_estado ON Estudiante(Estado);

-- ZonaSegura
CREATE INDEX idx_zonasegura_estudiante ON ZonaSegura(EstudianteID);
CREATE INDEX idx_zonasegura_usuario ON ZonaSegura(UsuarioID);
CREATE INDEX idx_zonasegura_activa ON ZonaSegura(Activa);

-- Trayecto
CREATE INDEX idx_trayecto_estudiante ON Trayecto(EstudianteID);
CREATE INDEX idx_trayecto_estado ON Trayecto(Estado);
CREATE INDEX idx_trayecto_fecha_inicio ON Trayecto(FechaHoraInicio);

-- Coordenada
CREATE INDEX idx_coordenada_trayecto ON Coordenada(TrayectoID);
CREATE INDEX idx_coordenada_fecha ON Coordenada(FechaHora);

-- Notificacion
CREATE INDEX idx_notificacion_trayecto ON Notificacion(TrayectoID);
CREATE INDEX idx_notificacion_zona ON Notificacion(ZonaID);
CREATE INDEX idx_notificacion_fecha ON Notificacion(FechaHora);
CREATE INDEX idx_notificacion_tipo ON Notificacion(TipoEvento);

-- ReciboNotificacion
CREATE INDEX idx_recibo_usuario ON ReciboNotificacion(UsuarioID);
CREATE INDEX idx_recibo_notificacion ON ReciboNotificacion(NotificacionID);
CREATE INDEX idx_recibo_leida ON ReciboNotificacion(Leida);

-- Parada
CREATE INDEX idx_parada_ruta ON Parada(RutaID);
CREATE INDEX idx_parada_orden ON Parada(RutaID, Orden);

-- ConfigNotificacion
CREATE INDEX idx_config_notif_usuario ON ConfigNotificacion(UsuarioID);

-- Seguridad
CREATE INDEX idx_user_role_user ON User_Role(UsuarioID);
CREATE INDEX idx_user_role_role ON User_Role(RoleID);
CREATE INDEX idx_role_permission_role ON Role_Permission(RoleID);
CREATE INDEX idx_user_session_user ON User_Session(UsuarioID);
CREATE INDEX idx_user_session_status ON User_Session(SessionStatus);

-- Logs
CREATE INDEX idx_activity_log_user ON Activity_Log(UsuarioID);
CREATE INDEX idx_activity_log_date ON Activity_Log(created_at);
CREATE INDEX idx_activity_log_type ON Activity_Log(ActionType);
CREATE INDEX idx_audit_user ON Audit(UsuarioID);
CREATE INDEX idx_audit_date ON Audit(created_at);
CREATE INDEX idx_error_log_user ON Error_Log(UsuarioID);
CREATE INDEX idx_error_log_date ON Error_Log(created_at);

-- =============================================
-- 6. COMENTARIOS DE TABLAS (DOCUMENTACIÓN)
-- =============================================

COMMENT ON TABLE Usuario IS 'Usuarios del sistema (padres y administradores)';
COMMENT ON TABLE Estudiante IS 'Estudiantes asociados a un padre de familia';
COMMENT ON TABLE Ruta IS 'Rutas creadas por los padres para sus estudiantes';
COMMENT ON TABLE Parada IS 'Paradas que componen una ruta';
COMMENT ON TABLE ZonaSegura IS 'Zonas de confianza registradas por el padre para un estudiante';
COMMENT ON TABLE ConfigNotificacion IS 'Configuración de notificaciones por usuario';
COMMENT ON TABLE Trayecto IS 'Trayectos realizados por un estudiante siguiendo una ruta';
COMMENT ON TABLE Coordenada IS 'Registro de coordenadas GPS durante un trayecto';
COMMENT ON TABLE Notificacion IS 'Notificaciones generadas durante un trayecto o al llegar a zona segura';
COMMENT ON TABLE ReciboNotificacion IS 'Registro de recepción y lectura de notificaciones por usuario';
COMMENT ON TABLE User_Ruta IS 'Relación entre usuarios (padres) y las rutas que han creado';
COMMENT ON TABLE Role IS 'Roles del sistema (ADMIN, PADRE)';
COMMENT ON TABLE Permission IS 'Permisos asignables a roles';
COMMENT ON TABLE User_Role IS 'Asignación de roles a usuarios';
COMMENT ON TABLE Role_Permission IS 'Asignación de permisos a roles';
COMMENT ON TABLE User_Session IS 'Sesiones activas de usuarios';
COMMENT ON TABLE Password_Policy IS 'Políticas de contraseña del sistema';
COMMENT ON TABLE Security_Configuration IS 'Configuraciones de seguridad del sistema';
COMMENT ON TABLE Activity_Log IS 'Registro de actividades de usuarios';
COMMENT ON TABLE Audit IS 'Auditoría de acciones del sistema';
COMMENT ON TABLE Error_Log IS 'Registro de errores del sistema';

-- =============================================
-- FIN DEL SCRIPT
-- =============================================




/*
TRUNCATE TABLE ReciboNotificacion CASCADE;
TRUNCATE TABLE Coordenada CASCADE;
TRUNCATE TABLE Notificacion CASCADE;
TRUNCATE TABLE Trayecto CASCADE;
TRUNCATE TABLE Parada CASCADE;
TRUNCATE TABLE ZonaSegura CASCADE;
TRUNCATE TABLE User_Ruta CASCADE;
TRUNCATE TABLE ConfigNotificacion CASCADE;
TRUNCATE TABLE Estudiante CASCADE;
TRUNCATE TABLE Ruta CASCADE;
TRUNCATE TABLE User_Session CASCADE;
TRUNCATE TABLE User_Role CASCADE;
TRUNCATE TABLE Role_Permission CASCADE;
TRUNCATE TABLE Activity_Log CASCADE;
TRUNCATE TABLE Audit CASCADE;
TRUNCATE TABLE Error_Log CASCADE;
TRUNCATE TABLE Usuario CASCADE;
TRUNCATE TABLE Role CASCADE;
TRUNCATE TABLE Permission CASCADE;
*/

-- =============================================
-- 2. INSERCIÓN DE DATOS MAESTROS (SEGURIDAD)
-- =============================================

-- Roles
INSERT INTO Role (RoleName, Description) VALUES 
    ('ADMIN', 'Administrador del sistema con acceso total'),
    ('PADRE', 'Padre de familia que monitorea a sus hijos');

-- Permisos
INSERT INTO Permission (PermissionName, Description) VALUES 
    ('CREATE_USER', 'Crear nuevos usuarios'),
    ('EDIT_USER', 'Editar usuarios existentes'),
    ('DELETE_USER', 'Eliminar usuarios'),
    ('VIEW_ALL_STUDENTS', 'Ver todos los estudiantes del sistema'),
    ('VIEW_OWN_STUDENTS', 'Ver solo sus propios estudiantes'),
    ('CREATE_ROUTE', 'Crear rutas'),
    ('EDIT_ROUTE', 'Editar rutas'),
    ('DELETE_ROUTE', 'Eliminar rutas'),
    ('CREATE_ZONE', 'Crear zonas seguras'),
    ('EDIT_ZONE', 'Editar zonas seguras'),
    ('DELETE_ZONE', 'Eliminar zonas seguras'),
    ('VIEW_REPORTS', 'Ver reportes del sistema'),
    ('MANAGE_SYSTEM', 'Gestionar configuración del sistema'),
    ('VIEW_LOGS', 'Ver logs del sistema');

-- Asignar permisos a roles (ADMIN tiene todos)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM Role r, Permission p
WHERE r.RoleName = 'ADMIN';

-- Asignar permisos a roles (PADRE tiene permisos limitados)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM Role r, Permission p
WHERE r.RoleName = 'PADRE' 
  AND p.PermissionName IN ('VIEW_OWN_STUDENTS', 'CREATE_ROUTE', 'EDIT_ROUTE', 'CREATE_ZONE', 'EDIT_ZONE', 'DELETE_ZONE');

-- =============================================
-- 3. INSERCIÓN DE USUARIOS
-- =============================================

-- Contraseñas en texto plano para referencia: 'Password123!'
-- Hash generado con BCrypt (ejemplo)

-- Administradores
INSERT INTO Usuario (NombreCompleto, Email, Telefono, PasswordHash, TipoUsuario, Estado, FechaCreacion) VALUES 
    ('Admin Principal', 'admin@gpsguardian.com', '3001234567', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'ADMIN', true, NOW());

-- Padres de familia
INSERT INTO Usuario (NombreCompleto, Email, Telefono, PasswordHash, TipoUsuario, Estado, FechaCreacion) VALUES 
    ('Carlos Rodríguez', 'carlos.rodriguez@email.com', '3112345678', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PADRE', true, NOW()),
    ('María González', 'maria.gonzalez@email.com', '3223456789', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PADRE', true, NOW()),
    ('Jorge Martínez', 'jorge.martinez@email.com', '3334567890', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PADRE', true, NOW()),
    ('Laura Fernández', 'laura.fernandez@email.com', '3445678901', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PADRE', true, NOW());

-- Asignar roles a usuarios
INSERT INTO User_Role (UsuarioID, RoleID)
SELECT u.UsuarioID, r.RoleID
FROM Usuario u, Role r
WHERE u.TipoUsuario = r.RoleName;

-- =============================================
-- 4. INSERCIÓN DE ESTUDIANTES
-- =============================================

-- Estudiantes de Carlos Rodríguez (UsuarioID = 2)
INSERT INTO Estudiante (UsuarioID, NombreCompleto, GradoEscolar, FechaNacimiento, ContactoEmergencia, Estado) VALUES 
    (2, 'Sofía Rodríguez Pérez', '5° Primaria', '2014-03-15', '3112345678 - Carlos', true),
    (2, 'Mateo Rodríguez Pérez', '2° Primaria', '2016-07-22', '3112345678 - Carlos', true);

-- Estudiantes de María González (UsuarioID = 3)
INSERT INTO Estudiante (UsuarioID, NombreCompleto, GradoEscolar, FechaNacimiento, ContactoEmergencia, Estado) VALUES 
    (3, 'Valentina González López', '8° Secundaria', '2011-11-30', '3223456789 - María', true),
    (3, 'Samuel González López', '4° Primaria', '2015-01-18', '3223456789 - María', true);

-- Estudiantes de Jorge Martínez (UsuarioID = 4)
INSERT INTO Estudiante (UsuarioID, NombreCompleto, GradoEscolar, FechaNacimiento, ContactoEmergencia, Estado) VALUES 
    (4, 'Isabella Martínez Rojas', '11° Secundaria', '2008-05-10', '3334567890 - Jorge', true);

-- Estudiantes de Laura Fernández (UsuarioID = 5)
INSERT INTO Estudiante (UsuarioID, NombreCompleto, GradoEscolar, FechaNacimiento, ContactoEmergencia, Estado) VALUES 
    (5, 'Lucas Fernández Torres', '1° Primaria', '2017-09-05', '3445678901 - Laura', true),
    (5, 'Emma Fernández Torres', 'Pre-Jardín', '2019-12-12', '3445678901 - Laura', true);

-- =============================================
-- 5. INSERCIÓN DE RUTAS
-- =============================================

-- Rutas creadas por Carlos Rodríguez (UsuarioID = 2)
INSERT INTO Ruta (NombreRuta, Descripcion, OrigenLat, OrigenLon, DestinoLat, DestinoLon, created_by) VALUES 
    ('Ruta Colegio San José - Casa', 'Recorrido desde el colegio San José hasta la casa', 4.7110, -74.0721, 4.6980, -74.0850, 2),
    ('Ruta Casa - Clase de Música', 'Recorrido hasta la academia de música', 4.6980, -74.0850, 4.7150, -74.0650, 2);

-- Rutas creadas por María González (UsuarioID = 3)
INSERT INTO Ruta (NombreRuta, Descripcion, OrigenLat, OrigenLon, DestinoLat, DestinoLon, created_by) VALUES 
    ('Ruta Colegio La Esperanza - Casa', 'Trayecto diario del colegio a casa', 4.6350, -74.0820, 4.6500, -74.0980, 3);

-- Rutas creadas por Jorge Martínez (UsuarioID = 4)
INSERT INTO Ruta (NombreRuta, Descripcion, OrigenLat, OrigenLon, DestinoLat, DestinoLon, created_by) VALUES 
    ('Ruta Colegio San Carlos - Casa', 'Recorrido desde el colegio San Carlos', 4.6800, -74.0600, 4.6950, -74.0750, 4);

-- Rutas creadas por Laura Fernández (UsuarioID = 5)
INSERT INTO Ruta (NombreRuta, Descripcion, OrigenLat, OrigenLon, DestinoLat, DestinoLon, created_by) VALUES 
    ('Ruta Jardín Infantil - Casa', 'Recorrido del jardín a casa', 4.7200, -74.0800, 4.7080, -74.0900, 5);

-- Asignar rutas a usuarios (relación User_Ruta)
INSERT INTO User_Ruta (UsuarioID, RutaID) VALUES
    (2, 1), (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- =============================================
-- 6. INSERCIÓN DE PARADAS
-- =============================================

-- Paradas para Ruta 1 (Colegio San José - Casa)
INSERT INTO Parada (RutaID, Orden, NombreParada, Latitud, Longitud) VALUES
    (1, 1, 'Colegio San José', 4.7110, -74.0721),
    (1, 2, 'Parque Principal', 4.7050, -74.0780),
    (1, 3, 'Casa Carlos', 4.6980, -74.0850);

-- Paradas para Ruta 2 (Casa - Clase de Música)
INSERT INTO Parada (RutaID, Orden, NombreParada, Latitud, Longitud) VALUES
    (2, 1, 'Casa Carlos', 4.6980, -74.0850),
    (2, 2, 'Academia Música', 4.7150, -74.0650);

-- Paradas para Ruta 3 (Colegio La Esperanza - Casa)
INSERT INTO Parada (RutaID, Orden, NombreParada, Latitud, Longitud) VALUES
    (3, 1, 'Colegio La Esperanza', 4.6350, -74.0820),
    (3, 2, 'Biblioteca Pública', 4.6400, -74.0880),
    (3, 3, 'Casa María', 4.6500, -74.0980);

-- Paradas para Ruta 4 (Colegio San Carlos - Casa)
INSERT INTO Parada (RutaID, Orden, NombreParada, Latitud, Longitud) VALUES
    (4, 1, 'Colegio San Carlos', 4.6800, -74.0600),
    (4, 2, 'Centro Comercial', 4.6880, -74.0680),
    (4, 3, 'Casa Jorge', 4.6950, -74.0750);

-- Paradas para Ruta 5 (Jardín Infantil - Casa)
INSERT INTO Parada (RutaID, Orden, NombreParada, Latitud, Longitud) VALUES
    (5, 1, 'Jardín Infantil', 4.7200, -74.0800),
    (5, 2, 'Panadería La Esquina', 4.7140, -74.0850),
    (5, 3, 'Casa Laura', 4.7080, -74.0900);

-- =============================================
-- 7. INSERCIÓN DE ZONAS SEGURAS
-- =============================================

-- Zonas seguras para estudiantes de Carlos
INSERT INTO ZonaSegura (UsuarioID, EstudianteID, NombreZona, Latitud, Longitud, RadioMetros, Activa) VALUES
    (2, 1, 'Casa Sofía', 4.6980, -74.0850, 50, true),
    (2, 1, 'Colegio San José', 4.7110, -74.0721, 100, true),
    (2, 2, 'Casa Mateo', 4.6980, -74.0850, 50, true),
    (2, 2, 'Academia Música', 4.7150, -74.0650, 80, true);

-- Zonas seguras para estudiantes de María
INSERT INTO ZonaSegura (UsuarioID, EstudianteID, NombreZona, Latitud, Longitud, RadioMetros, Activa) VALUES
    (3, 3, 'Casa Valentina', 4.6500, -74.0980, 50, true),
    (3, 3, 'Colegio La Esperanza', 4.6350, -74.0820, 100, true),
    (3, 4, 'Casa Samuel', 4.6500, -74.0980, 50, true);

-- Zonas seguras para estudiantes de Jorge
INSERT INTO ZonaSegura (UsuarioID, EstudianteID, NombreZona, Latitud, Longitud, RadioMetros, Activa) VALUES
    (4, 5, 'Casa Isabella', 4.6950, -74.0750, 50, true),
    (4, 5, 'Colegio San Carlos', 4.6800, -74.0600, 100, true);

-- Zonas seguras para estudiantes de Laura
INSERT INTO ZonaSegura (UsuarioID, EstudianteID, NombreZona, Latitud, Longitud, RadioMetros, Activa) VALUES
    (5, 6, 'Casa Lucas', 4.7080, -74.0900, 50, true),
    (5, 7, 'Casa Emma', 4.7080, -74.0900, 50, true),
    (5, 6, 'Jardín Infantil', 4.7200, -74.0800, 80, true),
    (5, 7, 'Jardín Infantil', 4.7200, -74.0800, 80, true);

-- =============================================
-- 8. INSERCIÓN DE CONFIGURACIÓN DE NOTIFICACIONES
-- =============================================

INSERT INTO ConfigNotificacion (UsuarioID, AlertaRetraso, AlertaCambioRuta, AlertaLlegada) VALUES
    (1, true, true, true),   -- Admin
    (2, true, true, true),   -- Carlos
    (3, true, false, true),  -- María (no quiere alertas de cambio de ruta)
    (4, true, true, false),  -- Jorge (no quiere alertas de llegada)
    (5, false, true, true);  -- Laura (no quiere alertas de retraso)

-- =============================================
-- 9. INSERCIÓN DE TRAYECTOS
-- =============================================

-- Trayectos completados
INSERT INTO Trayecto (EstudianteID, RutaID, FechaHoraInicio, FechaHoraFin, Estado, HayDesvio, created_by) VALUES
    (1, 1, '2026-04-01 07:00:00', '2026-04-01 07:45:00', 'FINALIZADO', false, 2),
    (1, 1, '2026-04-02 07:00:00', '2026-04-02 07:50:00', 'FINALIZADO', true, 2),
    (2, 2, '2026-04-01 15:30:00', '2026-04-01 16:00:00', 'FINALIZADO', false, 2),
    (3, 3, '2026-04-01 06:45:00', '2026-04-01 07:30:00', 'FINALIZADO', false, 3),
    (3, 3, '2026-04-02 06:45:00', '2026-04-02 07:35:00', 'FINALIZADO', true, 3),
    (5, 4, '2026-04-01 07:15:00', '2026-04-01 07:55:00', 'FINALIZADO', false, 4),
    (6, 5, '2026-04-01 08:00:00', '2026-04-01 08:30:00', 'FINALIZADO', false, 5);

-- Trayectos en curso
INSERT INTO Trayecto (EstudianteID, RutaID, FechaHoraInicio, Estado, HayDesvio, created_by) VALUES
    (1, 1, NOW(), 'EN_CURSO', false, 2),
    (3, 3, NOW(), 'EN_CURSO', false, 3),
    (6, 5, NOW(), 'EN_CURSO', false, 5);

-- =============================================
-- 10. INSERCIÓN DE COORDENADAS (simulando un trayecto)
-- =============================================

-- Coordenadas para TrayectoID 1 (Sofía, ruta colegio-casa, 2026-04-01)
INSERT INTO Coordenada (TrayectoID, Latitud, Longitud, FechaHora, Velocidad) VALUES
    (1, 4.7110, -74.0721, '2026-04-01 07:00:00', 0),
    (1, 4.7100, -74.0730, '2026-04-01 07:05:00', 25.5),
    (1, 4.7080, -74.0750, '2026-04-01 07:10:00', 30.2),
    (1, 4.7050, -74.0780, '2026-04-01 07:15:00', 0),
    (1, 4.7040, -74.0790, '2026-04-01 07:20:00', 28.5),
    (1, 4.7010, -74.0820, '2026-04-01 07:30:00', 32.0),
    (1, 4.6980, -74.0850, '2026-04-01 07:45:00', 0);

-- Coordenadas para TrayectoID 4 (Valentina, ruta colegio-casa, 2026-04-01)
INSERT INTO Coordenada (TrayectoID, Latitud, Longitud, FechaHora, Velocidad) VALUES
    (4, 4.6350, -74.0820, '2026-04-01 06:45:00', 0),
    (4, 4.6370, -74.0840, '2026-04-01 06:52:00', 28.0),
    (4, 4.6400, -74.0880, '2026-04-01 07:00:00', 0),
    (4, 4.6430, -74.0910, '2026-04-01 07:10:00', 26.5),
    (4, 4.6470, -74.0950, '2026-04-01 07:20:00', 30.0),
    (4, 4.6500, -74.0980, '2026-04-01 07:30:00', 0);

-- =============================================
-- 11. INSERCIÓN DE NOTIFICACIONES
-- =============================================

-- Notificaciones para trayectos
INSERT INTO Notificacion (TrayectoID, TipoEvento, Mensaje, FechaHora, EstadoEnvio) VALUES
    (1, 'LLEGADA_DESTINO', 'Sofía ha llegado a su destino (Casa)', '2026-04-01 07:45:00', true),
    (2, 'DESVIO_RUTA', 'Mateo se ha desviado de la ruta programada', '2026-04-02 07:30:00', true),
    (4, 'RETRASO', 'Valentina tiene un retraso de 10 minutos', '2026-04-01 07:15:00', true),
    (5, 'DESVIO_RUTA', 'Valentina se ha desviado de la ruta', '2026-04-02 07:20:00', true),
    (6, 'LLEGADA_DESTINO', 'Isabella ha llegado a su destino', '2026-04-01 07:55:00', true),
    (7, 'LLEGADA_ZONA_SEGURA', 'Lucas ha llegado al Jardín Infantil', '2026-04-01 08:30:00', true);

-- Notificaciones por llegada a zona segura (relacionadas con ZonaSegura)
INSERT INTO Notificacion (ZonaID, TipoEvento, Mensaje, FechaHora, EstadoEnvio) VALUES
    (1, 'LLEGADA_ZONA_SEGURA', 'Sofía ha llegado a Zona Segura: Casa Sofía', '2026-04-01 07:45:00', true),
    (2, 'LLEGADA_ZONA_SEGURA', 'Sofía ha llegado a Zona Segura: Colegio San José', '2026-04-01 06:55:00', true),
    (5, 'LLEGADA_ZONA_SEGURA', 'Valentina ha llegado a Zona Segura: Casa Valentina', '2026-04-01 07:30:00', true),
    (8, 'LLEGADA_ZONA_SEGURA', 'Isabella ha llegado a Zona Segura: Casa Isabella', '2026-04-01 07:55:00', true),
    (10, 'LLEGADA_ZONA_SEGURA', 'Lucas ha llegado a Zona Segura: Jardín Infantil', '2026-04-01 08:30:00', true);

-- =============================================
-- 12. INSERCIÓN DE RECIBOS DE NOTIFICACIONES
-- =============================================

INSERT INTO ReciboNotificacion (NotificacionID, UsuarioID, Leida, FechaRecibo, FechaLeida) VALUES
    (1, 2, true, '2026-04-01 07:45:05', '2026-04-01 07:46:00'),
    (2, 2, true, '2026-04-02 07:30:05', '2026-04-02 07:32:00'),
    (3, 3, true, '2026-04-01 07:15:10', '2026-04-01 07:16:00'),
    (4, 3, false, '2026-04-02 07:20:08', NULL),
    (5, 4, true, '2026-04-01 07:55:03', '2026-04-01 07:57:00'),
    (6, 5, true, '2026-04-01 08:30:02', '2026-04-01 08:31:00'),
    (7, 2, true, '2026-04-01 07:45:05', '2026-04-01 07:46:00'),
    (9, 3, true, '2026-04-01 07:30:10', '2026-04-01 07:31:00');

-- =============================================
-- 13. INSERCIÓN DE CONFIGURACIONES DE SEGURIDAD
-- =============================================

INSERT INTO Password_Policy (MinLength, MaxLength, RequireUppercase, RequireNumbers, RequireSymbols, ExpirationDays, updated_by) VALUES
    (10, 128, true, true, true, 90, 1);

INSERT INTO Security_Configuration (ConfigurationName, ConfigurationValue, Description, updated_by) VALUES
    ('SESSION_TIMEOUT_MINUTES', '30', 'Tiempo de inactividad para cerrar sesión', 1),
    ('MAX_LOGIN_ATTEMPTS', '5', 'Número máximo de intentos fallidos antes de bloquear', 1),
    ('BLOCK_DURATION_MINUTES', '10', 'Tiempo de bloqueo tras intentos fallidos', 1),
    ('GPS_UPDATE_INTERVAL_SECONDS', '30', 'Intervalo de actualización GPS en segundos', 1),
    ('INACTIVITY_ALERT_MINUTES', '5', 'Tiempo de inactividad para generar alerta', 1);

-- =============================================
-- 14. INSERCIÓN DE LOGS (ejemplos)
-- =============================================

-- Activity Logs
INSERT INTO Activity_Log (UsuarioID, ActionType, Description, OriginIp, Metadata) VALUES
    (2, 'LOGIN', 'Inicio de sesión exitoso', '192.168.1.100', '{"browser": "Chrome", "os": "Windows"}'),
    (2, 'VIEW_LOCATION', 'Visualización de ubicación de Sofía', '192.168.1.100', '{"estudiante": "Sofía Rodríguez", "trayecto_id": 1}'),
    (3, 'LOGIN', 'Inicio de sesión exitoso', '192.168.1.101', '{"browser": "Firefox", "os": "Android"}'),
    (2, 'CREATE_ZONE', 'Creación de zona segura', '192.168.1.100', '{"zona": "Casa Sofía", "estudiante": "Sofía"}'),
    (4, 'LOGIN_FAILED', 'Intento de inicio de sesión fallido', '10.0.0.50', '{"reason": "Contraseña incorrecta"}'),
    (1, 'ADMIN_ACTION', 'Configuración del sistema actualizada', '192.168.1.1', '{"setting": "SESSION_TIMEOUT_MINUTES", "new_value": "30"}');

-- Audit Logs
INSERT INTO Audit (UsuarioID, Action, Description, OriginIp, Metadata) VALUES
    (1, 'USER_CREATED', 'Creación de nuevo usuario padre', '192.168.1.1', '{"usuario": "carlos.rodriguez@email.com"}'),
    (2, 'STUDENT_CREATED', 'Registro de nuevo estudiante', '192.168.1.100', '{"estudiante": "Sofía Rodríguez"}'),
    (2, 'ROUTE_CREATED', 'Creación de nueva ruta', '192.168.1.100', '{"ruta": "Ruta Colegio San José - Casa"}'),
    (1, 'ROLE_ASSIGNED', 'Asignación de rol a usuario', '192.168.1.1', '{"usuario": "maria.gonzalez@email.com", "rol": "PADRE"}');

-- Error Logs
INSERT INTO Error_Log (UsuarioID, ErrorType, Description, StackTrace, OriginIp, Metadata) VALUES
    (3, 'GPS_TIMEOUT', 'Timeout en la recepción de coordenadas GPS', 'Error en línea 245: Connection timeout', '192.168.1.101', '{"trayecto_id": 4}'),
    (NULL, 'DATABASE_CONNECTION', 'Error de conexión a la base de datos', 'Connection refused', '127.0.0.1', '{"service": "backend"}'),
    (5, 'NOTIFICATION_FAILED', 'Fallo al enviar notificación push', 'Firebase error: Invalid token', '192.168.1.102', '{"notificacion_id": 6, "token": "expired"}');

-- =============================================
-- 15. INSERCIÓN DE SESIONES (ejemplo)
-- =============================================

INSERT INTO User_Session (UsuarioID, Token, StartedAt, OriginIp, SessionStatus) VALUES
    (2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjIsInJvbGUiOiJQQURSRSJ9.example1', NOW(), '192.168.1.100', 'ACTIVE'),
    (3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjMsInJvbGUiOiJQQURSRSJ9.example2', NOW() - INTERVAL '2 hours', '192.168.1.101', 'ACTIVE'),
    (1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjEsInJvbGUiOiJBRE1JTiJ9.example3', NOW() - INTERVAL '1 day', '192.168.1.1', 'EXPIRED');

-- =============================================
-- FIN DEL DML
-- =============================================

-- Consulta de verificación (opcional)
/*
SELECT 'Total Usuarios: ' || COUNT(*) FROM Usuario
UNION ALL
SELECT 'Total Estudiantes: ' || COUNT(*) FROM Estudiante
UNION ALL
SELECT 'Total Rutas: ' || COUNT(*) FROM Ruta
UNION ALL
SELECT 'Total Trayectos: ' || COUNT(*) FROM Trayecto
UNION ALL
SELECT 'Total Notificaciones: ' || COUNT(*) FROM Notificacion;
*/

SELECT * FROM Usuario