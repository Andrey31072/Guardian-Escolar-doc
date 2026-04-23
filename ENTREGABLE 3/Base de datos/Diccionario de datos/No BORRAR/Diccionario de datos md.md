
# DICCIONARIO DE DATOS - GPS GUARDIAN ESCOLAR

## TABLAS PRINCIPALES

### 1. Usuario

Almacena la información de los usuarios del sistema (padres y administradores).

| Campo          | Tipo        | Longitud | Nulo | Predeterminado    | Descripción                                   |
| -------------- | ----------- | -------- | ---- | ----------------- | ---------------------------------------------- |
| UsuarioID      | SERIAL      | -        | NO   | AUTO              | Identificador único del usuario (PK)          |
| NombreCompleto | VARCHAR     | 255      | NO   | -                 | Nombre completo del usuario                    |
| Email          | VARCHAR     | 100      | NO   | -                 | Correo electrónico (único, usado para login) |
| Telefono       | VARCHAR     | 20       | SI   | -                 | Número de teléfono de contacto               |
| PasswordHash   | VARCHAR     | 255      | NO   | -                 | Hash de la contraseña (BCrypt)                |
| TipoUsuario    | VARCHAR     | 20       | NO   | 'PADRE'           | Tipo: ADMIN o PADRE                            |
| Estado         | BOOLEAN     | -        | SI   | true              | Estado activo/inactivo del usuario             |
| FechaCreacion  | TIMESTAMP   | -        | SI   | CURRENT_TIMESTAMP | Fecha de registro del usuario                  |
| UltimoAcceso   | TIMESTAMP   | -        | SI   | -                 | Fecha y hora del último inicio de sesión     |
| created_at     | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de creación                 |
| updated_at     | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de última modificación     |
| deleted_at     | TIMESTAMPTZ | -        | SI   | -                 | Auditoría: fecha de borrado lógico           |
| created_by     | INTEGER     | -        | SI   | -                 | Auditoría: usuario que creó (FK Usuario)     |
| updated_by     | INTEGER     | -        | SI   | -                 | Auditoría: usuario que modificó (FK Usuario) |

---

### 2. Estudiante

Almacena la información de los estudiantes asociados a un padre.

| Campo              | Tipo        | Longitud | Nulo | Predeterminado | Descripción                                 |
| ------------------ | ----------- | -------- | ---- | -------------- | -------------------------------------------- |
| EstudianteID       | SERIAL      | -        | NO   | AUTO           | Identificador único del estudiante (PK)     |
| UsuarioID          | INTEGER     | -        | NO   | -              | Padre asociado (FK Usuario)                  |
| NombreCompleto     | VARCHAR     | 255      | NO   | -              | Nombre completo del estudiante               |
| GradoEscolar       | VARCHAR     | 50       | SI   | -              | Grado que cursa                              |
| FechaNacimiento    | DATE        | -        | SI   | -              | Fecha de nacimiento                          |
| ContactoEmergencia | VARCHAR     | 100      | SI   | -              | Nombre y teléfono de contacto de emergencia |
| Estado             | BOOLEAN     | -        | SI   | true           | Estado activo/inactivo                       |
| created_at         | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación               |
| updated_at         | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación           |
| deleted_at         | TIMESTAMPTZ | -        | SI   | -              | Auditoría: borrado lógico                  |
| created_by         | INTEGER     | -        | SI   | -              | Auditoría: usuario creador (FK Usuario)     |
| updated_by         | INTEGER     | -        | SI   | -              | Auditoría: usuario modificador (FK Usuario) |

---

### 3. Ruta

Almacena las rutas creadas por los padres para sus estudiantes.

