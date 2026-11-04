# Spec Kit

## Core Phases

1. `/constitution`
   **Purpose:** Define the project's fundamental principles and non-negotiable rules.
   The constitution establishes the project's guiding philosophy, constraints, standards, and decision-making criteria. Every later artifact (spec, plan, tasks, and implementation) should be evaluated against these principles. It is typically created once at the beginning of a project and updated only when core principles change.
   **Audience:** Product leaders, architects, and the entire project team.

2. `/specify`
   **Purpose:** Define _what_ should be built and _why_.
   This phase creates a feature specification written in business-oriented language. The focus is on user needs, business value, expected behavior, requirements, and acceptance criteria, rather than technical implementation details. The resulting specification should be understandable by stakeholders, product managers, customers, and developers alike.
   **Audience:** Product managers, stakeholders, customers, and developers.
   **Key Question:**

   > What problem are we solving, and what outcome do we expect?

3. `/plan`
   **Purpose:** Define _how_ the feature will be built.
   The planning phase translates the business specification into an engineering-focused implementation plan. It introduces technical architecture, system design decisions, dependencies, technology choices, data structures, APIs, workflows, and implementation approaches.
   **Audience:** Engineers and technical leads.
   **Key Question:**

   > How should the system be designed to fulfill the specification?

4. `/tasks`
   **Purpose:** Break the implementation plan into executable work.
   This phase decomposes the plan into concrete, actionable tasks that can be completed independently. Tasks are typically sequenced, prioritized, and scoped so that an engineer or coding agent can execute them systematically.
   **Audience:** Developers and coding agents.
   **Key Question:**

   > What specific work items need to be completed?

5. `/implement`
   **Purpose:** Execute the tasks and generate working code.
   The implementation phase is where the coding agent turns the planned tasks into actual code changes. Because all previous phases have already established requirements, architecture, and task breakdowns, the agent can focus on implementation rather than interpretation.
   **Audience:** Developers and AI coding agents.
   **Key Question:**
   > How do we turn the approved plan into working software?

## Optional Quality-Gate Phases

1. `/clarify`
   **Purpose:** Remove ambiguity from the specification before planning.
   After `/specify`, there may still be unclear requirements, assumptions, edge cases, or undefined behaviors. `/clarify` identifies these ambiguities and asks targeted questions to refine the specification. The goal is not to change the feature, but to make requirements precise enough for planning and implementation.
   **Audience:** Product managers, stakeholders, and requirement owners.
   **Key Question:**

   > Is anything still unclear or open to multiple interpretations?

2. `/analyze`
   **Purpose:** Detect inconsistencies and risks before implementation.
   After `/tasks`, this phase performs a cross-artifact review of the constitution, specification, plan, and task list. It looks for contradictions, missing requirements, duplicated work, architectural conflicts, requirement drift, or violations of the project constitution. Unlike implementation, analysis is typically a read-only validation step.
   **Audience:** Technical leads, architects, and developers.
   **Key Question:**
   > Are there any issues that should be resolved before writing code?

## Recommended SDD Workflow

### Lightweight Workflow

```text
1. /specify
2. /plan
3. /tasks
4. /implement
```

### Full Production Workflow

```text
1. /constitution
2. /specify
3. /clarify
4. /plan
5. /tasks
6. /analyze
7. /implement
```

This workflow aligns with Spec Kit's philosophy: **Intent → Specification → Design → Execution**, where each phase produces a structured artifact that becomes reliable context for the next phase.



