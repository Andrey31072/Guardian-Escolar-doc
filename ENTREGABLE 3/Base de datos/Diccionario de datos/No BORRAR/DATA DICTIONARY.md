# DATA DICTIONARY - GPS GUARDIAN ESCOLAR

## MAIN TABLES

### 1. User

Stores information about system users (parents and administrators).

| Field          | Type        | Length | Null | Default           | Description                                   |
| -------------- | ----------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| UserID         | SERIAL      | -      | NO   | AUTO              | Unique user identifier (PK)                    |
| FullName       | VARCHAR     | 255    | NO   | -                 | User's full name                               |
| Email          | VARCHAR     | 100    | NO   | -                 | Email address (unique, used for login)        |
| Phone          | VARCHAR     | 20     | YES  | -                 | Contact phone number                          |
| PasswordHash   | VARCHAR     | 255    | NO   | -                 | Password hash (BCrypt)                         |
| UserType       | VARCHAR     | 20     | NO   | 'PARENT'          | Type: ADMIN or PARENT                          |
| Status         | BOOLEAN     | -      | YES  | true              | Active/inactive user status                    |
| CreationDate   | TIMESTAMP   | -      | YES  | CURRENT_TIMESTAMP | User registration date                         |
| LastAccess     | TIMESTAMP   | -      | YES  | -                 | Last login date and time                       |
| created_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                          |
| updated_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: last modification date                 |
| deleted_at     | TIMESTAMPTZ | -      | YES  | -                 | Audit: soft delete date                       |
| created_by     | INTEGER     | -      | YES  | -                 | Audit: user who created (FK User)             |
| updated_by     | INTEGER     | -      | YES  | -                 | Audit: user who modified (FK User)            |

---

### 2. Student

Stores information about students associated with a parent.

| Field             | Type        | Length | Null | Default           | Description                                    |
| ----------------- | ----------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| StudentID         | SERIAL      | -      | NO   | AUTO              | Unique student identifier (PK)                 |
| UserID            | INTEGER     | -      | NO   | -                 | Associated parent (FK User)                    |
| FullName          | VARCHAR     | 255    | NO   | -                 | Student's full name                            |
| GradeLevel        | VARCHAR     | 50     | YES  | -                 | Current grade level                            |
| BirthDate         | DATE        | -      | YES  | -                 | Birth date                                     |
| EmergencyContact  | VARCHAR     | 100    | YES  | -                 | Emergency contact name and phone               |
| Status            | BOOLEAN     | -      | YES  | true              | Active/inactive status                         |
| created_at        | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                          |
| updated_at        | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: modification date                      |
| deleted_at        | TIMESTAMPTZ | -      | YES  | -                 | Audit: soft delete                            |
| created_by        | INTEGER     | -      | YES  | -                 | Audit: creator user (FK User)                 |
| updated_by        | INTEGER     | -      | YES  | -                 | Audit: modifier user (FK User)                |

---

### 3. Route

Stores routes created by parents for their students.

| Field          | Type        | Length | Null | Default           | Description                                    |
| -------------- | ----------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| RouteID        | SERIAL      | -      | NO   | AUTO              | Unique route identifier (PK)                   |
| RouteName      | VARCHAR     | 255    | NO   | -                 | Descriptive route name                         |
| Description    | TEXT        | -      | YES  | -                 | Additional description                         |
| OriginLat      | DECIMAL     | 10,8   | YES  | -                 | Origin point latitude                          |
| OriginLon      | DECIMAL     | 11,8   | YES  | -                 | Origin point longitude                         |
| DestinationLat | DECIMAL     | 10,8   | YES  | -                 | Final destination latitude                     |
| DestinationLon | DECIMAL     | 11,8   | YES  | -                 | Final destination longitude                    |
| created_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                          |
| updated_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: modification date                      |
| deleted_at     | TIMESTAMPTZ | -      | YES  | -                 | Audit: soft delete                            |
| created_by     | INTEGER     | -      | YES  | -                 | Audit: creator user (FK User)                 |
| updated_by     | INTEGER     | -      | YES  | -                 | Audit: modifier user (FK User)                |

---

### 4. Stop

Stores stops that make up a route.

| Field      | Type        | Length | Null | Default | Description                           |
| ---------- | ----------- | ------ | ---- | ------- | ------------------------------------- |
| StopID     | SERIAL      | -      | NO   | AUTO    | Unique stop identifier (PK)           |
| RouteID    | INTEGER     | -      | NO   | -       | Associated route (FK Route)           |
| StopOrder  | INTEGER     | -      | NO   | -       | Sequential order on the route         |
| StopName   | VARCHAR     | 100    | YES  | -       | Descriptive stop name                 |
| Latitude   | DECIMAL     | 10,8   | NO   | -       | Latitude coordinate                    |
| Longitude  | DECIMAL     | 11,8   | NO   | -       | Longitude coordinate                   |
| created_at | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: creation date                  |
| updated_at | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: modification date              |

