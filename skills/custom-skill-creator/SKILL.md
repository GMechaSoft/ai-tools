---
name: custom-skill-creator
description: "Activate when the user requests to create, optimize, or structure a new skill or a set of reusable instructions (.md) for AI agents."
---

## 📌 Overview
This skill transforms abstract requests, long prompts, or repetitive workflows into structured skill files following the `SKILL.md` standard. It ensures AI agents understand their role, follow precise workflows, and respect technical constraints without overloading their context window.

## ⚙️ Workflow

### 1. Requirements Extraction
* Analyze the repetitive process the user wants to automate.
* Identify the necessary input data and the expected output format.

### 2. Frontmatter Generation
* Assign a `name` using only lowercase letters, numbers, and hyphens.
* Write a clear, persuasive `description` in third person, specifying the exact activation trigger.

### 3. Content Writing (Standard Structure)
* **Overview**: Define the purpose in a maximum of two lines.
* **Procedure**: Detail sequential steps using imperative verbs.
* **Output Format**: Specify the visual structure (Markdown, JSON, tables) the response will adopt.
* **Constraints**: List operational limits and critical errors the agent must avoid.

### 4. File Creation
* Create the skill file in the `~/.agents/skills/[skill-name]/SKILL.md` directory.
* This is the standard location where new skills are stored and automatically loaded by AI agents.

### 5. Context Optimization
* Review that instructions do not use unnecessary absolute uppercase (e.g., avoid "ALWAYS", "NEVER").
* Briefly explain the "why" behind critical rules to improve model reasoning.
* If the process requires complex mathematical calculations, suggest creating an associated `scripts/` subfolder.

## 📋 Output Format
The final result must be delivered strictly within a Markdown code block with the following structure:

```markdown
---
name: custom-[skill-name]
description: "[Clear description of the skill trigger]"
---
## 📌 Overview
...

## ⚙️ Procedure or Workflow
1. ...

## 📋 Output Format
...

## 🛑 Constraints and Limits
* ...
```

## 🛑 Constraints and Limits
* **Length**: The final generated file must never exceed 500 lines of text.
* **Tone**: Avoid overly rigid language; prioritize context-based and logical instructions.
* **Independence**: Do not assume external tools unless the user explicitly specifies them.
