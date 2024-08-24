#!/bin/dash

# test08.sh - Testing grip-branch deletion
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

(cd "$ref_dir/test_repo" && grip-init > /dev/null 2>&1)
(cd "$imp_dir/test_repo" && grip-init > /dev/null 2>&1)

(cd "$ref_dir/test_repo" && grip-branch branch1 > /dev/null 2>&1 && grip-branch -d branch1 > /dev/null 2>&1)
(cd "$imp_dir/test_repo" && grip-branch branch1 > /dev/null 2>&1 && grip-branch -d branch1 > /dev/null 2>&1)

(cd "$ref_dir/test_repo" && grip-branch > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-branch > "$imp_output" 2>&1)

if cmp -s "$ref_output" "$imp_output"
then
    echo "PASS: grip-branch correctly deletes a branch."
else
    echo "FAIL: grip-branch did not correctly delete a branch."
    exit 1
fi
