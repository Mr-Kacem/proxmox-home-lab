# LFCS Lab Validation

## 1. Overview

The three-machine LFCS environment was completed and validated.

Final lab layout:

| Hostname         | IPv4             | Role                 |
| ---------------- | ---------------- | -------------------- |
| `lfcs-ubuntu-01` | `192.168.178.40` | Linux server         |
| `lfcs-ubuntu-02` | `192.168.178.41` | Linux server         |
| `lfcs-client-01` | `192.168.178.43` | Client / test system |

The addresses were configured to remain stable on the local network.

---

## 2. Clean Baseline Snapshots

A Proxmox snapshot named:

```text
clean-install
```

was created for each VM after completing the initial configuration.

This provides a known baseline that can be restored after exercises or configuration mistakes.

```text
clean system
    ↓
LFCS exercise
    ↓
restore clean-install if required
```

Automatic VM startup remains disabled so the lab consumes resources only when required.

---

## 3. Network Validation

All three VMs were started together and communication between them was tested.

Connectivity using IPv4 addresses was successful.

This confirmed that:

```text
VM
 ↓
VirtIO interface
 ↓
vmbr0
 ↓
local network
```

was working correctly for all machines.

SSH connections between the systems were also successfully verified.

Example:

```bash
ssh hamza@192.168.178.41
```

---

## 4. Hostname Resolution

To make communication easier than using IP addresses directly, local hostname resolution was configured through:

```text
/etc/hosts
```

Each VM contains entries for the other LFCS systems.

After configuration, commands such as:

```bash
ping lfcs-ubuntu-01
```

and:

```bash
ssh hamza@lfcs-ubuntu-02
```

worked successfully.

This confirmed both:

```text
network connectivity
+
hostname resolution
```

across the complete lab.

---

## 5. Final Validation

| Check                      | Result |
| -------------------------- | ------ |
| Stable IP addresses        | OK     |
| `clean-install` snapshots  | OK     |
| VM-to-VM ping              | OK     |
| SSH connectivity           | OK     |
| `/etc/hosts` configuration | OK     |
| Hostname resolution        | OK     |
| Automatic startup disabled | OK     |

The LFCS multi-server environment is now ready for practical exercises.

---

## 6. Next Step

The next phase will move away from the LFCS base lab and begin planning:

```text
docker-prod-01
```

The new VM will be designed before deployment, including:

* CPU and RAM allocation;
* SSD/HDD storage roles;
* stable network address;
* Docker service structure.

