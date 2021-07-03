---
title: Moscow SML on DOS
description: Nostalgia for a program I have never used.
---

Standard ML was used for my first programming course at
[DIKU](https://diku.dk), and so I have a soft spot for the language.
We used the [MosML](https://mosml.org/) implementation, and I had been
informed that it used to once run on DOS.  I'm not old enough to have
done that myself, but I was curious what that would be like.
Unfortunately, while I could find old references to various FTP
servers said to contain DOS executables of MosML, these links (and
usually the servers) were of course long dead.  Fortunately, [Peter
Sestoft](http://www.itu.dk/people/sestoft/) was able to dig up an old
FTP archive containing a distribution, which I uploaded to the
Internet Archive: [Moscow SML (MosML) 1.03 for
DOS](https://archive.org/details/mos1bin).  As far as I know, this is
the first publicly available version of MosML for DOS in decades.

It runs perfectly in [DOSBox](https://www.dosbox.com/), and using it
is... fine.  Just like any other MosML REPL, really.  The main
difference is that this old version does not support the ML module
system, so the top-level environment is very anaemic.