| Campo       | Tipo        | Longitud | Nulo | Predeterminado | Descripción                                 |
| ----------- | ----------- | -------- | ---- | -------------- | -------------------------------------------- |
| RutaID      | SERIAL      | -        | NO   | AUTO           | Identificador único de la ruta (PK)         |
| NombreRuta  | VARCHAR     | 255      | NO   | -              | Nombre descriptivo de la ruta                |
| Descripcion | TEXT        | -        | SI   | -              | Descripción adicional                       |
| OrigenLat   | DECIMAL     | 10,8     | SI   | -              | Latitud del punto de origen                  |
| OrigenLon   | DECIMAL     | 11,8     | SI   | -              | Longitud del punto de origen                 |
| DestinoLat  | DECIMAL     | 10,8     | SI   | -              | Latitud del destino final                    |
| DestinoLon  | DECIMAL     | 11,8     | SI   | -              | Longitud del destino final                   |
| created_at  | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación               |
| updated_at  | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación           |
| deleted_at  | TIMESTAMPTZ | -        | SI   | -              | Auditoría: borrado lógico                  |
| created_by  | INTEGER     | -        | SI   | -              | Auditoría: usuario creador (FK Usuario)     |
| updated_by  | INTEGER     | -        | SI   | -              | Auditoría: usuario modificador (FK Usuario) |

---

### 4. Parada

Almacena las paradas que componen una ruta.

| Campo        | Tipo        | Longitud | Nulo | Predeterminado | Descripción                           |
| ------------ | ----------- | -------- | ---- | -------------- | -------------------------------------- |
| ParadaID     | SERIAL      | -        | NO   | AUTO           | Identificador único de la parada (PK) |
| RutaID       | INTEGER     | -        | NO   | -              | Ruta a la que pertenece (FK Ruta)      |
| Orden        | INTEGER     | -        | NO   | -              | Orden secuencial en la ruta            |
| NombreParada | VARCHAR     | 100      | SI   | -              | Nombre descriptivo de la parada        |
| Latitud      | DECIMAL     | 10,8     | NO   | -              | Coordenada de latitud                  |
| Longitud     | DECIMAL     | 11,8     | NO   | -              | Coordenada de longitud                 |
| created_at   | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación         |
| updated_at   | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación     |

---

### 5. ZonaSegura

Almacena las zonas de confianza registradas por los padres para sus estudiantes.

| Campo        | Tipo        | Longitud | Nulo | Predeterminado | Descripción                                 |
| ------------ | ----------- | -------- | ---- | -------------- | -------------------------------------------- |
| ZonaID       | SERIAL      | -        | NO   | AUTO           | Identificador único de la zona (PK)         |
| UsuarioID    | INTEGER     | -        | NO   | -              | Usuario que registró la zona (FK Usuario)   |
| EstudianteID | INTEGER     | -        | NO   | -              | Estudiante asociado (FK Estudiante)          |
| NombreZona   | VARCHAR     | 100      | NO   | -              | Nombre descriptivo de la zona                |
| Latitud      | DECIMAL     | 10,8     | NO   | -              | Centro de la zona (latitud)                  |
| Longitud     | DECIMAL     | 11,8     | NO   | -              | Centro de la zona (longitud)                 |
| RadioMetros  | INTEGER     | -        | NO   | CHECK > 0      | Radio de cobertura en metros                 |
| Activa       | BOOLEAN     | -        | SI   | true           | Si la zona está activa                      |
| created_at   | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación               |
| updated_at   | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación           |
| deleted_at   | TIMESTAMPTZ | -        | SI   | -              | Auditoría: borrado lógico                  |
| created_by   | INTEGER     | -        | SI   | -              | Auditoría: usuario creador (FK Usuario)     |
| updated_by   | INTEGER     | -        | SI   | -              | Auditoría: usuario modificador (FK Usuario) |

---

### 6. ConfigNotificacion

Almacena las preferencias de notificaciones por usuario.

| Campo            | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| ---------------- | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| ConfigID         | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| UsuarioID        | INTEGER     | -        | NO   | -              | Usuario asociado (FK Usuario)      |
| AlertaRetraso    | BOOLEAN     | -        | SI   | true           | Recibir alertas de retraso         |
| AlertaCambioRuta | BOOLEAN     | -        | SI   | true           | Recibir alertas de cambio de ruta  |
| AlertaLlegada    | BOOLEAN     | -        | SI   | true           | Recibir alertas de llegada         |
| created_at       | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación     |
| updated_at       | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación |

---

### 7. Trayecto

Almacena los trayectos realizados por los estudiantes.

