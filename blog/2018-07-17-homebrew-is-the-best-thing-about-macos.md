---
title: Homebrew is the best thing about macOS
description: This is not a very high bar to clear, unfortunately.
---

This winter I asked [my department](http://diku.dk) for a MacBook Pro.
And not just any MacBook Pro, but one that was top of the line, with a
15" inch display, 16GiB of RAM, and a Vega-based GPU.  I have used
Linux exclusively for over ten years, but plain curiosity and a desire
to ensure that [my code](https://futhark-lang.org) works well on macOS
made me stray from my usual staple of ThinkPads.

Now, don't get me wrong - the MacBook is not a bad laptop.  The build
quality in particular is great (except for the keyboard), the display
is very good, and the speakers are perhaps the best I have seen in a
laptop.  Physically, it feels like a premium product.  But my old
ThinkPad X250 was both just as good overall, and significantly
cheaper.  Machine-wise, the lack of a proper docking port on the
MacBook means I have to fiddle with four different cables (power,
USB/keyboard/mouse/ethernet, monitor, audio) when I show up to work in
the morning.  Sometimes a bit more fiddling becomes necessary during
the day, as the USB-C connectors do not have a particularly tight fit,
and may dislodge if the laptop gets bumped.

However, these are hardware issues, and physical gizmos always have
annoying flaws.  It was expected, and I can mostly tolerate that.  My
ThinkPad certainly also had oddities.  What I was especially looking
forward to was macOS.  After using Linux for over a decade, I had
gotten used to all the various quirks, flaws, lack of polish, and need
for manual configuration that invariably accompanies a complex system
that does not have a paid QA team testing it.  I suppose that, over
the years, I had built up some unreasonable expectation that the
commercial operating systems would have none of the bugs, issues, and
incompatibilities that every Linux user eventually encounters.  Boy
was I disappointed.

Off the top of my head, I have had the following problems:

* With the lid down, it can take a few tries to make the Mac realise
  that an external monitor is connected.  Usually I have to re-connect
  the monitor or the power cable a few times, mash the keyboard, reset
  the monitor, or open the lid before macOS deigns to send an image to
  the monitor.

* Sometimes audio will simply stop working, no matter which output
  source I pick.  At least broken audio makes an old Linux user feel
  right at home.

* GDB does not simply work, but has to be [specially signed by a key I
  make up
  myself](https://gist.github.com/danisfermi/17d6c0078a2fd4c6ee818c954d2de13c).

* Valgrind is also weird.

* The Unix tools are outdated.  I do not mind a BSD userland, but I
  have no use for ten year old versions of `bash` and Emacs.

None of these are catastrophic issues.  I certainly deal with things
of similar severity on my Linux desktop at home.  But here's the
thing: the overall experience is *not all that more polished than a
Linux distribution running GNOME*.  It is a decent operating system,
but not worth the cost.

However, there is one glimmer of sunshine in these murky clouds:
[Homebrew](http://brew.sh/), the user-run package manager.  The
interesting aspects of Homebrew are not technical, but social.
Undoubtedly, systems like [Nix](https://nixos.org/nix/) are fare more
sophisticated.  But Homebrew has a laser-like focus on approachability
and simplicity of use.  This also extends to package development.  In
any of my long (and continuing) years of Linux, I never created a
single `.deb` or `.rpm` package.  I always found the tooling too
byzantine (such as [macro languages that generate shell
scripts](http://ftp.rpm.org/max-rpm/s1-rpm-build-creating-spec-file.html)),
and the process for inclusion into repositories too onerous.  No doubt
I could figure it out were I sufficiently motivated, but the friction
has so far been too great.  Doubly so, since I would have to learn
*multiple* package systems if I wanted to reach most Linux users.

Homebrew, in contrast, is much simpler.  A package definition is a
straightforward Ruby script that uses a simple DSL to define how to
fetch and build the software.  Inclusion into the repository is by [a
simple pull request on
GitHub](https://github.com/Homebrew/homebrew-core/pull/24138).  After
this, an automatic system takes over and produces precompiled
"bottles" of the package.  Very simple!

Part of the simplicity and usability of Homebrew is due to its limited
scope.  It exists exclusively to manage user-level applications and
libraries, not the operating system as a whole.  RPM and DEB solve
much more complex problems, and so the solutions are understandably
also more complicated.  For good reasons, they also cannot depend on a
centralised proprietary service like GitHub.

But the naturally limited scope of not the only reason for Homebrews
usability.  Its maintainers quite aggressively try to limit the
degrees of freedom in the system, to avoid unexpected (and untested)
behaviour.  Packages must built cleanly, [without macOS-specific
patches](https://github.com/Homebrew/brew/blob/master/docs/Acceptable-Formulae.md),
and optional components are frowned upon.  While I did at times become
frustrated by some of the rules (no [`stack`](http://haskellstack.org)
for building Haskell packages, for example), I [ultimately managed to
follow them](https://github.com/Homebrew/homebrew-core/pull/26574),
and the end result might well be a simpler system for everyone.  It
does sometimes [keep out complex
packages](https://github.com/Homebrew/homebrew-core/pull/29800), but I
suppose the hope is that it will incentivize maintainers to clean up
their act and simplify their build requirements.  I strongly believe
in robustness-through-simplicity, particularly by removing features
and configuration knobs, so I sympathise with this approach.

Of course, the main problem with Homebrew is that I don't much like
the operating system on which it runs.  But perhaps even Linux has
room for an approachable non-distribution-specific package manager for
non-system applications.  I will certainly have to take a look at
[Linuxbrew](http://linuxbrew.sh/).

Note: I had originally wanted to title this post *Homebrew is the only
good thing about macOS*, but that felt a bit too provocative.
