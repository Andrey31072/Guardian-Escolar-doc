
---

## DICCIONARIO DE DATOS - GPS GUARDIAN ESCOLAR v3.3.1

### TABLA 1: User (Usuario)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único del usuario (PK) |
| FullName | VARCHAR(100) | NO | - | Nombre completo del usuario |
| Email | VARCHAR(100) | NO | - | Correo electrónico (único, usado para login) |
| Phone | VARCHAR(30) | SI | - | Número de teléfono de contacto |
| PasswordHash | VARCHAR(255) | NO | - | Hash de la contraseña (BCrypt) |
| IsActive | BOOLEAN | SI | true | Estado activo/inactivo del usuario |
| EmailVerified | BOOLEAN | SI | false | Indica si el correo fue verificado (RF1.2.1) |
| EmailVerificationToken | VARCHAR(255) | SI | - | Token único para verificación de email |
| EmailVerificationExpiry | TIMESTAMPTZ | SI | - | Fecha de expiración del token de verificación |
| PasswordResetToken | VARCHAR(255) | SI | - | Token único para restablecer contraseña (RF1.4) |
| PasswordResetExpiry | TIMESTAMPTZ | SI | - | Fecha de expiración del token de restablecimiento |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 2: Route (Ruta)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único de la ruta (PK) |
| RouteName | VARCHAR(100) | NO | - | Nombre descriptivo de la ruta |
| Description | TEXT | SI | - | Descripción adicional de la ruta |
| OriginLat | DECIMAL(9,6) | SI | - | Latitud del punto de origen |
| OriginLon | DECIMAL(9,6) | SI | - | Longitud del punto de origen |
| DestinationLat | DECIMAL(9,6) | SI | - | Latitud del destino final |
| DestinationLon | DECIMAL(9,6) | SI | - | Longitud del destino final |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 3: Student (Estudiante)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único del estudiante (PK) |
| UserID | UUID | NO | - | Padre asociado (FK a User) |
| FullName | VARCHAR(100) | NO | - | Nombre completo del estudiante |
| SchoolGrade | school_grade_enum | SI | - | Grado escolar (PRE_KINDERGARTEN a ELEVENTH) |
| BirthDate | DATE | SI | - | Fecha de nacimiento |
| IsActive | BOOLEAN | SI | true | Estado activo/inactivo |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 4: Student_Route (Relación Estudiante - Ruta)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| StudentID | UUID | NO | - | ID del estudiante (FK a Student) - PK compuesta |
| RouteID | UUID | NO | - | ID de la ruta (FK a Route) - PK compuesta |
| IsActive | BOOLEAN | SI | true | Indica si la asignación está activa |
| AssignedAt | TIMESTAMPTZ | SI | NOW() | Fecha de asignación de la ruta |

---

### TABLA 5: EmergencyContact (Contacto de Emergencia)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único del contacto (PK) |
| StudentID | UUID | NO | - | Estudiante asociado (FK a Student) |
| FullName | VARCHAR(100) | NO | - | Nombre completo del contacto |
| Phone | VARCHAR(30) | NO | - | Número de teléfono del contacto |
| Relationship | VARCHAR(50) | SI | - | Parentesco (Madre, Padre, Abuelo, etc.) |
| IsPrimary | BOOLEAN | SI | false | Indica si es el contacto principal |
| IsActive | BOOLEAN | SI | true | Estado activo/inactivo |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 6: Stop (Parada)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único de la parada (PK) |
| RouteID | UUID | NO | - | Ruta a la que pertenece (FK a Route) |
| StopOrder | INTEGER | NO | - | Orden secuencial en la ruta |
| StopName | VARCHAR(100) | SI | - | Nombre descriptivo de la parada |
| Latitude | DECIMAL(9,6) | NO | - | Coordenada de latitud |
| Longitude | DECIMAL(9,6) | NO | - | Coordenada de longitud |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 7: SafeZone (Zona Segura)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único de la zona (PK) |
| StudentID | UUID | NO | - | Estudiante asociado (FK a Student) |
| ZoneName | VARCHAR(100) | NO | - | Nombre descriptivo de la zona |
| Latitude | DECIMAL(9,6) | NO | - | Centro de la zona (latitud) |
| Longitude | DECIMAL(9,6) | NO | - | Centro de la zona (longitud) |
| RadiusMeters | INTEGER | NO | CHECK > 0 | Radio de cobertura en metros |
| InactivityThresholdSeconds | INTEGER | NO | 300 | Tiempo de inactividad para generar alerta (RF4.1.1) |
| IsActive | BOOLEAN | SI | true | Si la zona está activa |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 8: NotificationConfig (Configuración de Notificaciones)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| UserID | UUID | NO | - | Usuario asociado (FK a User) |
| DelayAlert | BOOLEAN | SI | true | Recibir alertas de retraso (RF4.2) |
| RouteChangeAlert | BOOLEAN | SI | true | Recibir alertas de cambio de ruta (RF4.2) |
| ArrivalAlert | BOOLEAN | SI | true | Recibir alertas de llegada (RF4.2) |
| InactivityAlert | BOOLEAN | SI | true | Recibir alertas de inactividad (RF4.2) |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 9: Trip (Trayecto)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| StudentID | UUID | NO | - | Estudiante que realiza el trayecto (FK a Student) |
| RouteID | UUID | NO | - | Ruta seguida (FK a Route) |
| StartDateTime | TIMESTAMPTZ | NO | - | Inicio del trayecto |
| EndDateTime | TIMESTAMPTZ | SI | - | Fin del trayecto |
| Status | trip_status_enum | SI | 'PENDING' | Estado: PENDING, IN_PROGRESS, COMPLETED, CANCELLED |
| HasDetour | BOOLEAN | SI | false | Si hubo desvío de ruta (RF3.5) |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| DeletedAt | TIMESTAMPTZ | SI | - | Fecha de borrado lógico |
| CreatedBy | UUID | SI | - | Usuario que creó el registro (FK a User) |
| UpdatedBy | UUID | SI | - | Usuario que modificó el registro (FK a User) |