| Campo           | Tipo        | Longitud | Nulo | Predeterminado | Descripción                                       |
| --------------- | ----------- | -------- | ---- | -------------- | -------------------------------------------------- |
| TrayectoID      | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)                          |
| EstudianteID    | INTEGER     | -        | NO   | -              | Estudiante que realiza el trayecto (FK)            |
| RutaID          | INTEGER     | -        | NO   | -              | Ruta seguida (FK Ruta)                             |
| FechaHoraInicio | TIMESTAMP   | -        | NO   | -              | Inicio del trayecto                                |
| FechaHoraFin    | TIMESTAMP   | -        | SI   | -              | Fin del trayecto                                   |
| Estado          | VARCHAR     | 20       | SI   | 'PENDIENTE'    | Estado: PENDIENTE, EN_CURSO, FINALIZADO, CANCELADO |
| HayDesvio       | BOOLEAN     | -        | SI   | false          | Si hubo desvío de ruta                            |
| created_at      | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación                     |
| updated_at      | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación                 |
| deleted_at      | TIMESTAMPTZ | -        | SI   | -              | Auditoría: borrado lógico                        |
| created_by      | INTEGER     | -        | SI   | -              | Auditoría: usuario creador (FK Usuario)           |
| updated_by      | INTEGER     | -        | SI   | -              | Auditoría: usuario modificador (FK Usuario)       |

---

### 8. Coordenada

Almacena el registro de coordenadas GPS durante un trayecto.

| Campo      | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| ---------- | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| CoordID    | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| TrayectoID | INTEGER     | -        | NO   | -              | Trayecto asociado (FK Trayecto)    |
| Latitud    | DECIMAL     | 10,8     | NO   | -              | Coordenada de latitud              |
| Longitud   | DECIMAL     | 11,8     | NO   | -              | Coordenada de longitud             |
| FechaHora  | TIMESTAMP   | -        | NO   | -              | Momento del registro               |
| Velocidad  | DECIMAL     | 5,2      | SI   | -              | Velocidad en km/h                  |
| created_at | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación     |
| updated_at | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación |

---

### 9. Notificacion

Almacena las notificaciones generadas por el sistema.

| Campo          | Tipo      | Longitud | Nulo | Predeterminado    | Descripción                                                     |
| -------------- | --------- | -------- | ---- | ----------------- | ---------------------------------------------------------------- |
| NotificacionID | SERIAL    | -        | NO   | AUTO              | Identificador único (PK)                                        |
| TrayectoID     | INTEGER   | -        | SI   | -                 | Trayecto relacionado (FK Trayecto)                               |
| ZonaID         | INTEGER   | -        | SI   | -                 | Zona segura relacionada (FK ZonaSegura)                          |
| TipoEvento     | VARCHAR   | 50       | NO   | -                 | Tipo: LLEGADA_DESTINO, DESVIO_RUTA, RETRASO, LLEGADA_ZONA_SEGURA |
| Mensaje        | TEXT      | -        | NO   | -                 | Contenido de la notificación                                    |
| FechaHora      | TIMESTAMP | -        | SI   | CURRENT_TIMESTAMP | Fecha y hora de generación                                      |
| EstadoEnvio    | BOOLEAN   | -        | SI   | false             | Si fue enviada exitosamente                                      |

---

### 10. ReciboNotificacion

Registra la recepción y lectura de notificaciones por usuario.

| Campo          | Tipo        | Longitud | Nulo | Predeterminado    | Descripción                             |
| -------------- | ----------- | -------- | ---- | ----------------- | ---------------------------------------- |
| ReciboID       | SERIAL      | -        | NO   | AUTO              | Identificador único (PK)                |
| NotificacionID | INTEGER     | -        | NO   | -                 | Notificación recibida (FK Notificacion) |
| UsuarioID      | INTEGER     | -        | NO   | -                 | Usuario que recibió (FK Usuario)        |
| Leida          | BOOLEAN     | -        | SI   | false             | Si fue leída                            |
| FechaRecibo    | TIMESTAMP   | -        | SI   | CURRENT_TIMESTAMP | Momento de recepción                    |
| FechaLeida     | TIMESTAMP   | -        | SI   | -                 | Momento de lectura                       |
| created_at     | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de creación           |
| updated_at     | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de modificación       |

---

## TABLAS DE RELACIÓN

### 11. User_Ruta

Relación muchos a muchos entre usuarios y rutas (padres que crean rutas).

