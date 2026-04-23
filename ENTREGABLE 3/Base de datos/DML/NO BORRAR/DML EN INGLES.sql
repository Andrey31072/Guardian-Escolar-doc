-- =============================================
-- GPS GUARDIAN ESCOLAR - DML (TEST DATA)
-- Version: Final
-- April 2026
-- =============================================

-- =============================================
-- 1. DATA CLEANUP (optional, to reset)
-- =============================================

/*
TRUNCATE TABLE NotificationReceipt CASCADE;
TRUNCATE TABLE Coordinate CASCADE;
TRUNCATE TABLE Notification CASCADE;
TRUNCATE TABLE Journey CASCADE;
TRUNCATE TABLE Stop CASCADE;
TRUNCATE TABLE SafeZone CASCADE;
TRUNCATE TABLE User_Route CASCADE;
TRUNCATE TABLE NotificationConfig CASCADE;
TRUNCATE TABLE Student CASCADE;
TRUNCATE TABLE Route CASCADE;
TRUNCATE TABLE User_Session CASCADE;
TRUNCATE TABLE User_Role CASCADE;
TRUNCATE TABLE Role_Permission CASCADE;
TRUNCATE TABLE Activity_Log CASCADE;
TRUNCATE TABLE Audit CASCADE;
TRUNCATE TABLE Error_Log CASCADE;
TRUNCATE TABLE User CASCADE;
TRUNCATE TABLE Role CASCADE;
TRUNCATE TABLE Permission CASCADE;
*/

-- =============================================
-- 2. MASTER DATA INSERTION (SECURITY)
-- =============================================

-- Roles
INSERT INTO Role (RoleName, Description) VALUES 
    ('ADMIN', 'System administrator with full access'),
    ('PARENT', 'Parent who monitors their children');

-- Permissions
INSERT INTO Permission (PermissionName, Description) VALUES 
    ('CREATE_USER', 'Create new users'),
    ('EDIT_USER', 'Edit existing users'),
    ('DELETE_USER', 'Delete users'),
    ('VIEW_ALL_STUDENTS', 'View all students in the system'),
    ('VIEW_OWN_STUDENTS', 'View only their own students'),
    ('CREATE_ROUTE', 'Create routes'),
    ('EDIT_ROUTE', 'Edit routes'),
    ('DELETE_ROUTE', 'Delete routes'),
    ('CREATE_ZONE', 'Create safe zones'),
    ('EDIT_ZONE', 'Edit safe zones'),
    ('DELETE_ZONE', 'Delete safe zones'),
    ('VIEW_REPORTS', 'View system reports'),
    ('MANAGE_SYSTEM', 'Manage system configuration'),
    ('VIEW_LOGS', 'View system logs');

-- Assign permissions to roles (ADMIN has all)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM Role r, Permission p
WHERE r.RoleName = 'ADMIN';