---

### 5. SafeZone

Stores trusted zones registered by parents for their students.

| Field         | Type        | Length | Null | Default     | Description                                    |
| ------------- | ----------- | ------ | ---- | ----------- | ---------------------------------------------- |
| ZoneID        | SERIAL      | -      | NO   | AUTO        | Unique zone identifier (PK)                    |
| UserID        | INTEGER     | -      | NO   | -           | User who registered the zone (FK User)         |
| StudentID     | INTEGER     | -      | NO   | -           | Associated student (FK Student)                |
| ZoneName      | VARCHAR     | 100    | NO   | -           | Descriptive zone name                          |
| Latitude      | DECIMAL     | 10,8   | NO   | -           | Zone center latitude                           |
| Longitude     | DECIMAL     | 11,8   | NO   | -           | Zone center longitude                          |
| RadiusMeters  | INTEGER     | -      | NO   | CHECK > 0   | Coverage radius in meters                      |
| Active        | BOOLEAN     | -      | YES  | true        | Whether the zone is active                     |
| created_at    | TIMESTAMPTZ | -      | YES  | NOW()       | Audit: creation date                          |
| updated_at    | TIMESTAMPTZ | -      | YES  | NOW()       | Audit: modification date                      |
| deleted_at    | TIMESTAMPTZ | -      | YES  | -           | Audit: soft delete                            |
| created_by    | INTEGER     | -      | YES  | -           | Audit: creator user (FK User)                 |
| updated_by    | INTEGER     | -      | YES  | -           | Audit: modifier user (FK User)                |

---

### 6. NotificationConfig

Stores user notification preferences.

| Field            | Type        | Length | Null | Default | Description                           |
| ---------------- | ----------- | ------ | ---- | ------- | ------------------------------------- |
| ConfigID         | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                |
| UserID           | INTEGER     | -      | NO   | -       | Associated user (FK User)             |
| DelayAlert       | BOOLEAN     | -      | YES  | true    | Receive delay alerts                  |
| RouteChangeAlert | BOOLEAN     | -      | YES  | true    | Receive route change alerts           |
| ArrivalAlert     | BOOLEAN     | -      | YES  | true    | Receive arrival alerts                |
| created_at       | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: creation date                  |
| updated_at       | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: modification date              |

---

### 7. Journey

Stores journeys taken by students.

| Field           | Type        | Length | Null | Default           | Description                                           |
| --------------- | ----------- | ------ | ---- | ----------------- | ----------------------------------------------------- |
| JourneyID       | SERIAL      | -      | NO   | AUTO              | Unique identifier (PK)                               |
| StudentID       | INTEGER     | -      | NO   | -                 | Student taking the journey (FK)                       |
| RouteID         | INTEGER     | -      | NO   | -                 | Route followed (FK Route)                             |
| StartDateTime   | TIMESTAMP   | -      | NO   | -                 | Journey start time                                    |
| EndDateTime     | TIMESTAMP   | -      | YES  | -                 | Journey end time                                      |
| Status          | VARCHAR     | 20     | YES  | 'PENDING'         | Status: PENDING, IN_PROGRESS, COMPLETED, CANCELLED   |
| HasDeviation    | BOOLEAN     | -      | YES  | false             | Whether there was a route deviation                  |
| created_at      | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                                 |
| updated_at      | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: modification date                             |
| deleted_at      | TIMESTAMPTZ | -      | YES  | -                 | Audit: soft delete                                   |
| created_by      | INTEGER     | -      | YES  | -                 | Audit: creator user (FK User)                        |
| updated_by      | INTEGER     | -      | YES  | -                 | Audit: modifier user (FK User)                       |

---

### 8. Coordinate

Stores GPS coordinate records during a journey.

| Field       | Type        | Length | Null | Default | Description                           |
| ----------- | ----------- | ------ | ---- | ------- | ------------------------------------- |
| CoordID     | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                |
| JourneyID   | INTEGER     | -      | NO   | -       | Associated journey (FK Journey)        |
| Latitude    | DECIMAL     | 10,8   | NO   | -       | Latitude coordinate                    |
| Longitude   | DECIMAL     | 11,8   | NO   | -       | Longitude coordinate                   |
| DateTime    | TIMESTAMP   | -      | NO   | -       | Record timestamp                       |
| Speed       | DECIMAL     | 5,2    | YES  | -       | Speed in km/h                          |
| created_at  | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: creation date                  |
| updated_at  | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: modification date              |

