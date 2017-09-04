---
title: ICFP 2017, day 1
description: My impressions of the first day of ICFP.
---

I'm attending ICFP 2017 this year, and my plan is to end each day by
writing about my impressions.  As a bonus, this entry will also
discuss my day of arrival (Sunday, where I did not attend any
presentations).

Arrival
==

ICFP this year is held at Oxford.  One particularly nice effect of
this is that accomodation is at the many colleges, with signup via a
simple web form on the conference page.  This is vastly superior to
hunting for dinky hotels yourself!  I was quartered at [Lady Margaret
Hall](http://www.lmh.ox.ac.uk/), and even if the room was not as
objectively "nice" as a similarly priced hotel, the convenience is
easily worth the premium.  An added bonus is that all the colleges are
guaranteed to be within reasonable walking distance of the conference
venue (the [Andrew Wiles
Building](https://www.maths.ox.ac.uk/about-us/our-building)).  I found
it odd that while the room was equipped with a water heater, it was
bundled with only two pockets of tea, accompanied by seven small
canisters of milk.  No wonder England lost her Empire.

The Sessions
==

I will not write about everything I saw - only what I considered
particularly interesting (or had enough energy to take notes).  I
liked the auditorium was equipped, which was well equipped with desks
suitable for taking notes.  This is something I missed at PLDI.  The
auditorium was extremely full during the keynote, and attendance did
not drop significantly later in the day.  Oddly, despite this
seemingly being the main auditorium for the mathematics department,
coffee was not allowed.  How do they intend to teach mathematics under
such circumstances?

The keynote was by Chris Martens, and on "unforeseen interactions with
computers".  Sounds like management-speak for "bugs" to me!  Another
way of putting it, and which I think captured the essence of the
keynote quite well, is "human-computer collaboration".  The keynote
was about using logic as an intermediate language for conversing with
computers, and for driving the search algorithms that are at the core
of (classical) AI, as opposed to modern data-driven statistical
approaches.  Nice to see that the old ideas are still around!  I
always found them much nicer than the modern trend of turning
everything into a matrix multiplication.

There was a presentation on a DSL for video editing/manipulation,
called *Super 8 Languages for Making Movies*.  The talk was really
about applying the principle of "language-oriented programming", by
using the facilities provided by [Racket](https://racket-lang.org/) to
define a stack of eight DSLs that provided gradually more refined ways
to manipulate video.  The resulting language looked quite like the
popular combinator-based approaches to image manipulation, although no
doubt the addition of the time dimension adds some extra
opportunities.

The next presentation was *Testing and Debugging Functional Reactive
Programming*, which started out by showing a nice Arrow-ized library
for doing FRP.  They then moved on to showing
[QuickCheck](http://www.cse.chalmers.se/~rjmh/QuickCheck/)-based
generation of event streams to detect bugs (cool!), and an interactive
debugger that allowed replay and modification to reproduce bugs (even
cooler!).

Next up was *Lock-Step Simulation Is Child's Play*, which discusses
how synchronising distributed real-time applications (such as
multiplayer games) is very difficult in the presence of latency.  The
authors showed how purity (unsurprisingly) makes the whole exercise
much easier, by providing guaranteed-safe replay of events once it
information from other nodes are received.  The entire thing was done
in the context of [code.world](https://code.world/), an initiative
that uses Haskell to teach mathematics to middle school children.

Last in the first session was *Scaling up Functional Programming
Education: Under the Hood of the OCaml MOOC*, which discussed a large
online course that the authors had run.  Out of 7000 enrolled
students, 2418 showed up at course start, and somewhere between 500
and 1000 actually completed the course.  Not a bad retention
statistic.  The talk was mostly about the technical infrastructure
they used, which in particular involved fully automatic grading, and a
policy of zero installation - everything ran in the browser.

A later presentation was *A Pretty But Not Greedy Printer*, which
showed a new prettyprinting library.  This one, conceptually, contains
"alternatives", which can be used to specify different ways of
printing something, depending on available space.  In contrast to
greedy approaches, this can generate more pleasing output by using
non-local information.  The downside is significant slowdown (often an
order of magnitude slower than current Wadler-style prettyprinters),
but modern machines print fast enough anyway.

Perhaps the most thought-provoking presentation of the day was
*Generic Functional Parallel Algorithms: Scan and FFT* by Conal
Elliott.  He takes a category/generic programming-based approach to
parallel programming, one that emphasises the structure of the
recursive patterns rather than array index arithmetic.  I am
definitely in favour of trying to find an alternative to low-level
array programming.  However, I feel the presentation was missing a
"and then a miracle occurs" step to turn the proposed technique into
efficient code.  This talk definitely convinced me to take a deep hard
look at the paper, though.

The last presentation I attended was *Effect-Driven QuickChecking of
Compilers*, which showed a technique to generate interesting test
programs for OCaml compilers.  The trick is to avoid "boring"
programs, which are syntax- or type-incorrect, and also avoid programs
that exhibit undefined behaviour (turns out OCaml has undefined
evaluation order - I thought it was always right to left).  I would
like to try their approach on generating test programs for [my own
compiler](http://futhark-lang.org/).

I was a bit skeptical after initially browsing the ICFP programme, but
I have been pleasantly surprised.  This year's ICFP is so far quite
enjoyable, and significantly better than last year, which I did not
like overmuch.
