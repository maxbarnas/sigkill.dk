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
proponents of semicolons-as-separators against those who believed in
semicolons-as-terminators.  OCaml, which comes from an entirely
different branch of language evolution, even considers the
double-semicolon (`;;`) to be a distinct token, although [it only has
meaning in the
interpreter](https://baturin.org/docs/ocaml-faq/#heading_toc_j_1).

While the most popular use of semicolons is in the context of
statements, some languages use them for other purposes.  For example,
F# and Matlab use semicolons for separating elements in collections,
and in Lisp they are used for comments.

Clearly semicolons are widespread, but *which languages do not use
semicolons at all*?  This page is an attempt at a list, although it
elides [esoteric languages](https://esolangs.org/), unless they are
very notable (like Brainfuck).

See also the [list of programming languages that do not use curly
braces](braces.html).

Do you know of any languages I've missed?  Send an email!

The list
---

  * [BASIC](https://en.wikipedia.org/wiki/BASIC) ([specific dialects may differ](https://www.ecma-international.org/publications/files/ECMA-ST-WITHDRAWN/ECMA-55,%201st%20Edition,%20January%201978.pdf))

  * [Brainfuck](https://esolangs.org/wiki/Brainfuck)

  * [COBOL](https://en.wikipedia.org/wiki/COBOL) (treats semicolon as whitespace)

  * [E](http://erights.org/)

  * [Elm](http://elm-lang.org/)

  * [FORTRAN](http://www.math-cs.gordon.edu/courses/cs323/FORTRAN/fortran.html) (very old versions)

  * [Futhark](https://futhark-lang.org)

  * [MoonScript](https://moonscript.org/)

  * [Plasma](https://plasmalang.org/)

  * [RPG II](https://en.wikipedia.org/wiki/IBM_RPG_II)

  * TeX (although some macro packages may define a special meaning for semicolon)

  * [Vimscript](http://vimdoc.sourceforge.net/htmldoc/usr_41.html)

Honourable mentions
---

Some languages do syntactically use semicolons, but they are rarely
used in practice.  Usually this is by some other mechanism that
"automatically" inserts them during parsing.

  * [Go](https://golang.org/) uses automatic insertion, and it is a
    widespead style.  However, it is still used in other constructs,
    such as `for` loops.

  * [Haskell](https://www.haskell.org/) avoids semicolons *only* when
    using exclusively [indentation-based
    layout](https://en.wikibooks.org/wiki/Haskell/Indentation), which
    is a common style.  [Python](https://python.org) is a similar case.

  * Non-textual languages like [Scratch](https://scratch.mit.edu/) or
    [Piet](http://www.dangermouse.net/esoteric/piet.html) naturally do
    not make use of semicolons.

  * [Prolog](http://www.swi-prolog.org/pldoc/man?section=operators)
    predefines a semicolon infix operator in the standard environment
    (for disjunction), but it is not assigned special status by the
    syntax of the language.

  * [Scala](https://www.scala-lang.org/) uses automatic insertion at
    linebreaks, but it is not uncommon to put multiple
    semicolon-separated statements on a single line.

  * Transact-SQL (the SQL dialect used by SQL Server and Sybase)
    supports semicolons, but it is only used under [very rare
    circumstances](https://stackoverflow.com/questions/710683/when-should-i-use-semicolons-in-sql-server#710697).

Dishonourable mentions
---

  * [Javascript](https://en.wikipedia.org/wiki/JavaScript) supports
    automatic semicolon insertion (like Go), but its use is [somewhat
    contentious](http://www.bradoncode.com/blog/2015/08/26/javascript-semi-colon-insertion/).
