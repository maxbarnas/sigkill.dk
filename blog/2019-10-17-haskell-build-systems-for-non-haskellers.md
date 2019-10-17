---
title: Haskell build systems for non-Haskellers
description: Somehow I don't think enough people have had their say on this fascinating issue.
---

The Haskell build system war seems to have quieted down a bit, with
both [`cabal`](http://hackage.haskell.org/package/cabal-install) and
[`stack`](http://hackage.haskell.org/package/cabal-install) seeing
wide use.  I have my own preference (cards on the table: it's `stack`
for the moment), but I feel my reasons were not represented well in
the flame wars.  I figure I should write them down.

It is my impression that many Haskell programmers fall into two groups:

  1) Those who mainly produce libraries for distribution on Hackage,
     which must work with many different dependencies and versions of
     GHC.

  2) Those who mainly write Haskell applications that they also host
     or deploy themselves, and who tend to freeze their environment.

(This is a gross simplification, bear with me.)

I am mostly related to the second group, but with some differences: my
main project is [a Haskell program](https://futhark-lang.org) whose
audience is users who do not much care that it is implemented in
Haskell.  While I try to make binary packages available, it is still
important that people can easily download and compile the source code
themselves.

For most C programs, this has historically been straightforward.  You
obtain the code, run `./configure && make` (or the `cmake` equivalent)
and that's it.  This is because most C programs have either no
dependencies, or just a few popular ones that are likely to be
available via the OS package manager.  Further, C is stable enough
that it tends not to matter exactly which version of the C compiler
you are using.

For both good and ill, Haskell is a more unstable language, and
programs tend to have dozens of dependencies.  In practice, if I want
my users (who may not care about Haskell!) to have a reasonable chance
of successfully compiling my program, I must ensure that they use
exactly the same compiler and library versions as I do.

This was `stack`'s major advantage for me.  While `cabal freeze` can
be used to pin dependencies for `cabal`, you cannot also pin the
versions of GHC and tools such as
[`happy`](https://www.haskell.org/happy/).  While I can certainly
document the required versions, providing instructions on how to
install them on a large variety of operating systems is no easy task,
particularly when the obvious solutions (e.g `apt install ghc happy`)
are likely not to be correct.  In contrast, it is very easy for me to
just point at [`stack`s installation
instructions](https://docs.haskellstack.org/en/stable/README/#how-to-install)
and let them worry about making it work on whatever strange operating
systems people come up with.

There is also a particularly tricky category of users: people who
already have some old or defective Haskell setup that they obtained
for a course or idly experiment and since forgot about.  Debugging
build errors due to interactions with these remnants can be quite
maddening.

Modern `cabal` has solved most of these problems well.  With
[Nix-style local
builds](https://cabal.readthedocs.io/en/latest/nix-local-build-overview.html),
most tools and libraries needed will be installed automatically and
isolated from anything else going on with the system.  It is, however,
still on the user to install *two* programs themselves: `cabal` and
the *right* version of GHC.

While most package managers should already contain an adequately new
version of `cabal` (or will soon in any case), the situation with GHC
is more complicated.  Some systems, like Ubuntu LTS, will contain a
version that is too old.  Others, like [Homebrew](https://brew.sh),
may contain one that is too new!  This is because it tends to take a
couple of months after a GHC release before all of my dependencies
have been updated.  There is of course
[`ghcup`](https://www.haskell.org/ghcup/), which makes it easy to
obtain a specific version of GHC, but I must then maintain
human-readable documentation on how to do so (and my users must
manually keep track of when it changes).  In contrast, `stack build`
will automatically work the same for my users as for me, which means I
will likely notice any problems quickly.

In short, while my fondness for `cabal` has grown significantly for my
own uses, I still find `stack` superior for the task of giving my
source code to users who do not particularly care that it is written
in Haskell.  My philosophy is that the installation instructions are a
crucial part of a program's user interface.
