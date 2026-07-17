# GCP Ubuntu 24.04 — Lab 01 Evidence

## Environment

- Platform: Google Cloud
- Operating system: Ubuntu 24.04.4 LTS
- Kernel: `6.17.0-1020-gcp`
- Architecture: x86-64
- Lab hostname: `pabaops-gcp-ubuntu-lab`

> Office account identifiers, IP addresses, service-account details, and other internal information are intentionally excluded.

## Safe Preview

The setup script was first executed without `--apply`:

```bash
sudo bash scripts/setup-lab.sh
```

Result:

```text
PabaOps User and Group Management Lab

This script will create:
  User:            pabaops_lab_user
  Primary group:   pabaops_lab_group
  Secondary group: pabaops_lab_ops

No changes were made.
```

This confirmed that the script performs a safe preview before changing the system.

## User and Group Provisioning

The lab was applied with:

```bash
sudo bash scripts/setup-lab.sh --apply
```

Created resources:

```text
Primary group:   pabaops_lab_group
Secondary group: pabaops_lab_ops
User:            pabaops_lab_user
Home directory:  /home/pabaops_lab_user
Login shell:     /bin/bash
Password status: Locked
```

## Automated Verification

The read-only verification script was executed:

```bash
bash scripts/verify-lab.sh
```

Result:

```text
[PASS] User exists: pabaops_lab_user
[PASS] Primary group exists: pabaops_lab_group
[PASS] Secondary group exists: pabaops_lab_ops
[PASS] Home directory exists
[PASS] Login shell is /bin/bash
[PASS] Primary group is correct
[PASS] Secondary membership is present

All verification checks passed.
```

## Manual Verification

The following checks confirmed the final configuration:

```bash
id pabaops_lab_user
getent passwd pabaops_lab_user
getent group pabaops_lab_group
getent group pabaops_lab_ops
ls -ld /home/pabaops_lab_user
sudo passwd -S pabaops_lab_user
```

Validated results:

- The user had a dedicated UID and primary GID.
- The primary group was `pabaops_lab_group`.
- Supplementary membership in `pabaops_lab_ops` was present.
- The home directory existed and was owned by the lab user and primary group.
- The login shell was `/bin/bash`.
- The password was locked as intended.

## Cleanup Verification

The cleanup script was executed:

```bash
sudo bash scripts/cleanup-lab.sh
```

Post-cleanup checks confirmed:

```text
[PASS] User removed
[PASS] Primary group removed
[PASS] Secondary group removed
[PASS] Home directory removed
```

## Outcome

Lab 01 was completed successfully on Ubuntu 24.04 LTS running on Google Cloud. The exercise demonstrated safe previewing, controlled user and group provisioning, automated verification, manual validation, password locking, and complete cleanup.
