---
title: Programming Languages and Curly Braces
---

List of programming languages that do not use curly braces
===

Curly braces, [like semicolons](semicolons.html), are very widely used
in the syntax of programming languages.  One vector is through the
syntactical dominance of C-like languages, where braces are used for
grouping statements and declarations.  C inherited this notation from
[B](https://en.wikipedia.org/wiki/B_(programming_language)), which got
it from [BCPL](https://en.wikipedia.org/wiki/BCPL), although braces
were often written as `$(` and `$)` due to character set limitations.
However, even languages that inherit from a completely different
syntactical tradition often use curly braces, as for example in
Python, which uses them for dictionary literals.  This is not
particularly surprising, as there are not that many paired ASCII
characters to pick from: only `[]`, `()`, `{}`, and `<>`.

This list is an attempt at cataloguing the languages that do not use
curly braces for *any purpose*.  I do not mean this list (or [the
other one](semicolons.html)) as a critique (there is nothing wrong
with using curly braces, [even my own language uses
them](https://futhark-lang.org)).  This list is assembled solely to
satisfy my own curiosity.  Most of the languages on this list are from
before C and Unix took over the world.

Do you know of any languages I've missed?  Please tell me!  I am not
terribly interested in listing hundreds of esoteric languages or
variants of dead mainframe languages, so I reserve the privilege to
only include notable (or recent, or interesting) ones.  I also do not
intend to include languages written for machines where curly braces
did not exist, unless particularly notable (such as by having actually
survived).  The following should at least be complete for the
languages on the [TIOBE Top 50](https://www.tiobe.com/tiobe-index/).

Overall, my impression is that while very few languages do not use
semicolons, there are many languages that do not use curly braces.

The list
---

  * Ada

  * APL (prior to [dfns](https://dfns.dyalog.com/))

  * Assembly (specific dialects may differ)

  * BASIC

  * [Brainfuck](https://esolangs.org/wiki/Brainfuck)

  * [COBOL](https://en.wikipedia.org/wiki/COBOL)

  * Datalog

  * [ELAN](../files/Elan_1.7.pdf)

  * [FORTRAN](http://www.math-cs.gordon.edu/courses/cs323/FORTRAN/fortran.html)

  * [IMP 77](https://web.archive.org/web/20050529121643/http://imp.nb-info.co.uk/imp77.pdf)

  * [Jam](../files/Jam_1.1.pdf)

  * Lisp (specific dialects may differ)

  * [Lucid](https://en.wikipedia.org/wiki/Lucid_(programming_language))

  * Pascal (recent versions use curly braces for comments, but these
    were written with `(*` and `*)` in ancient times, likely because
    of character set restrictions)

  * PL/I

  * [Rapira](https://en.wikipedia.org/wiki/Rapira)

  * [Rexx](https://en.wikipedia.org/wiki/Rexx)

  * [RPG](https://en.wikipedia.org/wiki/IBM_RPG)

  * Smalltalk (some newer dialects have a notation for "dynamic
    arrays" that uses curly braces)

  * [SNOBOL](https://en.wikipedia.org/wiki/SNOBOL)

  * SQL

Honourable mentions
---

Some languages do syntactically use curly braces, but they are rarely
used in practice.

  * Forth uses curly braces for local variables, but this feature
    seems like it is left out of many minimalist Forth
    implementations.

  * Prolog allows you to define your own meaning for curly braces.

  * Non-textual languages like [Scratch](https://scratch.mit.edu/) or
    [Piet](http://www.dangermouse.net/esoteric/piet.html) naturally do
    not make use of curly braces.