| Campo      | Tipo        | Longitud | Nulo | Predeterminado | Descripción                        |
| ---------- | ----------- | -------- | ---- | -------------- | ----------------------------------- |
| UsuarioID  | INTEGER     | -        | NO   | -              | Usuario (FK Usuario) - PK compuesta |
| RutaID     | INTEGER     | -        | NO   | -              | Ruta (FK Ruta) - PK compuesta       |
| created_at | TIMESTAMPTZ | -        | SI   | NOW()          | Fecha de creación de la relación  |

---

## TABLAS DE SEGURIDAD

### 12. Role

Define los roles del sistema.

| Campo       | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| ----------- | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| RoleID      | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| RoleName    | VARCHAR     | 20       | NO   | -              | Nombre del rol: ADMIN, PADRE       |
| Description | VARCHAR     | 255      | SI   | -              | Descripción del rol               |
| created_at  | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación     |
| updated_at  | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación |

---

### 13. Permission

Define los permisos disponibles en el sistema.

| Campo          | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| -------------- | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| PermissionID   | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| PermissionName | VARCHAR     | 100      | NO   | -              | Nombre del permiso                 |
| Description    | TEXT        | -        | SI   | -              | Descripción del permiso           |
| created_at     | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de creación     |
| updated_at     | TIMESTAMPTZ | -        | SI   | NOW()          | Auditoría: fecha de modificación |

---

### 14. User_Role

Asigna roles a usuarios.

| Campo      | Tipo      | Longitud | Nulo | Predeterminado    | Descripción                        |
| ---------- | --------- | -------- | ---- | ----------------- | ----------------------------------- |
| UsuarioID  | INTEGER   | -        | NO   | -                 | Usuario (FK Usuario) - PK compuesta |
| RoleID     | INTEGER   | -        | NO   | -                 | Rol (FK Role) - PK compuesta        |
| AssignedAt | TIMESTAMP | -        | SI   | CURRENT_TIMESTAMP | Fecha de asignación                |

---

### 15. Role_Permission

Asigna permisos a roles.

| Campo        | Tipo    | Longitud | Nulo | Predeterminado | Descripción                           |
| ------------ | ------- | -------- | ---- | -------------- | -------------------------------------- |
| RoleID       | INTEGER | -        | NO   | -              | Rol (FK Role) - PK compuesta           |
| PermissionID | INTEGER | -        | NO   | -              | Permiso (FK Permission) - PK compuesta |

---

### 16. User_Session

Gestiona las sesiones activas de usuarios.

| Campo         | Tipo        | Longitud | Nulo | Predeterminado    | Descripción                       |
| ------------- | ----------- | -------- | ---- | ----------------- | ---------------------------------- |
| SessionID     | SERIAL      | -        | NO   | AUTO              | Identificador único (PK)          |
| UsuarioID     | INTEGER     | -        | NO   | -                 | Usuario asociado (FK Usuario)      |
| Token         | VARCHAR     | 500      | NO   | -                 | Token JWT de sesión               |
| StartedAt     | TIMESTAMP   | -        | SI   | CURRENT_TIMESTAMP | Inicio de sesión                  |
| EndedAt       | TIMESTAMP   | -        | SI   | -                 | Fin de sesión                     |
| OriginIp      | INET        | -        | SI   | -                 | IP de origen                       |
| SessionStatus | VARCHAR     | 20       | SI   | 'ACTIVE'          | Estado: ACTIVE, EXPIRED, LOGOUT    |
| created_at    | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de creación     |
| updated_at    | TIMESTAMPTZ | -        | SI   | NOW()             | Auditoría: fecha de modificación |

---

## TABLAS GLOBALES Y LOGS

### 17. Password_Policy

Define las políticas de contraseña del sistema.

| Campo            | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| ---------------- | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| PolicyID         | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| MinLength        | INT         | -        | SI   | 10             | Longitud mínima                   |
| MaxLength        | INT         | -        | SI   | 128            | Longitud máxima                   |
| RequireUppercase | BOOLEAN     | -        | SI   | true           | Requiere mayúsculas               |
| RequireNumbers   | BOOLEAN     | -        | SI   | true           | Requiere números                  |
| RequireSymbols   | BOOLEAN     | -        | SI   | true           | Requiere símbolos                 |
| ExpirationDays   | INT         | -        | SI   | 90             | Días de expiración               |
| updated_at       | TIMESTAMPTZ | -        | SI   | NOW()          | Fecha de modificación             |
| updated_by       | INTEGER     | -        | SI   | -              | Usuario que modificó (FK Usuario) |

