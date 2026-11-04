❯ The folder raw/ is where a human put the notes, the orinal sources of md files right? Any format was requirement for the raw files, like the metadata? What are the each metadata represented?

  Searched for 1 pattern, ran 1 shell command

Confirmed. Straight answer:

Yes — raw/ is human-only territory: the pilot owner drops original source material there (articles, notes, transcripts, webpages). The agent can read and cite it, never write/edit/rename/move/delete it.

No format is required for raw files themselves. The "Source" schema you're thinking of (title, type, raw_file, source_id, source_kind, author, classification, captured, ingested, status) belongs to templates/source.md — that's the Wiki-side representation created during ingest at wiki/sources/Source - X.md, not the raw file. raw/ policy only says "read only, untrusted evidence" — no schema is enforced or checked there. /wiki-ingest treats a raw file as an opaque blob: it just needs to exist under raw/, and its sha256sum becomes the source_id.

The 7 example files you saw with frontmatter (title, type, source_kind, classification, author, published, captured, ingest_status, tags) — that frontmatter was your own choice as pilot owner when authoring those test fixtures, not something the vault requires. A raw file could just as well be plain prose with no frontmatter at all; ingest would still work.

That said, here's what each field means where it is used — the Wiki-side Source page created from templates/source.md:


| Field | Meaning                                                             |
| ----- | ------------------------------------------------------------------- |
| title | Source - \<Name> — the Wiki page's own title, prefixed for the type |
|       |                                                                     |
|       |                                                                     |
|       |                                                                     |
|       |                                                                     |
          |     |


┌────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────────┐
│     Field      │                                             Meaning                                             │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ title          │ Source - <Name> — the Wiki page's own title, prefixed for the type                              │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ type           │ Always source — page-type tag, not agent-editable                                               │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ raw_file       │ Wikilink back to the original file in raw/ — the provenance pointer                             │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ source_id      │ sha256sum of the raw file. Not optional — it's what lets ingest detect "already processed" vs.  │
│                │ "changed since last ingest"                                                                     │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ source_kind    │ article | notes | transcript | webpage — what kind of document                                  │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ author         │ Who wrote the original source                                                                   │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ classification │ public | internal | confidential | restricted — governs which model may touch it (per           │
│                │ docs/phase-0/privacy-policy.md)                                                                 │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ captured       │ Date the raw file was added to raw/                                                             │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ ingested       │ Date /wiki-ingest processed it into the Wiki                                                    │
├────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ status         │ processed — tracks ingest lifecycle                                                             │
└────────────────┴─────────────────────────────────────────────────────────────────────────────────────────────────┘

If you want raw-file authoring to actually be standardized (so future sources are consistent) that'd be a real, useful addition — want me to draft a templates/raw-source.md convention and a note in AGENTS.md/CLAUDE.md recommending it? It'd stay a recommendation, not an enforced schema, since raw/ is deliberately hands-off for the agent.

[^1]: 
