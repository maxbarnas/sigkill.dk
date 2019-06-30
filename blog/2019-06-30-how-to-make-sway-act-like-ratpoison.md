---
title: How to make sway act like ratpoison
description: I switched to a new window manager and I wanted to make it behave like the one I used ten years ago.
---

[Sway](https://github.com/swaywm/sway) is an
[i3](https://i3wm.org/)-compatible
[Wayland](http://wayland.freedesktop.org/) compositor.
[Ratpoison](https://www.nongnu.org/ratpoison/) is a tiling window
manager for X11 that is largely modeled after [GNU
screen](http://www.gnu.org/software/screen).  After a lost couple of
years in the [WIMPy](https://en.wikipedia.org/wiki/WIMP_(computing))
land of [GNOME](https://www.gnome.org/), I wanted to go back to a
tiling window manager on my desktop system.  I still wanted to stick
to Wayland ([X11 is soon becoming
retrocomputing](https://www.phoronix.com/scan.php?page=news_item&px=X.Org-Maintenance-Mode-Quickly)),
which leaves sway as the only option.  However, I have no prior love
of i3, and I found the default key shortcuts bad.  Specifically, sway
assumes that it can be granted an entire modifier key (say, Alt)
for key shortcuts.  As an example, `Alt-f` makes a window full
screen.  A window manager making such assumptions is intolerable in
the presence of software like [GNU
Emacs](https://www.gnu.org/software/emacs/), which needs all the
modifier keys it can get.  Returning to `Alt-f` (or
[`M-f`](https://en.wikipedia.org/wiki/Meta_key) in Emacs-speak), this
shortcut is usually bound to the common command `forward-word`.  One
solution is to simply pick a more obscure modifier key, like Super or
Hyper, typically in the form of the Windows- or Menu-keys on a modern
keyboard.  Unfortunately, I use a [Unicomp reconstruction of a PS/2
Model M keyboard](https://www.pckeyboard.com/), which has no such
fancy keys.

A much better model of keyboard shortcuts is the one used by programs
such as GNU Screen, [`tmux`](https://github.com/tmux/tmux), and
ratpoison, where all commands are hidden behind a prefix key.  For
example, in ratpoison you open a new terminal by first pressing
`Ctrl-t` and then pressing `c` (without holding down Ctrl).  Giving up
`Ctrl-t` (or `Ctrl-b` for `tmux`) is a much easier sacrifice than an
entire modifier key.  Further, the usual convention is to bind the
non-modified key to send the captured keypress to the current
application (so `Ctrl-t t` would send `Ctrl-t`).

Sway is quite configurable, but unfortunately does not seem to support
multi-chord keybindings.  Fortunately, sway does have a notion of
"modes", much like `vi`, although in the default configuration the
only mode is for resizing windows.  With some cleverness, we can use
these modes to emulate a prefix key.  We will bind `Ctrl-t` to a
command that switches to the prefix mode, where we then bind the
actual keys that we care about.  However, there is a wrinkle: in sway,
once you are in a mode, you *stay* in that mode.  This not what we
want: after starting a terminal with `Ctrl-t c`, we don't want every
subsequent `c` to start a new terminal!  Fortunately, we can bind `c`
to launch the terminal, and then switch back to the "default" mode.
We will have to do this for every command, which looks a bit clumsy,
but it works well in practice:

    mode "prefix" {
        # Launch terminal.
        bindsym c exec $term; mode "default"

        # Send ctrl-t to focused window.
        bindsym t exec xdotool key ctrl+t; mode "default"

        # Kill focused window.
        bindsym k kill; mode "default"

        # return to default mode
        bindsym Control+g mode "default"
        bindsym Return mode "default"
        bindsym Escape mode "default"
    }
    bindsym Control+t mode "prefix"

The main difference compared to ratpoison is that if you are in the
prefix mode and hit a key not associated with a command, that key will
be passed to the focused window, and you will stay in prefix mode.
Ratpoison would beep at you and exit prefix mode (although it's
strictly not a mode in ratpoison).  There is no simple way to capture
this behaviour in sway, since you cannot define a "default binding"
that would exit the mode.

Still, if you are like me, and consider the early/mid-2000s to be the
pinnacle of Unix UI design, then the above produces a quite tolerable
experience.  My [full sway
configuration](https://github.com/athas/config/blob/master/sway/config)
has more bits and commands, but you should be able to flesh it out
yourself.  It is not an exact reproduction of ratpoison, nor is it
supposed to be: I can accept some measure of progress, as long as I am
allowed to keep decades of muscle memory intact.
