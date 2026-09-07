Selective DNS with NetworkManager

1. Overview

The workstation pluto was configured to use different DNS policies depending on the connected Wi-Fi network.

Two existing Wi-Fi profiles are used:

Fast — 5 GHz

Slow — 2.4 GHz

The objective was to use AdGuard Home only when connected to Slow, while keeping the normal FRITZ!Box DNS configuration on Fast.

2. DNS Policy

The Slow NetworkManager profile was configured to use:

192.168.178.42

as its IPv4 DNS server.

Automatic DNS information received for both IPv4 and IPv6 is ignored on this profile.

IPv6 connectivity itself remains enabled; only automatically supplied DNS servers are prevented from bypassing AdGuard Home.

The resulting policy is:

Slow (2.4 GHz) → AdGuard Home DNS
Fast (5 GHz)   → FRITZ!Box DNS

3. Verification

After reconnecting to the Slow Wi-Fi profile, the active DNS configuration was verified with nmcli.

The DNS server in use was confirmed as:

192.168.178.42

The AdGuard Home dashboard also showed DNS requests originating from pluto.

This confirmed that changing Wi Fi networks is enough to switch DNS policy without manually modifying the system configuration each time.

