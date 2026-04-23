-- =============================================
-- GPS GUARDIAN ESCOLAR - RELATIONAL MODEL v3.3.1
-- Student Many-to-Many Routes | RBAC Only
-- Abril 2026
-- =============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- 0. ENUMS
-- =============================================
CREATE TYPE school_grade_enum AS ENUM (
    'PRE_KINDERGARTEN', 'KINDERGARTEN', 'TRANSITION', 'FIRST', 'SECOND',
    'THIRD', 'FOURTH', 'FIFTH', 'SIXTH', 'SEVENTH', 'EIGHTH',
    'NINTH', 'TENTH', 'ELEVENTH'
);

CREATE TYPE trip_status_enum AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE session_status_enum AS ENUM ('ACTIVE', 'EXPIRED', 'LOGOUT');
CREATE TYPE role_name_enum AS ENUM ('ADMIN', 'PARENT');

-- =============================================
-- 1. MAIN TABLES
-- =============================================

CREATE TABLE "User" (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(30),
    PasswordHash VARCHAR(255) NOT NULL,
    IsActive BOOLEAN DEFAULT true,

    -- RF1.2.1: Verificación de correo electrónico
    EmailVerified BOOLEAN DEFAULT false,
    EmailVerificationToken VARCHAR(255) UNIQUE,
    EmailVerificationExpiry TIMESTAMPTZ,

    -- RF1.4: Recuperación de contraseña
    PasswordResetToken VARCHAR(255) UNIQUE,
    PasswordResetExpiry TIMESTAMPTZ,

    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

COMMENT ON TABLE "User" IS 'Usuarios del sistema (Padres y Administradores)';

CREATE TABLE Route (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RouteName VARCHAR(100) NOT NULL,
    Description TEXT,
    OriginLat DECIMAL(9,6),
    OriginLon DECIMAL(9,6),
    DestinationLat DECIMAL(9,6),
    DestinationLon DECIMAL(9,6),
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

COMMENT ON TABLE Route IS 'Rutas del servicio escolar';

CREATE TABLE Student (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID NOT NULL REFERENCES "User"(ID) ON DELETE RESTRICT,
    FullName VARCHAR(100) NOT NULL,
    SchoolGrade school_grade_enum,
    BirthDate DATE,
    IsActive BOOLEAN DEFAULT true,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

COMMENT ON TABLE Student IS 'Estudiantes asociados a un padre';

CREATE TABLE Student_Route (
    StudentID UUID NOT NULL REFERENCES Student(ID) ON DELETE CASCADE,
    RouteID UUID NOT NULL REFERENCES Route(ID) ON DELETE CASCADE,
    IsActive BOOLEAN DEFAULT true,
    AssignedAt TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (StudentID, RouteID)
);

COMMENT ON TABLE Student_Route IS 'Relación muchos a muchos: Un estudiante puede tener múltiples rutas (ida, vuelta, etc.)';

CREATE TABLE EmergencyContact (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    StudentID UUID NOT NULL REFERENCES Student(ID) ON DELETE CASCADE,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(30) NOT NULL,
    Relationship VARCHAR(50),
    IsPrimary BOOLEAN DEFAULT false,
    IsActive BOOLEAN DEFAULT true,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

CREATE TABLE Stop (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RouteID UUID NOT NULL REFERENCES Route(ID) ON DELETE CASCADE,
    StopOrder INTEGER NOT NULL,
    StopName VARCHAR(100),
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE SafeZone (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    StudentID UUID NOT NULL REFERENCES Student(ID) ON DELETE CASCADE,
    ZoneName VARCHAR(100) NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    RadiusMeters INTEGER NOT NULL CHECK (RadiusMeters > 0),
    InactivityThresholdSeconds INTEGER NOT NULL DEFAULT 300 CHECK (InactivityThresholdSeconds > 0),
    IsActive BOOLEAN DEFAULT true,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

CREATE TABLE NotificationConfig (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID NOT NULL REFERENCES "User"(ID) ON DELETE CASCADE,
    DelayAlert BOOLEAN DEFAULT true,
    RouteChangeAlert BOOLEAN DEFAULT true,
    ArrivalAlert BOOLEAN DEFAULT true,
    InactivityAlert BOOLEAN DEFAULT true,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Trip (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    StudentID UUID NOT NULL REFERENCES Student(ID) ON DELETE CASCADE,
    RouteID UUID NOT NULL REFERENCES Route(ID) ON DELETE RESTRICT,
    StartDateTime TIMESTAMPTZ NOT NULL,
    EndDateTime TIMESTAMPTZ,
    Status trip_status_enum DEFAULT 'PENDING',
    HasDetour BOOLEAN DEFAULT false,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    DeletedAt TIMESTAMPTZ,
    CreatedBy UUID REFERENCES "User"(ID),
    UpdatedBy UUID REFERENCES "User"(ID)
);

CREATE TABLE Coordinate (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    TripID UUID NOT NULL REFERENCES Trip(ID) ON DELETE CASCADE,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    RecordedAt TIMESTAMPTZ NOT NULL,
    SpeedKmh DECIMAL(5,1),
    StopDurationSeconds INTEGER DEFAULT 0 CHECK (StopDurationSeconds >= 0),
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Notification (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    TripID UUID REFERENCES Trip(ID) ON DELETE SET NULL,
    ZoneID UUID REFERENCES SafeZone(ID) ON DELETE SET NULL,
    EventType VARCHAR(50) NOT NULL,
    Message TEXT NOT NULL,
    EventDateTime TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    IsSent BOOLEAN DEFAULT false
);

-- =============================================
-- 2. RELATIONSHIP TABLES
-- =============================================

CREATE TABLE NotificationReceipt (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    NotificationID UUID NOT NULL REFERENCES Notification(ID) ON DELETE CASCADE,
    UserID UUID NOT NULL REFERENCES "User"(ID) ON DELETE CASCADE,
    IsRead BOOLEAN DEFAULT false,
    ReceivedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ReadAt TIMESTAMPTZ,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 3. SECURITY - RBAC
-- =============================================

CREATE TABLE Role (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RoleName role_name_enum UNIQUE NOT NULL,
    Description VARCHAR(255),
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Permission (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    PermissionName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT,
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE User_Role (
    UserID UUID NOT NULL REFERENCES "User"(ID) ON DELETE CASCADE,
    RoleID UUID NOT NULL REFERENCES Role(ID) ON DELETE CASCADE,
    AssignedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, RoleID)
);

CREATE TABLE Role_Permission (
    RoleID UUID NOT NULL REFERENCES Role(ID) ON DELETE CASCADE,
    PermissionID UUID NOT NULL REFERENCES Permission(ID) ON DELETE CASCADE,
    PRIMARY KEY (RoleID, PermissionID)
);

CREATE TABLE UserSession (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID NOT NULL REFERENCES "User"(ID) ON DELETE CASCADE,
    Token VARCHAR(500) NOT NULL,
    StartedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    EndedAt TIMESTAMPTZ,
    OriginIp INET,
    SessionStatus session_status_enum DEFAULT 'ACTIVE',
    CreatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedAt TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 4. GLOBAL AND LOG TABLES
-- =============================================

CREATE TABLE PasswordPolicy (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    MinLength INT DEFAULT 10,
    MaxLength INT DEFAULT 128,
    RequireUppercase BOOLEAN DEFAULT true,
    RequireNumbers BOOLEAN DEFAULT true,
    RequireSymbols BOOLEAN DEFAULT true,
    ExpirationDays INT DEFAULT 90,
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedBy UUID REFERENCES "User"(ID)
);

CREATE TABLE SecurityConfiguration (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ConfigName VARCHAR(100) UNIQUE NOT NULL,
    ConfigValue TEXT,
    Description TEXT,
    UpdatedAt TIMESTAMPTZ DEFAULT NOW(),
    UpdatedBy UUID REFERENCES "User"(ID)
);

CREATE TABLE ActivityLog (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID REFERENCES "User"(ID),
    ActionType VARCHAR(50) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Metadata JSONB,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AuditLog (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID REFERENCES "User"(ID),
    Action VARCHAR(255) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Application VARCHAR(100) DEFAULT 'GPS_Guardian',
    Metadata JSONB,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ErrorLog (
    ID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    UserID UUID REFERENCES "User"(ID),
    ErrorType VARCHAR(100) NOT NULL,
    Description TEXT,
    StackTrace TEXT,
    OriginIp INET,
    Metadata JSONB,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 5. INDEXES
-- =============================================

-- User
CREATE INDEX idx_user_email ON "User"(Email);
CREATE INDEX idx_user_active ON "User"(IsActive);
CREATE INDEX idx_user_deleted ON "User"(DeletedAt) WHERE DeletedAt IS NULL;
CREATE INDEX idx_user_email_verification_token ON "User"(EmailVerificationToken) WHERE EmailVerificationToken IS NOT NULL;
CREATE INDEX idx_user_password_reset_token ON "User"(PasswordResetToken) WHERE PasswordResetToken IS NOT NULL;

-- Student
CREATE INDEX idx_student_user ON Student(UserID);
CREATE INDEX idx_student_active ON Student(IsActive);

-- Student_Route
CREATE INDEX idx_student_route_student ON Student_Route(StudentID);
CREATE INDEX idx_student_route_route ON Student_Route(RouteID);

-- Trip
CREATE INDEX idx_trip_student ON Trip(StudentID);
CREATE INDEX idx_trip_route ON Trip(RouteID);
CREATE INDEX idx_trip_status ON Trip(Status);
CREATE INDEX idx_trip_start ON Trip(StartDateTime);

-- Stop
CREATE INDEX idx_stop_route ON Stop(RouteID);
CREATE INDEX idx_stop_order ON Stop(RouteID, StopOrder);

-- SafeZone
CREATE INDEX idx_safezone_student ON SafeZone(StudentID);
CREATE INDEX idx_safezone_student_active ON SafeZone(StudentID) WHERE IsActive = true;

-- Coordinate
CREATE INDEX idx_coordinate_trip ON Coordinate(TripID);
CREATE INDEX idx_coordinate_stop_duration ON Coordinate(TripID, StopDurationSeconds);

-- Notification
CREATE INDEX idx_notification_trip ON Notification(TripID);

-- Security
CREATE INDEX idx_user_role_user ON User_Role(UserID);
CREATE INDEX idx_session_user ON UserSession(UserID);
CREATE INDEX idx_session_token ON UserSession(Token);

-- =============================================
-- END OF SCRIPT - GPS Guardian Escolar v3.3.1
-- =============================================