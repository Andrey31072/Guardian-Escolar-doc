
---

## DATA DICTIONARY - GPS SCHOOL GUARDIAN v3.3.1

---
### TABLE 1: User

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique user identifier (PK) |
| FullName | VARCHAR(100) | NO | - | User's full name |
| Email | VARCHAR(100) | NO | - | Email address (unique, used for login) |
| Phone | VARCHAR(30) | YES | - | Contact phone number |
| PasswordHash | VARCHAR(255) | NO | - | Password hash (BCrypt) |
| IsActive | BOOLEAN | YES | true | User active/inactive status |
| EmailVerified | BOOLEAN | YES | false | Indicates if email was verified (RF1.2.1) |
| EmailVerificationToken | VARCHAR(255) | YES | - | Unique token for email verification |
| EmailVerificationExpiry | TIMESTAMPTZ | YES | - | Email verification token expiration date |
| PasswordResetToken | VARCHAR(255) | YES | - | Unique token for password reset (RF1.4) |
| PasswordResetExpiry | TIMESTAMPTZ | YES | - | Password reset token expiration date |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 2: Route

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique route identifier (PK) |
| RouteName | VARCHAR(100) | NO | - | Descriptive route name |
| Description | TEXT | YES | - | Additional route description |
| OriginLat | DECIMAL(9,6) | YES | - | Origin point latitude |
| OriginLon | DECIMAL(9,6) | YES | - | Origin point longitude |
| DestinationLat | DECIMAL(9,6) | YES | - | Final destination latitude |
| DestinationLon | DECIMAL(9,6) | YES | - | Final destination longitude |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 3: Student

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique student identifier (PK) |
| UserID | UUID | NO | - | Associated parent (FK to User) |
| FullName | VARCHAR(100) | NO | - | Student's full name |
| SchoolGrade | school_grade_enum | YES | - | School grade (PRE_KINDERGARTEN to ELEVENTH) |
| BirthDate | DATE | YES | - | Date of birth |
| IsActive | BOOLEAN | YES | true | Active/inactive status |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 4: Student_Route (Student-Route Relationship)

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| StudentID | UUID | NO | - | Student ID (FK to Student) - Composite PK |
| RouteID | UUID | NO | - | Route ID (FK to Route) - Composite PK |
| IsActive | BOOLEAN | YES | true | Indicates if assignment is active |
| AssignedAt | TIMESTAMPTZ | YES | NOW() | Route assignment date |

---

### TABLE 5: EmergencyContact

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique contact identifier (PK) |
| StudentID | UUID | NO | - | Associated student (FK to Student) |
| FullName | VARCHAR(100) | NO | - | Contact's full name |
| Phone | VARCHAR(30) | NO | - | Contact's phone number |
| Relationship | VARCHAR(50) | YES | - | Relationship (Mother, Father, Grandparent, etc.) |
| IsPrimary | BOOLEAN | YES | false | Indicates if it's the primary contact |
| IsActive | BOOLEAN | YES | true | Active/inactive status |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 6: Stop

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique stop identifier (PK) |
| RouteID | UUID | NO | - | Parent route (FK to Route) |
| StopOrder | INTEGER | NO | - | Sequential order on the route |
| StopName | VARCHAR(100) | YES | - | Descriptive stop name |
| Latitude | DECIMAL(9,6) | NO | - | Latitude coordinate |
| Longitude | DECIMAL(9,6) | NO | - | Longitude coordinate |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 7: SafeZone

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique zone identifier (PK) |
| StudentID | UUID | NO | - | Associated student (FK to Student) |
| ZoneName | VARCHAR(100) | NO | - | Descriptive zone name |
| Latitude | DECIMAL(9,6) | NO | - | Zone center latitude |
| Longitude | DECIMAL(9,6) | NO | - | Zone center longitude |
| RadiusMeters | INTEGER | NO | CHECK > 0 | Coverage radius in meters |
| InactivityThresholdSeconds | INTEGER | NO | 300 | Inactivity time to trigger alert (RF4.1.1) |
| IsActive | BOOLEAN | YES | true | Whether the zone is active |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 8: NotificationConfig

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| UserID | UUID | NO | - | Associated user (FK to User) |
| DelayAlert | BOOLEAN | YES | true | Receive delay alerts (RF4.2) |
| RouteChangeAlert | BOOLEAN | YES | true | Receive route change alerts (RF4.2) |
| ArrivalAlert | BOOLEAN | YES | true | Receive arrival alerts (RF4.2) |
| InactivityAlert | BOOLEAN | YES | true | Receive inactivity alerts (RF4.2) |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 9: Trip

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| StudentID | UUID | NO | - | Student making the trip (FK to Student) |
| RouteID | UUID | NO | - | Route followed (FK to Route) |
| StartDateTime | TIMESTAMPTZ | NO | - | Trip start time |
| EndDateTime | TIMESTAMPTZ | YES | - | Trip end time |
| Status | trip_status_enum | YES | 'PENDING' | Status: PENDING, IN_PROGRESS, COMPLETED, CANCELLED |
| HasDetour | BOOLEAN | YES | false | Whether there was a route detour (RF3.5) |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| DeletedAt | TIMESTAMPTZ | YES | - | Soft delete date |
| CreatedBy | UUID | YES | - | User who created the record (FK to User) |
| UpdatedBy | UUID | YES | - | User who modified the record (FK to User) |

