# Lab 01 — Linux User and Group Management

## Objective

Create and manage Linux users and groups safely, verify access settings, understand the relevant account files, and remove the lab resources cleanly.

## Scenario

A DevOps team requires a controlled Linux account for a new engineer. The account must:

- Have a dedicated home directory
- Use Bash as the login shell
- Belong to a project group
- Remain password-locked until an approved credential method is configured
- Be verifiable through standard Linux commands
- Be removable without affecting unrelated accounts

## Supported Distributions

- Ubuntu
- RHEL
- CentOS
- AlmaLinux

## Lab Resource Names

This lab uses predictable names to avoid touching real accounts:

```text
User:  pabaops_lab_user
Group: pabaops_lab_group
```

## Learning Outcomes

After completing this lab, you should be able to:

- Inspect existing users and groups
- Create a Linux group
- Create a user with a home directory and shell
- Add and remove supplementary group membership
- Lock and unlock passwords
- Review `/etc/passwd`, `/etc/group`, and `/etc/shadow` safely
- Verify account properties
- Remove lab accounts cleanly

---

## Part 1 — Inspect the Current Environment

```bash
cat /etc/os-release
whoami
id
getent passwd | head
getent group | head
```

### Explanation

- `cat /etc/os-release` identifies the Linux distribution.
- `whoami` shows the current effective username.
- `id` displays UID, GID, and group memberships.
- `getent` queries the system account databases and also works with directory-backed identity sources.

---

## Part 2 — Create the Project Group

```bash
sudo groupadd pabaops_lab_group
```

Verify:

```bash
getent group pabaops_lab_group
```

Expected format:

```text
pabaops_lab_group:x:<GID>:
```

---

## Part 3 — Create the User

```bash
sudo useradd   --create-home   --shell /bin/bash   --gid pabaops_lab_group   --comment "PabaOps Linux Administration Lab User"   pabaops_lab_user
```

### Explanation

| Option | Meaning |
|---|---|
| `--create-home` | Creates `/home/pabaops_lab_user` |
| `--shell /bin/bash` | Sets Bash as the login shell |
| `--gid` | Sets the primary group |
| `--comment` | Adds a descriptive GECOS field |

Verify:

```bash
id pabaops_lab_user
getent passwd pabaops_lab_user
sudo ls -ld /home/pabaops_lab_user
```

---

## Part 4 — Keep the Password Locked

Check password state:

```bash
sudo passwd -S pabaops_lab_user
```

Lock it explicitly:

```bash
sudo passwd -l pabaops_lab_user
```

### Why this matters

A newly created service or administration account should not automatically allow password-based login. Access should follow an approved method such as an SSH key, identity provider, or controlled password process.

> Locking a password does not automatically block every possible login method. SSH keys, sudo rules, and other authentication mechanisms must also be reviewed.

---

## Part 5 — Supplementary Groups

Create a second test group:

```bash
sudo groupadd pabaops_lab_ops
```

Add the user:

```bash
sudo usermod -aG pabaops_lab_ops pabaops_lab_user
```

Verify:

```bash
id pabaops_lab_user
groups pabaops_lab_user
getent group pabaops_lab_ops
```

Remove the supplementary membership:

### Ubuntu/Debian

```bash
sudo deluser pabaops_lab_user pabaops_lab_ops
```

### RHEL/CentOS/AlmaLinux and portable method

```bash
sudo gpasswd -d pabaops_lab_user pabaops_lab_ops
```

---

## Part 6 — Review Account Databases

```bash
getent passwd pabaops_lab_user
getent group pabaops_lab_group
sudo grep '^pabaops_lab_user:' /etc/shadow
```

### Main account files

| File | Purpose |
|---|---|
| `/etc/passwd` | Usernames, UIDs, home directories, shells |
| `/etc/group` | Groups and memberships |
| `/etc/shadow` | Password hashes and password-aging information |
| `/etc/gshadow` | Secure group administration data |

Never copy real `/etc/shadow` content into screenshots or GitHub.

---

## Part 7 — Run the Verification Script

Make it executable:

```bash
chmod +x scripts/verify-lab.sh
```

Run:

```bash
./scripts/verify-lab.sh
```

The script performs read-only checks and does not modify the system.

---

## Part 8 — Optional Automated Setup

The setup script does not run unless you provide `--apply`.

```bash
chmod +x scripts/setup-lab.sh
sudo ./scripts/setup-lab.sh --apply
```

It creates only the documented lab user and group.

---

## Part 9 — Cleanup

Manual cleanup:

```bash
sudo userdel --remove pabaops_lab_user
sudo groupdel pabaops_lab_ops 2>/dev/null || true
sudo groupdel pabaops_lab_group
```

Or use the cleanup script:

```bash
chmod +x scripts/cleanup-lab.sh
sudo ./scripts/cleanup-lab.sh
```

Verify removal:

```bash
getent passwd pabaops_lab_user || echo "User removed"
getent group pabaops_lab_group || echo "Primary group removed"
getent group pabaops_lab_ops || echo "Supplementary group removed"
```

---

## Troubleshooting

### `groupadd: group already exists`

Check it:

```bash
getent group pabaops_lab_group
```

Use the existing lab group or clean up the previous lab before repeating the setup.

### `useradd: user already exists`

```bash
id pabaops_lab_user
```

Do not delete an account until you confirm it is the intended lab account.

### Home directory missing

```bash
sudo mkdir -p /home/pabaops_lab_user
sudo chown pabaops_lab_user:pabaops_lab_group /home/pabaops_lab_user
sudo chmod 750 /home/pabaops_lab_user
```

### User cannot log in

Check:

```bash
getent passwd pabaops_lab_user
sudo passwd -S pabaops_lab_user
sudo grep -E '^(AllowUsers|DenyUsers|PasswordAuthentication|PubkeyAuthentication)' /etc/ssh/sshd_config
```

A locked password is expected to block password authentication.

---

## Security Considerations

- Follow least privilege.
- Do not grant `sudo` or `wheel` membership unless required.
- Prefer SSH keys over password authentication for remote administration.
- Lock unused accounts.
- Set account expiration dates for temporary users.
- Review group membership regularly.
- Never expose `/etc/shadow` content.

Example temporary-account expiration:

```bash
sudo chage -E 2026-12-31 pabaops_lab_user
sudo chage -l pabaops_lab_user
```

---

## Evidence Checklist

Capture sanitized screenshots or terminal output for:

1. Operating system identification
2. Group creation
3. User creation
4. `id pabaops_lab_user`
5. Home-directory ownership
6. Password-lock status
7. Supplementary group membership
8. Verification script result
9. Cleanup verification

Store safe screenshots in:

```text
01-user-and-group-management/evidence/
```

The evidence directory is ignored by default to prevent accidental upload of sensitive data. Remove or adjust the `.gitignore` rule only for sanitized files you intentionally want to publish.

## Result

This lab demonstrates controlled Linux account administration, verification, security awareness, distribution-aware commands, Bash scripting, and safe cleanup.
