---
title: ICFP 2017, day 3
description: My impressions of the third day of ICFP.
---

The first Racket talk of the day (I thought Lisp was supposed to be
dead!) was *Herbarium Racketensis: A Stroll through the Woods*,
although a better name would probably be "language-oriented
programming in Racket".  The idea behind language-oriented programming
is to decompose a problem into languages that can be used to directly
address its domain (as opposed to how objects are used for the same
purpose in object-oriented languages).  Racket seems to have
specialised in this, and not just via the usual language-extending
Lisp macros, but also by cleanly supporting different syntaxes, even
within the same file.  I'm not really sure I grasp how it's different
from the horrifying reader macros of Common Lisp, but presumably it's
a little more structured...  The primary example language used was for
[Lindenmayer systems](https://en.wikipedia.org/wiki/L-system), which
certainly produces very pretty graphics.

The next presentation was *A Specification for Dependent Types in
Haskell*.  After skimming [Richard Eisenbergs PhD
thesis](http://cs.brynmawr.edu/~rae/papers/2016/thesis/eisenberg-thesis.pdf),
I thought dependent types were close to being adopted in Haskell, but
this presentation made it seem rather distant.  Well, actually, as the
presenter pointed out, some people think that Haskell *already* has
dependent types, cobbled together through its various extensions.
Essentially, the presentation introduced two new core languaes, System
D and System DC (I do not quite remember how they were related), to
serve as dependently typed replacements for GHC Core.  That seems far
off.  What I found particularly interesting in the presentation is the
explanantion that Haskell cannot build on much of the prior work on
dependent types, because they all assume that the language is total,
which GHC is not.

Then there was another presentation (this one actually by Richard
Eisenberg), on *Constrained Type Families*.  The problem is that GHC
has a somewhat naive view of type families, assuming they are total
(that by applying a type familiy to any concrete types you can
eventually produce a concrete type), which is not generally true.  The
proposal, it seems, is to require type families to be either *closed*
(you cannot add new equations outside the module where it is defined),
or require that the type family belongs to a type class.  This will
break compatibility though, but given recent GHC changes, who knows...

An interesting presentation that I didn't understand half of was
*Automating Sized-Type Inference for Complexity Analysis*.  The idea
is to assign types in a program a *size*, which directly relates to
how many reduction steps can be performed on functions operating on
that type.  This then encodes the complexity of a function directly in
its types.  The real novelty was that the sizes could be *inferred*,
which implies inference of the *complexity.  I did not quite grasph
how they did this, nor how they restrict the language to make it
feasible.  They mentioned that they cannot encode quicksort, though.

The last Racket talk of the day (and the last talk at ICFP) was
*Inferring Scope through Syntactic Sugar*.  This was a rather strange
presentation about inferring how (hygienic) Lisp macros bind the names
they are given, or rather, which ones they bind.  I enjoyed the
definition of shadowing, which was done by defining a preorder on
scopes, and defining that the definition that counts at a given use
site is the least scope.  In this preorder, a scope *A* is lesser than
another scope *B* if the definition of *A* can reach *B*.

The day concluded with the Chair's Report.  Apparently ICFP this year
got 127 submissions (close to a record number), and accepted 44 (which
I think was a record number).  The number of submissions seems to be
growing, and the accept rate was 35% this year.  Too bad the paper I
co-authored wasn't among them!  This means that the three-day program
is getting squeezed a bit, with presentations limited to 18 minutes
plus questions.  Other conferences (including PLDI) uses multiple
parallel tracks, but the ICFP steering committee appears to be opposed
to this idea.  Type systems and Haskell are by far the most popular
topics of submitted papers.
