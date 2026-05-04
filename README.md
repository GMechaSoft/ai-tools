# OpenCode Agent Configurations

This repository contains the official specialized agent configurations and governance frameworks for **OpenCode**. It provides a standardized set of agents ensuring consistent behavior, high-quality code, and efficient orchestration under a strict technical framework.

## 🚀 Core Agents

The core suite of agents includes:

- **Architect-Developer:** The primary orchestrator and governance enforcer.
- **Architect:** Specialized in system design and feasibility validation.
- **Developer:** Focuses on clean, idiomatic implementation.
- **Documenter:** Maintains ADRs and technical contracts.
- **Investigator:** Codebase analysis and root-cause investigation.
- **Prompt Optimizer:** Refines agent interactions for maximum efficiency.
- **Quick Response:** Handles rapid inquiries and small tasks.

All agents follow the **Agent Governance Framework** (see `AGENTS.md`), which mandates internal reasoning in Spanish and technical output (code/docs) in English.

## 📂 Project Structure

```text
.
├── agents/             # Agent definition files
├── AGENTS.md           # Governance Framework
├── opencode.json       # Tool and provider configuration
└── README.md           # This file
```

## 🛠️ Governance & Standards

- **User Conversation:** Spanish.
- **Internal Reasoning:** English.
- **Technical Output:** English (Code, Docs, Commits).
- **Architecture:** SOLID, DRY, and Clean Architecture principles.
- **Atomic Development Cycle:**
    1. **Design:** Feasibility and patterns.
    2. **Documentation:** ADRs and contracts.
    3. **Implementation:** Clean, high-performance code.

---
*Official OpenCode Configuration Repository.*