---

### 9. Notification

Stores notifications generated by the system.

| Field           | Type      | Length | Null | Default           | Description                                                |
| --------------- | --------- | ------ | ---- | ----------------- | ---------------------------------------------------------- |
| NotificationID  | SERIAL    | -      | NO   | AUTO              | Unique identifier (PK)                                     |
| JourneyID       | INTEGER   | -      | YES  | -                 | Related journey (FK Journey)                               |
| ZoneID          | INTEGER   | -      | YES  | -                 | Related safe zone (FK SafeZone)                            |
| EventType       | VARCHAR   | 50     | NO   | -                 | Type: DESTINATION_ARRIVAL, ROUTE_DEVIATION, DELAY, SAFE_ZONE_ARRIVAL |
| Message         | TEXT      | -      | NO   | -                 | Notification content                                        |
| DateTime        | TIMESTAMP | -      | YES  | CURRENT_TIMESTAMP | Generation date and time                                   |
| SentStatus      | BOOLEAN   | -      | YES  | false             | Whether it was sent successfully                           |

---

### 10. NotificationReceipt

Records notification receipt and reading by users.

| Field           | Type        | Length | Null | Default           | Description                                |
| --------------- | ----------- | ------ | ---- | ----------------- | ------------------------------------------ |
| ReceiptID       | SERIAL      | -      | NO   | AUTO              | Unique identifier (PK)                     |
| NotificationID  | INTEGER     | -      | NO   | -                 | Received notification (FK Notification)    |
| UserID          | INTEGER     | -      | NO   | -                 | User who received it (FK User)             |
| IsRead          | BOOLEAN     | -      | YES  | false             | Whether it was read                        |
| ReceiveDate     | TIMESTAMP   | -      | YES  | CURRENT_TIMESTAMP | Reception time                             |
| ReadDate        | TIMESTAMP   | -      | YES  | -                 | Reading time                               |
| created_at      | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                      |
| updated_at      | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: modification date                  |

---

## RELATIONSHIP TABLES

### 11. User_Route

Many-to-many relationship between users and routes (parents who create routes).

| Field       | Type        | Length | Null | Default | Description                               |
| ----------- | ----------- | ------ | ---- | ------- | ----------------------------------------- |
| UserID      | INTEGER     | -      | NO   | -       | User (FK User) - Composite PK             |
| RouteID     | INTEGER     | -      | NO   | -       | Route (FK Route) - Composite PK           |
| created_at  | TIMESTAMPTZ | -      | YES  | NOW()   | Relationship creation date                |

---

## SECURITY TABLES

### 12. Role

Defines system roles.

| Field       | Type        | Length | Null | Default | Description                           |
| ----------- | ----------- | ------ | ---- | ------- | ------------------------------------- |
| RoleID      | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                |
| RoleName    | VARCHAR     | 20     | NO   | -       | Role name: ADMIN, PARENT               |
| Description | VARCHAR     | 255    | YES  | -       | Role description                      |
| created_at  | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: creation date                  |
| updated_at  | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: modification date              |

---

### 13. Permission

Defines available permissions in the system.

| Field           | Type        | Length | Null | Default | Description                           |
| --------------- | ----------- | ------ | ---- | ------- | ------------------------------------- |
| PermissionID    | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                |
| PermissionName  | VARCHAR     | 100    | NO   | -       | Permission name                        |
| Description     | TEXT        | -      | YES  | -       | Permission description                 |
| created_at      | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: creation date                  |
| updated_at      | TIMESTAMPTZ | -      | YES  | NOW()   | Audit: modification date              |

---

### 14. User_Role

Assigns roles to users.

| Field       | Type      | Length | Null | Default           | Description                           |
| ----------- | --------- | ------ | ---- | ----------------- | ------------------------------------- |
| UserID      | INTEGER   | -      | NO   | -                 | User (FK User) - Composite PK         |
| RoleID      | INTEGER   | -      | NO   | -                 | Role (FK Role) - Composite PK         |
| AssignedAt  | TIMESTAMP | -      | YES  | CURRENT_TIMESTAMP | Assignment date                       |

---

### 15. Role_Permission

Assigns permissions to roles.

| Field         | Type    | Length | Null | Default | Description                               |
| ------------- | ------- | ------ | ---- | ------- | ----------------------------------------- |
| RoleID        | INTEGER | -      | NO   | -       | Role (FK Role) - Composite PK             |
| PermissionID  | INTEGER | -      | NO   | -       | Permission (FK Permission) - Composite PK |

