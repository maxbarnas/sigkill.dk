---
title: Sindre
---

Programming language for writing simple GUIs
===
[(Available on Github)](https://github.com/Athas/Sindre)

I wrote a programming language called Sindre.  It came about after I
got tired of writing simple X11 tools directly against the Xlib API.
At the time I was doing a lot of shell scripting, and I had become
enamored with the pattern-action mode of programming found in
[Awk](http://en.wikipedia.org/wiki/AWK), and I realised I could
implement a similar language where the patterns were events (both from
X11 and in the MVC sense), and the actions were... well, imperative
code.  Combined with a simple way to declaratively specify the GUI, I
would have all the functionality I needed to write simple programs to
interact with the likes of [the surf
browser](http://surf.suckless.org).

I wrote a number of small tools, including controlling programs for
surf (basically just a more intelligent
[dmenu](http://tools.suckless.org/dmenu)), and
[gsmenu](/projects/gsmenu), the latter of which I still use for
managing windows in Xmonad.

Unfortunately, I have more or less given up on the idea of loosely
composable GUI programs.  It is simply too difficult to pass around
the necessary information, and the programs written to support it
(like surf) tend to lack important features.  For example, surf is
lacking in security, key management, stability, and many other small
quality-of-life features.

But I suppose that given I still use programs written in Sindre every
day, it has been a success of a sort.
