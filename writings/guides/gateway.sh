#!/bin/sh
#
# Setup a simple IPv4 gateway on a GNU/Linux system.

internal=eth0  # From whence we receive packets from the client.
external=wlan0 # From whence we have access to the Internet.

# Delete all rules in the 'nat' chain.
iptables --table nat --flush
iptables --table nat --delete-chain

# Set up IP forwarding and masquerading (this is the actual NAT
# stuff).
iptables --table nat --append POSTROUTING --out-interface $external -j MASQUERADE
iptables --append FORWARD --in-interface $internal -j ACCEPT

# Enable packet forwarding by kernel.
echo 1 > /proc/sys/net/ipv4/ip_forward
