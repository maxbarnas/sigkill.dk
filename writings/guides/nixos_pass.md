---
title: Using `pass` on NixOS
---

Using `pass` on NixOS
=====================

On NixOS, you may find that `pass`, the [standard unix password
manager](https://www.passwordstore.org/) fails with a cryptic error
when it tries to decrypt passwords:

```
$ pass show foo
gpg: decryption failed: No secret key
```

The problem is actually that `pass` cannot figure out how to ask you
for the master password.

One workaround is to use `gpg` to manually decrypt the password:

```
$ nix-shell -p gnupg --run 'gpg --decrypt --pinentry-mode=loopback < ~/.password-store/foo.gpg'
```

But this sucks.  A beter solution is to install `pinentry-curses` (put
it in your `systemPackages` in your NixOS configuration), and then
modify `$HOME/.gnupg/gpg-agent.conf` to contain the following:

```
pinentry-program /run/current-system/sw/bin/pinentry-curses
```

You may need to reload the running `gpg-agent` to make it pick up the
change:

```
$ gpgconf --reload gpg-agent
```
