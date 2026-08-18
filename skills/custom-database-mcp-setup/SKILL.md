---
name: custom-database-mcp-setup
description: "Create, configure, and run MCP servers for database connections, including SQL Server, with anonymized credentials and a reliable local setup workflow."
---
## 📌 Overview
This skill helps create and run MCP servers that connect to databases such as SQL Server. It focuses on a safe setup flow, anonymized credentials, and practical troubleshooting for local and container-based environments.

## ⚙️ Procedure or Workflow
1. Identify the target database engine, host, database name, and authentication method.
2. Create or update the MCP configuration file in the workspace, typically in the .vscode folder.
3. Use the correct executable for the operating system, such as npx for Linux/macOS or npx.cmd for Windows.
4. Add the required arguments so the server starts without interactive prompts.
5. Provide the connection string through environment variables using a clear, named pattern such as CONNECTION_LOCAL.
6. Replace real secrets with placeholders or anonymized values before sharing the configuration.
7. Reload the editor or restart the MCP session after changing the configuration.
8. Verify that the server appears as configured and that the connection is available to the MCP tools.

## 📋 Output Format
Provide the final guidance in this structure:
- Purpose
- Recommended MCP configuration example
- Required environment variables
- Verification steps
- Notes for Windows, Linux, or Docker environments

Include concrete syntax such as:

```json
{
  "servers": {
    "sqlserver-local": {
      "type": "stdio",
      "command": "npx.cmd",
      "args": [
        "-y",
        "mssql-mcp-server"
      ],
      "env": {
        "CONNECTION_LOCAL": "Data Source=<host>; Initial Catalog=<database>; User ID=<user>; Password=<password>; Encrypt=False; TrustServerCertificate=True;"
      }
    }
  },
  "inputs": []
}
```

And, when needed, show the equivalent Linux/macOS form:

```json
{
  "servers": {
    "sqlserver-local": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "mssql-mcp-server"
      ],
      "env": {
        "CONNECTION_LOCAL": "Data Source=<host>; Initial Catalog=<database>; User ID=<user>; Password=<password>; Encrypt=False; TrustServerCertificate=True;"
      }
    }
  },
  "inputs": []
}
```

## 🛑 Constraints and Limits
* Avoid exposing real passwords, connection strings, or hostnames that reveal sensitive infrastructure.
* Prefer placeholders such as <host>, <database>, <user>, and <password>.
* Use the operating-system-specific command form that matches the target environment.
* Keep instructions concise and actionable so they can be reused by another agent or model.
