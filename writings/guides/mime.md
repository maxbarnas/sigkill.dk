---
title: Fixing MIME type associations on GNU/Linux
---

Fixing MIME type associations on GNU/Linux
==

I had a problem where my [NixOS](https://nixos.org/) desktop kept
opening PDFs in programs like GIMP or Wine Internet Explorer(!), even
though I also had Evince installed.  The problem was that all of these
applications install [.desktop
files](https://specifications.freedesktop.org/desktop-entry-spec/latest/)
indicating their willingness to handle various file types, and in
particular they were all willing to accept PDFs, which is fine.
Unfortunately, if multiple applications are available, then an
arbitrary one (maybe the one that comes first alphabetically?) gets
chosen.  Use the `xdg-mime` command to fix this, e.g. I did

    $ xdg-mime default org.gnome.Evince.desktop application/pdf

where `org.gnome.Evince.desktop` is the catchy name for the `.desktop`
file installed by Evince.  See `/usr/share/applications/` (or
`/var/run/current-system/sw/share/applications/` in NixOS) for a list
of all `.desktop` files.
