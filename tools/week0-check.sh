#!/usr/bin/env bash
# Prints tool versions and connectivity for the Week 0 environment check.
set -u
echo "== Tools =="
for cmd in git ssh kubectl terraform tofu jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd: missing"
    continue
  fi
  case "$cmd" in
    ssh)       echo "ssh: $(ssh -V 2>&1)" ;;
    kubectl)   echo "kubectl: $(kubectl version --client 2>/dev/null | head -n 1)" ;;
    terraform) echo "terraform: $(terraform version | head -n 1)" ;;
    tofu)      echo "tofu: $(tofu version | head -n 1)" ;;
    *)         echo "$cmd: $("$cmd" --version 2>&1 | head -n 1)" ;;
  esac
done
echo "== Connectivity =="
BASTION="${BASTION:?set BASTION to the bastion address}"
BASTION_USER="${BASTION_USER:-$USER}"
if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new \
     "$BASTION_USER@$BASTION" true 2>/dev/null; then
  echo "SSH to bastion: ok"
else
  echo "SSH to bastion: FAILED"
fi
if ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new git@github.com 2>&1 \
     | grep -q "successfully authenticated"; then
  echo "GitHub SSH: ok"
else
  echo "GitHub SSH: FAILED"
fi
echo "Checked at $(date -u +%Y-%m-%dT%H:%M:%SZ) by $(git config user.name 2>/dev/null || echo unknown)"