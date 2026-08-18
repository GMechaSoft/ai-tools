---
name: custom-mapperly-hexagonal
description: "Activate when the user requests to implement or configure mappings using Riok.Mapperly between domain models, application DTOs (CQRS), and data entities within a Hexagonal Architecture."
---

## 📌 Overview
This skill standardizes the implementation of Riok.Mapperly in Hexagonal Architecture. It ensures efficient, reflection-free object mapping using Dependency Injection (DI), explicitly avoiding common C# antipatterns such as mixing static classes with instances or performing manual mapping of properties.

## ⚙️ Workflow

### 1. Architectural Context Analysis
* Identify the source and destination layers for the requested mapping.
* **Application Layer**: Map CQRS Commands/Queries to Domain Models, and Domain Models to Response DTOs or QueryResult Records.
* **Data Layer**: Map Persistence Entities to Domain Models, and Domain Models to Persistence Entities.

### 2. Interface Definition (Dependency Injection)
* Always define an abstraction (interface) for the mapper (e.g., `IEntityMapper`) defining the mapping contracts.
* This ensures maximum decoupling and allows for unit testing (mocking) within the Application and Data layers.

### 3. Mapper Definition
* Create a **non-static** `partial class` implementing the defined interface with the `[Mapper]` attribute.
* Let Mapperly do the heavy lifting: Rely on its ability to automatically map to parameterized constructors (like those used in C# Records). Do not write manual mapping logic inside custom methods unless absolutely necessary for complex data transformations.
* Use `[MapProperty]` when field names differ between the external contract and the Domain Model to maintain readable code.

### 4. Code Generation & Best Practices
* Structure the mappers to be injected via interfaces.
* Provide the Dependency Injection registration snippet, ensuring the mapper is registered as a `Singleton` (Mapperly classes are stateless and thread-safe).

## 📋 Output Format
When activated, generate the response in C# code blocks organized strictly by architectural layers:
1. **Domain Models**: Briefly establish the core model.
2. **Abstractions**: Provide the interface definition.
3. **Mapper Implementation**: Provide the Mapperly `partial class` implementing the interface.
4. **Dependency Injection**: Show the registration snippet (e.g., `services.AddSingleton<IMapper, Mapper>();`).
5. **Implementation**: Show a brief usage example injecting the interface into a CommandHandler or Repository.

## 🛑 Constraints and Limits
* **Strict C# Rules (Avoid Antipatterns)**: NEVER generate a `static partial class` that attempts to hold an instance (`new()`) or contains non-static partial methods. If static is required by the user, all members must be static and DI cannot be used. Default to DI.
* **No Manual Mapping**: NEVER write manual mapping code inside the mapper (e.g., `return new QueryResult(dto.A, dto.B)`) for records or parameterized constructors. Mapperly handles this natively.
* **No Reflection**: Rely exclusively on Mapperly's source generators. Avoid any runtime reflection workarounds.
* **Domain Purity**: Do not pollute the Domain Model with Mapperly attributes (`[Mapper]`, `[MapProperty]`). All configuration must reside strictly in the Application or Data layer mapper classes.