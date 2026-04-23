DROP TABLE IF EXISTS Notificacion_Recibe     CASCADE;

DROP TABLE IF EXISTS Notificacion            CASCADE;

DROP TABLE IF EXISTS Coordenadas             CASCADE;

DROP TABLE IF EXISTS Trayecto                CASCADE;

DROP TABLE IF EXISTS Parada                  CASCADE;

DROP TABLE IF EXISTS ConfigNotificacion      CASCADE;

DROP TABLE IF EXISTS Estudiante              CASCADE;

DROP TABLE IF EXISTS User_Route              CASCADE;

DROP TABLE IF EXISTS Ruta                    CASCADE;

DROP TABLE IF EXISTS Log_Errores             CASCADE;

DROP TABLE IF EXISTS Auditoria               CASCADE;

DROP TABLE IF EXISTS Sesion_Usuario          CASCADE;

DROP TABLE IF EXISTS Registro                CASCADE;

DROP TABLE IF EXISTS Rol_Permiso             CASCADE;

DROP TABLE IF EXISTS Usuario_Rol             CASCADE;

DROP TABLE IF EXISTS Permisos                CASCADE;

DROP TABLE IF EXISTS Roles                   CASCADE;

DROP TABLE IF EXISTS Politicas_Contrasenas   CASCADE;

DROP TABLE IF EXISTS Configuracion_Seguridad CASCADE;

DROP TABLE IF EXISTS Usuario                 CASCADE;

CREATE TABLE Configuracion_Seguridad (
    ConfiguracionID         INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NombreConfiguracion     VARCHAR(100) NOT NULL,
    ValorConfiguracion      VARCHAR(500) NOT NULL,
    Descripcion             VARCHAR(255)
);

CREATE TABLE Politicas_Contrasenas (
    PoliticaID              INT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    MinLongitud             INT     NOT NULL DEFAULT 8,
    MaxLongitud             INT     NOT NULL DEFAULT 20,
    RequiereMayusculas      BOOLEAN NOT NULL DEFAULT TRUE,
    RequiereMinusculas      BOOLEAN NOT NULL DEFAULT TRUE,
    RequiereNumeros         BOOLEAN NOT NULL DEFAULT TRUE,
    RequiereSimbolos        BOOLEAN NOT NULL DEFAULT TRUE,
    CaducidadDias           INT     NOT NULL DEFAULT 90,
    IntentosFallidosMax     INT     NOT NULL DEFAULT 5
);

CREATE TABLE Usuario (
    UsuarioID           INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NombreCompleto      VARCHAR(255) NOT NULL,
    username            VARCHAR(255),
    Email               VARCHAR(100) NOT NULL UNIQUE,
    Telefono            VARCHAR(20),
    FechaNacimiento     DATE,
    Genero              CHAR(1)      CHECK (Genero IN ('M','F','O')),
    ContactoEmergencia  VARCHAR(100),
    GradoEscolar        VARCHAR(50),
    Contrasena          VARCHAR(255) NOT NULL,
    TipoAutenticacion   VARCHAR(50)  NOT NULL DEFAULT 'LOCAL',
    TipoUsuario         VARCHAR(20)  NOT NULL CHECK (TipoUsuario IN ('Padre','Admin','Estudiante')),
    EstadoUsuario       BOOLEAN      NOT NULL DEFAULT TRUE,
    FechaCreacion       TIMESTAMP    NOT NULL DEFAULT NOW(),
    UltimoAcceso        TIMESTAMP,
    creado_por          INT          REFERENCES Usuario(UsuarioID),
    creado_en           TIMESTAMP    NOT NULL DEFAULT NOW(),
    modificado_por      INT,
    modificado_en       TIMESTAMP
);

CREATE TABLE Roles (
    RolID       INT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NombreRol   VARCHAR(50) NOT NULL UNIQUE,
    Descripcion VARCHAR(255)
);

CREATE TABLE Permisos (
    PermisoID      INT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NombrePermiso  VARCHAR(50) NOT NULL UNIQUE,
    Descripcion    VARCHAR(255)
);

CREATE TABLE Usuario_Rol (
    UsuarioID       INT       NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    RolID           INT       NOT NULL REFERENCES Roles(RolID)       ON DELETE CASCADE,
    FechaAsignacion TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (UsuarioID, RolID)
);

CREATE TABLE Rol_Permiso (
    RolID           INT       NOT NULL REFERENCES Roles(RolID)   ON DELETE CASCADE,
    PermisoID       INT       NOT NULL REFERENCES Permisos(PermisoID) ON DELETE CASCADE,
    FechaAsignacion TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (RolID, PermisoID)
);