---

### TABLE 10: Coordinate

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| TripID | UUID | NO | - | Associated trip (FK to Trip) |
| Latitude | DECIMAL(9,6) | NO | - | Latitude coordinate |
| Longitude | DECIMAL(9,6) | NO | - | Longitude coordinate |
| RecordedAt | TIMESTAMPTZ | NO | - | Recording timestamp |
| SpeedKmh | DECIMAL(5,1) | YES | - | Speed in km/h |
| StopDurationSeconds | INTEGER | YES | 0 | Stop duration in seconds |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 11: Notification

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| TripID | UUID | YES | - | Related trip (FK to Trip) |
| ZoneID | UUID | YES | - | Related safe zone (FK to SafeZone) |
| EventType | VARCHAR(50) | NO | - | Event type (detour, delay, arrival, etc.) |
| Message | TEXT | NO | - | Notification content |
| EventDateTime | TIMESTAMPTZ | YES | CURRENT_TIMESTAMP | Event date and time |
| IsSent | BOOLEAN | YES | false | Whether it was sent successfully |

---

### TABLE 12: NotificationReceipt

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| NotificationID | UUID | NO | - | Received notification (FK to Notification) |
| UserID | UUID | NO | - | User who received it (FK to User) |
| IsRead | BOOLEAN | YES | false | Whether it was read |
| ReceivedAt | TIMESTAMPTZ | YES | CURRENT_TIMESTAMP | Receipt timestamp |
| ReadAt | TIMESTAMPTZ | YES | - | Read timestamp |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 13: Role

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| RoleName | role_name_enum | NO | - | Role name: ADMIN, PARENT |
| Description | VARCHAR(255) | YES | - | Role description |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 14: Permission

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| PermissionName | VARCHAR(100) | NO | - | Permission name (unique) |
| Description | TEXT | YES | - | Permission description |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 15: User_Role (User Role Assignment)

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| UserID | UUID | NO | - | User (FK to User) - Composite PK |
| RoleID | UUID | NO | - | Role (FK to Role) - Composite PK |
| AssignedAt | TIMESTAMPTZ | YES | CURRENT_TIMESTAMP | Role assignment date |

---

### TABLE 16: Role_Permission (Role Permission Assignment)

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| RoleID | UUID | NO | - | Role (FK to Role) - Composite PK |
| PermissionID | UUID | NO | - | Permission (FK to Permission) - Composite PK |

---

### TABLE 17: UserSession

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| UserID | UUID | NO | - | Associated user (FK to User) |
| Token | VARCHAR(500) | NO | - | JWT session token |
| StartedAt | TIMESTAMPTZ | YES | CURRENT_TIMESTAMP | Session start time |
| EndedAt | TIMESTAMPTZ | YES | - | Session end time |
| OriginIp | INET | YES | - | Source IP address |
| SessionStatus | session_status_enum | YES | 'ACTIVE' | Status: ACTIVE, EXPIRED, LOGOUT |
| CreatedAt | TIMESTAMPTZ | YES | NOW() | Record creation date |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |

---

