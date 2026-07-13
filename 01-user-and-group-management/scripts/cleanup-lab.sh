#!/usr/bin/env bash
set -euo pipefail

LAB_USER="pabaops_lab_user"
PRIMARY_GROUP="pabaops_lab_group"
SECONDARY_GROUP="pabaops_lab_ops"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: Run this script with sudo or as root." >&2
  exit 1
fi

cat <<EOF
This will remove only these documented lab resources:
  User:            ${LAB_USER}
  Primary group:   ${PRIMARY_GROUP}
  Secondary group: ${SECONDARY_GROUP}

The user's home directory will also be removed.
EOF

read -r -p "Type DELETE to continue: " confirmation
if [[ "${confirmation}" != "DELETE" ]]; then
  echo "Cleanup cancelled."
  exit 0
fi

if getent passwd "${LAB_USER}" >/dev/null; then
  userdel --remove "${LAB_USER}"
  echo "Removed user: ${LAB_USER}"
else
  echo "User not found: ${LAB_USER}"
fi

for group in "${SECONDARY_GROUP}" "${PRIMARY_GROUP}"; do
  if getent group "${group}" >/dev/null; then
    groupdel "${group}"
    echo "Removed group: ${group}"
  else
    echo "Group not found: ${group}"
  fi
done

echo "Cleanup completed."