CREATE TABLE Sesion_Usuario (
    SesionID        INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    UsuarioID       INT          NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    FechaInicio     TIMESTAMP    NOT NULL DEFAULT NOW(),
    FechaFin        TIMESTAMP,
    IP_Origen       VARCHAR(50),
    EstadoSesion    VARCHAR(50)  NOT NULL DEFAULT 'ACTIVA'
                                 CHECK (EstadoSesion IN ('ACTIVA','CERRADA','EXPIRADA'))
);

CREATE TABLE Registro (
    RegistroID      INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    UsuarioID       INT          NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE SET NULL,
    TipoAccion      VARCHAR(100) NOT NULL,
    Descripcion     VARCHAR(500),
    FechaHora       TIMESTAMP    NOT NULL DEFAULT NOW(),
    IP_Origen       VARCHAR(50),
    Dispositivo     VARCHAR(100),
    EstadoDispositivo VARCHAR(50)
);

CREATE TABLE Auditoria (
    AuditoriaID INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    UsuarioID   INT          REFERENCES Usuario(UsuarioID) ON DELETE SET NULL,
    Accion      VARCHAR(255) NOT NULL,
    Fecha       TIMESTAMP    NOT NULL DEFAULT NOW(),
    Descripcion VARCHAR(500),
    IP_Origen   VARCHAR(50),
    Aplicacion  VARCHAR(255)
);

CREATE TABLE Log_Errores (
    ErrorID     INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Fecha       TIMESTAMP    NOT NULL DEFAULT NOW(),
    UsuarioID   INT          REFERENCES Usuario(UsuarioID) ON DELETE SET NULL,
    TipoError   VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(500),
    IP_Origen   VARCHAR(50)
);

CREATE TABLE Ruta (
    RutaID          INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NombreRuta      VARCHAR(255) NOT NULL,
    Descripcion     VARCHAR(255),
    HorarioSalida   TIME,
    EstadoRuta      VARCHAR(30)  NOT NULL DEFAULT 'Activa'
                                 CHECK (EstadoRuta IN ('Activa','Inactiva','Suspendida')),
    OriginLatitud   DECIMAL(9,6),
    OriginLongitud  DECIMAL(9,6),
    creado_por      INT          REFERENCES Usuario(UsuarioID),
    creado_en       TIMESTAMP    NOT NULL DEFAULT NOW(),
    modificado_por  INT,
    modificado_en   TIMESTAMP
);

CREATE TABLE User_Route (
    UsuarioID INT NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    RutaID    INT NOT NULL REFERENCES Ruta(RutaID)       ON DELETE CASCADE,
    PRIMARY KEY (UsuarioID, RutaID)
);

CREATE TABLE Parada (
    ParadaID        INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RutaID          INT          NOT NULL REFERENCES Ruta(RutaID) ON DELETE CASCADE,
    NombreParada    VARCHAR(255) NOT NULL,
    Latitud         DECIMAL(9,6) NOT NULL,
    Longitud        DECIMAL(9,6) NOT NULL,
    HorarioEstimado TIME,
    Orden           INT,
    creado_por      INT          REFERENCES Usuario(UsuarioID),
    creado_en       TIMESTAMP    NOT NULL DEFAULT NOW(),
    modificado_por  INT,
    modificado_en   TIMESTAMP
);

CREATE TABLE Estudiante (
    EstudianteID        INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    UsuarioID           INT          NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    RutaID              INT          REFERENCES Ruta(RutaID) ON DELETE SET NULL,
    NombreEstudiante    VARCHAR(255) NOT NULL,
    GradoEscolar        VARCHAR(50),
    ContactoEmergencia  VARCHAR(100),
    EstadoEstudiante    BOOLEAN      NOT NULL DEFAULT TRUE,
    FechaNacimiento     DATE,
    creado_por          INT          REFERENCES Usuario(UsuarioID),
    creado_en           TIMESTAMP    NOT NULL DEFAULT NOW(),
    modificado_por      INT,
    modificado_en       TIMESTAMP
);

CREATE TABLE Trayecto (
    TrayectoID          INT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RutaID              INT         NOT NULL REFERENCES Ruta(RutaID)           ON DELETE RESTRICT,
    EstudianteID        INT         REFERENCES Estudiante(EstudianteID)         ON DELETE SET NULL,
    FechaInicio         TIMESTAMP   NOT NULL DEFAULT NOW(),
    FechaFin            TIMESTAMP,
    EstadoTrayecto      VARCHAR(30) NOT NULL DEFAULT 'En Progreso'
                                    CHECK (EstadoTrayecto IN ('En Progreso','Completado','Cancelado')),
    DuracionEstimada    INT,
    creado_por          INT         REFERENCES Usuario(UsuarioID),
    creado_en           TIMESTAMP   NOT NULL DEFAULT NOW(),
    modificado_por      INT,
    modificado_en       TIMESTAMP
);