---

### 16. User_Session

Manages active user sessions.

| Field          | Type        | Length | Null | Default           | Description                               |
| -------------- | ----------- | ------ | ---- | ----------------- | ----------------------------------------- |
| SessionID      | SERIAL      | -      | NO   | AUTO              | Unique identifier (PK)                    |
| UserID         | INTEGER     | -      | NO   | -                 | Associated user (FK User)                 |
| Token          | VARCHAR     | 500    | NO   | -                 | JWT session token                         |
| StartedAt      | TIMESTAMP   | -      | YES  | CURRENT_TIMESTAMP | Session start time                        |
| EndedAt        | TIMESTAMP   | -      | YES  | -                 | Session end time                          |
| OriginIp       | INET        | -      | YES  | -                 | Origin IP address                         |
| SessionStatus  | VARCHAR     | 20     | YES  | 'ACTIVE'          | Status: ACTIVE, EXPIRED, LOGOUT           |
| created_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: creation date                      |
| updated_at     | TIMESTAMPTZ | -      | YES  | NOW()             | Audit: modification date                  |

---

## GLOBAL TABLES AND LOGS

### 17. Password_Policy

Defines system password policies.

| Field             | Type        | Length | Null | Default | Description                               |
| ----------------- | ----------- | ------ | ---- | ------- | ----------------------------------------- |
| PolicyID          | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                    |
| MinLength         | INT         | -      | YES  | 10      | Minimum length                            |
| MaxLength         | INT         | -      | YES  | 128     | Maximum length                            |
| RequireUppercase  | BOOLEAN     | -      | YES  | true    | Requires uppercase letters                |
| RequireNumbers    | BOOLEAN     | -      | YES  | true    | Requires numbers                          |
| RequireSymbols    | BOOLEAN     | -      | YES  | true    | Requires symbols                          |
| ExpirationDays    | INT         | -      | YES  | 90      | Expiration days                           |
| updated_at        | TIMESTAMPTZ | -      | YES  | NOW()   | Modification date                         |
| updated_by        | INTEGER     | -      | YES  | -       | User who modified (FK User)               |

---

### 18. Security_Configuration

Stores system security configurations.

| Field               | Type        | Length | Null | Default | Description                               |
| ------------------- | ----------- | ------ | ---- | ------- | ----------------------------------------- |
| ConfigurationID     | SERIAL      | -      | NO   | AUTO    | Unique identifier (PK)                    |
| ConfigurationName   | VARCHAR     | 100    | NO   | -       | Configuration name                        |
| ConfigurationValue  | TEXT        | -      | YES  | -       | Configuration value                       |
| Description         | TEXT        | -      | YES  | -       | Description                               |
| updated_at          | TIMESTAMPTZ | -      | YES  | NOW()   | Modification date                         |
| updated_by          | INTEGER     | -      | YES  | -       | User who modified (FK User)               |

---

### 19. Activity_Log

Records user activities.

| Field       | Type      | Length | Null | Default           | Description                                    |
| ----------- | --------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| LogID       | BIGSERIAL | -      | NO   | AUTO              | Unique identifier (PK)                         |
| UserID      | INTEGER   | -      | YES  | -                 | User who performed the action (FK User)        |
| ActionType  | VARCHAR   | 50     | NO   | -                 | Type of action                                 |
| Description | TEXT      | -      | YES  | -                 | Action description                             |
| OriginIp    | INET      | -      | YES  | -                 | Origin IP address                              |
| Metadata    | JSONB     | -      | YES  | -                 | Additional data in JSON format                 |
| created_at  | TIMESTAMP | -      | YES  | CURRENT_TIMESTAMP | Record date and time                           |

---

### 20. Audit

Records important action audits.

| Field       | Type      | Length | Null | Default           | Description                                    |
| ----------- | --------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| AuditID     | BIGSERIAL | -      | NO   | AUTO              | Unique identifier (PK)                         |
| UserID      | INTEGER   | -      | YES  | -                 | User who performed the action (FK User)        |
| Action      | VARCHAR   | 255    | NO   | -                 | Action performed                               |
| Description | TEXT      | -      | YES  | -                 | Detailed description                           |
| OriginIp    | INET      | -      | YES  | -                 | Origin IP address                              |
| Application | VARCHAR   | 100    | YES  | 'GPS_Guardian'    | Source application                             |
| Metadata    | JSONB     | -      | YES  | -                 | Additional data in JSON format                 |
| created_at  | TIMESTAMP | -      | YES  | CURRENT_TIMESTAMP | Record date and time                           |

---

### 21. Error_Log

