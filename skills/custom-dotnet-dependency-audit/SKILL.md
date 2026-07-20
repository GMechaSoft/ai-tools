---
name: custom-dotnet-dependency-audit
user-invocable: true
description: "Análisis de árbol de dependencias NuGet e identificación de referencias transitivas vulnerables en proyectos .NET. WHEN: análisis de árbol de dependencias, identificar origen de dependencia transitiva, rastrear paquete vulnerable, dotnet nuget why, dotnet list package --vulnerable, auditoría de seguridad NuGet, resolver dependencia transitiva vulnerable, dependency hell, conflicto de versiones NuGet."
---

# Análisis de Árbol de Dependencias NuGet

## Objective
Identificar el origen de dependencias transitivas vulnerables en proyectos .NET y proporcionar recomendaciones de remediación.

---

## STEP-BY-STEP WORKFLOW

### Paso 1: Identificar el Paquete Vulnerable

**Comando:**
```bash
dotnet list package --vulnerable --include-transitive
```

**Qué hace:**
- Escanea TODOS los paquetes (directos y transitivos) contra bases de datos CVE
- Lista vulnerabilidades conocidas con severidad (HIGH/MEDIUM/LOW)
- Muestra el proyecto afectado y la versión vulnerable

**Output esperado:**
```
Vulnerable package: System.Security.Cryptography.Xml (v8.0.2)
Severity: HIGH
Advisories: GHSA-xxxx-xxxx-xxxx
```

---

### Paso 2: Rastrear el Origen de la Dependencia

**Comando:**
```bash
dotnet nuget why <PROYECTO.csproj> <NOMBRE_PAQUETE>
```

**Ejemplo:**
```bash
dotnet nuget why AgavalPagoCreditoDigital.Application.Test/AgavalPagoCreditoDigital.Application.Test.csproj System.Security.Cryptography.Xml
```

**Output esperado:**
```
El proyecto 'X' tiene los siguientes gráficos de dependencia para 'Y':

  [net10.0]
  └── PaqueteDirecto (v1.0.0)
      ├── PaqueteIntermedio1 (v1.0.0)
      │   └── PaqueteIntermedio2 (v1.0.0)
      │       └── PaqueteIntermedio3 (v1.0.0)
      │           └── System.Security.Cryptography.Xml (v8.0.2) ← VULNERABLE
```

**Qué analizar:**
- Identificar el paquete DIRECTO que inicia la cadena
- Verificar si es una dependencia declarada en el `.csproj`
- Mapear toda la cadena de transitivas

---

### Paso 3: Verificar Dependencias Directas del Proyecto

**Acción:**
Leer el archivo `.csproj` del proyecto afectado:

```bash
cat <PROYECTO>.csproj
```

**Qué buscar:**
- Lista de `<PackageReference>` en `<ItemGroup>`
- Identificar si el paquete que inicia la cadena es una dependencia directa
- Verificar si se usa Central Package Management (`Directory.Packages.props`)

---

### Paso 4: Verificar Central Package Management

**Acción:**
Buscar si existe `Directory.Packages.props` en la raíz del solution:

```bash
ls Directory.Packages.props
```

**Si existe:**
- Las versiones se centralizan en este archivo
- La remediación se hace actualizando la versión en `Directory.Packages.props`
- Todos los proyectos heredan la versión desde aquí

**Si no existe:**
- Las versiones se declaran en cada `.csproj` individualmente
- La remediación requiere actualizar cada `.csproj` afectado
- Se puede proponer migrar a Central Package Management como mejora de largo plazo

---

### Paso 5: Analizar Incompatibilidades de Versión

**Checklist:**
- [ ] ¿El paquete directo es compatible con el `TargetFramework`?
- [ ] ¿Hay paquetes antiguos (e.g., ASP.NET Core MVC 2.3.0) en proyectos .NET 10?
- [ ] ¿Otros proyectos del solution usan versiones más modernas?
- [ ] ¿Existe una versión del paquete directo compatible con el framework target?

---

### Paso 6: Generar Recomendación de Remediación

**Opción A - Actualizar Paquete Directo (Recomendada):**
```xml
<!-- Cambiar versión antigua por versión compatible con .NET 10 -->
<PackageReference Include="Microsoft.AspNetCore.Mvc" Version="X.X.X" />
```

**Opción B - Forzar Versión Segura (Temporal):**
```xml
<!-- Agregar dependencia directa para sobrescribir la transitiva -->
<PackageReference Include="System.Security.Cryptography.Xml" Version="10.0.10" />
```

