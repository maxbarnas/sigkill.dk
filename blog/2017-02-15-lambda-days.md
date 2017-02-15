---
title: Lambda Days 2017 trip report
description: Notes on the Lambda Days conference in Krakow
---

Last week, I attended the [Lambda
Days](http://www.lambdadays.org/lambdadays2017) conference in Krakow.
I did not know about this conference until last years FHPC, where
[John Hughes](http://www.cse.chalmers.se/~rjmh/) suggested submissions
to its research track.  My colleagues also had not heard of this
conference before.  I feel this is obscurity is undeserved: Lambda
Days was well organised and most presentations were quite good and on
relevant topics.  Apart from the research track, at which I presented
[Futhark](https://futhark-lang.org), Lambda Days is an industrial
conference, not an academic one.  While I was unable to attend all
presentations, I did attend several, which I will summarise below.  I
believe every talk was recorded on video, but at the time of this
writing, recordings are not yet available.

Krakow itself was an unusually pretty city, and a welcome diversion
from the urban horror of Brussels, which had been the scene for my
[trip to FOSDEM](http://sigkill.dk/blog/2017-02-06-fosdem.html).  I
will definitely try to attend Lambda Days again next year.

Day One
==

The day opened with a keynote by John Hughes and Mary Sheeran, on *Why
Functional Programming Matters*.  There was little new in John's part
if you have already read [his famous
paper](http://worrydream.com/refs/Hughes-WhyFunctionalProgrammingMatters.pdf)
or seen a previous presentation on the topic, but he was as always a
highly engaging speaker.  Mary's part was more unfamiliar to me, as
she spoke about functional hardware specifications.  Mary also
mentioned [Backus's famous Turing Award
paper](http://dl.acm.org/citation.cfm?id=359579).  I was amused when
she suggested skipping the latter half, which she said had not aged as
well.  This was exactly the impression I got when I read the paper
myself.  According to the keynote, the four principal concepts of
functional programming are: *Programming with whole values*, having
strong *combining forms*, possessing *simple laws*, and *using
functions as representations*.  No argument here (except I'll say the
latter often engenders far more trouble in practice than the former
three).

I spent rest of the day attending the research track.  the first
presentation was on [hardware realisations of functional
specifications](http://www.lambdadays.org/lambdadays2017/stanislaw-ambroszkiewicz)
(I think).  The thesis seemed to be that first-order functions can be
mapped directly to hardware, and with (future?) dynamically
reconfigurable circuitry, so can higher-order functions.
Unfortunately, the speaker failed to optimally utilise the microphone
(to put it in diplomatic terms), and as a result, most of what was
said could not be hard.  While I hardly consider myself graceful with
a microphone, I am grateful for my years in the student revue for
teaching me the basics.  Several in the audience rose and left as the
microphone situation continued to deteriorate, which I found slightly
rude.

Next talk was on [automatically deriving parallel cost
models](http://www.lambdadays.org/lambdadays2017/kevin-hammond), but
if I had to give my own summary, I would say that it was about making
functions express their parallel structure in their types.  The point
is that this will allow callers to implement the parallel structure in
whichever way they see fit, and have the types to guide and check
them.  The approach hinges on expressing parallelism through specific
well-behaved recursion schemes.  One main one seemed to be the
hylomorphism; essentially generalised divide-and-conquer.  This segued
nicely into the next talk, which was on [automatically detecting such
recursion
schemes](http://www.lambdadays.org/lambdadays2017/adam-d-barwell).
Combined with the previous work, this is essentially
auto-parallelisation for functional languages!  Although in contrast
to the black-box behemoths found in the imperative world, the focus
here is to aid the programmer in refactoring his program to obtain
parallelism.

The [next talk](http://www.lambdadays.org/lambdadays2017/niki-vazou)
was on [Liquid
Haskell](https://ucsd-progsys.github.io/liquidhaskell-blog/); an
effort to add refinement types to Haskell.  In comparison with
dependent types, refinement types are more limited, but with decidable
type checking.  The motivating example was Heartbleed-ish behaviour
via the `Text.Unsafe` module, which did not seen very convincing to
me.  In this case, dynamic checks (which were explicitly disabled)
would have been sufficient.  The practical demonstration made the
system seem surprisingly practical, though.

Next up was a person doing [HPC traffic simulations in
Erlang](http://www.lambdadays.org/lambdadays2017/wojciech-turek).
Never knew anyone ran Erlang on a supercomputer.  The system seemed to
scale well, but there was no comparison of absolute runtimes to
non-Erlang implementations.  The next talk was [on automatically
detecting divide-and-conquer patterns in Erlang
programs](http://www.lambdadays.org/lambdadays2017/tamas-kozsik), with
the goal of refactoring for parallelism.  sounds familiar.

We moved on to, as I understood it, [adding functional annotations to
existing HPC
code](http://www.lambdadays.org/lambdadays2017/daniel-rubio-bonilla).
It looked vaguely like a functional version OpenMP.  I spaced out a
bit here, since I have a dire allergy against [dusty
deck](http://www.catb.org/jargon/html/D/dusty-deck.html) HPC code.
The following talk seemed a bit oddly placed at the research track, as
it was on [how Jet.com had used F# to write hundreds of
microservices](http://www.lambdadays.org/lambdadays2017/nikhil-barthwal),
although the presenter was decent.  The final research talk was on
[using Haskell Arrows to describe reactive
UIs](http://www.lambdadays.org/lambdadays2017/annette-bieniusa).  I
wonder if they will stick with arrows, or switch to the more familiar
monads, as [Hakyll](https://jaspervdj.be/hakyll/) did.

Day Two
==

The second day keynote was quite ambitious and extremely polished.  I
recommend reading [the companion
essay](http://blog.troutwine.us/2017/02/10/build-good-software/).  In
short, the keynote was on how technology reflects the politics of the
organisations that fund the development, and the importance of
creating technology that embeds our desired values.  In particular,
humans must be kept in the loop and never be totally subservient to
machines.

The next talk was by David Turner on [some history of functional
programming](http://www.lambdadays.org/lambdadays2017/david-turner).
The speaker, the author of Miranda, had been personally involved in
many of the efforts that eventually led to Haskell.  Turner had some
interesting points.  For example, that (original) Lisp was not really
based on the lambda calculus, as the scope rules were wrong until
Scheme introduced static scoping in the 1970s.  It was also
interesting to hear where various now-popular functional language
features had originated.  [ALGOL
60](https://en.wikipedia.org/wiki/ALGOL_60), for example, supported
functions as parameters, but not return values.  The
[ISWIM](https://en.wikipedia.org/wiki/ISWIM) language, never
implemented, supported first-class functions but also had imperative
features.  A simplified form of ISWIM became FAL, and the functional
core of FAL became
[SASL](https://en.wikipedia.org/wiki/SASL_%28programming_language%29),
the St Andrews Applicative Language.  Turner emphasised the removal
Lisp's metaprogramming features (`quote`/`eval`), but it is unclear
whether SASL was dynamically or statically typed at this point.
Initially, SASL was strict and had no real pattern matching, but it
eventually became lazy in 1976, and grew pattern guards and `case`.
ISWIM also begat other languages, such as NPL and Hope, where
algebraic data types were developed (and copied into SASL).
Eventually, a simplified SASL was released as
[Miranda](http://miranda.org.uk/), which became the main basis for
Haskell.  I recommend [this very readable
paper](http://haskell.cs.yale.edu/wp-content/uploads/2011/02/history.pdf)
for the rest of the Haskell story.

The [next talk](http://www.lambdadays.org/lambdadays2017/adam-warski)
was on free monads, a frequently mentioned Haskell technique.  I do
not use free monads in my own code, so maybe I'm missing out.  The
talk did not really give my any new usage ideas, as it was more about
the underlying algebraic inspiration.  The
[Scala](https://www.scala-lang.org/) language was used for exposition,
which seemed an awkward choice.  The Scala syntax appears almost
hostile to idea of functional programming, with much verbose ceremony.
And why the awkward name `flatMap` instead of Haskell's much clearer
`>>=`?.

I then went to [a talk on fast neural
networks](http://www.lambdadays.org/lambdadays2017/riccardo-terrell).
I suspect the presenter ran out of time, because he didn't really get
to a main point.  He spent some time talking about naive and very
inefficient agent-based implementations of neural networks.  Are
neural networks not best done by bulk array operations these days?

The final talk I was able to attend was a [very interesting one on
recursion
schemes](http://www.lambdadays.org/lambdadays2017/pawel-szulc).  Alas,
more Scala.  Notation does matter, and Scala syntax is eye poison.  My
main thought here was whether one could build a language with
recursion schemes as a primitive.  This could function as an
alternative to the flattening algorithm for handling nested
parallelism, as the recursive structure could be directly manipulated
by the compiler.  I definitely agree with the presenter that explicit
recursion all too often leads to incomprehensible spaghetti code.
