#!/usr/bin/env bash
set -u

LAB_USER="${1:-pabaops_lab_user}"
PRIMARY_GROUP="${2:-pabaops_lab_group}"
SECONDARY_GROUP="${3:-pabaops_lab_ops}"

failures=0

check() {
  local description="$1"
  shift

  if "$@" >/dev/null 2>&1; then
    printf '[PASS] %s
' "${description}"
  else
    printf '[FAIL] %s
' "${description}"
    failures=$((failures + 1))
  fi
}

echo "PabaOps Linux User and Group Lab Verification"
echo "=============================================="

check "User exists: ${LAB_USER}" getent passwd "${LAB_USER}"
check "Primary group exists: ${PRIMARY_GROUP}" getent group "${PRIMARY_GROUP}"
check "Secondary group exists: ${SECONDARY_GROUP}" getent group "${SECONDARY_GROUP}"
check "Home directory exists" test -d "/home/${LAB_USER}"
check "Login shell is /bin/bash" bash -c   '[[ "$(getent passwd "$1" | cut -d: -f7)" == "/bin/bash" ]]' _ "${LAB_USER}"
check "Primary group is correct" bash -c   '[[ "$(id -gn "$1")" == "$2" ]]' _ "${LAB_USER}" "${PRIMARY_GROUP}"
check "Secondary membership is present" bash -c   'id -nG "$1" | tr " " "\n" | grep -Fxq "$2"' _ "${LAB_USER}" "${SECONDARY_GROUP}"

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "All verification checks passed."
  exit 0
fi

echo "${failures} verification check(s) failed."
exit 1
