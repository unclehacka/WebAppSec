#!/usr/bin/env bash
set -euo pipefail
URL="${1:-}"
[ -z "$URL" ] && { echo "usage: $0 https://host"; exit 2; }

declare -A REQ=(
  ["strict-transport-security"]="max-age=31536000"
  ["x-content-type-options"]="nosniff"
  ["referrer-policy"]="strict-origin-when-cross-origin"
  ["x-frame-options"]="SAMEORIGIN"
  ["cross-origin-opener-policy"]="same-origin"
  ["cross-origin-resource-policy"]="same-site"
  ["permissions-policy"]="geolocation=()"
)

hdrs=$(curl -fsSI "$URL")
fail=0
for key in "${!REQ[@]}"; do
  val="$(grep -i "^$key:" <<<"$hdrs" || true)"
  if [[ -z "$val" || "$val" != *"${REQ[$key]}"* ]]; then
    echo "MISS/WRONG: $key needs '${REQ[$key]}'"; fail=1
  else
    echo "OK: $key -> $val"
  fi
done
exit $fail
