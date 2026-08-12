# LFCS Lab Expansion

## 1. Overview

After creating the first LFCS virtual machine, the lab was expanded with two additional Ubuntu Server systems.

The objective is to move from practicing on a single Linux machine to a small multi server environment where networking, SSH, services, and troubleshooting can be practiced between different hosts.

The current LFCS lab consists of:

```text
lfcs-ubuntu-01
lfcs-ubuntu-02
lfcs-client-01
```

All LFCS virtual machines are stored on:

```text
pve-data
```

the 1 TB HDD dedicated to lab workloads.

They are configured with:

```text
Start at boot: No
```

because these machines should normally remain powered off when they are not being used for exercises.

---

## 2. `lfcs-ubuntu-02`

The second Linux server was created as:

```text
VM ID: 101
Name: lfcs-ubuntu-02
```

Resources:

```text
CPU:     1 vCPU
RAM:     2 GiB
Disk:    32 GiB
Format:  qcow2
Storage: pve-data
Network: vmbr0
```

Ubuntu Server was installed successfully.

The initial system preparation included:

* system updates;
* OpenSSH Server;
* `qemu-guest-agent`;
* hostname configuration;
* SSH access verification.

The VM uses the user:

```text
hamza
```

---

## 3. `lfcs-client-01`

A third VM was created as:

```text
lfcs-client-01
```

This system has a different role from the two LFCS server VMs.

Instead of acting primarily as another server, it can be used as a client system for testing communication with the other machines.

Examples include:

```text
SSH connections
ping tests
hostname resolution
service connectivity
network troubleshooting
```

The VM was intentionally configured with modest resources because it does not require significant computing power for this role.

It is also stored on:

```text
pve-data
```

and connected to:

```text
vmbr0
```

Ubuntu Server was installed and the initial preparation included:

* system updates;
* OpenSSH;
* `qemu-guest-agent`;
* hostname configuration;
* SSH access.

---

## 4. Current LFCS Architecture

The lab now has three independent Linux systems:

```text
                 Proxmox VE
                     │
                   vmbr0
                     │
        ┌────────────┼────────────┐
        │            │            │
        ↓            ↓            ↓
lfcs-ubuntu-01 lfcs-ubuntu-02 lfcs-client-01
     Server         Server         Client
```

This provides the foundation for exercises that require communication between multiple machines instead of working only on `localhost`.

---

## 5. Why Multiple VMs?

A single Linux VM is sufficient for learning many administration tasks.

However, several LFCS related concepts become clearer when multiple systems are available.

For example:

```text
client
   │
   ├── SSH ──────────→ server
   │
   ├── ping ─────────→ server
   │
   └── service test ─→ server
```

This allows the lab to simulate more realistic situations involving:

* remote administration;
* network connectivity;
* client/server communication;
* hostname resolution;
* firewall rules;
* file transfers;
* service troubleshooting.

---

# 6. Planned Clean Baseline Snapshots

Before beginning exercises that modify the systems, clean baseline snapshots are planned for the next session.

The snapshot name will be:

```text
clean-install
```

The purpose is to preserve the state after:

```text
Ubuntu installation
+
system updates
+
OpenSSH
+
qemu-guest-agent
+
basic network configuration
```

The snapshots should be created before intentionally modifying the VMs during LFCS exercises.

Conceptually:

```text
clean-install snapshot
        │
        ↓
perform exercise
        │
        ├── success → continue
        │
        └── broken system → restore snapshot
```
---

# 7. Planned Lab Verification

Before starting normal LFCS exercises, all three VMs will be powered on together and tested.

The next session will verify:

### VM State

```text
lfcs-ubuntu-01 → running
lfcs-ubuntu-02 → running
lfcs-client-01 → running
```

### Network Addresses

The IP addresses assigned to each VM will be checked and stabilized where necessary.

A final table will then be documented containing:

```text
hostname
role
IP address
```

### Connectivity

Communication between the systems will be tested using:

```bash
ping
```

and:

```bash
ssh
```

The objective is to confirm that each VM can communicate correctly through `vmbr0`.

### Hostname Verification

Each system will also be checked to confirm that its configured hostname matches its intended role.

Hostname resolution between the machines will then be evaluated.

---

## 8. Current Status

At the end of today's work:

| Component                  | Status     |
| -------------------------- | ---------- |
| `lfcs-ubuntu-01`           | Installed  |
| `lfcs-ubuntu-02`           | Installed  |
| `lfcs-client-01`           | Installed  |
| Ubuntu updates             | Completed  |
| OpenSSH                    | Installed  |
| QEMU Guest Agent           | Installed  |
| `vmbr0` networking         | Configured |
| Automatic VM startup       | Disabled   |
| Clean baseline snapshots   | Planned    |
| Three-VM connectivity test | Planned    |
| Final IP/role table        | Planned    |

The basic three-machine LFCS environment is therefore built, but the lab will only be considered ready after the snapshot and inter-VM connectivity tests are completed.

---

## 9. Next Step

The next session will focus exclusively on validating the LFCS environment:

1. verify and stabilize VM IP addresses;
2. start all three VMs simultaneously;
3. verify `ping` connectivity;
4. verify SSH access;
5. verify hostnames and name resolution;
6. document the final IP and role table.

Only after these checks are complete will the lab move on to additional workloads or services.

