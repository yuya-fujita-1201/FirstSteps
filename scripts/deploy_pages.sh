#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN is not set."
  echo "Set it in your shell, then re-run this script."
  exit 1
fi

PROJECT_NAME="${1:-marumi-works}"

wrangler pages deploy docs/site --project-name "${PROJECT_NAME}"
