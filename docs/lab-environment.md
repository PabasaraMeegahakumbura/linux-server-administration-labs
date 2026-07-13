# Recommended Lab Environment

## Minimum Requirements

- One Linux virtual machine or cloud instance
- 1 vCPU
- 1-2 GB RAM
- 10 GB disk
- A non-production environment
- A normal user with `sudo` access

## Recommended Options

- Ubuntu Server 22.04/24.04
- RHEL 9
- CentOS Stream 9
- AlmaLinux 9

## Pre-Lab Checks

```bash
cat /etc/os-release
uname -r
whoami
id
sudo -v
```

## Safety Rules

1. Never test user deletion, firewall changes, or SSH changes first on production.
2. Keep an active console or provider web terminal when testing remote access.
3. Do not store real passwords, API keys, private keys, or customer data in GitHub.
4. Redact public IPs, email addresses, hostnames, account IDs, and sensitive logs from screenshots.
5. Take a VM snapshot before risky administration work.
