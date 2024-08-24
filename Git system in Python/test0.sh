#!/bin/dash

# test00.sh - Testing grip-init
# Harsh z5361547

PATH="$PATH:$(pwd)"

ref_output="$(mktemp)"
imp_output="$(mktemp)"
ref_dir="$(mktemp -d)"
imp_dir="$(mktemp -d)"

cleanup() {
    rm -f "$ref_output" "$imp_output"
    rm -rf "$ref_dir" "$imp_dir"
}
trap cleanup EXIT


mkdir "$ref_dir/test_repo" "$imp_dir/test_repo"

(cd "$ref_dir/test_repo" && grip-init > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-init > "$imp_output" 2>&1)

if [ -d "$ref_dir/test_repo/.grip" ] && \
   [ -d "$ref_dir/test_repo/.grip/branches" ] && \
   [ -f "$ref_dir/test_repo/.grip/HEAD" ] && \
   [ -d "$imp_dir/test_repo/.grip" ] && \
   [ -d "$imp_dir/test_repo/.grip/branches" ] && \
   [ -f "$imp_dir/test_repo/.grip/HEAD" ]
   then
    echo "PASS: .grip directory and files created."
else
    echo "FAIL: .grip directory or files not created."
    exit 1
fi