-- Assign permissions to roles (PARENT has limited permissions)
INSERT INTO Role_Permission (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM Role r, Permission p
WHERE r.RoleName = 'PARENT' 
  AND p.PermissionName IN ('VIEW_OWN_STUDENTS', 'CREATE_ROUTE', 'EDIT_ROUTE', 'CREATE_ZONE', 'EDIT_ZONE', 'DELETE_ZONE');

-- =============================================
-- 3. USER INSERTION
-- =============================================

-- Passwords in plain text for reference: 'Password123!'
-- Hash generated with BCrypt (example)

-- Administrators
INSERT INTO User (FullName, Email, Phone, PasswordHash, UserType, Status, CreationDate) VALUES 
    ('Main Admin', 'admin@gpsguardian.com', '3001234567', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'ADMIN', true, NOW());

-- Parents
INSERT INTO User (FullName, Email, Phone, PasswordHash, UserType, Status, CreationDate) VALUES 
    ('Carlos Rodríguez', 'carlos.rodriguez@email.com', '3112345678', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PARENT', true, NOW()),
    ('María González', 'maria.gonzalez@email.com', '3223456789', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PARENT', true, NOW()),
    ('Jorge Martínez', 'jorge.martinez@email.com', '3334567890', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PARENT', true, NOW()),
    ('Laura Fernández', 'laura.fernandez@email.com', '3445678901', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrCqYqKjLqQkFjLqQkFjLqQkFjLqQkF', 'PARENT', true, NOW());

-- Assign roles to users
INSERT INTO User_Role (UserID, RoleID)
SELECT u.UserID, r.RoleID
FROM User u, Role r
WHERE u.UserType = r.RoleName;

-- =============================================
-- 4. STUDENT INSERTION
-- =============================================

-- Students of Carlos Rodríguez (UserID = 2)
INSERT INTO Student (UserID, FullName, GradeLevel, BirthDate, EmergencyContact, Status) VALUES 
    (2, 'Sofía Rodríguez Pérez', '5th Grade', '2014-03-15', '3112345678 - Carlos', true),
    (2, 'Mateo Rodríguez Pérez', '2nd Grade', '2016-07-22', '3112345678 - Carlos', true);

-- Students of María González (UserID = 3)
INSERT INTO Student (UserID, FullName, GradeLevel, BirthDate, EmergencyContact, Status) VALUES 
    (3, 'Valentina González López', '8th Grade', '2011-11-30', '3223456789 - María', true),
    (3, 'Samuel González López', '4th Grade', '2015-01-18', '3223456789 - María', true);

-- Students of Jorge Martínez (UserID = 4)
INSERT INTO Student (UserID, FullName, GradeLevel, BirthDate, EmergencyContact, Status) VALUES 
    (4, 'Isabella Martínez Rojas', '11th Grade', '2008-05-10', '3334567890 - Jorge', true);

-- Students of Laura Fernández (UserID = 5)
INSERT INTO Student (UserID, FullName, GradeLevel, BirthDate, EmergencyContact, Status) VALUES 
    (5, 'Lucas Fernández Torres', '1st Grade', '2017-09-05', '3445678901 - Laura', true),
    (5, 'Emma Fernández Torres', 'Pre-K', '2019-12-12', '3445678901 - Laura', true);

-- =============================================
-- 5. ROUTE INSERTION
-- =============================================

-- Routes created by Carlos Rodríguez (UserID = 2)
INSERT INTO Route (RouteName, Description, OriginLat, OriginLon, DestinationLat, DestinationLon, created_by) VALUES 
    ('San José School - Home Route', 'Route from San José School to home', 4.7110, -74.0721, 4.6980, -74.0850, 2),
    ('Home - Music Class Route', 'Route to the music academy', 4.6980, -74.0850, 4.7150, -74.0650, 2);

-- Routes created by María González (UserID = 3)
INSERT INTO Route (RouteName, Description, OriginLat, OriginLon, DestinationLat, DestinationLon, created_by) VALUES 
    ('La Esperanza School - Home Route', 'Daily route from school to home', 4.6350, -74.0820, 4.6500, -74.0980, 3);

-- Routes created by Jorge Martínez (UserID = 4)
INSERT INTO Route (RouteName, Description, OriginLat, OriginLon, DestinationLat, DestinationLon, created_by) VALUES 
    ('San Carlos School - Home Route', 'Route from San Carlos School', 4.6800, -74.0600, 4.6950, -74.0750, 4);

-- Routes created by Laura Fernández (UserID = 5)
INSERT INTO Route (RouteName, Description, OriginLat, OriginLon, DestinationLat, DestinationLon, created_by) VALUES 
    ('Kindergarten - Home Route', 'Route from kindergarten to home', 4.7200, -74.0800, 4.7080, -74.0900, 5);

-- Assign routes to users (User_Route relationship)
INSERT INTO User_Route (UserID, RouteID) VALUES
    (2, 1), (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- =============================================
-- 6. STOP INSERTION
-- =============================================

-- Stops for Route 1 (San José School - Home)
INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
    (1, 1, 'San José School', 4.7110, -74.0721),
    (1, 2, 'Main Park', 4.7050, -74.0780),
    (1, 3, 'Carlos Home', 4.6980, -74.0850);

-- Stops for Route 2 (Home - Music Class)
INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
    (2, 1, 'Carlos Home', 4.6980, -74.0850),
    (2, 2, 'Music Academy', 4.7150, -74.0650);

-- Stops for Route 3 (La Esperanza School - Home)
INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
    (3, 1, 'La Esperanza School', 4.6350, -74.0820),
    (3, 2, 'Public Library', 4.6400, -74.0880),
    (3, 3, 'María Home', 4.6500, -74.0980);

-- Stops for Route 4 (San Carlos School - Home)
INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
    (4, 1, 'San Carlos School', 4.6800, -74.0600),
    (4, 2, 'Shopping Center', 4.6880, -74.0680),
    (4, 3, 'Jorge Home', 4.6950, -74.0750);

-- Stops for Route 5 (Kindergarten - Home)
INSERT INTO Stop (RouteID, StopOrder, StopName, Latitude, Longitude) VALUES
    (5, 1, 'Kindergarten', 4.7200, -74.0800),
    (5, 2, 'Corner Bakery', 4.7140, -74.0850),
    (5, 3, 'Laura Home', 4.7080, -74.0900);

-- =============================================
-- 7. SAFE ZONE INSERTION
-- =============================================

-- Safe zones for Carlos' students
INSERT INTO SafeZone (UserID, StudentID, ZoneName, Latitude, Longitude, RadiusMeters, Active) VALUES
    (2, 1, 'Sofía Home', 4.6980, -74.0850, 50, true),
    (2, 1, 'San José School', 4.7110, -74.0721, 100, true),
    (2, 2, 'Mateo Home', 4.6980, -74.0850, 50, true),
    (2, 2, 'Music Academy', 4.7150, -74.0650, 80, true);

-- Safe zones for María's students
INSERT INTO SafeZone (UserID, StudentID, ZoneName, Latitude, Longitude, RadiusMeters, Active) VALUES
    (3, 3, 'Valentina Home', 4.6500, -74.0980, 50, true),
    (3, 3, 'La Esperanza School', 4.6350, -74.0820, 100, true),
    (3, 4, 'Samuel Home', 4.6500, -74.0980, 50, true);

-- Safe zones for Jorge's students
INSERT INTO SafeZone (UserID, StudentID, ZoneName, Latitude, Longitude, RadiusMeters, Active) VALUES
    (4, 5, 'Isabella Home', 4.6950, -74.0750, 50, true),
    (4, 5, 'San Carlos School', 4.6800, -74.0600, 100, true);

-- Safe zones for Laura's students
INSERT INTO SafeZone (UserID, StudentID, ZoneName, Latitude, Longitude, RadiusMeters, Active) VALUES
    (5, 6, 'Lucas Home', 4.7080, -74.0900, 50, true),
    (5, 7, 'Emma Home', 4.7080, -74.0900, 50, true),
    (5, 6, 'Kindergarten', 4.7200, -74.0800, 80, true),
    (5, 7, 'Kindergarten', 4.7200, -74.0800, 80, true);

-- =============================================
-- 8. NOTIFICATION CONFIGURATION INSERTION
-- =============================================

INSERT INTO NotificationConfig (UserID, DelayAlert, RouteChangeAlert, ArrivalAlert) VALUES
    (1, true, true, true),   -- Admin
    (2, true, true, true),   -- Carlos
    (3, true, false, true),  -- María (doesn't want route change alerts)
    (4, true, true, false),  -- Jorge (doesn't want arrival alerts)
    (5, false, true, true);  -- Laura (doesn't want delay alerts)

-- =============================================
-- 9. JOURNEY INSERTION
-- =============================================

-- Completed journeys
INSERT INTO Journey (StudentID, RouteID, StartDateTime, EndDateTime, Status, HasDeviation, created_by) VALUES
    (1, 1, '2026-04-01 07:00:00', '2026-04-01 07:45:00', 'COMPLETED', false, 2),
    (1, 1, '2026-04-02 07:00:00', '2026-04-02 07:50:00', 'COMPLETED', true, 2),
    (2, 2, '2026-04-01 15:30:00', '2026-04-01 16:00:00', 'COMPLETED', false, 2),
    (3, 3, '2026-04-01 06:45:00', '2026-04-01 07:30:00', 'COMPLETED', false, 3),
    (3, 3, '2026-04-02 06:45:00', '2026-04-02 07:35:00', 'COMPLETED', true, 3),
    (5, 4, '2026-04-01 07:15:00', '2026-04-01 07:55:00', 'COMPLETED', false, 4),
    (6, 5, '2026-04-01 08:00:00', '2026-04-01 08:30:00', 'COMPLETED', false, 5);

-- Ongoing journeys
INSERT INTO Journey (StudentID, RouteID, StartDateTime, Status, HasDeviation, created_by) VALUES
    (1, 1, NOW(), 'IN_PROGRESS', false, 2),
    (3, 3, NOW(), 'IN_PROGRESS', false, 3),
    (6, 5, NOW(), 'IN_PROGRESS', false, 5);

-- =============================================
-- 10. COORDINATE INSERTION (simulating a journey)
-- =============================================

-- Coordinates for JourneyID 1 (Sofía, school-home route, 2026-04-01)
INSERT INTO Coordinate (JourneyID, Latitude, Longitude, DateTime, Speed) VALUES
    (1, 4.7110, -74.0721, '2026-04-01 07:00:00', 0),
    (1, 4.7100, -74.0730, '2026-04-01 07:05:00', 25.5),
    (1, 4.7080, -74.0750, '2026-04-01 07:10:00', 30.2),
    (1, 4.7050, -74.0780, '2026-04-01 07:15:00', 0),
    (1, 4.7040, -74.0790, '2026-04-01 07:20:00', 28.5),
    (1, 4.7010, -74.0820, '2026-04-01 07:30:00', 32.0),
    (1, 4.6980, -74.0850, '2026-04-01 07:45:00', 0);

-- Coordinates for JourneyID 4 (Valentina, school-home route, 2026-04-01)
INSERT INTO Coordinate (JourneyID, Latitude, Longitude, DateTime, Speed) VALUES
    (4, 4.6350, -74.0820, '2026-04-01 06:45:00', 0),
    (4, 4.6370, -74.0840, '2026-04-01 06:52:00', 28.0),
    (4, 4.6400, -74.0880, '2026-04-01 07:00:00', 0),
    (4, 4.6430, -74.0910, '2026-04-01 07:10:00', 26.5),
    (4, 4.6470, -74.0950, '2026-04-01 07:20:00', 30.0),
    (4, 4.6500, -74.0980, '2026-04-01 07:30:00', 0);

-- =============================================
-- 11. NOTIFICATION INSERTION
-- =============================================

-- Notifications for journeys
INSERT INTO Notification (JourneyID, EventType, Message, DateTime, SentStatus) VALUES
    (1, 'DESTINATION_ARRIVAL', 'Sofía has arrived at her destination (Home)', '2026-04-01 07:45:00', true),
    (2, 'ROUTE_DEVIATION', 'Mateo has deviated from the planned route', '2026-04-02 07:30:00', true),
    (4, 'DELAY', 'Valentina has a 10-minute delay', '2026-04-01 07:15:00', true),
    (5, 'ROUTE_DEVIATION', 'Valentina has deviated from the route', '2026-04-02 07:20:00', true),
    (6, 'DESTINATION_ARRIVAL', 'Isabella has arrived at her destination', '2026-04-01 07:55:00', true),
    (7, 'SAFE_ZONE_ARRIVAL', 'Lucas has arrived at the Kindergarten', '2026-04-01 08:30:00', true);

-- Notifications for safe zone arrivals (related to SafeZone)
INSERT INTO Notification (ZoneID, EventType, Message, DateTime, SentStatus) VALUES
    (1, 'SAFE_ZONE_ARRIVAL', 'Sofía has arrived at Safe Zone: Sofía Home', '2026-04-01 07:45:00', true),
    (2, 'SAFE_ZONE_ARRIVAL', 'Sofía has arrived at Safe Zone: San José School', '2026-04-01 06:55:00', true),
    (5, 'SAFE_ZONE_ARRIVAL', 'Valentina has arrived at Safe Zone: Valentina Home', '2026-04-01 07:30:00', true),
    (8, 'SAFE_ZONE_ARRIVAL', 'Isabella has arrived at Safe Zone: Isabella Home', '2026-04-01 07:55:00', true),
    (10, 'SAFE_ZONE_ARRIVAL', 'Lucas has arrived at Safe Zone: Kindergarten', '2026-04-01 08:30:00', true);

-- =============================================
-- 12. NOTIFICATION RECEIPT INSERTION
-- =============================================

INSERT INTO NotificationReceipt (NotificationID, UserID, IsRead, ReceiveDate, ReadDate) VALUES
    (1, 2, true, '2026-04-01 07:45:05', '2026-04-01 07:46:00'),
    (2, 2, true, '2026-04-02 07:30:05', '2026-04-02 07:32:00'),
    (3, 3, true, '2026-04-01 07:15:10', '2026-04-01 07:16:00'),
    (4, 3, false, '2026-04-02 07:20:08', NULL),
    (5, 4, true, '2026-04-01 07:55:03', '2026-04-01 07:57:00'),
    (6, 5, true, '2026-04-01 08:30:02', '2026-04-01 08:31:00'),
    (7, 2, true, '2026-04-01 07:45:05', '2026-04-01 07:46:00'),
    (9, 3, true, '2026-04-01 07:30:10', '2026-04-01 07:31:00');

-- =============================================
-- 13. SECURITY CONFIGURATIONS INSERTION
-- =============================================

INSERT INTO Password_Policy (MinLength, MaxLength, RequireUppercase, RequireNumbers, RequireSymbols, ExpirationDays, updated_by) VALUES
    (10, 128, true, true, true, 90, 1);

INSERT INTO Security_Configuration (ConfigurationName, ConfigurationValue, Description, updated_by) VALUES
    ('SESSION_TIMEOUT_MINUTES', '30', 'Inactivity time to close session', 1),
    ('MAX_LOGIN_ATTEMPTS', '5', 'Maximum failed attempts before blocking', 1),
    ('BLOCK_DURATION_MINUTES', '10', 'Block duration after failed attempts', 1),
    ('GPS_UPDATE_INTERVAL_SECONDS', '30', 'GPS update interval in seconds', 1),
    ('INACTIVITY_ALERT_MINUTES', '5', 'Inactivity time to generate alert', 1);

-- =============================================
-- 14. LOGS INSERTION (examples)
-- =============================================

-- Activity Logs
INSERT INTO Activity_Log (UserID, ActionType, Description, OriginIp, Metadata) VALUES
    (2, 'LOGIN', 'Successful login', '192.168.1.100', '{"browser": "Chrome", "os": "Windows"}'),
    (2, 'VIEW_LOCATION', 'Viewing Sofía location', '192.168.1.100', '{"student": "Sofía Rodríguez", "journey_id": 1}'),
    (3, 'LOGIN', 'Successful login', '192.168.1.101', '{"browser": "Firefox", "os": "Android"}'),
    (2, 'CREATE_ZONE', 'Safe zone creation', '192.168.1.100', '{"zone": "Sofía Home", "student": "Sofía"}'),
    (4, 'LOGIN_FAILED', 'Failed login attempt', '10.0.0.50', '{"reason": "Incorrect password"}'),
    (1, 'ADMIN_ACTION', 'System configuration updated', '192.168.1.1', '{"setting": "SESSION_TIMEOUT_MINUTES", "new_value": "30"}');

-- Audit Logs
INSERT INTO Audit (UserID, Action, Description, OriginIp, Metadata) VALUES
    (1, 'USER_CREATED', 'Creation of new parent user', '192.168.1.1', '{"user": "carlos.rodriguez@email.com"}'),
    (2, 'STUDENT_CREATED', 'New student registration', '192.168.1.100', '{"student": "Sofía Rodríguez"}'),
    (2, 'ROUTE_CREATED', 'Creation of new route', '192.168.1.100', '{"route": "San José School - Home Route"}'),
    (1, 'ROLE_ASSIGNED', 'Role assignment to user', '192.168.1.1', '{"user": "maria.gonzalez@email.com", "role": "PARENT"}');

-- Error Logs
INSERT INTO Error_Log (UserID, ErrorType, Description, StackTrace, OriginIp, Metadata) VALUES
    (3, 'GPS_TIMEOUT', 'Timeout receiving GPS coordinates', 'Error at line 245: Connection timeout', '192.168.1.101', '{"journey_id": 4}'),
    (NULL, 'DATABASE_CONNECTION', 'Database connection error', 'Connection refused', '127.0.0.1', '{"service": "backend"}'),
    (5, 'NOTIFICATION_FAILED', 'Failed to send push notification', 'Firebase error: Invalid token', '192.168.1.102', '{"notification_id": 6, "token": "expired"}');

-- =============================================
-- 15. SESSION INSERTION (example)
-- =============================================

INSERT INTO User_Session (UserID, Token, StartedAt, OriginIp, SessionStatus) VALUES
    (2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjIsInJvbGUiOiJQQURSRSJ9.example1', NOW(), '192.168.1.100', 'ACTIVE'),
    (3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjMsInJvbGUiOiJQQURSRSJ9.example2', NOW() - INTERVAL '2 hours', '192.168.1.101', 'ACTIVE'),
    (1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjEsInJvbGUiOiJBRE1JTiJ9.example3', NOW() - INTERVAL '1 day', '192.168.1.1', 'EXPIRED');

-- =============================================
-- END OF DML
-- =============================================

-- Verification query (optional)
/*
SELECT 'Total Users: ' || COUNT(*) FROM User
UNION ALL
SELECT 'Total Students: ' || COUNT(*) FROM Student
UNION ALL
SELECT 'Total Routes: ' || COUNT(*) FROM Route
UNION ALL
SELECT 'Total Journeys: ' || COUNT(*) FROM Journey
UNION ALL
SELECT 'Total Notifications: ' || COUNT(*) FROM Notification;
*/