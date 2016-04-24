---
title: Futhark
---

Futhark
=======

Futhark is a small programming language designed to be compiled to
highly performant GPU code.  It is a statically typed, data-parallel,
and purely functional array language, and comes with a heavily
optimising ahead-of-time compiler that generates GPU code via
OpenCL. Futhark is not designed for graphics programming, but instead
uses the compute power of the GPU to accelerate data-parallel array
computations. We support regular nested data-parallelism, as well as a
form of imperative-style in-place modification of arrays, while still
preserving the overall purity of the language via the use of a
uniqueness type system.  Development of the Futhark language and its
optimising compiler consistitutes most of the practical work on my
PhD.

More information can be found on the [main Futhark
website](http://futhark-lang.org).
