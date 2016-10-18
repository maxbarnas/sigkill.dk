---
title: FHPC'16 Trip Report
description: I went to FHPC'16 in Nara, Japan, and this is what I thought.
---

The International Conference on Functional Programming ([ICFP][]) is
likely the world's premier forum on functional programming.  Apart
from the main track, several workshops on specific topics are held in
the days preceding and following ICFP proper.  [Many][haskell]
[language][erlang] [communities][ml] use these mini-conferences to
meet in person and discuss issues of interest to their entire
community (and drink beer).

The workshop of greatest interest to myself is the workshop on
[High-Performance Functional Programming][fhpc], which I have attended
most years since it debuted in 2012.  FHPC has at times seemed to be
in risk of fading away - only 5 papers were accepted in 2015, and not
many more were submitted.  However, this year's FHPC seems to have
reversed this unfortunate trend, with 9 papers accepted, and almost
double that submitted.  More importantly, I felt that the quality of
the presented work was quite high.  in fact, I felt I got more out of
FHPC than the main FHPC track of presentations, although it is
probably contributory that FHPC matches my own research interests
exactly.

FHPC was scheduled at the same time as the Haskell symposium, which
seems unfortunate, as I suspect there is significant overlap in
potential audience.  Most people seemed to think the same, and it is
likely that FHPC will be moved to another time slot next year.  Still,
attendance was strong for a workshop, with a minimum of 20-30 people
in the audience at most times, and the (small-ish) room entirely full
at times - I don't think I have ever seen that before.

For the rest of this most, I will try to give my impressions of the
presentations I saw at FHPC.  Unfortunately, I am writing this a few
weeks after the workshop, so I may have forgotten a few points in the
interim.

First up was [Amos Robinson](https://www.cse.unsw.edu.au/~amosr/), who
presented [*Icicle: write once, run
once*](http://dl.acm.org/citation.cfm?id=2975992).  This work is about
writing streaming dataflow programs that are guaranteed to never
manifest the entire input data in memory.  I don't think the point was
to work on infinite streams, but rather to work on datasets of such
magnitude that it is not feasible to perform multiple passes over
them.

Next was [*Using fusion to enable late design decisions for pipelined
computations*](http://dl.acm.org/citation.cfm?id=2975993), which
presented a language embedded in Haskell for "programming pipelined
computations".  It felt like a (very) high-level hardware description
language, and is indeed also a continuation of the Obsidian/Feldspar
line of research.  Their language is built around stream transformers,
with fusion used to remove the potential overheads of programming with
many small transformers.

The next paper was [*Automatic generation of efficient codes from
mathematical descriptions of stencil
computation*](http://dl.acm.org/citation.cfm?id=2975994) - a paper
with 12 authors, easily beating the 8 on my own paper (although mine
has a sillier title).  In this work, a functional-style language is
presented for writing stencil applications, with a compiler doing the
usual stencil optimisations (time tiling) and generating efficient
code for the Japanese [K
supercomputer](https://en.wikipedia.org/wiki/K_computer).  I found
this work particularly interesting because the stencil language (with
the hilarious name *Formura*) was developed in concert with actual
scientists with actual simulation needs.  Formura enables these
scientists, who are not expert high-performance programmers, to easily
translate their mathematical models to code and obtain great parallel
performance.  It seems that *this time*, that oft-repeated promise of
functional programming has indeed borne fruit.  Notably, the work is a
[finalist in the 2016 ACM Gordon Bell
Prize](http://sc16.supercomputing.org/2016/08/23/finalists-compete-prestigious-acm-gordon-bell-prize-high-performance-computing/).

In [*JIT Costing Adaptive Skeletons for Performance
Portability*](http://eprints.gla.ac.uk/122321/), the authors present a
JIT-based approach to performance portability that makes use of
rewrite rules to, at runtime, transform the declaratively-specified
parallelism.  I must admit that I am sceptical of the rewrite-rule
based approach - specifically, its ability to scale to more
complicated cases.  How would e.g. loop tiling be represented?
However, the work targets *irregular* parallelism, which is certainly
a tough nut to crack, and my hunch is that some kind of JIT approach
may be the way to go.  (I strongly prefer ahead-of-time compilers, so
this is not easy for me to admit!)

The next presentation was by a fellow PhD student from
[DIKU](http://diku.dk) - [Martin Dybdal](http://dybber.dk).  The work
he presented ([*Low-level functional GPU programming for parallel
algorithms*](http://dl.acm.org/citation.cfm?id=2975996)) was on a
language called FCL, which is derived from Obsidian, but which, unlike
Obsidian, is not embedded in Haskell, but is instead a conventional
separate language with a compiler that generates OpenCL kernels.  I
think this is the right way to go - embedded languages can be
convenient, but are hard to target for code generation, and are
usually complicated to use, as they have to embed their type rules in
the type system of the host.  Haskell has a type system powerful
enough to embed most properties you want, but the ergonomics,
particularly with respect to type errors, can be very lacking.

I was up next, and presented [*APL on GPUs: a TAIL from the past,
scribbled in Futhark*](http://dl.acm.org/citation.cfm?id=2975997).
This paper was the extension of a student project where we compile
TAIL (a kind of statically typed intermediate language for APL) to
Futhark (the high-performance data-parallel language I work on during
my PhD).  Pretty amusing work - APL is of course great fun, and it is
very satisfying to get crazy factor-1000x speedups without that much
effort (because the optimising compiler is already written).  While I
felt my presentation was much more raw than others at the workshop, I
think people got a good impression of what we have done, and were
amused by my ribbing on some of the more silly aspects of APL.  I had
a good discussion with several people afterwards - even Simon Peyton
Jones himself had some interesting suggestions as to why array
languages don't seem to be that popular anymore.  Well, let's see if
we can change that by [making them go really
fast](http://futhark-lang.org/performance.html).

The next paper was by yet another DIKU colleague, Frederik Meisner
Madsen: [*Streaming nested data parallelism on
multicores*](http://dl.acm.org/citation.cfm?id=2975998).  Frederik has
been working on a extension of the classic
[NESL](https://www.cs.cmu.edu/~scandal/nesl.html) language where
streaming properties is visible in the type system.  Yes, it's another
streaming paper at FHPC - guess I know what to write about for next
year.  What I like most about this work (apart from the robust
multicore performance) is that it is very *principled* - the compiler
is not just some black box, but has a fairly understandable
compilation model (flattening).  Of course, flattening can easily make
a mess of some programs, especially as pertains to memory traffic, but
it is at least predictable.

For the last two presentations I was rather exhausted (and perhaps
even a bit starstruck after my conversation with SPJ).  Ben Lippmeier
presented [*Polarized data parallel data
flow*](http://dl.acm.org/citation.cfm?id=2975999), a type system
approach to ensuring that streaming(!) programs can run in constant
space.  The final presentation was [*s6raph: vertex-centric graph
processing framework with functional
interface*](http://dl.acm.org/citation.cfm?id=2976000), but
unfortunately I was by then too tired to remember much.

In summary, this was by a significant margin the best FHPC I have ever
attended.  In fact, this year I even found it better than the
"competing" PLDI workshop
[ARRAY](http://conf.researchr.org/track/pldi-2016/ARRAY-2016).  I hope
to attend both ICFP and FHPC next year, when it will be held in
Oxford.

[ICFP]: http://icfpconference.org
[haskell]: https://www.haskell.org/haskell-symposium/
[erlang]: http://www.erlang.org/community/workshops
[ml]: http://www.mlworkshop.org/
[fhpc]: https://sites.google.com/site/fhpcworkshops/
