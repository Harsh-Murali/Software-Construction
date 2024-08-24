#!/bin/dash

# test03.sh - Testing grip-commit after adding a file
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

touch "$ref_dir/test_repo/file1"
touch "$imp_dir/test_repo/file1"

(cd "$ref_dir/test_repo" && grip-add file1 && grip-commit -m "commit message" > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-add file1 && grip-commit -m "commit message" > "$imp_output" 2>&1)

if cmp -s "$ref_output" "$imp_output"
then
    echo "PASS: Commit after adding a file works correctly."
else
    echo "FAIL: Commit after adding a file does not work correctly."
    exit 1
fi
