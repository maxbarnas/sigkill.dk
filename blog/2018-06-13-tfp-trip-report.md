---
title: TFP'18 Trip Report
description: Trends in Functional Programming 2018 in Gothenburg and what I saw there.
---

These are my notes from my first visit to [Trends in Functional
Programming](http://www.cse.chalmers.se/~myreen/tfp2018/).  Overall I
had a great time - the audience was friendly, and the talks more
accessible than is usually the case at the larger conferences.  I
suspect this is due to most of the presentations being given by fairly
new researchers who are still themselves new to their subjects, rather
than senior academics who are reporting the latest news in a
decades-old research agenda.

Also, Gothenburg is one big hill.  Ugh.

Day One
==

The invited talk was *Refactoring Reflected* by Simon Thompson.  This
was a general overview of the difficulties and motivation behind
refactoring (renaming, function extraction, etc).  The speaker went
over a lot of various quirks in Haskell, Erlang, and OCaml that make
refactoring troublesome in these languages.  While there has been some
progress in automatic refactoring for fixing bugs and such, he seemed
quite sceptical about fully automated refactoring.  A human must be
kept in the loop.  This seems sensible, since much refactoring is
about making the code more readable to a human.  He also believes that
a refactoring tool need not be 100% automatic; as long as it can do
95% (and clearly label the remaining 5%, not just screw them up),
that's fine.

The speaker used one very striking catchphrase: "The more precise the
types, the more fragile the structure".  The context was a point about
how usually refactoring is done without changing the types of
anything, but programs in dependently types languages are often so
rigid that refactorings will have to change the types.

I was a bit disappointed that the presentation skipped what I consider
the most difficult aspect of refactoring tools and similar, namely
retaining original formatting in the untouched parts of the code.
This is because normal parsing techniques all produce *abstract*
syntax trees, where irrelevant details about whitespace (and
comments!) are gone.  The speaker suggested that this problem can be
ameliorated via the use of code formatters in the style of `gofmt`,
but I am not so sure.

It was mentioned that they debug their refactoring tools by generating
random programs and then firing random refactorings at them.  That
sounds fun.  I wonder what the resulting programs look like.

The first ordinary talk was *Liquid: A concurrent calculus with
declaring first-order asynchronous functions*.  This was an attempt to
provide some syntactic sugar on the usual `await`/`async` mechanisms
by making calls to asynchronous functions syntactically the same as
calls to synchronous functions, then automatically also turning
dependent statements into futures.  For example, assuming `request` is
an asynchronous function:

```
var r = request("http://...")
print(r)       // Not executed until r is available
print("hello") // Executed immediately
```

This seems very messy and unpredictable.  I doubt this is superior to
a bit of boilerplate.


The second talk was *Shifting and Resetting in the Calculus of
Constructions*, and while it seemed solid work, I did not have the
background necessary to understand it.  I think it was fundamentally
about supporting `call/cc` in dependently typed languages, but I'm not
really familiar with the shift/reset mechanism.

Next up was *Colocation of Potential Parallelism in a Distributed
Adaptive Run-time System for Parallel Haskell*.  I'm generally
sceptical of parallel Haskell because I find it difficult to use
efficiently and I see very few real-world applications in practice
(concurrent Haskell, on the other hand, is a big success).  This
presentation talked about a new work-stealing scheduler for
distributed parallel Haskell that used a notion of "ancestry" to
decide which sparks should be stolen by idle processors.  Essentially,
the runtime keeps track of how sparks are related by their call stack
(simplifying a bit here), and processors that finish a spark will go
on to try to execute the most related one.  The hope is that this
spark will already be close by.  The main weakness of the presentation
was that the benchmarks did not contain any sparks that required large
quantities of data, so migration was only latency-bound, not
bandwidth-bound.  Also, as is unfortunately common with parallel
Haskell benchmarks, only scaling was shown, and not performance
compared to non-Haskell parallel implementations.

Then was *Reversible Choreographies in Haskell*, which is an
implementation of a Haskell DSL for specifying protocol
implementations, where the actions of the protocol implementations are
(dynamically) checked via session types.  The work was the practical
implementation of the theory paper [Causally consistent reversible
choreographies](https://dl.acm.org/citation.cfm?id=3131864), which I
have not read, so I had a bit of trouble appreciating the finer
details.

The penultimate presentation had the most frightening title in all of
TFP: *Intrinsic Currying for C++ Template Metaprograms*.  It was about
the effort to support traditional functional language features in C++
template metaprogramming, this time focusing on currying.  It was, as
expected, horrifying, but quite well done.  I still have a hard time
abiding a programming methodology that uses [compile errors as control
flow](https://en.wikipedia.org/wiki/Substitution_failure_is_not_an_error).

The final presentation was *On Optimizing Bignum Multiplication*, and
talked about an effort to implement a new library for arbitrary-size
integers.  Most of the talk was about experimentally determining the
optimal size for the bignum digits (make them as big as possible) and
the threshold for switching from [Karatsuba
multiplication](https://en.wikipedia.org/wiki/Karatsuba_algorithm) to
conventional grade school multiplication (do essentially what
[GMP](https://gmplib.org/) does.

Day Two
==

This day only had two sessions for some reason.

The first talk was *Active-Code Reloading in the OODIDA Platform*, and
essentially about supporting hot code (re)loading for on-board car
analysis platforms by sending them Python code (as strings) to be
evaluated on-device.  While this is certainly flexible, I can't help
but feel that the potential issues were glossed over.

The second talk was *Towards Optic-Based Algebraic Theories: the Case
of Lenses*, and went a bit over my head.  It seemed to focus on
constructing a generalisation of lenses that also works for impure
structures.  In particular, it was observed that `MonadState a (State
s)` can be seen as a generalisation of `Lens s a`.

Next up was *Type Safe Interpreters for Free*, a pretty nifty library,
called Saint, which "connects your Haskell eDSL to the cloud".
Fundamentally, Saint provides a semi-automated away to expose an
untyped interface (a necessity when it goes over the web) to a typed
API, where the type checking is obtained for free.  Cool stuff.

The final talk was yet another one I had a hard time following:
*Handling Recursion in Generic Programming Using Closed Type
Families*.  I have done only a little generic programming in the
Haskell sense of the word, and only enough to decide that I prefer the
boilerplate to the complex techniques you otherwise end up using.

In the evening we went on a lovely combined four-hour boat ride and
dinner on the rivers surrounding Gothenburg.  Major kudos to the hosts
for that one.

Day Three
==

The invited talk on day three was one of my favourites of the entire
event.  It was titled *Retrofitting purity with comonads*, and that
was exactly what it was about.  In a pure language, we add support for
effects with monads.  So in an effectful language, how do we add
support for guaranteed-pure computation?  Comonads of course!
Comonads are a wonderful dual to monads that are constructed by
"reversing" the arrows from a category theoretical point of view.  In
practice, it means that for a comonad `m` you have functions

    coreturn :: m a -> a

    cojoin :: m a -> m (m a)

(Usually called `extract` and `duplicate`.)  It makes logical sense,
too: in an impure language, you don't want the programmer to be able
to promote the result of an impure computation to a pure value, but it
is fine to inject a pure value into the impure (non-comonadic) world.
The use case seems to be to help retrofit existing impure functional
languages, like OCaml, with purity for optimisation and reasoning
purposes.  I talked a bit with the presenter, and he did not seem to
think there was a good reason to use this kind of design for a fresh
language (just make it pure instead).

The first normal research talk was *Inductive type refinement by
conjugate hylomorphisms*.  It seemed to be about using some category
theory-ish diagram to explain types defined via something called
"ornaments", but I had a really hard time following this one.  I guess
that the purpose is explaining the principles behind identities such as

    length (xs ++ ys) = length xs + length y

Intuitively, we can see an integer as a list that has "forgotten" some
extra information (its values) and how contains only the lists.  There
was also a connection to refinement types that I completely failed to
grasp.  Somewhat frustrating that the post-proceedings are months
away!


The next talk was *Folds, Unfolds, and Metaheuristics: Towards
Automatic Rewriting and Derivation of Metaheuristics*.  Heuristics are
algorithms we use to approximately solve really hard problems
(especially the NP-hard ones).  *Meta*-heuristics are the building
blocks for heuristic approximation algorithms.  This talk was on an
in-progress framework for expressing (in Idris) a dependently typed
representation of these building blocks, permitting programming
transformation of the algorithm itself.  Unfortunately, the only
example use that was hinted at was adding timeouts to various parts.
I will definitely be keeping an eye on this one, to see where it goes.

Next up was a position paper (well, talk): *Graph Reduction Hardware
Revisited*.  The presenter argued that while graph reduction hardware
was out-competed by commodity hardware in the 80s, the death of
sequential speedups and (especially) the rise of FPGAs means we should
reconsider this old idea.  There seems to be two ways of going about
it: either compile a functional (core) language directly to a hardware
description language, or compile it to a set of supercombinators
(think SKI), an interpreter for which is then manually implemented on
an FPGA.  I think the latter is what the presenter was most
enthusiastic about.  I am less enthusiastic about the idea as a whole;
or rather I believe it is premature.  FPGAs are not some perfectly
flexible piece of reprogrammable hardware, while more flexible than
traditional CPUs (or GPUs), they still need to be used *just right* to
reach peak performance.  In particular, the hardwired functional units
(ALUs etc) are much more efficient than what can be built using the
reprogrammable gates.  I think we may have to wait for either cheap
ASIC fabrication to become possible (which is decades away), or use
functional hardware description languages, that can map more cleanly
to the FPGA domain.  There's still no free lunch.

Next was *Improving Haskell*, which was not about improving Haskell,
but rather about improving Haskell *programs*.  Reasoning about
performance in a lazy language is tricky, because it depends on the
context in which the expression is used.  Consider an expression
`(fast x, slow x)` versus `(slow x, fast x)`.  The former is faster if
they are passed to `fst`, but the second is faster if passed to `snd`.
*Improvement theory* is a theory for reasoning about performance in
*all possible contexts*.  Apart from a basic introduction to
improvement theory, this talk was a demo of
[Unie](https://github.com/mathandley/Unie) - the University of
Nottingham Improvement Engine - which is an interactive tool for
helping write proofs in improvement theory.  It looked quite polished
as the presenter took us through part of a proof of why `xs ++ (ys ++
zx)` is an improvement on `(xs ++ ys) ++ zs`.

The penultimate talk was *High-performance defunctionalization in
Futhark*, given by the [DIKU](http://diku.dk) student Anders Kiel
Hovgaard, who implemented higher-order functions for
[Futhark](https://futhark-lang.org) for his masters project.  This was
a very successful project and Anders's work was very polished
(including both a robust implementation and a formal proof of
correctness of the defunctionalisation algorithm).  The talk was good,
too.

The final talk was *Strategic Skeleton Composition with Location Aware
Remote Data*.  The context was the distributed parallel Haskell
dialect Eden, which I had some exposure to earlier in my studies via
[Jost Berthold](http://jberthold.github.io/).  It works quite well,
but is hampered by requiring the use of a fork of the GHC runtime
system.  Eden is an elaborate fork-join model, and this talk was about
trying to avoid having to frequently send data back to the master
node, by parameterising parallelisation skeletons with a policy of
where to send the resulting data.  The example given was a bitonic
sorting network, where nodes should interchange data with each other
in a very structured form that can be predicted in advance.
Unfortunately there were no experimental results reported, so it is
very hard to judge how well it works.
