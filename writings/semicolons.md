---
title: Programming Languages and Semicolons
---

List of programming languages that do not use semicolons
===

Semicolons are prevalent in most programming languages.  Most are
familiar with them through their use as statement terminators in
C-derived languages, but their pedigree is even older than that.
ALGOL used them as statement separators, as do most of its
descendants.  In fact, the 70s bore witness to quite a battle between
proponents of semicolon-as-separators against those who believed in
semicolons-as-terminators.  OCaml, which comes from an entirely
different branch of language evolution, even considers the
double-semicolon (`;;`) to be a distinct token, although [it only has
meaning in the
interpreter](https://baturin.org/docs/ocaml-faq/#heading_toc_j_1).

While the most popular use of semicolons is in the context of
statements, some languages use them for other purposes.  For example,
F# and Matlab use semicolons for separating elements in collections.

An interesting quesion is to ask *which languages do not use
semicolons at all*?  This page is an attempt at a list, although it
elides [esoteric languages](https://esolangs.org/), unless they are
very notable (like Brainfuck).

Do you know of any languages I've missed?  Please write me.

  * [APL](https://en.wikipedia.org/wiki/APL_(programming_language))

  * [BASIC](https://en.wikipedia.org/wiki/BASIC) (specific dialects may differ)

  * [Brainfuck](https://esolangs.org/wiki/Brainfuck)

  * [Elm](http://elm-lang.org/)

  * [Futhark](https://futhark-lang.org)

  * [Python](https://www.python.org/)

Honourable mentions
---

Some languages do syntactically use semicolons, but they are rarely
used in practice.  Usually this is by some other mechanism that
"automatically" inserts them during parsing.

  * [Go](https://golang.org/) uses automatic insertion, and it is a
    widespead style.

  * [Haskell](https://www.haskell.org/) avoids semicolons *only* when
    using exclusively [indentation-based
    layout](https://en.wikibooks.org/wiki/Haskell/Indentation), which
    is a common style.

Dishonourable mentions
---

  * [Javascript](https://en.wikipedia.org/wiki/JavaScript) supports
    automatic semicolon insertion (like Go), but it is not universally
    used.
