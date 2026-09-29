---
name: custom-vscode-mssql-mcp-connect
description: "Conectar a bases de datos SQL Server y ejecutar consultas usando las herramientas MCP nativas (mssql_*) de Visual Studio Code, basadas en los perfiles guardados de la extensión Microsoft SQL Server (SQL Tools). Usar cuando el usuario pida: conectar a una base de datos, comprobar el estado de la conexión, listar bases de datos/tablas/esquemas, ejecutar una query SQL, inspeccionar el esquema o usar el schema designer dentro de VS Code."
---

## 📌 Overview
Skill para conectar a SQL Server y explorar/ejecutar consultas mediante las herramientas MCP `mssql_*` integradas en VS Code (extensión Microsoft SQL Server). Trabajan sobre los perfiles de conexión guardados en la extensión: no requieren MCP server externo, `npx` ni `.mcp.json`.

## ⚙️ Procedure or Workflow

### 1. Precondiciones
1. Confirmar que la sesión es en VS Code: las herramientas `mssql_*` solo existen en ese editor (en otros contextos usar `sqlcmd` o un MCP server externo).
2. Llamar a `mssql_list_servers` para enumerar los perfiles disponibles. Devuelve una lista de `{ profileId, profileName, server, database }`.
3. Si la lista está vacía, no hay perfiles guardados: guiar al usuario a crear uno (vista **SQL Server** en la activity bar → *New Connection* → servidor, autenticación, credenciales → guardar). No continuar hasta que al menos un servidor aparezca.
4. Si la BD es local (p. ej. contenedor Docker), verificar que está corriendo antes de conectar (`docker ps`, puerto 1433), porque un "connection refused" casi siempre es el servicio apagado y no un error de credenciales.

### 2. Conectar
1. Usar el valor exacto de `server` retornado por `mssql_list_servers` como `serverName` (el tool valida contra los perfiles registrados; un nombre inventado falla).
2. Llamar `mssql_connect(serverName=...)`:
   - Con `database` solo si el usuario la mencionó.
   - Con `profileId` (de `mssql_list_servers`) solo si el usuario mencionó explícitamente el perfil ("conectar usando el perfil X").
   - Si el `database` indicado no existe y la conexión falla, reconectar sin database y usar `mssql_list_databases` para encontrar el nombre correcto.
3. Guardar el `connectionId` (UUID) retornado: lo necesitan todas las herramientas siguientes. No confundirlo con los IDs de otros tools (ver Constraints).

### 3. Verificar estado de la conexión
1. `mssql_get_connection_details(connectionId)` → confirma `server`, `database`, `authenticationType`, `user`, `trustServerCertificate`.
2. `mssql_list_databases(connectionId)` → lista de bases de datos del servidor.
3. Presentar al usuario el banner de estado (ver Output Format).

### 4. Explorar el esquema
- `mssql_list_tables`, `mssql_list_schemas`, `mssql_list_views`, `mssql_list_functions` (todas reciben `connectionId`; las tablas incluyen el nombre de schema).
- `mssql_change_database(connectionId, database)` para cambiar de base de datos con las mismas credenciales; mostrar antes `mssql_list_databases` como opciones.

### 5. Ejecutar consultas (`mssql_run_query`)
1. El tool exige además de `query` los campos `queryTypes` (tipos de operación presentes: SELECT, JOIN, CTE, INSERT, UPDATE, ...) y `queryIntent` (uso principal: data_exploration, troubleshooting, schema_exploration, ...).
2. Predeterminar a lectura: `SELECT`, `EXPLAIN`, `sys.*`, `INFORMATION_SCHEMA`.
3. Antes de operaciones de escritura (INSERT/UPDATE/DELETE/ALTER/DROP/TRUNCATE): mostrar la sentencia al usuario y obtener confirmación explícita; una UPDATE/DELETE sin `WHERE` requiere confirmación doble porque afecta toda la tabla.

### 6. Schema Designer (opcional, operación visual)
- `mssql_schema_designer` con `operation: "show"` abre el diseñador. Gotcha: el parámetro `connectionId` de ese tool es el del runtime de VS Code, no el del MCP; para abrir con la conexión MCP, pasar el UUID de `mssql_connect` en el campo **`connectionName`** (exactamente uno de los dos campos).
- `get_overview` / `get_table` / `apply_edits` operan sobre el diseñador ya activo; toda mutación exige `expectedVersion` del último `get_overview`/`get_table` (si está desactualizado el tool retorna `stale_state` con la versión vigente).

### 7. Cerrar
- `mssql_disconnect(connectionId)` al terminar la tarea o si el usuario lo pide, para no dejar sesiones abiertas.

## 📋 Output Format
Banner de estado de conexión:
```
> 🟢 Connected to:
> ➖ Server - <server>
> ➖ Database - <database>
> (auth: <authenticationType>, user: <user>)
```
- Bases de datos y tablas: lista Markdown; si hay más de 15 tablas, agrupar por schema.
- Resultados de query: tabla Markdown con columnas + conteo de filas; si el resultado es extenso, mostrar las primeras ~20 filas e indicar el total.

## 🛑 Constraints and Limits
* Solo aplica en VS Code: fuera de este editor las `mssql_*` no existen; derivar a `sqlcmd` o a un MCP server externo (ver la skill `custom-database-mcp-setup` para esa vía).
* El `serverName` de `mssql_connect` debe salir siempre de `mssql_list_servers`: el tool rechaza servidores no registrados en los perfiles de la extensión.
* No pedir, capturar ni mostrar contraseñas: las credenciales viven en el perfil guardado de la extensión y no deben aparecer en la conversación ni en archivos compartidos.
* El UUID de `mssql_connect` es opaco y específico de esos tools: al reutilizarlo en `mssql_schema_designer` va en `connectionName`, nunca en `connectionId`.
* `mssql_run_query` ejecuta cualquier SQL tal cual: no ejecutar DDL destructivo (DROP, TRUNCATE) sin confirmación explícita del usuario.
* Delimitar consultas: usar `TOP` en tablas anchas para no saturar el contexto con filas innecesarias.
* Ante "connection refused": diagnosticar primero puerto/servicio (Docker local: `docker ps` + puerto 1433), y solo después credenciales.