---

### 18. Security_Configuration

Almacena configuraciones de seguridad del sistema.

| Campo              | Tipo        | Longitud | Nulo | Predeterminado | Descripción                       |
| ------------------ | ----------- | -------- | ---- | -------------- | ---------------------------------- |
| ConfigurationID    | SERIAL      | -        | NO   | AUTO           | Identificador único (PK)          |
| ConfigurationName  | VARCHAR     | 100      | NO   | -              | Nombre de la configuración        |
| ConfigurationValue | TEXT        | -        | SI   | -              | Valor de la configuración         |
| Description        | TEXT        | -        | SI   | -              | Descripción                       |
| updated_at         | TIMESTAMPTZ | -        | SI   | NOW()          | Fecha de modificación             |
| updated_by         | INTEGER     | -        | SI   | -              | Usuario que modificó (FK Usuario) |

---

### 19. Activity_Log

Registro de actividades de los usuarios.

| Campo       | Tipo      | Longitud | Nulo | Predeterminado    | Descripción                                 |
| ----------- | --------- | -------- | ---- | ----------------- | -------------------------------------------- |
| LogID       | BIGSERIAL | -        | NO   | AUTO              | Identificador único (PK)                    |
| UsuarioID   | INTEGER   | -        | SI   | -                 | Usuario que realizó la acción (FK Usuario) |
| ActionType  | VARCHAR   | 50       | NO   | -                 | Tipo de acción                              |
| Description | TEXT      | -        | SI   | -                 | Descripción de la acción                   |
| OriginIp    | INET      | -        | SI   | -                 | IP de origen                                 |
| Metadata    | JSONB     | -        | SI   | -                 | Datos adicionales en JSON                    |
| created_at  | TIMESTAMP | -        | SI   | CURRENT_TIMESTAMP | Fecha y hora del registro                    |

---

### 20. Audit

Registro de auditoría de acciones importantes.

| Campo       | Tipo      | Longitud | Nulo | Predeterminado    | Descripción                                 |
| ----------- | --------- | -------- | ---- | ----------------- | -------------------------------------------- |
| AuditID     | BIGSERIAL | -        | NO   | AUTO              | Identificador único (PK)                    |
| UsuarioID   | INTEGER   | -        | SI   | -                 | Usuario que realizó la acción (FK Usuario) |
| Action      | VARCHAR   | 255      | NO   | -                 | Acción realizada                            |
| Description | TEXT      | -        | SI   | -                 | Descripción detallada                       |
| OriginIp    | INET      | -        | SI   | -                 | IP de origen                                 |
| Application | VARCHAR   | 100      | SI   | 'GPS_Guardian'    | Aplicación origen                           |
| Metadata    | JSONB     | -        | SI   | -                 | Datos adicionales en JSON                    |
| created_at  | TIMESTAMP | -        | SI   | CURRENT_TIMESTAMP | Fecha y hora del registro                    |

---

### 21. Error_Log

Registro de errores del sistema.

| Campo       | Tipo      | Longitud | Nulo | Predeterminado    | Descripción                  |
| ----------- | --------- | -------- | ---- | ----------------- | ----------------------------- |
| ErrorID     | BIGSERIAL | -        | NO   | AUTO              | Identificador único (PK)     |
| UsuarioID   | INTEGER   | -        | SI   | -                 | Usuario afectado (FK Usuario) |
| ErrorType   | VARCHAR   | 100      | NO   | -                 | Tipo de error                 |
| Description | TEXT      | -        | SI   | -                 | Descripción del error        |
| StackTrace  | TEXT      | -        | SI   | -                 | Traza del error               |
| OriginIp    | INET      | -        | SI   | -                 | IP de origen                  |
| Metadata    | JSONB     | -        | SI   | -                 | Datos adicionales en JSON     |
| created_at  | TIMESTAMP | -        | SI   | CURRENT_TIMESTAMP | Fecha y hora del error        |

