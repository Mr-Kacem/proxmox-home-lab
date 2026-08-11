# Proxmox VE Host Validation

## 1. Overview

After completing the Proxmox VE installation and storage configuration, the next step was to verify that the physical host was correctly configured before creating the first virtual machine.

The purpose of this phase was not to add new services or virtual machines.

The objective was to answer a simpler question:

> Is the Proxmox host itself ready to run virtual machines?

The validation focused on four areas:

* network configuration;
* storage availability;
* physical hardware resources;
* hardware virtualization support.

---

## 2. Why Validate the Host First?

Creating a virtual machine before checking the underlying host could make future troubleshooting more difficult.

For example, if a VM had no network connectivity, the problem could be:

```text
VM configuration
        ↓
virtual network interface
        ↓
Proxmox bridge
        ↓
physical network interface
        ↓
router
```

By verifying the Proxmox host first, the base infrastructure can be separated from problems that may later occur inside a VM.

The same principle applies to storage and virtualization support.

The host should therefore be validated before adding another layer of complexity.

---

# 3. Network Verification

## 3.1 Proxmox Management Address

The Proxmox node uses the following static management address:

```text
192.168.178.35/24
```

The default gateway is:

```text
192.168.178.1
```

This provides the Proxmox server with a stable address on the local network.

A static management address is important because other computers need a predictable address to reach the hypervisor.

The Proxmox web interface is available at:

```text
https://192.168.178.35:8006
```

---

## 3.2 Understanding `vmbr0`

The Proxmox network configuration includes the Linux bridge:

```text
vmbr0
```

A bridge is important because future virtual machines need a way to communicate with the physical network.

Conceptually:

```text
Virtual Machine
      │
      │ virtual network interface
             ↓
    vmbr0
      │
      │ physical network interface
             ↓
Home Network
      │
             ↓
FRITZ!Box / Gateway
```

`vmbr0` therefore acts similarly to a virtual network switch.

The physical Proxmox host and future virtual machines can use this bridge to communicate with the local network.

This is an important distinction:

```text
Physical network interface
        ≠
Linux bridge
```

The physical interface connects the server to the actual Ethernet network.

The bridge provides the Layer 2 connection that allows virtual machines to share access to that physical network.

---

# 4. Hardware Resource Verification

Before creating the first VM, the physical resources available to Proxmox were checked.

The host currently provides approximately:

```text
CPU:    4 cores
RAM:    15 GiB usable
```

The installed processor is:

```text
Intel Core i5-4440
```

The physical system contains 16 GB of RAM, with approximately 15 GiB reported as usable by the operating system.

This is expected because not all installed memory is necessarily presented as available system memory.

---

## 4.1 Why Resource Verification Matters

A virtual machine consumes resources provided by the physical host.

For example:

```text
Physical Host
16 GB RAM
4 CPU cores
       │
       ├── Proxmox itself
       │
       ├── VM 1
       │
       ├── VM 2
       │
       └── future services
```

The total resources assigned to virtual machines must therefore be planned according to the limitations of the physical server.

With four CPU cores and 16 GB of installed RAM, the objective is not to create many large virtual machines.

Instead, the lab will initially use small Linux VMs with conservative resource allocations.

Resources can later be adjusted according to actual usage.

---

# 5. Hardware Virtualization Verification

One of the most important checks was confirming that the CPU supports hardware virtualization.

The Intel Core i5-4440 supports:

```text
Intel VT-x
```

Hardware virtualization was already enabled.

This capability is required for efficient KVM-based virtual machines.

---

## 5.1 KVM Kernel Modules

The Linux kernel modules related to KVM were also checked.

The system showed the following modules loaded:

```text
kvm_intel
kvm
```

### `kvm`

```text
kvm
```

is the main Linux Kernel-based Virtual Machine module.

It provides the core virtualization infrastructure inside the Linux kernel.

### `kvm_intel`

```text
kvm_intel
```

is the Intel-specific KVM module.

It allows KVM to use Intel hardware virtualization features such as VT-x.

The relationship can be simplified as:

```text
Intel CPU
   │
   └── Intel VT-x
          │
          ↓
      kvm_intel
          │
          ↓
         kvm
          │
          ↓
       KVM/QEMU
          │
          ↓
     Virtual Machine
```

---

# 6. What This Verification Confirms

At this point, the main layers required before creating a VM have been checked.

```text
Physical hardware
      │
      ├── CPU                     → OK
      ├── RAM                     → OK
      ├── Intel VT-x              → OK
      │
      ↓
Linux / Proxmox
      │
      ├── KVM                     → OK
      ├── kvm_intel               → OK
      │
      ↓
Network
      │
      ├── vmbr0                   → OK
      ├── 192.168.178.35/24       → OK
      ├── Gateway 192.168.178.1   → OK
      │
      ↓
Storage
      │
      ├── pve-data                → OK
      └── pve-backup              → OK
```

This means that the basic Proxmox node is ready for the virtualization phase.

---

# 7. Current Homelab State

The project has now progressed through the following stages:

```text
Planning
   ↓
Proxmox installation
   ↓
Storage configuration
   ↓
Storage persistence verification
   ↓
Host network verification
   ↓
Hardware verification
   ↓
KVM virtualization verification
   ↓
HOST READY
```
---

# 8. Lessons Learned

## Proxmox Is Still a Linux System

Although Proxmox provides a graphical management interface, the underlying system still depends on Linux concepts such as:

* kernel modules;
* network interfaces;
* bridges;
* filesystems;
* mount points;
* hardware detection.

Understanding these layers is important for troubleshooting.

---

# 9. Validation Result

The Proxmox base node is now considered ready for its first virtual machine.

Final validation status:

| Component            | Status |
| -------------------- | ------ |
| Proxmox installation | OK     |
| Management network   | OK     |
| Static IP            | OK     |
| Gateway              | OK     |
| Linux bridge `vmbr0` | OK     |
| Main data storage    | OK     |
| Backup storage       | OK     |
| Storage persistence  | OK     |
| CPU resources        | OK     |
| RAM                  | OK     |
| Intel VT-x           | OK     |
| KVM modules          | OK     |

---

# 10. Next Step

The next phase of the project is the creation of the first Ubuntu Server virtual machine.

Before creating it, the VM configuration should be planned rather than simply accepting every default value.

The next decisions will include:

* VM name;
* Ubuntu Server ISO;
* CPU allocation;
* RAM allocation;
* virtual disk size;
* storage location;
* network bridge;
* virtual network adapter;
* BIOS/UEFI choice;
* installation method.

The objective will again be to understand why each resource is assigned before creating the virtual machine.