---

### TABLA 10: Coordinate (Coordenada)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| TripID | UUID | NO | - | Trayecto asociado (FK a Trip) |
| Latitude | DECIMAL(9,6) | NO | - | Coordenada de latitud |
| Longitude | DECIMAL(9,6) | NO | - | Coordenada de longitud |
| RecordedAt | TIMESTAMPTZ | NO | - | Momento del registro |
| SpeedKmh | DECIMAL(5,1) | SI | - | Velocidad en km/h |
| StopDurationSeconds | INTEGER | SI | 0 | Duración de detención en segundos |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 11: Notification (Notificación)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| TripID | UUID | SI | - | Trayecto relacionado (FK a Trip) |
| ZoneID | UUID | SI | - | Zona segura relacionada (FK a SafeZone) |
| EventType | VARCHAR(50) | NO | - | Tipo de evento (desvío, retraso, llegada, etc.) |
| Message | TEXT | NO | - | Contenido de la notificación |
| EventDateTime | TIMESTAMPTZ | SI | CURRENT_TIMESTAMP | Fecha y hora del evento |
| IsSent | BOOLEAN | SI | false | Si fue enviada exitosamente |

---

### TABLA 12: NotificationReceipt (Recibo de Notificación)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| NotificationID | UUID | NO | - | Notificación recibida (FK a Notification) |
| UserID | UUID | NO | - | Usuario que recibió (FK a User) |
| IsRead | BOOLEAN | SI | false | Si fue leída |
| ReceivedAt | TIMESTAMPTZ | SI | CURRENT_TIMESTAMP | Momento de recepción |
| ReadAt | TIMESTAMPTZ | SI | - | Momento de lectura |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 13: Role (Rol)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| RoleName | role_name_enum | NO | - | Nombre del rol: ADMIN, PARENT |
| Description | VARCHAR(255) | SI | - | Descripción del rol |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 14: Permission (Permiso)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| PermissionName | VARCHAR(100) | NO | - | Nombre del permiso (único) |
| Description | TEXT | SI | - | Descripción del permiso |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 15: User_Role (Asignación de Rol a Usuario)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| UserID | UUID | NO | - | Usuario (FK a User) - PK compuesta |
| RoleID | UUID | NO | - | Rol (FK a Role) - PK compuesta |
| AssignedAt | TIMESTAMPTZ | SI | CURRENT_TIMESTAMP | Fecha de asignación del rol |

---

### TABLA 16: Role_Permission (Asignación de Permiso a Rol)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| RoleID | UUID | NO | - | Rol (FK a Role) - PK compuesta |
| PermissionID | UUID | NO | - | Permiso (FK a Permission) - PK compuesta |

---

### TABLA 17: UserSession (Sesión de Usuario)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| UserID | UUID | NO | - | Usuario asociado (FK a User) |
| Token | VARCHAR(500) | NO | - | Token JWT de sesión |
| StartedAt | TIMESTAMPTZ | SI | CURRENT_TIMESTAMP | Inicio de sesión |
| EndedAt | TIMESTAMPTZ | SI | - | Fin de sesión |
| OriginIp | INET | SI | - | Dirección IP de origen |
| SessionStatus | session_status_enum | SI | 'ACTIVE' | Estado: ACTIVE, EXPIRED, LOGOUT |
| CreatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de creación del registro |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |

---

