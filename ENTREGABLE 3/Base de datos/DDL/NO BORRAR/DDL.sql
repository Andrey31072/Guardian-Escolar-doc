-- =============================================
-- GPS GUARDIAN ESCOLAR - MODELO RELACIONAL FINAL
-- Versión Corregida y Alineada al Diagrama de Clases
-- Abril 2026
-- =============================================

-- =============================================
-- 1. TABLAS PRINCIPALES
-- =============================================

CREATE TABLE Usuario (
    UsuarioID SERIAL PRIMARY KEY, -- Cambiar el Serial por un UUID
    NombreCompleto VARCHAR(255) NOT NULL, -- Editar numero de caracter por menor Caracteres.
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL, -- Editar numero de caracter por menor Caracteres, ademas cambiar contraseñas hash por el bicryt.
    TipoUsuario VARCHAR(20) DEFAULT 'PADRE' CHECK (TipoUsuario IN ('ADMIN', 'PADRE')),
    Estado BOOLEAN DEFAULT true,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UltimoAcceso TIMESTAMP,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID), -- Dejar opcional para el primero usuario, debido a que va hacer el SuperAdmin. 
    updated_by INTEGER REFERENCES Usuario(UsuarioID) -- Dejar opcional para el primero usuario, debido a que va hacer el SuperAdmin. 
);

CREATE TABLE Estudiante (
    EstudianteID SERIAL PRIMARY KEY,-- Cambiar el Serial por un UUID
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE RESTRICT,
    NombreCompleto VARCHAR(255) NOT NULL, -- Editar numero de caracter por menor Caracteres.
    GradoEscolar VARCHAR(50), -- Hacerlo a trávez de unos parametros establecidos con un ENUM.
    FechaNacimiento DATE,
    ContactoEmergencia VARCHAR(100), -- Hacerlo a través de variable parametrizadass, Enum o Hacerlo a travéz de una entidad nueva.
    Estado BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Ruta (
    RutaID SERIAL PRIMARY KEY,-- Cambiar el Serial por un UUID
    NombreRuta VARCHAR(255) NOT NULL,
    Descripcion TEXT,
    OrigenLat DECIMAL(10,8), -- Cambiar decimales a a menor
    OrigenLon DECIMAL(11,8),-- Cambiar decimales a a menor
    DestinoLat DECIMAL(10,8), -- Cambiar decimales a a menor
    DestinoLon DECIMAL(11,8), -- Cambiar decimales a a menor
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Parada (
    ParadaID SERIAL PRIMARY KEY,-- Cambiar el Serial por un UUID
    RutaID INTEGER NOT NULL REFERENCES Ruta(RutaID) ON DELETE CASCADE,
    Orden INTEGER NOT NULL, 
    NombreParada VARCHAR(100),
    Latitud DECIMAL(10,8) NOT NULL, -- Cambiar decimales a a menor
    Longitud DECIMAL(11,8) NOT NULL,-- Cambiar decimales a a menor
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ZonaSegura (
    ZonaID SERIAL PRIMARY KEY, -- Cambiar el serial por un UIID
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    EstudianteID INTEGER NOT NULL REFERENCES Estudiante(EstudianteID) ON DELETE CASCADE,
    NombreZona VARCHAR(100) NOT NULL, -- Cambiar decimales a a menor
    Latitud DECIMAL(10,8) NOT NULL, -- Cambiar decimales a a menor
    Longitud DECIMAL(11,8) NOT NULL,-- Cambiar decimales a a menor
    RadioMetros INTEGER NOT NULL CHECK (RadioMetros > 0),
    Activa BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES Usuario(UsuarioID),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE ConfigNotificacion (
    ConfigID SERIAL PRIMARY KEY, --Cambiar el Serial por un UUID
    UsuarioID INTEGER NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    AlertaRetraso BOOLEAN DEFAULT true,
    AlertaCambioRuta BOOLEAN DEFAULT true,
    AlertaLlegada BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Trayecto (
    TrayectoID SERIAL PRIMARY KEY,--Cambiar el Serial por un UUID
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
    CoordID SERIAL PRIMARY KEY, --Cambiar el Serial por un UUID
    TrayectoID INTEGER NOT NULL REFERENCES Trayecto(TrayectoID) ON DELETE CASCADE,
    Latitud DECIMAL(10,8) NOT NULL, -- Cambiar decimales a a menor
    Longitud DECIMAL(11,8) NOT NULL,-- Cambiar decimales a a menor
    FechaHora TIMESTAMP NOT NULL, 
    Velocidad DECIMAL(5,2),-- Cambiar decimales a a menor
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Notificacion (
    NotificacionID SERIAL PRIMARY KEY, --Cambiar Serial a UUID
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
    ReciboID SERIAL PRIMARY KEY,-- Cambiar Serial a UUID
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
    RoleID SERIAL PRIMARY KEY,--Cambiar el Seria por el UUID
    RoleName VARCHAR(20) UNIQUE NOT NULL CHECK (RoleName IN ('ADMIN', 'PADRE')),
    Description VARCHAR(255),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Permission (
    PermissionID SERIAL PRIMARY KEY,--Cambiar el Seria por el UUID
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
    SessionID SERIAL PRIMARY KEY,-- Cambiar el Seria por el UUID
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
    PolicyID SERIAL PRIMARY KEY, --Cambiar el Seria por el UUID
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
    ConfigurationID SERIAL PRIMARY KEY,--Cambiar el Seria por el UUID
    ConfigurationName VARCHAR(100) UNIQUE NOT NULL,
    ConfigurationValue TEXT,
    Description TEXT,
    
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by INTEGER REFERENCES Usuario(UsuarioID)
);

CREATE TABLE Activity_Log (
    LogID BIGSERIAL PRIMARY KEY, --Cambiar el BigSeria por el UUID
    UsuarioID INTEGER REFERENCES Usuario(UsuarioID),
    ActionType VARCHAR(50) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Audit (
    AuditID BIGSERIAL PRIMARY KEY, --Cambiar el BigSeria por el UUID
    UsuarioID INTEGER REFERENCES Usuario(UsuarioID),
    Action VARCHAR(255) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Application VARCHAR(100) DEFAULT 'GPS_Guardian',
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Error_Log (
    ErrorID BIGSERIAL PRIMARY KEY,--Cambiar el BigSeria por el UUID
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