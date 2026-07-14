---
name: create-user-story
description: "Activate when the user requests to create a user story (US), write acceptance criteria in GWT format (Given/When/Then), or generate a file in docs/stories/US-####.md."
---

## Overview
This skill guides the user in gathering the necessary information to create a structured user story. It generates a `US-####.md` file in `docs/stories/` following the standard template with description and acceptance criteria in GWT format.

## Procedure

### 1. Request Base Information
Ask the user the following questions, one at a time or in batches if the information is already available in context:

1. **US Number**: Request the numeric identifier (e.g. `0001`). If not provided, find the highest US in `docs/stories/` and suggest the next incremental number (`####` with 4-digit padding).
2. **Title**: Ask for a descriptive and concise title.
3. **Role (As a)**: Ask who the user or stakeholder is (e.g. "Developer", "QA Tester", "End user").
4. **Action (I want)**: Ask what functionality or behavior is desired.
5. **Purpose (So that)**: Ask for the benefit or business reason behind the action.
6. **Acceptance Criteria**: Ask how many acceptance criteria are needed. For each one, request:
   - **Criterion name** (e.g. "Clean Interface")
   - **Given** (context or precondition)
   - **When** (action or triggering event)
   - **Then** (expected result)

### 2. Validate and Confirm
Before writing the file, show a summary with all collected data and request user confirmation. Allow adjustments if needed.

### 3. Generate the File
Create the file at `docs/stories/US-<number>.md` using the structure defined in the Output Format section.

## Output Format

The generated file must follow this exact structure:

```markdown
# [US-####] Title

## Description:
- **As a**: [role].

- **I want**: [action/requirement].

- **So that**: [benefit/reason].


## Acceptance Criteria:


### AC-NN: Criterion Name

- **Given**: [context or precondition].

- **When**: [action or event].

- **Then**: [expected result].
```

Formatting rules:
- Use a sequential identifier `AC-01`, `AC-02`, etc. for each criterion.
- Separate the `As a`, `I want`, and `So that` blocks with a blank line between them, as shown in the template.
- Separate acceptance criteria with a blank line between them.
- Use `-` bullets for the internal fields of each criterion.

## Constraints and Limits
* The `docs/stories/` directory must be created automatically if it does not exist.
* The US number uses 4-digit padding (e.g. `US-0001`, `US-0042`).
* If the user already has a US with that number, warn and ask for confirmation before overwriting.
* Do not include additional sections beyond those specified in the template (Description and Acceptance Criteria).
* If the user does not provide acceptance criteria, omit that section instead of inventing data.
* Keep the descriptions in English, aligned with the project standard.
