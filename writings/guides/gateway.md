---
title: Quick and dirty GNU/Linux gateway
---

Setting up a quick and dirty gateway on GNU/Linux
==

It's occasionally useful to set up your GNU/Linux system to function
as an Internet gateway for other machines.  In particular, when
installing a new operating system on a laptop, the only network in
range may be an encrypted WLAN for which the installer does not have
drivers.  In such a case, connect the laptop (the *client*) to another
machine (the *gateway*) via an ethernet cable and follow this guide.
I will assume that the client and gateway are connected to each other
through the `eth0` interface, and that the gateway is connected to the
Internet through `wlan0`.

Finally, note that I'm not much of a system administrator.  Don't use
a setup this crude for anything but ad-hoc short-term purposes.

Gateway setup
--

Run [this script](gateway.sh) on the gateway as root.  It sets up the
actual forwarding and NATing in the kernel.  You will need to have the
`iptable_nat` kernel module loaded.

Then statically assign the gateway an IP adress on the `eth0`
interface:

    # ifconfig eth0 10.0.0.1

Client setup
--

First, statically assign an IP adress by running the following command
on the client.

    # ifconfig eth0 10.0.0.2

You should be able to ping the gateway now.  Try it with `ping
10.0.0.1`.

Now we must add the IP address of the gateway to the kernel routing table.

    # route add default gw 10.0.0.1

Finally, you will probably want to be able to perform DNS lookups on
the client, so you should add the IP address of Googles free DNS
server to the file `/etc/resolv.conf`.

    # echo nameserver 8.8.8.8 > /etc/resolv.conf

And that's it.

DHCP server
--

The above is a pretty crude setup, in particular because you have to
manually setup the client.  Sometimes, you may not be able to interact
with the client (it may have no keyboard, or screen).  Yet still, most
machines have DHCP clients attached to their network interfaces, so if
you run a DHCP server on the gateway, you'll be able to give it a
known IP address.  Install the program `dhcpd` and create an
`/etc/dhcpd.conf` file containing:

    subnet 10.0.0.0 netmask 255.255.255.0 {
      range 10.0.0.10 10.0.0.20;
    }

This will give an IP address in the interval `10.0.0.10` to
`10.0.0.20` to anyone making a request.  Run the DHCP server as so:

    # dhcpd -d -f eth0

This will run the DHCP server in the foreground and send logging
output to standard error, so you'll be able to tell which IP address
is given to the client.
