#!/usr/bin/env bash
set -euo pipefail

LAB_USER="pabaops_lab_user"
PRIMARY_GROUP="pabaops_lab_group"
SECONDARY_GROUP="pabaops_lab_ops"

if [[ "${1:-}" != "--apply" ]]; then
  cat <<EOF
PabaOps User and Group Management Lab

This script will create:
  User:            ${LAB_USER}
  Primary group:   ${PRIMARY_GROUP}
  Secondary group: ${SECONDARY_GROUP}

No changes were made.

Run as root with:
  sudo $0 --apply
EOF
  exit 0
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: Run this script with sudo or as root." >&2
  exit 1
fi

if getent passwd "${LAB_USER}" >/dev/null; then
  echo "ERROR: User ${LAB_USER} already exists. Stop and verify it before continuing." >&2
  exit 1
fi

if ! getent group "${PRIMARY_GROUP}" >/dev/null; then
  groupadd "${PRIMARY_GROUP}"
  echo "Created primary group: ${PRIMARY_GROUP}"
else
  echo "Primary group already exists: ${PRIMARY_GROUP}"
fi

if ! getent group "${SECONDARY_GROUP}" >/dev/null; then
  groupadd "${SECONDARY_GROUP}"
  echo "Created secondary group: ${SECONDARY_GROUP}"
else
  echo "Secondary group already exists: ${SECONDARY_GROUP}"
fi

useradd   --create-home   --shell /bin/bash   --gid "${PRIMARY_GROUP}"   --groups "${SECONDARY_GROUP}"   --comment "PabaOps Linux Administration Lab User"   "${LAB_USER}"

passwd -l "${LAB_USER}" >/dev/null

echo
echo "Lab account created successfully."
id "${LAB_USER}"
getent passwd "${LAB_USER}"
ls -ld "/home/${LAB_USER}"
passwd -S "${LAB_USER}"
