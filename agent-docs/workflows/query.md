# Query Workflow

## Scope

Load this document when answering a question from the Wiki. A normal Query is read-only and does not authorize file-back.

## Normal read-only Query

1. Read `wiki/index.md` first.
2. Locate relevant canonical pages.
3. Prefer reviewed pages over unreviewed pages.
4. Follow source links for important claims.
5. Read raw evidence only when verification is necessary.
6. Read only raw files already referenced by selected Wiki pages unless the human explicitly authorizes a wider read-only scope.
7. Separate verified facts, synthesis, personal observations, uncertainty, contradictions, and open questions.
8. List every Wiki and source file used.
9. State when an important page has not been human-reviewed.
10. Do not write anything to the Vault.

Do not load write-oriented documents merely to answer a read-only Query.

## Query file-back

File-back is a separate write operation. A request for an answer is not approval to save it.

Before proposing file-back:

1. Explain why the result has durable value.
2. Identify the exact target path.
3. State whether it creates or updates the target.
4. Load the write-related documents specified in the root routing map.
5. Produce a new file-level plan.
6. Obtain explicit approval of that plan.

After approval, perform preflight, execute only the approved change, validate it, and provide the required final report.

File-back remains subject to all Stage 1 prohibitions and cannot modify `raw/` or `dev/`.