### TABLA 18: PasswordPolicy (Política de Contraseñas)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| MinLength | INT | SI | 10 | Longitud mínima de contraseña |
| MaxLength | INT | SI | 128 | Longitud máxima de contraseña |
| RequireUppercase | BOOLEAN | SI | true | Requiere mayúsculas |
| RequireNumbers | BOOLEAN | SI | true | Requiere números |
| RequireSymbols | BOOLEAN | SI | true | Requiere símbolos |
| ExpirationDays | INT | SI | 90 | Días de expiración de contraseña |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| UpdatedBy | UUID | SI | - | Usuario que modificó (FK a User) |

---

### TABLA 19: SecurityConfiguration (Configuración de Seguridad)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| ConfigName | VARCHAR(100) | NO | - | Nombre de la configuración (único) |
| ConfigValue | TEXT | SI | - | Valor de la configuración |
| Description | TEXT | SI | - | Descripción de la configuración |
| UpdatedAt | TIMESTAMPTZ | SI | NOW() | Fecha de última modificación |
| UpdatedBy | UUID | SI | - | Usuario que modificó (FK a User) |

---

### TABLA 20: ActivityLog (Registro de Actividades)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| UserID | UUID | SI | - | Usuario que realizó la acción (FK a User) |
| ActionType | VARCHAR(50) | NO | - | Tipo de acción (LOGIN, LOGOUT, VIEW, etc.) |
| Description | TEXT | SI | - | Descripción de la acción |
| OriginIp | INET | SI | - | Dirección IP de origen |
| Metadata | JSONB | SI | - | Datos adicionales en formato JSON |
| CreatedAt | TIMESTAMP | SI | CURRENT_TIMESTAMP | Fecha y hora del registro |

---

### TABLA 21: AuditLog (Registro de Auditoría)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| UserID | UUID | SI | - | Usuario que realizó la acción (FK a User) |
| Action | VARCHAR(255) | NO | - | Acción realizada (CREATE, UPDATE, DELETE) |
| Description | TEXT | SI | - | Descripción detallada de la acción |
| OriginIp | INET | SI | - | Dirección IP de origen |
| Application | VARCHAR(100) | SI | 'GPS_Guardian' | Aplicación origen |
| Metadata | JSONB | SI | - | Datos adicionales en formato JSON |
| CreatedAt | TIMESTAMP | SI | CURRENT_TIMESTAMP | Fecha y hora del registro |

---

### TABLA 22: ErrorLog (Registro de Errores)

| Campo | Tipo | Nulo | Predeterminado | Descripción |
|-------|------|------|----------------|-------------|
| ID | UUID | NO | gen_random_uuid() | Identificador único (PK) |
| UserID | UUID | SI | - | Usuario afectado (FK a User) |
| ErrorType | VARCHAR(100) | NO | - | Tipo de error |
| Description | TEXT | SI | - | Descripción del error |
| StackTrace | TEXT | SI | - | Traza del error |
| OriginIp | INET | SI | - | Dirección IP de origen |
| Metadata | JSONB | SI | - | Datos adicionales en formato JSON |
| CreatedAt | TIMESTAMP | SI | CURRENT_TIMESTAMP | Fecha y hora del error |

---

## ENUMS

| Enum | Valores | Descripción |
|------|---------|-------------|
| school_grade_enum | PRE_KINDERGARTEN, KINDERGARTEN, TRANSITION, FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH | Grados escolares |
| trip_status_enum | PENDING, IN_PROGRESS, COMPLETED, CANCELLED | Estados del trayecto |
| session_status_enum | ACTIVE, EXPIRED, LOGOUT | Estados de la sesión |
| role_name_enum | ADMIN, PARENT | Roles del sistema |

---

## RESUMEN DE TABLAS

| # | Tabla | Descripción |
|---|-------|-------------|
| 1 | User | Usuarios del sistema |
| 2 | Route | Rutas del servicio escolar |
| 3 | Student | Estudiantes asociados a un padre |
| 4 | Student_Route | Relación N:M entre estudiantes y rutas |
| 5 | EmergencyContact | Contactos de emergencia |
| 6 | Stop | Paradas de una ruta |
| 7 | SafeZone | Zonas seguras registradas |
| 8 | NotificationConfig | Configuración de notificaciones |
| 9 | Trip | Trayectos realizados |
| 10 | Coordinate | Coordenadas GPS registradas |
| 11 | Notification | Notificaciones generadas |
| 12 | NotificationReceipt | Recepción de notificaciones |
| 13 | Role | Roles del sistema |
| 14 | Permission | Permisos del sistema |
| 15 | User_Role | Asignación de roles a usuarios |
| 16 | Role_Permission | Asignación de permisos a roles |
| 17 | UserSession | Sesiones de usuarios |
| 18 | PasswordPolicy | Políticas de contraseña |
| 19 | SecurityConfiguration | Configuraciones de seguridad |
| 20 | ActivityLog | Registro de actividades |
| 21 | AuditLog | Registro de auditoría |
| 22 | ErrorLog | Registro de errores |

---
