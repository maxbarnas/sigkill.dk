---
title: Running Borderlands 2 on Fedora 26
description: See title.
---

The game [Borderlands 2][] has been ported to Linux (several years
ago; yes I'm slow). However, after installing it through Steam on my
Fedora 26 machine, it crashed with a segmentation fault when launched.
The problem turned out to be whatever is responsible for showing the
intro movie.  Running the game with ``-nomoviestartup`` made it work
for me.  This can be done either by running the game from the command
line, or by right-clicking the game and modifying the Launch Options
from within Steam.

[Borderlands 2]: http://store.steampowered.com/agecheck/app/49520/