Records system errors.

| Field       | Type      | Length | Null | Default           | Description                                    |
| ----------- | --------- | ------ | ---- | ----------------- | ---------------------------------------------- |
| ErrorID     | BIGSERIAL | -      | NO   | AUTO              | Unique identifier (PK)                         |
| UserID      | INTEGER   | -      | YES  | -                 | Affected user (FK User)                        |
| ErrorType   | VARCHAR   | 100    | NO   | -                 | Type of error                                  |
| Description | TEXT      | -      | YES  | -                 | Error description                              |
| StackTrace  | TEXT      | -      | YES  | -                 | Error stack trace                              |
| OriginIp    | INET      | -      | YES  | -                 | Origin IP address                              |
| Metadata    | JSONB     | -      | YES  | -                 | Additional data in JSON format                 |
| created_at  | TIMESTAMP | -      | YES  | CURRENT_TIMESTAMP | Error date and time                            |

---

## CONSTRAINTS AND ALLOWED VALUES

### Enums / CHECK Constraints

| Table              | Field         | Allowed Values                                     |
| ------------------ | ------------- | -------------------------------------------------- |
| User               | UserType      | 'ADMIN', 'PARENT'                                  |
| Journey            | Status        | 'PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED' |
| Role               | RoleName      | 'ADMIN', 'PARENT'                                  |
| User_Session       | SessionStatus | 'ACTIVE', 'EXPIRED', 'LOGOUT'                      |

### Additional Validations

| Table              | Field                                            | Validation        |
| ------------------ | ------------------------------------------------ | ----------------- |
| SafeZone           | RadiusMeters                                     | > 0               |
| SafeZone           | Active                                           | default true      |
| NotificationConfig | DelayAlert, RouteChangeAlert, ArrivalAlert      | default true      |
| Notification       | SentStatus                                       | default false     |

---

## RELATIONSHIPS AND FOREIGN KEYS

| Table              | Field          | Reference                    | ON DELETE TYPE |
| ------------------ | -------------- | ---------------------------- | -------------- |
| Student            | UserID         | User(UserID)                 | RESTRICT       |
| Route              | created_by     | User(UserID)                 | -              |
| Route              | updated_by     | User(UserID)                 | -              |
| Stop               | RouteID        | Route(RouteID)               | CASCADE        |
| SafeZone           | UserID         | User(UserID)                 | CASCADE        |
| SafeZone           | StudentID      | Student(StudentID)           | CASCADE        |
| NotificationConfig | UserID         | User(UserID)                 | CASCADE        |
| Journey            | StudentID      | Student(StudentID)           | CASCADE        |
| Journey            | RouteID        | Route(RouteID)               | RESTRICT       |
| Coordinate         | JourneyID      | Journey(JourneyID)           | CASCADE        |
| Notification       | JourneyID      | Journey(JourneyID)           | SET NULL       |
| Notification       | ZoneID         | SafeZone(ZoneID)             | SET NULL       |
| NotificationReceipt| NotificationID | Notification(NotificationID) | CASCADE        |
| NotificationReceipt| UserID         | User(UserID)                 | CASCADE        |
| User_Route         | UserID         | User(UserID)                 | CASCADE        |
| User_Route         | RouteID        | Route(RouteID)               | CASCADE        |
| User_Role          | UserID         | User(UserID)                 | CASCADE        |
| User_Role          | RoleID         | Role(RoleID)                 | CASCADE        |
| Role_Permission    | RoleID         | Role(RoleID)                 | CASCADE        |
| Role_Permission    | PermissionID   | Permission(PermissionID)     | CASCADE        |
| User_Session       | UserID         | User(UserID)                 | CASCADE        |
| Activity_Log       | UserID         | User(UserID)                 | -              |
| Audit              | UserID         | User(UserID)                 | -              |
| Error_Log          | UserID         | User(UserID)                 | -              |

---

## RECOMMENDED INDEXES

| Table              | Index                       | Type   |
| ------------------ | --------------------------- | ------ |
| User               | idx_user_email              | UNIQUE |
| User               | idx_user_type               | BTREE  |
| Student            | idx_student_user            | BTREE  |
| SafeZone           | idx_safezone_student        | BTREE  |
| Journey            | idx_journey_student         | BTREE  |
| Journey            | idx_journey_status          | BTREE  |
| Coordinate         | idx_coordinate_journey      | BTREE  |
| Notification       | idx_notification_journey    | BTREE  |
| NotificationReceipt| idx_receipt_user            | BTREE  |
| Activity_Log       | idx_activity_log_date       | BTREE  |
| Audit              | idx_audit_date              | BTREE  |

---