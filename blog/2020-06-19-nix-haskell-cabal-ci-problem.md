---
title: A subtle issue when using Nix and Cabal for CI
description: I ran into an issue with the CI setup for one of my projects, and I figured I'd write it down.
---

[Philip](https://munksgaard.me/) and I recently migrated the CI
infrastructure for [Futhark](https://futhark-lang.org) to GitHub
Actions.  We have many different CI jobs, in particular we compile
Futhark in many different ways (both `stack`, `cabal-install`, and
`Nix`) and on various operating systems.

It has mostly been a good experience, but one of our jobs was being
flaky.  The job in question was responsible for compiling Futhark in
order to run the unit tests (with `cabal test`), as well as run
[hlint](https://github.com/ndmitchell/hlint) on the source code.

To make it easy to use the same environment in CI and locally, we
decided to use [Nix](https://nixos.org/) to obtain the various
necessary tools, such as GHC itself,
[cabal-install](https://hackage.haskell.org/package/cabal-install),
and `hlint`.  Specifically, we used a
[shell.nix](https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
file, and then commands such as `nix-shell --pure --run 'cabal test'`
to run the tests.  Yet sometimes `cabal test` would fail with a
mysterious error:

```
/home/runner/.cabal/store/ghc-8.10.1/happy-1.19.12-77f44f4e1b397ecd8847f7694a29d33efa016984155f1eb70f21d8ed5fbf3069/bin/happy:
createProcess: runInteractiveProcess: exec: does not exist (No such file or directory)
```

[`happy`](https://www.haskell.org/happy/) is a parser generator that
`cabal` will automatically build if necessary, like all other build
tools.  It took me a while to realise that the error message is
misleading: the `happy` binary *does* exist (or else `cabal` would
rebuild it), but *it is dynamically linked against libraries that fail
to be found* (incidentally, who decided it was a good idea for the
dynamic linker to report the error like that?  Grumble.)

So how does this happen?  Well, to cut down on build times, our CI
uses caching.  Specifically, it caches the `~/.cabal/packages` and
`~/.cabal/store` directories.  This means that the `happy` binary we
use is likely one that was built during a previous CI run.  *However*,
because we run `cabal` under Nix, that `happy` binary will be
dynamically linked against libraries in the Nix store (located under
`/nix`), which we do *not* cache, because they are normally fetched or
rebuilt by Nix on demand.  The cached `happy` binary therefore has a
dependency on very specific libraries in the Nix store, which `cabal`
doesn't know about!  When the Nix store eventually changes, which it
does semi-frequently, the path to the C library embedded in the
`happy` binary will no longer be valid, and `happy` will fail to run.

How did we fix this?  Not elegantly, I'm afraid: we moved `cabal test`
to another job, specifically one builds without Nix, instead using
normal Debian packages.  I'd be quite curious to see if anyone has a
nice solution to this problem.
