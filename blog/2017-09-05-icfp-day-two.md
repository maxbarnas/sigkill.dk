---
title: ICFP 2017, day 2
description: My impressions of the second day of ICFP.
---

The theme of the morning seemed to be verification, and the keynote,
*Challenges in Assuring AI* set the stage quite well.  John Launchbury
(from Galois) talked about the difficulties involved in verifying that
an AI program does what it's supposed to.  It certainly is frustrating
that just after the community finally seems to have a handle on how to
verify that a program meets some specification (most notably by the
construction of verified compilers such as CompCert and CakeML),
people start writing programs where it is quite unclear what the
specification even *is*!  I was particularly unsettled by his
demonstration of the fragility of neural networks, where attackers can
make the network dramatically misclassify by adding
human-imperceptible noise to the image.  I foresee some interesting
exploits in the future.

A later talk was *Verified Low-Level Programming Embedded in [F\*](https://www.fstar-lang.org/)*,
which presented a verified implementation of an authentication code
(Poly1305).  This is in the context of a larger project to write a
fully verified HTTPS stack.  The idea is to write to separate F\*
implementations, one that is low-level and using effect types to model
the C stack and heap, and one that is high-level and "structurally"
correct (or at least safe), then using F\* magic to prove that the two
implementations are equivalent.  From the low-level implementation one
can then automatically extract fully verified C code.  The performance
of the resulting code was fine; matching that of C from OpenSSL, but
being significantly outperformed by assembly implementations.

The following talk was *Verifying Efficient Function Calls in CakeML*.
While CompCert (the verified C compiler) gets a lot of attention,
CakeML is certainly also worthy of a few raised eyebrows, as it may
very well be the first verified compiler for a high-level language.
The presentation discusses the verification of a pretty
straightforward (and common) optimisation for common-case calls of
multi-parameter functions in ML-style languages, where closure
allocation is avoided.  Interestingly, this is exactly the
optimisation that yesterdays presentation found to be buggy in the
OCaml compiler!

Perhaps my favourite talk of the day was *Better Living through
Operational Semantics: An Optimizing Compiler for Radio Protocols*.
This may because I have a soft spot for the presenter, Geoffrey
Mainland, ever since my bachelor's project, which was an adaptation of
his [Flask
project](https://www.cs.drexel.edu/~mainland/projects/flask/) to run
on Arduino devices.  Or maybe I just have sympathy for his work, which
generally focuses on using high-level languages to program devices
that really ought have no business running high-level languages.  In
this case, he is presenting an optimising compiler for Ziria, which is
a language used to implement radio protocols such as the ones used for
e.g. WiFi.  The focus here was on fusion (apparently radio protocols
are basically just stream transducers), and on chunking.  The latter
is useful for translating e.g. one-bit transducers into a transducer
that operates a byte-at-a-time; perhaps even using a lookup table.

The most immediately mind-bending talk was *Compiling to Categories*.
The foundation is that the lambda calculus can be simplified to remove
explicit lambdas and names, making it combinator-based instead.  It
turns out these combinators form a (cartesian closed) category, which
provides no end of amusement.  The general idea seems to be that we
can take "arbitrary" Haskell programs and turn them into compositions
within any category that has certain properties.  This category could
be an executor, a hardware synthesizer, or a graphing tool that
produces a visualisation of the program.  My bind unbent a bit when I
realised this was just yet another deeply embedded language, and that
it likely has the same problems as other deep embeddings in Haskell
(in particular, recursion becomes awkward).  Using (almost) arbitrary
categories as the compilation target is a cool trick, though.