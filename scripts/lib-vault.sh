#!/usr/bin/env bash
# Shared read-only vault helpers. Sourced by baseline-metrics.sh and wiki-lint.sh.
# Assumes the caller has already cd'd to the vault root.

# Knowledge pages. Excludes docs/, templates/, scripts/ — process documents, not knowledge.
notes() { find wiki okf raw -type f -name '*.md' 2>/dev/null | sort; }

# Wiki factual pages only, excluding wiki/sources/ (provenance IS the page), index, and log.
# Use this for the "every factual page cites sources" check — okf/ pages cite via
# knowledge_basis/informed_by instead, and raw/ files are the evidence, not a citation of it.
# Scanning all of wiki+okf+raw for a `sources:` field flagged 10 false positives once already.
wiki_pages() {
  notes | grep '^wiki/' | grep -v '^wiki/sources/' | grep -vE '^wiki/(index|log)\.md$'
}

count() { grep -c . || true; }

# Every wikilink as "<source file><TAB><target basename>".
# Filenames contain spaces, so never pipe them through xargs — that bug shipped once already.
# A trailing .md is dropped: Obsidian resolves [[x.md]] and [[x]] to the same note, and the
# newer wiki/sources/ pages store raw_file with the extension. Keeping it made all 20 of them
# report broken-link against files that exist (2026-10-23).
link_graph() {
  notes | while IFS= read -r f; do
    grep -ho '\[\[[^]]*\]\]' "$f" 2>/dev/null |
      sed -e 's/^\[\[//' -e 's/\]\]$//' -e 's/|.*$//' -e 's/#.*$//' -e 's#.*/##' -e 's/\.md$//' |
      while IFS= read -r t; do
        [ -n "$t" ] && printf '%s\t%s\n' "$f" "$t"
      done
  done
}

# Page titles that exist, as basenames without .md.
existing_titles() { notes | sed 's#.*/##; s#\.md$##' | sort -u; }

# Non-note files a wikilink may legitimately target (images embedded with ![[x.png]]), as
# basenames with their extension. Kept separate from existing_titles so attachments never count
# as pages for duplicate, orphan, or benchmark purposes.
existing_attachments() {
  find wiki okf raw -type f ! -name '*.md' ! -name '.gitkeep' 2>/dev/null | sed 's#.*/##' | sort -u
}

# Frontmatter field value, or empty. Reads only the leading --- block.
frontmatter() { # <file> <field>
  awk -v k="$2" '
    NR==1 && $0!="---" {exit}
    NR>1 && $0=="---" {exit}
    $0 ~ "^"k":" {sub("^"k":[ \t]*",""); print; exit}
  ' "$1"
}

# True when the frontmatter has the field at all, list-valued included.
has_field() { grep -qE "^$2:" "$1"; }

# Values of a list-valued frontmatter field, one per line, quotes and [[ ]] stripped.
# Handles both the block form and the inline form:
#   aliases:            aliases: [MFR, markdown-first]
#     - MFR
frontmatter_list() { # <file> <field>
  awk -v k="$2" '
    NR==1 && $0!="---" {exit}
    NR>1 && $0=="---" {exit}
    $0 ~ "^"k":" {
      rest=$0; sub("^"k":[ \t]*","",rest)
      if (rest != "" && rest != "[]") {
        gsub(/^\[|\]$/,"",rest)
        n=split(rest,a,",")
        for (i=1;i<=n;i++) { gsub(/^[ \t"'"'"']+|[ \t"'"'"']+$/,"",a[i]); if (a[i]!="") print a[i] }
      } else { inlist=1 }
      next
    }
    inlist && /^[ \t]*-[ \t]*/ { sub(/^[ \t]*-[ \t]*/,""); gsub(/^["'"'"']|["'"'"']$/,""); print; next }
    inlist && /^[A-Za-z_]+:/ { inlist=0 }
  ' "$1" | sed -e 's/^\[\[//' -e 's/\]\]$//'
}

# Declared page type, or empty. The folder a page sits in is a convention; this is the claim.
page_type() { frontmatter "$1" type; }

# Title normaliser for duplicate detection: case, punctuation, spacing, and a trailing plural
# all collapse. Reads one string per line on stdin. "Wiki Indexes" and "wiki-index" both become
# "wikiindex", which is the whole point — those are the same idea filed twice.
norm_title() { tr 'A-Z' 'a-z' | sed 's/[^a-z0-9]//g; s/s$//'; }

# Initials of a multi-word title, lowercased: "Markdown-First Retrieval" -> "mfr".
# Only meaningful for titles of two or more words; single-word titles return empty.
acronym_of() { # <title>
  printf '%s\n' "$1" | tr -- '-_/' '   ' |
    awk '{ if (NF < 2) exit; for (i=1;i<=NF;i++) printf "%s", tolower(substr($i,1,1)); print "" }'
}

# The source_id already recorded against a raw/ path by its wiki/sources/ page, if it has been
# ingested. raw_file is stored as a wikilink with or without the extension, e.g.
# "[[raw/articles/x]]" or "[[raw/notes/Python/Python.md]]". Empty output means not ingested yet —
# nothing to compare against, and that is fine: a brand-new source has no recorded hash to drift from.
#
# Exact path match, never substring. The earlier `*"$base"*` glob matched raw/notes/Python/Python.md
# against raw/notes/Python/Object-Oriented-Programming.md (the folder carries the name) and
# reported content drift on two untouched files in CI (2026-10-23). A drift check that compares
# against the wrong record is worse than none: it trains the operator to ignore it.
recorded_source_id() { # <raw-file-path>
  local want="${1#./}"; want="${want%.md}"
  local f rf
  for f in wiki/sources/*.md; do
    [ -f "$f" ] || continue
    rf=$(frontmatter "$f" raw_file | tr -d '\r' |
      sed -e 's/^["'\'']//' -e 's/["'\'']$//' -e 's/^\[\[//' -e 's/\]\]$//' -e 's/|.*$//' -e 's/\.md$//')
    if [ "$rf" = "$want" ]; then
      frontmatter "$f" source_id | tr -d '\r'
      return
    fi
  done
}
