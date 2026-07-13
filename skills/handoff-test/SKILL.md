---
name: handoff-test
description: "Use this skill whenever the user wants to log off, transition their work, switch branches, or document the current state of a development task for another engineer or a future AI session. Triggers include requests like 'create a handoff', 'generate handoff.md', 'prepare the transfer', 'wrap up my day', or 'document what failed'. This skill inspects the repository status via git tools, infers the objective from recent context, and generates a structured technical document capturing current status, modified files, completed changes, failures/blockers, and prioritized upcoming tasks. Do NOT use for general project readme files, API documentation, or code comments unrelated to context handover."
---

# Handoff-test creation, documentation, and engineering state transfer

## Overview

A `handoff.md` file is an asynchronous context-transfer document in Markdown format designed to pass explicit engineering context between developers or AI sessions without information loss.

## Quick Reference


| Task | Command / Approach |
|------|--------------------|
| Read current git status | `git status -s` |
| Inspect precise file diffs | `git diff --name-only` or `git diff --name-only HEAD~1 HEAD` |
| Generate the handoff file | Write to root directory as `handoff.md` |

### Inspecting Repository State

Before building the document, run system tools to extract precise data:

```bash
# Get the current branch name
git branch --show-current

# List all staged and unstaged modified files
git status --short

# Review the code changes made in the session to extract implementation details
git diff
git diff HEAD~1 HEAD
```

---

## Creating the Handoff Document

Generate the `handoff.md` file at the root level of the workspace. Fill in the structural blocks using the precise context deduced from execution history and environment commands.

### File Template Structure

```markdown
# 🚀 Development Handoff: {task_name}

**Date:** {current_date}  
**Repository Branch:** {current_git_branch}

---

## 🎯 1. Objective
- {Briefly describe the purpose of the changes and what technical or business problem they solve}.

## 📊 2. Current Status
- **Status:** [Blocked / In Progress / Ready for Testing]
- {Concisely describe what functionality or logic is already operational at this exact moment}.

## 🗂️ 3. Files in Progress
{List the paths of the modified or created files, for example: - `src/components/Auth.tsx`}

## 🛠️ 4. Changes Made
- {Detail the functions, components, endpoints, or configurations successfully injected}.

## ⚠️ 5. Attempts and Failures
- **Attempt:** {Alternative approach or logic that was tested}
  - *Result:* Failed due to {console error, bug, or exception} because {short technical explanation of the failure}.

## 🔮 6. Next Steps (Upcoming Tasks)
1. 🔲 {Immediate technical step to resume or unblock development}.
2. 🔲 {Next validation, refactor, or integration required}.
3. 🔲 {Automated test or final acceptance criteria needed before Merge}.
```

---

## Technical Composition Rules

To ensure high density and complete utility for the receiving engineer, follow these strict execution patterns:

### Objectives & Status Definitions
- **Never guess business logic:** If the core goal isn't clear from recent logs or commits, infer it directly from user commands or state it as undefined.
- **Explicit Statuses only:** Use exactly one of the three lifecycle states: `Blocked` (cannot proceed due to environmental/bug reasons), `In Progress` (actively changing), or `Ready for Testing` (code complete but unvalidated).

### File Resolution
- **Always use exact relative paths:** Do not write loose file names. Write `- src/api/middleware/auth.ts`, never `- auth.ts`.
- Match the list precisely to the outputs gathered from `git status`.

### Error Logging (Attempts and Failures)
- **Do not hide errors:** If a compilation step, automated test suite, or api request failed during execution, capture the precise message or status code.
- Provide a concise architectural root cause if known (e.g., *cors mismatch*, *missing environmental variable key*, or *database lock constraint*).

### Next Steps Structure
- **Keep tasks short and executable:** Each list item in the next steps section must be exactly one short, actionable fragment starting with a checkbox square (`🔲`).
- Order them chronologically by immediate priority so the receiving agent can begin work immediately on task item 1.
