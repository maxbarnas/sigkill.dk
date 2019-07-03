---
title: My history with window managers
---

My history with window managers
==

Sometime in prehistory, I installed Mandrake Linux on my computer, but
I didn't stick with it.  I suppose it ran KDE of some sort.  When I
eventually did switch to GNU/Linux in August of 2003, I initially did
not use a window manager at all.  The reason is that I had chosen to
install Debian Woody, which failed to bring up X.  Thus, my first
Linux experience was using the console and learning `vi` to, in vain,
try to fix the XFree86 configuration file.  Much later I realised that
the issue was that Debian Woody's `nv` driver was not compatible with
my NVIDIA graphics card.  Switching to the `vesa` driver (or
installing the proprietary NVIDIA driver) would have fixed it.

Instead I switched to [Knoppix](http://www.knoppix.org/), which was
mostly a live CD, but could also be installed to a disk - and in this
case, was essentially Debian with better hardware detection.  It came
with [KDE](https://kde.org/), which was then what I used.  Eventually
I switched to [GNOME](https://www.gnome.org/) 2.2.  I don't remember
the reason - maybe that the upcoming GNOME 2.4 was fairly hyped at the
time.

After that I went a bit back and forth (I distinctly remember trying
to learn Qt programming in April of 2004), but eventually switched to
the tiling window manager
[Ion](https://en.wikipedia.org/wiki/Ion_(window_manager)) window
manager (this was before the [author became grumpy and abandoned
it](https://lists.freebsd.org/pipermail/freebsd-ports/2007-December/045494.html).
I don't remember exactly why, but I was probably chasing obscure
software to establish hacker street cred.  I never liked its model
much though, and eventually found
[ratpoison](https://www.nongnu.org/ratpoison/), a window manager
inspired by [GNU Screen](https://www.gnu.org/software/screen/).  It
felt much less magical and predictable than Ion, and I used that for a
great many years.  Since I was a [smug Lisp
weenie](http://wiki.c2.com/?SmugLispWeenie) in those years, I also
tried out [StumpWM](https://stumpwm.github.io/) - a ratpoison
successor written in Common Lisp - but I had some early problems with
it losing window focus, so I stuck to ratpoison.

As happens to all hackers, I eventually wanted to write a window
manager of my own.  The result, from around 2009, was
[Mousetoxin](../files/mousetoxin.pdf), a clone of ratpoison written in
[literate Haskell](https://en.wikipedia.org/wiki/Literate_programming)
(if you check the Mousetoxin link, you'll find it's a PDF - the actual
source has been lost).  It worked quite well, and I used it for a
couple of years.  About a year later, I did switch to
[xmonad](https://xmonad.org/) to fit in with the rest of the Haskell
community, although I did end up [writing an entire programming
language](../projects/sindre) just so I could write a few tools (like
[gsmenu](../projects/gsmenu)) for interacting with it.  It made sense
at the time, but in retrospect it was a bit silly.

I used xmonad for years, right up until curiosity made me switch over
to GNOME 3 around 2016.  Most of my work was (and is) done in a full
screen Emacs session, and GNOME supported that well enough, while
having fewer bugs than xmonad.  EVentually I did grow tired of being a
[WIMP](https://en.wikipedia.org/wiki/WIMP_(computing)) and in June of
2019, I switched to [sway](https://swaywm.org/), after I figured out
[how to make it act like
ratpoison](../blog/2019-06-30-how-to-make-sway-act-like-ratpoison.html).
I rediscovered just how pleasant a nice tiling window manager can be.
It may also help that the user base of tiling window managers is
somewhat larger than it used to be, so the troubleshooting is more
well distributed.

*To be continued...*
