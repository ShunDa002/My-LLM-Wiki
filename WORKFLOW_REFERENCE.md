# LLM Wiki + OKF Workflow Reference

This document provides a comprehensive overview of all the available agent workflows in the LLM Wiki + OKF pilot vault. These workflows are configured as slash commands in the Antigravity IDE (e.g., `/wiki-ingest`) and are defined in an agent-neutral format in the `prompts/` directory.

## Core Wiki Workflows

These workflows are responsible for capturing, synthesizing, maintaining, and querying knowledge within the Wiki.

### 1. `/wiki-ingest` (Ingest Source)
- **Purpose**: Integrate one raw source into the Wiki as a reviewed transaction.
- **Input**: A single file path under the `raw/` directory.
- **Process**:
  1. Validates the source path and checks for duplicates.
  2. Reads context (`wiki/index.md`, `wiki/log.md`, related concepts) before reading the new source to prevent fragmentation.
  3. Proposes an **Ingest Plan** detailing what concept pages will be created or updated.
  4. Waits for user approval.
  5. Executes the approved plan (updates `sources/`, `concepts/`, index, and logs operations).
- **Automation Level**: Plan and execute (requires human approval).

### 2. `/wiki-query` (Answer a Question)
- **Purpose**: Answer a question strictly using the compiled vault knowledge, with proper citations.
- **Input**: A user question.
- **Process**:
  1. Searches `wiki/index.md` and follows wikilinks.
  2. Uses full-text search as a fallback.
  3. Formats an answer marking clearly where evidence comes from, what is inferred, and surfacing any contradictions.
  4. Classifies the answer as Ephemeral, Reusable, or Actionable. If Reusable or Actionable, proposes saving it as a Synthesis page.
- **Automation Level**: Read-only (proposes write if generating a synthesis).

### 3. `/wiki-lint` (Lint Vault)
- **Purpose**: Report vault health findings across all structural, schema, and governance layers.
- **Input**: None (runs across the vault).
- **Process**:
  1. Executes underlying bash scripts (`wiki-lint.sh`, `check-schema.sh`, `find-duplicates.sh`, `lint-governance.sh`).
  2. Identifies structural issues (e.g., broken links, missing sources, schema violations).
  3. Identifies governance issues (e.g., projects resting on disputed knowledge, stale reviews).
  4. Optionally analyzes semantic layers by reading recent syntheses for unsupported claims.
  5. Outputs a detailed lint report.
- **Automation Level**: Recommends (never repairs automatically).

### 4. `/wiki-find-duplicates` (Find Duplicates)
- **Purpose**: Report duplicate and fragmented concept pages to prevent knowledge fragmentation.
- **Input**: None (scans vault) or a proposed new page title.
- **Process**:
  1. Evaluates mechanical collision criteria (aliases, similar names, content overlap).
  2. Judges each candidate as a true duplicate, contradiction, or subset.
  3. Outputs a duplicate report proposing fixes, such as adding aliases or merging pages (owner-only action).
- **Automation Level**: Recommends (proposes only).

### 5. `/wiki-trace` (Trace Claim)
- **Purpose**: Trace a claim, Wiki page, or decision back to the original raw evidence.
- **Input**: A claim, page, or OKF record.
- **Process**:
  1. Walks the chain from the synthesis/decision down to the source page, and finally to the exact sentence in the `raw/` file.
  2. Classifies the support level (`supported`, `narrower`, `inferred`, `unsupported`, `stale`).
  3. Identifies gaps in the evidence chain.
- **Automation Level**: Read-only.

---

## OKF Bridge Workflows

These workflows connect the accumulated Wiki knowledge to the Objective Key Results Framework (OKF), linking what is known to what is being executed.

### 6. `/bridge-apply` (Apply to Target)
- **Purpose**: Apply a Wiki synthesis to an active OKF project or proposed decision.
- **Input**: A synthesis/concept page and an OKF target.
- **Process**:
  1. Reads both the synthesis and the OKF target.
  2. Evaluates the specific implication for the target.
  3. Proposes an update (e.g., adding to `knowledge_basis` or `informed_by`, writing a context paragraph, or proposing a decision/experiment).
  4. Waits for approval and modifies only the target OKF record.
- **Automation Level**: Plan and execute (requires human approval).

### 7. `/bridge-impact` (Impact Analysis)
- **Purpose**: Report which OKF records are potentially affected by a change in a Wiki page.
- **Input**: A changed Wiki page (concept, synthesis, or source).
- **Process**:
  1. Finds all OKF records citing the page, mapping both direct and transitive dependencies.
  2. Ranks the impact and highlights if the underlying knowledge has become `disputed` or `superseded`.
  3. Reports the findings without making modifications.
- **Automation Level**: Read-only.

### 8. `/bridge-promote` (Promote Lesson)
- **Purpose**: Propose promoting a lesson from a local OKF experiment to a reusable Wiki synthesis.
- **Input**: An `experiment` page.
- **Process**:
  1. Reads the experiment's "broader lesson".
  2. Evaluates if the lesson applies beyond one project and if it is supported by multiple observations.
  3. Proposes the creation of a new synthesis page.
- **Automation Level**: Recommends (proposes only; synthesis requires separate approval).

---

## Notes on the Automation Approach
All write-capable workflows function as transactions: they must explicitly formulate a **Plan** and wait for **Human Approval** before touching the filesystem. Scripts and tools are deliberately restricted based on risk-level to ensure the raw evidence remains immutable and the OKF authority is respected.
