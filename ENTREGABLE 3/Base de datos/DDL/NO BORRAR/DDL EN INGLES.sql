-- =============================================
-- GPS GUARDIAN ESCOLAR - FINAL RELATIONAL MODEL
-- Corrected Version Aligned with Class Diagram
-- April 2026
-- =============================================

-- =============================================
-- 1. MAIN TABLES
-- =============================================

CREATE TABLE User (
    UserID SERIAL PRIMARY KEY,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    PasswordHash VARCHAR(255) NOT NULL,
    UserType VARCHAR(20) DEFAULT 'PARENT' CHECK (UserType IN ('ADMIN', 'PARENT')),
    Status BOOLEAN DEFAULT true,
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastAccess TIMESTAMP,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES User(UserID),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Student (
    StudentID SERIAL PRIMARY KEY,
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE RESTRICT,
    FullName VARCHAR(255) NOT NULL,
    GradeLevel VARCHAR(50),
    BirthDate DATE,
    EmergencyContact VARCHAR(100),
    Status BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES User(UserID),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Route (
    RouteID SERIAL PRIMARY KEY,
    RouteName VARCHAR(255) NOT NULL,
    Description TEXT,
    OriginLat DECIMAL(10,8),
    OriginLon DECIMAL(11,8),
    DestinationLat DECIMAL(10,8),
    DestinationLon DECIMAL(11,8),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES User(UserID),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Stop (
    StopID SERIAL PRIMARY KEY,
    RouteID INTEGER NOT NULL REFERENCES Route(RouteID) ON DELETE CASCADE,
    StopOrder INTEGER NOT NULL,
    StopName VARCHAR(100),
    Latitude DECIMAL(10,8) NOT NULL,
    Longitude DECIMAL(11,8) NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE SafeZone (
    ZoneID SERIAL PRIMARY KEY,
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    StudentID INTEGER NOT NULL REFERENCES Student(StudentID) ON DELETE CASCADE,
    ZoneName VARCHAR(100) NOT NULL,
    Latitude DECIMAL(10,8) NOT NULL,
    Longitude DECIMAL(11,8) NOT NULL,
    RadiusMeters INTEGER NOT NULL CHECK (RadiusMeters > 0),
    Active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES User(UserID),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE NotificationConfig (
    ConfigID SERIAL PRIMARY KEY,
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    DelayAlert BOOLEAN DEFAULT true,
    RouteChangeAlert BOOLEAN DEFAULT true,
    ArrivalAlert BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Journey (
    JourneyID SERIAL PRIMARY KEY,
    StudentID INTEGER NOT NULL REFERENCES Student(StudentID) ON DELETE CASCADE,
    RouteID INTEGER NOT NULL REFERENCES Route(RouteID) ON DELETE RESTRICT,
    StartDateTime TIMESTAMP NOT NULL,
    EndDateTime TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'PENDING' CHECK (Status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED')),
    HasDeviation BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_by INTEGER REFERENCES User(UserID),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Coordinate (
    CoordID SERIAL PRIMARY KEY,
    JourneyID INTEGER NOT NULL REFERENCES Journey(JourneyID) ON DELETE CASCADE,
    Latitude DECIMAL(10,8) NOT NULL,
    Longitude DECIMAL(11,8) NOT NULL,
    DateTime TIMESTAMP NOT NULL,
    Speed DECIMAL(5,2),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE Notification (
    NotificationID SERIAL PRIMARY KEY,
    JourneyID INTEGER REFERENCES Journey(JourneyID) ON DELETE SET NULL,
    ZoneID INTEGER REFERENCES SafeZone(ZoneID) ON DELETE SET NULL,
    EventType VARCHAR(50) NOT NULL,
    Message TEXT NOT NULL,
    DateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SentStatus BOOLEAN DEFAULT false
);

-- =============================================
-- 2. RELATIONSHIP TABLES
-- =============================================

CREATE TABLE User_Route (
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    RouteID INTEGER NOT NULL REFERENCES Route(RouteID) ON DELETE CASCADE,
    PRIMARY KEY (UserID, RouteID),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE NotificationReceipt (
    ReceiptID SERIAL PRIMARY KEY,
    NotificationID INTEGER NOT NULL REFERENCES Notification(NotificationID) ON DELETE CASCADE,
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    IsRead BOOLEAN DEFAULT false,
    ReceiveDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReadDate TIMESTAMP,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 3. SECURITY
-- =============================================

CREATE TABLE Role (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(20) UNIQUE NOT NULL CHECK (RoleName IN ('ADMIN', 'PARENT')),
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
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    RoleID INTEGER NOT NULL REFERENCES Role(RoleID) ON DELETE CASCADE,
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, RoleID)
);

CREATE TABLE Role_Permission (
    RoleID INTEGER NOT NULL REFERENCES Role(RoleID) ON DELETE CASCADE,
    PermissionID INTEGER NOT NULL REFERENCES Permission(PermissionID) ON DELETE CASCADE,
    PRIMARY KEY (RoleID, PermissionID)
);

CREATE TABLE User_Session (
    SessionID SERIAL PRIMARY KEY,
    UserID INTEGER NOT NULL REFERENCES User(UserID) ON DELETE CASCADE,
    Token VARCHAR(500) NOT NULL,
    StartedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndedAt TIMESTAMP,
    OriginIp INET,
    SessionStatus VARCHAR(20) DEFAULT 'ACTIVE' CHECK (SessionStatus IN ('ACTIVE', 'EXPIRED', 'LOGOUT')),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 4. GLOBAL TABLES AND LOGS
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
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Security_Configuration (
    ConfigurationID SERIAL PRIMARY KEY,
    ConfigurationName VARCHAR(100) UNIQUE NOT NULL,
    ConfigurationValue TEXT,
    Description TEXT,
    
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by INTEGER REFERENCES User(UserID)
);

CREATE TABLE Activity_Log (
    LogID BIGSERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES User(UserID),
    ActionType VARCHAR(50) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Audit (
    AuditID BIGSERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES User(UserID),
    Action VARCHAR(255) NOT NULL,
    Description TEXT,
    OriginIp INET,
    Application VARCHAR(100) DEFAULT 'GPS_Guardian',
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Error_Log (
    ErrorID BIGSERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES User(UserID),
    ErrorType VARCHAR(100) NOT NULL,
    Description TEXT,
    StackTrace TEXT,
    OriginIp INET,
    Metadata JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 5. RECOMMENDED INDEXES
-- =============================================

-- User
CREATE INDEX idx_user_email ON User(Email);
CREATE INDEX idx_user_type ON User(UserType);
CREATE INDEX idx_user_status ON User(Status);

-- Student
CREATE INDEX idx_student_user ON Student(UserID);
CREATE INDEX idx_student_status ON Student(Status);

-- SafeZone
CREATE INDEX idx_safezone_student ON SafeZone(StudentID);
CREATE INDEX idx_safezone_user ON SafeZone(UserID);
CREATE INDEX idx_safezone_active ON SafeZone(Active);

-- Journey
CREATE INDEX idx_journey_student ON Journey(StudentID);
CREATE INDEX idx_journey_status ON Journey(Status);
CREATE INDEX idx_journey_start_date ON Journey(StartDateTime);

-- Coordinate
CREATE INDEX idx_coordinate_journey ON Coordinate(JourneyID);
CREATE INDEX idx_coordinate_datetime ON Coordinate(DateTime);

-- Notification
CREATE INDEX idx_notification_journey ON Notification(JourneyID);
CREATE INDEX idx_notification_zone ON Notification(ZoneID);
CREATE INDEX idx_notification_datetime ON Notification(DateTime);
CREATE INDEX idx_notification_type ON Notification(EventType);

-- NotificationReceipt
CREATE INDEX idx_receipt_user ON NotificationReceipt(UserID);
CREATE INDEX idx_receipt_notification ON NotificationReceipt(NotificationID);
CREATE INDEX idx_receipt_read ON NotificationReceipt(IsRead);

-- Stop
CREATE INDEX idx_stop_route ON Stop(RouteID);
CREATE INDEX idx_stop_order ON Stop(RouteID, StopOrder);

-- NotificationConfig
CREATE INDEX idx_notification_config_user ON NotificationConfig(UserID);

-- Security
CREATE INDEX idx_user_role_user ON User_Role(UserID);
CREATE INDEX idx_user_role_role ON User_Role(RoleID);
CREATE INDEX idx_role_permission_role ON Role_Permission(RoleID);
CREATE INDEX idx_user_session_user ON User_Session(UserID);
CREATE INDEX idx_user_session_status ON User_Session(SessionStatus);

-- Logs
CREATE INDEX idx_activity_log_user ON Activity_Log(UserID);
CREATE INDEX idx_activity_log_date ON Activity_Log(created_at);
CREATE INDEX idx_activity_log_type ON Activity_Log(ActionType);
CREATE INDEX idx_audit_user ON Audit(UserID);
CREATE INDEX idx_audit_date ON Audit(created_at);
CREATE INDEX idx_error_log_user ON Error_Log(UserID);
CREATE INDEX idx_error_log_date ON Error_Log(created_at);

-- =============================================
-- 6. TABLE COMMENTS (DOCUMENTATION)
-- =============================================

COMMENT ON TABLE User IS 'System users (parents and administrators)';
COMMENT ON TABLE Student IS 'Students associated with a parent';
COMMENT ON TABLE Route IS 'Routes created by parents for their students';
COMMENT ON TABLE Stop IS 'Stops that make up a route';
COMMENT ON TABLE SafeZone IS 'Trusted zones registered by parents for a student';
COMMENT ON TABLE NotificationConfig IS 'User-specific notification settings';
COMMENT ON TABLE Journey IS 'Journeys taken by a student following a route';
COMMENT ON TABLE Coordinate IS 'GPS coordinate records during a journey';
COMMENT ON TABLE Notification IS 'Notifications generated during a journey or upon reaching a safe zone';
COMMENT ON TABLE NotificationReceipt IS 'Record of notification receipt and reading by users';
COMMENT ON TABLE User_Route IS 'Relationship between users (parents) and routes they have created';
COMMENT ON TABLE Role IS 'System roles (ADMIN, PARENT)';
COMMENT ON TABLE Permission IS 'Permissions assignable to roles';
COMMENT ON TABLE User_Role IS 'Role assignment to users';
COMMENT ON TABLE Role_Permission IS 'Permission assignment to roles';
COMMENT ON TABLE User_Session IS 'Active user sessions';
COMMENT ON TABLE Password_Policy IS 'System password policies';
COMMENT ON TABLE Security_Configuration IS 'System security configurations';
COMMENT ON TABLE Activity_Log IS 'User activity records';
COMMENT ON TABLE Audit IS 'System action auditing';
COMMENT ON TABLE Error_Log IS 'System error records';

-- =============================================
-- END OF SCRIPT
-- =============================================