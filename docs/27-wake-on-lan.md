# Wake on LAN for the Proxmox Host

## 1. Overview

Wake on LAN (WoL) was configured and tested on the Proxmox host so the server can be powered on without physical access. 

The network interface `nic0` was verified with `ethtool` and confirmed to support Wake on LAN through Magic Packet.

---

## 2. Initial Verification

The NIC reported Wake on LAN support but WoL was initially disabled:

```text
Supports Wake on: pumbg
Wake on: d
```

It was enabled temporarily with:

```bash
ethtool -s nic0 wol g
```

The FRITZ!Box also exposed its Wake on LAN function for the Proxmox host.

---

## 3. Hardware Troubleshooting

The first shutdown test failed because the Ethernet interface did not remain powered while the server was off.

The motherboard BIOS settings were reviewed and the required Wake on LAN option was enabled.

After the BIOS change, a real power on test succeeded:

```text
Server powered off
      ↓
Wake command from FRITZ!Box
      ↓
Proxmox host powered on
```

---

## 4. Persistent Linux Configuration

After rebooting, Linux reset the NIC to:

```text
Wake on: d
```

To make the setting persistent, the following command was added to `/etc/network/interfaces`:

```text
post up /usr/sbin/ethtool -s nic0 wol g
```

After another reboot, the interface reported:

```text
Wake on: g
```

confirming that Wake on LAN remained enabled.

---

## 5. Final Status

| Check | Status |
|---|---|
| NIC Magic Packet support | Verified |
| BIOS Wake on LAN support | Enabled |
| FRITZ!Box wake function | Verified |
| Real power on test | Passed |
| Persistent Linux configuration | Verified |

The Proxmox host can now be powered on through Wake on LAN, and the configuration survives system reboots.