### TABLE 18: PasswordPolicy

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| MinLength | INT | YES | 10 | Minimum password length |
| MaxLength | INT | YES | 128 | Maximum password length |
| RequireUppercase | BOOLEAN | YES | true | Requires uppercase letters |
| RequireNumbers | BOOLEAN | YES | true | Requires numbers |
| RequireSymbols | BOOLEAN | YES | true | Requires symbols |
| ExpirationDays | INT | YES | 90 | Password expiration days |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| UpdatedBy | UUID | YES | - | User who modified it (FK to User) |

---

### TABLE 19: SecurityConfiguration

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| ConfigName | VARCHAR(100) | NO | - | Configuration name (unique) |
| ConfigValue | TEXT | YES | - | Configuration value |
| Description | TEXT | YES | - | Configuration description |
| UpdatedAt | TIMESTAMPTZ | YES | NOW() | Last modification date |
| UpdatedBy | UUID | YES | - | User who modified it (FK to User) |

---

### TABLE 20: ActivityLog

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| UserID | UUID | YES | - | User who performed the action (FK to User) |
| ActionType | VARCHAR(50) | NO | - | Action type (LOGIN, LOGOUT, VIEW, etc.) |
| Description | TEXT | YES | - | Action description |
| OriginIp | INET | YES | - | Source IP address |
| Metadata | JSONB | YES | - | Additional data in JSON format |
| CreatedAt | TIMESTAMP | YES | CURRENT_TIMESTAMP | Record timestamp |

---

### TABLE 21: AuditLog

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| UserID | UUID | YES | - | User who performed the action (FK to User) |
| Action | VARCHAR(255) | NO | - | Action performed (CREATE, UPDATE, DELETE) |
| Description | TEXT | YES | - | Detailed action description |
| OriginIp | INET | YES | - | Source IP address |
| Application | VARCHAR(100) | YES | 'GPS_Guardian' | Source application |
| Metadata | JSONB | YES | - | Additional data in JSON format |
| CreatedAt | TIMESTAMP | YES | CURRENT_TIMESTAMP | Record timestamp |

---

### TABLE 22: ErrorLog

| Field | Type | Null | Default | Description |
|-------|------|------|---------|-------------|
| ID | UUID | NO | gen_random_uuid() | Unique identifier (PK) |
| UserID | UUID | YES | - | Affected user (FK to User) |
| ErrorType | VARCHAR(100) | NO | - | Error type |
| Description | TEXT | YES | - | Error description |
| StackTrace | TEXT | YES | - | Error stack trace |
| OriginIp | INET | YES | - | Source IP address |
| Metadata | JSONB | YES | - | Additional data in JSON format |
| CreatedAt | TIMESTAMP | YES | CURRENT_TIMESTAMP | Error timestamp |

---

## ENUMS

| Enum | Values | Description |
|------|--------|-------------|
| school_grade_enum | PRE_KINDERGARTEN, KINDERGARTEN, TRANSITION, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH | School grades |
| trip_status_enum | PENDING, IN_PROGRESS, COMPLETED, CANCELLED | Trip statuses |
| session_status_enum | ACTIVE, EXPIRED, LOGOUT | Session statuses |
| role_name_enum | ADMIN, PARENT | System roles |

---

## TABLE SUMMARY

| # | Table | Description |
|---|-------|-------------|
| 1 | User | System users |
| 2 | Route | School service routes |
| 3 | Student | Students associated with a parent |
| 4 | Student_Route | N:M relationship between students and routes |
| 5 | EmergencyContact | Emergency contacts |
| 6 | Stop | Route stops |
| 7 | SafeZone | Registered safe zones |
| 8 | NotificationConfig | Notification configuration |
| 9 | Trip | Completed trips |
| 10 | Coordinate | Recorded GPS coordinates |
| 11 | Notification | Generated notifications |
| 12 | NotificationReceipt | Notification receipts |
| 13 | Role | System roles |
| 14 | Permission | System permissions |
| 15 | User_Role | Role assignments to users |
| 16 | Role_Permission | Permission assignments to roles |
| 17 | UserSession | User sessions |
| 18 | PasswordPolicy | Password policies |
| 19 | SecurityConfiguration | Security configurations |
| 20 | ActivityLog | Activity log |
| 21 | AuditLog | Audit log |
| 22 | ErrorLog | Error log |