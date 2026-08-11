# First LFCS Virtual Machine

## 1. Overview

After validating the Proxmox host, the next step was to create the first virtual machine of the homelab.

The VM is dedicated to Linux system administration practice and preparation for the Linux Foundation Certified System Administrator (LFCS) certification.

The virtual machine was named:

```text
lfcs-ubuntu-01
```

This is the first guest system running on the new Proxmox infrastructure.

---

## 2. Purpose of the VM

The purpose of `lfcs-ubuntu-01` is to provide a controlled Linux environment where I can practice:

* Linux command-line administration;
* users and permissions;
* services;
* storage;
* networking;
* SSH;
* systemd;
* package management;
* troubleshooting;
* LFCS exercises.

Using a virtual machine instead of practicing directly on the Proxmox host provides isolation.

If the guest operating system is misconfigured or damaged during an exercise, the Proxmox host remains unaffected.

Conceptually:

```text
Physical Server
      │
             ↓
Proxmox VE
      │
             ↓
lfcs-ubuntu-01
      │
             ↓
LFCS exercises
```

---

## 3. Virtual Machine Configuration

The VM was created with the following resources:

| Setting          | Value               |
| ---------------- | ------------------- |
| VM ID            | `100`               |
| VM name          | `lfcs-ubuntu-01`    |
| Operating system | Ubuntu Server 26.04 |
| CPU              | 2 vCPU              |
| CPU topology     | 1 socket / 2 cores  |
| Memory           | 2 GiB RAM           |
| Virtual disk     | 32 GiB              |
| Disk format      | qcow2               |
| Storage          | `pve-data`          |
| Network bridge   | `vmbr0`             |
| Network adapter  | VirtIO              |

The objective was to allocate enough resources for normal Linux administration exercises without wasting the limited physical resources of the host.

---

## 4. Networking

The virtual network interface was connected to:

```text
vmbr0
```

using a:

```text
VirtIO
```

network adapter.

The relationship is:

```text
lfcs-ubuntu-01
       │
       │ VirtIO NIC
               ↓
     vmbr0
       │
               ↓
Physical Ethernet interface
       │
               ↓
Home network
       │
               ↓
FRITZ!Box
```

This allows the VM to behave like another system connected to the home network.

---

## 5. Ubuntu Server Installation

Ubuntu Server 26.04 was installed inside the newly created VM.

The operating system installation completed successfully.

No major installation problems were encountered.

The VM was intentionally kept relatively simple because its purpose is Linux administration practice rather than hosting production services.

---

## 6. OpenSSH Server

OpenSSH Server was installed during the Ubuntu Server setup.

This allows the VM to be administered remotely from another computer using:

```bash
ssh <user>@<vm-ip>
```

SSH is particularly important for this lab because Linux servers are commonly administered remotely rather than through a graphical console.

Using SSH also provides practice with an important LFCS administration skill.

---

## 7. QEMU Guest Agent

The package:

```text
qemu-guest-agent
```

was installed inside the Ubuntu VM.

The service was verified using:

```bash
systemctl status qemu-guest-agent
```

and was running correctly:

```text
active (running)
```

---

## 7.1 Why the QEMU Guest Agent Is Useful

The QEMU Guest Agent provides communication between:

```text
Proxmox host
      ↕
Ubuntu guest
```

Without the guest agent, Proxmox mainly sees the virtual hardware it provides to the VM.

With the guest agent installed, Proxmox can obtain additional information and perform selected guest-aware operations.

This improves the integration between Proxmox and the operating system running inside the VM.

---

## 8. Network Address

After installation, the VM received the following IPv4 address:

```text
192.168.178.40/24
```

The address was initially assigned through DHCP by the home router.

A fixed DHCP reservation was then configured in the router for `lfcs-ubuntu-01`.

This means that the VM itself can continue using DHCP while the router consistently assigns the same IPv4 address.

The distinction is important:

```text
Static configuration inside Ubuntu
            ≠
DHCP reservation in the router
```

The chosen configuration is:

```text
Ubuntu VM
    │
    │ requests address via DHCP
         ↓
FRITZ!Box
    │
    │ recognizes the VM
         ↓
always assigns
192.168.178.40
```

This keeps the guest network configuration simple while still providing a predictable management address.

---

## 8.1 Why a Predictable IP Is Useful

For a server VM, knowing its address in advance simplifies:

* SSH connections;
* communication with future VMs;
* documentation;
* service configuration;
* troubleshooting;
* automation.

Instead of repeatedly checking which address DHCP assigned, the VM can consistently be reached at:

```text
192.168.178.40
```

---

## 9. Initial VM Validation

After installation, the basic VM configuration was verified.

The important results were:

```text
Ubuntu Server installation   → OK
VM boot                      → OK
Network connectivity         → OK
IPv4 assignment              → OK
OpenSSH Server               → OK
QEMU Guest Agent             → OK
```

This confirmed that the first virtual machine was operational and correctly integrated with the Proxmox environment.

---

## 10. Clean Baseline

Before beginning LFCS exercises, the VM should remain in a known clean state.

The ideal baseline consists of:

```text
Fresh Ubuntu Server installation
+
OpenSSH Server
+
QEMU Guest Agent
+
working network
+
stable IP reservation
```

This provides a reference point before making potentially destructive configuration changes during exercises.

A Proxmox snapshot named:

```text
clean-install
```

can be used for this purpose.

---

## 11. Lessons Learned

### A VM Still Needs Planned Resources

Creating a VM is not simply a matter of clicking `Create VM`.

Before creating it, decisions must be made about:

```text
CPU
RAM
storage
networking
operating system
purpose
```

Resource allocation should match the actual purpose of the guest.

---

### DHCP Does Not Necessarily Mean a Changing Address

The VM can use DHCP while still receiving the same address every time if the router has a DHCP reservation.

This keeps network configuration centralized in the router and avoids manually configuring static addresses inside every cloned VM.

---

### Guest Integration Is Separate from Virtualization

The VM can run without `qemu-guest-agent`, but installing the agent improves communication between the guest operating system and Proxmox.

Virtualization and guest integration are therefore related but separate concepts.

---

## 12. Next Steps

The first LFCS virtual machine is now available.

The next phase should focus on building the required VM structure gradually rather than immediately installing additional services.

Future steps may include:

1. confirming a clean baseline snapshot;
2. creating additional Linux VMs when required by LFCS exercises;
3. defining a consistent VM naming convention;
4. assigning predictable network addresses;
5. testing SSH communication between systems;
6. testing Proxmox snapshots;
7. creating the first VM backup;
8. testing restore procedures.

The goal remains to understand each infrastructure layer before adding unnecessary complexity.