---

## RESTRICCIONES Y VALORES PERMITIDOS

### Enums / CHECK Constraints

| Tabla              | Campo         | Valores permitidos                                 |
| ------------------ | ------------- | -------------------------------------------------- |
| Usuario            | TipoUsuario   | 'ADMIN', 'PADRE'                                   |
| Trayecto           | Estado        | 'PENDIENTE', 'EN_CURSO', 'FINALIZADO', 'CANCELADO' |
| Role               | RoleName      | 'ADMIN', 'PADRE'                                   |
| User_Session       | SessionStatus | 'ACTIVE', 'EXPIRED', 'LOGOUT'                      |
| ReciboNotificacion | receiverType  | 'PADRE', 'ADMIN'                                   |

### Validaciones adicionales

| Tabla              | Campo                                          | Validación   |
| ------------------ | ---------------------------------------------- | ------------- |
| ZonaSegura         | RadioMetros                                    | > 0           |
| ZonaSegura         | Activa                                         | default true  |
| ConfigNotificacion | AlertaRetraso, AlertaCambioRuta, AlertaLlegada | default true  |
| Notificacion       | EstadoEnvio                                    | default false |

---

## RELACIONES Y CLAVES FORÁNEAS

| Tabla              | Campo          | Referencia                   | Tipo ON DELETE |
| ------------------ | -------------- | ---------------------------- | -------------- |
| Estudiante         | UsuarioID      | Usuario(UsuarioID)           | RESTRICT       |
| Ruta               | created_by     | Usuario(UsuarioID)           | -              |
| Ruta               | updated_by     | Usuario(UsuarioID)           | -              |
| Parada             | RutaID         | Ruta(RutaID)                 | CASCADE        |
| ZonaSegura         | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| ZonaSegura         | EstudianteID   | Estudiante(EstudianteID)     | CASCADE        |
| ConfigNotificacion | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| Trayecto           | EstudianteID   | Estudiante(EstudianteID)     | CASCADE        |
| Trayecto           | RutaID         | Ruta(RutaID)                 | RESTRICT       |
| Coordenada         | TrayectoID     | Trayecto(TrayectoID)         | CASCADE        |
| Notificacion       | TrayectoID     | Trayecto(TrayectoID)         | SET NULL       |
| Notificacion       | ZonaID         | ZonaSegura(ZonaID)           | SET NULL       |
| ReciboNotificacion | NotificacionID | Notificacion(NotificacionID) | CASCADE        |
| ReciboNotificacion | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| User_Ruta          | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| User_Ruta          | RutaID         | Ruta(RutaID)                 | CASCADE        |
| User_Role          | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| User_Role          | RoleID         | Role(RoleID)                 | CASCADE        |
| Role_Permission    | RoleID         | Role(RoleID)                 | CASCADE        |
| Role_Permission    | PermissionID   | Permission(PermissionID)     | CASCADE        |
| User_Session       | UsuarioID      | Usuario(UsuarioID)           | CASCADE        |
| Activity_Log       | UsuarioID      | Usuario(UsuarioID)           | -              |
| Audit              | UsuarioID      | Usuario(UsuarioID)           | -              |
| Error_Log          | UsuarioID      | Usuario(UsuarioID)           | -              |

---

## ÍNDICES RECOMENDADOS

| Tabla              | Índice                   | Tipo   |
| ------------------ | ------------------------- | ------ |
| Usuario            | idx_usuario_email         | UNIQUE |
| Usuario            | idx_usuario_tipo          | BTREE  |
| Estudiante         | idx_estudiante_usuario    | BTREE  |
| ZonaSegura         | idx_zonasegura_estudiante | BTREE  |
| Trayecto           | idx_trayecto_estudiante   | BTREE  |
| Trayecto           | idx_trayecto_estado       | BTREE  |
| Coordenada         | idx_coordenada_trayecto   | BTREE  |
| Notificacion       | idx_notificacion_trayecto | BTREE  |
| ReciboNotificacion | idx_recibo_usuario        | BTREE  |
| Activity_Log       | idx_activity_log_date     | BTREE  |
| Audit              | idx_audit_date            | BTREE  |

---