**Opción C - Central Package Management (Largo Plazo):**
Si NO existe `Directory.Packages.props`, se puede proponer crearlo:
```xml
<!-- Directory.Packages.props en la raíz del solution -->
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
  <ItemGroup>
    <PackageVersion Include="System.Security.Cryptography.Xml" Version="10.0.10" />
  </ItemGroup>
</Project>
```
Si YA existe, actualizar la versión en el archivo central.

---

### Paso 7: Generar Archivo de Reporte (CONDICIONAL)

**Solo si el usuario solicita explícitamente generar un reporte:**

**Comando:**
```bash
dotnet list <SOLUCION.sln> package --vulnerable --include-transitive > vulnerabilidades-report.md
```

**Formato del reporte:**
```markdown
# Reporte de Vulnerabilidades NuGet
Fecha: 2026-07-24
Solución: <SOLUCION.sln>

## Resumen
- Total de vulnerabilidades: X
- HIGH: X | MEDIUM: X | LOW: X
- Proyectos afectados: X de X

## Vulnerabilidades por Proyecto

### Proyecto: <NOMBRE>
| Paquete | Tipo | Versión Actual | Versión Segura | Severidad | Advisory |
|---------|------|----------------|----------------|-----------|----------|
| ... | ... | ... | ... | ... | ... |

## Recomendaciones
1. ...
2. ...
```

---

## DECISION BRANCHING

```
¿El paquete vulnerable es transitivo?
├── SÍ → ¿Qué paquete directo lo inicia?
│         ├── Sí → ¿Existe Central Package Management?
│         │         ├── Sí → Actualizar Directory.Packages.props
│         │         └── No → Actualizar paquete directo O forzar versión
│         └── No → Agregar dependencia directa forzada
└── NO → ¿Es una dependencia directa declarada?
          ├── Sí → ¿Existe versión segura compatible?
          │         ├── Sí → Actualizar en .csproj (o Directory.Packages.props)
          │         └── No → Buscar alternativa o reportar como riesgo aceptado
          └── No → Revisar configuración de paquetes
```

---

## QUALITY CRITERIA

- [ ] Se identificó el paquete vulnerable con su CVE/advisory
- [ ] Se incluyeron TODAS las severidades (HIGH, MEDIUM, LOW)
- [ ] Se trazó la cadena completa de dependencias transitivas
- [ ] Se identificó el paquete directo responsable
- [ ] Se verificó compatibilidad con TargetFramework
- [ ] Se comparó con otros proyectos del solution
- [ ] Se verificó si existe Central Package Management
- [ ] Se proporcionó al menos una recomendación de remediación
- [ ] Se explicó el trade-off de cada opción
- [ ] Se generó archivo de reporte SOLO si el usuario lo solicitó

---

## EXAMPLES

### Ejemplo 1: ASP.NET Core MVC en .NET 10
**Problema:** `Microsoft.AspNetCore.Mvc v2.3.0` → `System.Security.Cryptography.Xml v8.0.2`
**Origen:** Dependencia directa en `.csproj`
**Solución:** Actualizar a versión compatible con .NET 10

### Ejemplo 2: Conflicto de Versiones
**Problema:** Mismo solution con algunos proyectos en `v10.0.10` y otros en `v8.0.2`
**Origen:** Inconsistencia entre proyectos
**Solución:** Centralizar versión en `Directory.Packages.props`

---

## TOOLS REFERENCE

| Comando | Propósito |
|---------|-----------|
| `dotnet list package --vulnerable --include-transitive` | Listar paquetes vulnerables |
| `dotnet nuget why <proyecto> <paquete>` | Rastrear origen de dependencia |
| `dotnet list package --include-transitive` | Listar todas las dependencias |
| `dotnet list package --outdated --include-transitive` | Listar paquetes desactualizados |
| `dotnet build -bl:msbuild.binlog` | Generar log binario para análisis avanzado |

---

## TIPS

1. **Usar `dotnet nuget why` primero** — Es el comando más directo para rastrear el origen
2. **Comparar con otros proyectos** — Si otros proyectos ya usan la versión segura, es más fácil justificar el cambio
3. **Verificar TargetFramework** — A veces el problema es incompatibilidad entre paquete antiguo y framework nuevo
4. **Documentar en handoff** — Registrar hallazgos para que el equipo conozca las dependencias vulnerables