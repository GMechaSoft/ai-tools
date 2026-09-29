---
name: custom-mapster-hexagonal
description: "Activate when the user requests to implement or configure mappings using Mapster between domain models, application DTOs (CQRS), and data entities within a Hexagonal Architecture."
---

## 📌 Overview
This skill standardizes the implementation of **Mapster** in Hexagonal Architecture. It ensures consistent object mapping via `IRegister` profiles (auto-scanned) and an injected `IMapper` (Scoped). Mapster binds to parameterized constructors (records) and `init`/`private set` properties, so mappers are configured rather than hand-coded. This replaces the legacy Riok.Mapperly source-generator approach.

## ⚙️ Workflow

### 1. Architectural Context Analysis
* Identify the source and destination layers for the requested mapping.
* **Application Layer**: Map CQRS Commands → Domain Models, and Domain Models → Response DTOs / QueryResult records.
* **Data Layer**: Map Persistence Entities ↔ Domain Models. In this codebase entities usually INHERIT the domain model (e.g., `RequestEntity : Request`).

### 2. Profile Definition (`IRegister`)
* Create a **`public`** class implementing `Mapster.IRegister` — one file per feature (feature-slicing).
* It MUST be `public` so the assembly scan can instantiate it via reflection.
* Declare each pair with `config.NewConfig<TSource, TTarget>()` inside `void Register(TypeAdapterConfig config)`.
* Do NOT create hand-rolled mappers or static extension methods; the runtime mapper resolves the pair from the registered config.

### 3. Fluent Translation of Mapping Rules
* **Renamed properties**: `.Map(dest => dest.Destination, src => src.Source)`.
* **Ignore a target property**: `.Ignore(dest => dest.Prop)`.
* **No equivalent on source**: Mapster skips it automatically — no config needed.
* **Entities inheriting the model** (`RequestEntity : Request`):
  * Entity → Model: identity cast `config.NewConfig<RequestEntity, Request>().MapWith(src => (Request)src)` (no property copy; lists resolve by the element pair).
  * Model → Entity: just `config.NewConfig<Request, RequestEntity>()` — Mapster instantiates via the parameterless ctor by default (no factory needed) — plus `.Ignore(...)` for members with non-public setters.
* **Destination with a non-public ctor** (e.g. `internal ItineraryEntity()`): do NOT declare the Model→Entity profile — Mapster cannot instantiate it and the mapping fails at runtime. Declare only Entity→Model (read-only use).
* **Base model with a `protected` ctor** (e.g. `Reason`): the profile destination must always be the derived entity, which has a public parameterless ctor.
* Note: `ForType(...)` is a `TypeAdapterConfig` method (config level), NOT a method on the setter returned by `NewConfig<...>()`. Custom functions per profile use `.MapWith(src => ...)`.

### 4. Bootstrap & Dependency Injection
* Global config is registered ONCE in Infrastructure (`MapsterExtension.AddMapsterConfig`):
  ```csharp
  using Mapster;        // TypeAdapterConfig, IRegister
  using MapsterMapper;  // IMapper, ServiceMapper

  var config = TypeAdapterConfig.GlobalSettings;
  config.Default.MapToConstructor(true);   // instantiate destinations via constructors (immutable records)
  // Do NOT enable EnableNonPublicMembers: Mapster would then write non-public-set
  // members (GrossRefund, Status, RequestId…) whenever the source exposes a same-named
  // property, breaking domain invariants. Exclusion is always explicit via .Ignore(...).
  config.Scan(assemblies);                 // discovers every concrete IRegister
  services.AddSingleton(config);
  services.AddScoped<IMapper, ServiceMapper>();
  ```
* `IMapper` is **Scoped** (`ServiceMapper`); its ctor `(IServiceProvider, TypeAdapterConfig)` is resolved by DI — no lambda factory needed. `ServiceMapper` also injects the `IServiceProvider` into `MapContext.Parameters` (usable via `MapContext.Current.GetService<T>()` inside mappings).
* Simpler alternative: `services.AddMapster();` registers a `Mapper` over `GlobalSettings` as **Transient**; preferred pattern here is the scoped `ServiceMapper` with the config registered.

### 5. Consumption
* **Application (Wolverine-style handlers)**: inject `IMapper mapper` as a `Handle(...)` parameter → `mapper.Map<TDestination>(source)`.
* **Repositories (Data.EfCore)**: inject `IMapper mapper` via the primary constructor.
* Collections: `mapper.Map<TDest[]>(source)` / `mapper.Map<List<TDest>>(source)` — the element pair is resolved automatically.

## 📋 Output Format
When activated, generate the response in C# code blocks organized strictly by architectural layers:
1. **Profiles**: the `public class XMapper : IRegister` with its `NewConfig` pairs.
2. **Bootstrap**: the `AddMapsterConfig` registration in Infrastructure (or a reminder that it already exists).
3. **Consumption**: a usage example injecting `IMapper` into a CommandHandler or Repository.

## 🛑 Constraints and Limits
* **No Riok.Mapperly**: NEVER generate `[Mapper]`, `static partial` mappers, `[MapProperty]`, `[MapperIgnoreSource/Target]`, or `MapToModel`/`MapFromModel` extension calls — Mapperly was removed from the solution.
* **`IRegister` must be `public`**: otherwise the scan silently fails to register the pair (runtime error, not compile error).
* **Domain invariants are NOT mapped**: properties with `private`/`internal` setters (e.g., `GrossRefund`, `NetRefund`, `Status`, audit dates) are left to the domain entity / ORM — exclude them with explicit `.Ignore(...)` per profile; never enable `EnableNonPublicMembers(true)` globally.
* **Namespaces**: `IRegister`/`TypeAdapterConfig` live in `Mapster`; `IMapper`/`ServiceMapper` live in **`MapsterMapper`**. Any file injecting `IMapper` needs `using MapsterMapper;`.
* **No `.ForType(...)` on `NewConfig` results**: that member does not exist on the setter; use `.MapWith(src => ...)` for custom functions / identity casts.
* **Package management**: add packages only via central version management (`Directory.Packages.props`); use `PrivateAssets="Compile"` in projects that reference Mapster but are themselves referenced by others — EXCEPT the Application layer (its `Mapster` reference must flow transitively to Infrastructure).
* **Domain purity**: never add mapping configuration/attributes to Domain models; all configuration lives in Application or Data layer `IRegister` classes.
