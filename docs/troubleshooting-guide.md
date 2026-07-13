# General Linux Troubleshooting Guide

Use a consistent troubleshooting process:

## 1. Define the Problem

- What changed?
- Who is affected?
- When did it start?
- Is the issue repeatable?
- What is the business or service impact?

## 2. Confirm the System State

```bash
date
hostnamectl
uptime
who
free -h
df -h
```

## 3. Check Services and Processes

```bash
systemctl --failed
systemctl status <service>
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

## 4. Check Logs

```bash
journalctl -p warning -b
journalctl -u <service> --since "30 minutes ago"
dmesg --level=err,warn
```

## 5. Check Networking

```bash
ip addr
ip route
ss -tulpn
resolvectl status 2>/dev/null || cat /etc/resolv.conf
```

## 6. Verify the Fix

- Repeat the failing action.
- Check service state.
- Review logs again.
- Record the cause, fix, and validation.
