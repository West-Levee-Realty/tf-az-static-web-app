#!/usr/bin/env bash
# Generates terraform.auto.tfvars.json for a given site from config.json.
# Usage: scripts/generate-tfvars.sh <site>
set -euo pipefail

SITE="${1:?usage: generate-tfvars.sh <site>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$ROOT/config.json"
OUT="$ROOT/sites/$SITE/terraform/terraform.auto.tfvars.json"

if [ ! -f "$CONFIG" ]; then
  echo "config.json not found at $CONFIG" >&2; exit 1
fi
if ! jq -e --arg s "$SITE" '.sites[$s]' "$CONFIG" >/dev/null; then
  echo "site '$SITE' not in config.json" >&2; exit 1
fi

# tenant_id is intentionally NOT in config.json — it must come from runtime
# env (TF_VAR_tenant_id, populated from GH org secret AZURE_TENANT_ID).
jq --arg s "$SITE" '
  .sites[$s] +
  { subscription_id: .subscription_id }
' "$CONFIG" > "$OUT"
echo "wrote $OUT"