CREATE TABLE Coordenadas (
    CoordenadaID    INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TrayectoID      INT          NOT NULL REFERENCES Trayecto(TrayectoID) ON DELETE CASCADE,
    Latitud         DECIMAL(9,6) NOT NULL,
    Longitud        DECIMAL(9,6) NOT NULL,
    FechaHora       TIMESTAMP    NOT NULL DEFAULT NOW(),
    Velocidad       DECIMAL(5,2),
    creado_por      INT          REFERENCES Usuario(UsuarioID),
    creado_en       TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE Notificacion (
    NotificacionID  INT          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TrayectoID      INT          REFERENCES Trayecto(TrayectoID)  ON DELETE SET NULL,
    ReportadoPor    INT          REFERENCES Usuario(UsuarioID)    ON DELETE SET NULL,
    TipoEvento      VARCHAR(50)  NOT NULL
                                 CHECK (TipoEvento IN ('Retraso','CambioRuta','Llegada','Emergencia','Desvio','Info')),
    Mensaje         TEXT         NOT NULL,
    FechaHora       TIMESTAMP    NOT NULL DEFAULT NOW(),
    EsDesvioRuta    BOOLEAN      NOT NULL DEFAULT FALSE,
    EstadoEnvio     VARCHAR(30)  NOT NULL DEFAULT 'Enviado'
                                 CHECK (EstadoEnvio IN ('Enviado','Fallido','Pendiente')),
    creado_por      INT          REFERENCES Usuario(UsuarioID),
    creado_en       TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE Notificacion_Recibe (
    NotificacionID  INT         NOT NULL REFERENCES Notificacion(NotificacionID) ON DELETE CASCADE,
    ReceptorID      INT         NOT NULL REFERENCES Usuario(UsuarioID)           ON DELETE CASCADE,
    ReceptorTipo    VARCHAR(20) NOT NULL DEFAULT 'Padre'
                                CHECK (ReceptorTipo IN ('Padre','Admin','Estudiante')),
    FechaRecibo     TIMESTAMP   NOT NULL DEFAULT NOW(),
    Leida           BOOLEAN     NOT NULL DEFAULT FALSE,
    PRIMARY KEY (NotificacionID, ReceptorID)
);

CREATE TABLE ConfigNotificacion (
    ConfigID        INT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    UsuarioID       INT     NOT NULL REFERENCES Usuario(UsuarioID) ON DELETE CASCADE,
    AlertaRetraso   BOOLEAN NOT NULL DEFAULT TRUE,
    AlertaCambioRuta BOOLEAN NOT NULL DEFAULT TRUE,
    AlertaLlegada   BOOLEAN NOT NULL DEFAULT TRUE,
    creado_por      INT     REFERENCES Usuario(UsuarioID),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    modificado_por  INT,
    modificado_en   TIMESTAMP,
    UNIQUE (UsuarioID)
);

CREATE INDEX IX_Usuario_Email            ON Usuario(Email);

CREATE INDEX IX_Usuario_Estado           ON Usuario(EstadoUsuario);

CREATE INDEX IX_Sesion_Usuario           ON Sesion_Usuario(UsuarioID);

CREATE INDEX IX_Sesion_Estado            ON Sesion_Usuario(EstadoSesion);

CREATE INDEX IX_Registro_Usuario         ON Registro(UsuarioID, FechaHora DESC);

CREATE INDEX IX_Auditoria_Usuario        ON Auditoria(UsuarioID, Fecha DESC);

CREATE INDEX IX_LogErrores_Fecha         ON Log_Errores(Fecha DESC);

CREATE INDEX IX_LogErrores_Tipo          ON Log_Errores(TipoError);

CREATE INDEX IX_Parada_Ruta              ON Parada(RutaID);

CREATE INDEX IX_Estudiante_Ruta          ON Estudiante(RutaID);

CREATE INDEX IX_Trayecto_FechaInicio     ON Trayecto(FechaInicio DESC);

CREATE INDEX IX_Trayecto_Estudiante      ON Trayecto(EstudianteID);

CREATE INDEX IX_Trayecto_Ruta            ON Trayecto(RutaID);

CREATE INDEX IX_Coordenadas_Trayecto     ON Coordenadas(TrayectoID);

CREATE INDEX IX_Notificacion_Trayecto    ON Notificacion(TrayectoID);

CREATE INDEX IX_Notificacion_Tipo        ON Notificacion(TipoEvento);

CREATE INDEX IX_Notif_Recibe_Receptor    ON Notificacion_Recibe(ReceptorID);