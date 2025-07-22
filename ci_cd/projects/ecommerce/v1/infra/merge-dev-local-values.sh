#!/usr/bin/env bash
VALUES="$1"
VALUES_DEV_LOCAL="$2"
SECRETS_DEV="$3"
SECRETS_DEV_LOCAL="$4"
TMPDIR="$5"
OUTPUT_DIR="$6"
MERGED_YAML="$7"

set -e
yq eval-all 'select(filename=="./tmp/values.yaml") as $a | select(filename=="./tmp/values.dev.local.yaml") as $b | select(filename=="./tmp/secrets.values.dev.decrypted.yaml") as $c | select(filename=="./tmp/secrets.values.dev.local.decrypted.yaml") as $d | $a * $b * $c * $d' ./tmp/values.yaml ./tmp/values.dev.local.yaml ./tmp/secrets.values.dev.decrypted.yaml ./tmp/secrets.values.dev.local.decrypted.yaml > "$OUTPUT_DIR/$MERGED_YAML"