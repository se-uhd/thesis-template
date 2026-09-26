#!/usr/bin/env bash
# Adjusts thesis.tex for a seminar report: sets the document type, switches to a
# one-sided layout, adapts the declaration of originality, and removes or
# replaces the blocks marked with "% seminar-report: begin/end <name>" comments
# (German abstract, abstract, acknowledgments, chapters). The new chapters follow
# the outline for seminar reports from https://se-uhd.de/theses/q+a.
set -euo pipefail

cd "$(dirname "$0")"
file="thesis.tex"

for block in german-abstract abstract acknowledgments chapters; do
  if ! grep -qF "% seminar-report: begin $block" "$file"; then
    echo "error: marker for block '$block' missing in $file (already converted?)" >&2
    exit 1
  fi
done

IFS= read -r -d '' ABSTRACT <<'EOF' || true
The abstract should be between half a page and one page in length.
It should summarize the topic, the main paper, the additional papers, and the key insights of the report.
EOF

IFS= read -r -d '' CHAPTERS <<'EOF' || true
\chapter{Introduction}
\label{ch:introduction}

\todo{Motivate the topic, state the goal of the report, and briefly describe the main paper}

% example paragraph with citations
The software engineering research community is often criticized for not addressing the problems that practitioners actually face during their work~\cite{Briand2012}.
At the same time, software developers' beliefs are rather based on their personal experience than on empirical findings~\cite{DevanbuZimmermannOthers2016}.

\chapter{Background}
\label{ch:background}

\todo{Introduce the concepts needed to understand the main paper and summarize related work}

\lipsum[1-4]

\chapter{Synthesis}
\label{ch:synthesis}

\todo{Combine the main paper and the additional papers into a coherent picture of the topic. Structure the chapter by themes that fit your topic (e.g., problems, approaches, or findings) instead of summarizing one paper after another, and point out similarities and differences between the papers. You can split the chapter into sections or several chapters.}

\lipsum[1-12]

\chapter{Discussion}
\label{ch:discussion}

\todo{Critically reflect on the main paper and the additional papers}

\lipsum[1-4]

\chapter{Conclusion}
\label{ch:conclusion}

\todo{Summarize the key insights and give an outlook and ideas for future work}

\lipsum[1-2]
EOF

export ABSTRACT CHAPTERS

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

awk '
  BEGIN { replacement["abstract"] = ENVIRON["ABSTRACT"]; replacement["chapters"] = ENVIRON["CHAPTERS"] }

  # end of a marked block; after a removed block, also drop the following blank line
  index($0, "% seminar-report: end ") == 1 { if (!(block in replacement)) drop_blank = 1; block = ""; next }
  block != "" { next }
  index($0, "% seminar-report: begin ") == 1 {
    split(substr($0, 25), parts, " ")
    block = parts[1]
    if (block in replacement) printf "%s", replacement[block]
    next
  }
  drop_blank { drop_blank = 0; if ($0 == "") next }

  index($0, "\\newcommand{\\thesistype}") == 1 { print "\\newcommand{\\thesistype}{Seminar Report}"; next }
  $0 ~ /^[ \t]*twoside,/ { print "    oneside, % Prepares the document for one-sided printing"; next }
  /zur Erlangung eines akademischen Grades eingereicht wurde/ {
    sub(/zur Erlangung eines akademischen Grades eingereicht wurde/, "als Prüfungsleistung in einer anderen Lehrveranstaltung eingereicht wurde")
    print; next
  }
  { print }
' "$file" > "$tmp"

for expected in '{Seminar Report}' 'oneside,' 'als Prüfungsleistung' '\chapter{Synthesis}' '\listoffigures'; do
  if ! grep -qF "$expected" "$tmp"; then
    echo "error: conversion failed ('$expected' missing), $file was not changed" >&2
    exit 1
  fi
done
if grep -qF '% seminar-report:' "$tmp"; then
  echo "error: conversion failed (unmatched marker), $file was not changed" >&2
  exit 1
fi

cat "$tmp" > "$file"
echo "Converted $file to a seminar report. Adjust the chapters to your topic."
