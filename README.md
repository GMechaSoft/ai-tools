# Multi-Agent Ecosystem

A centralized repository for specialized agent configurations and governance frameworks. This project aims to provide a standardized set of agents for various platforms, ensuring consistent behavior, high-quality code, and efficient orchestration.

## 🚀 Current Status: OpenCode Agents

We have successfully implemented the core suite of agents for **OpenCode**, including:

- **Architect-Developer:** The primary orchestrator and governance enforcer.
- **Architect:** Specialized in system design and feasibility validation.
- **Developer:** Focuses on clean, idiomatic implementation.
- **Documenter:** Maintains ADRs and technical contracts.
- **Investigator:** Codebase analysis and root-cause investigation.
- **Prompt Optimizer:** Refines agent interactions for maximum efficiency.
- **Quick Response:** Handles rapid inquiries and small tasks.

All OpenCode agents follow the **Agent Governance Framework** (see `opencode/AGENTS.md`), which mandates internal reasoning in Spanish and technical output (code/docs) in English.

## 🔮 Roadmap

Our goal is to expand this ecosystem to support multiple AI platforms and CLI tools:

- [ ] **Claude Agents:** Optimized configurations for Anthropic's Claude models.
- [ ] **Gemini CLI Agents:** Integration and specialization for Gemini-based workflows.
- [ ] **Other Platforms:** Support for OpenAI, local LLMs (LM Studio), and more.

## 📂 Project Structure

```text
.
├── opencode/           # OpenCode specific configurations
│   ├── agents/         # Agent definition files
│   ├── AGENTS.md       # Governance Framework
│   └── opencode.json   # Tool and provider configuration
└── README.md           # This file
```

## 🛠️ Governance & Standards

- **User Conversation:** Spanish.
- **Internal Reasoning:** English.
- **Technical Output:** English (Code, Docs, Commits).
- **Architecture:** SOLID, DRY, and Clean Architecture principles.
- **Atomic Development:** Design -> Documentation -> Implementation.

---
*Developed with focus on modularity and cross-platform compatibility.*
