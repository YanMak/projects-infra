#!/usr/bin/env bash
MERGED_YAML="$1"
BASE_DIR="$2"
set -e
yq e ".env | to_entries | .[] | \"\(.key)='\(.value|tostring)'\"" "$BASE_DIR/$MERGED_YAML" > "$BASE_DIR/app.local.env"