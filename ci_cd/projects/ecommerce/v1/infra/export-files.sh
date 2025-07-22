#!/usr/bin/env bash
MERGED_YAML="$1"
BASE_DIR="$2"

mkdir -p "$BASE_DIR/creds"
yq e -r '.files.creds | to_entries[] | .value.filename' "$BASE_DIR/$MERGED_YAML" | while read filename; do
yq e -r ".files.creds[] | select(.filename == \"$filename\") | .data" "$BASE_DIR/$MERGED_YAML" > "$BASE_DIR/creds/$filename"
done

mkdir -p "$BASE_DIR/certs"
yq e -r '.files.certs | to_entries[] | .value.filename' "$BASE_DIR/$MERGED_YAML" | while read filename; do
yq e -r ".files.certs[] | select(.filename == \"$filename\") | .data" "$BASE_DIR/$MERGED_YAML" > "$BASE_DIR/certs/$filename"
done
# yq e -r '.files | to_entries[] | .value.filename' "$1" | while read filename; do
# yq e -r ".files[] | select(.filename == \"$filename\") | .data" "$1" > "$filename"
# done