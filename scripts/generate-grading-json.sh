#!/usr/bin/env bash
set -euo pipefail
cd terraform
terraform output -json > ../grading.json
echo "grading.json generated in repo root (commit it before submission)."