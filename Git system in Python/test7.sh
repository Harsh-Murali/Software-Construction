#!/bin/dash

# test07.sh - Testing grip-status with modified and staged files
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

echo "file content" > "$ref_dir/test_repo/file1.txt"
echo "file content" > "$imp_dir/test_repo/file1.txt"

(cd "$ref_dir/test_repo" && grip-add file1.txt && grip-commit -m "Initial commit" > /dev/null 2>&1)
(cd "$imp_dir/test_repo" && grip-add file1.txt && grip-commit -m "Initial commit" > /dev/null 2>&1)

echo "modified content" > "$ref_dir/test_repo/file1.txt"
echo "modified content" > "$imp_dir/test_repo/file1.txt"

(cd "$ref_dir/test_repo" && grip-add file1.txt > /dev/null 2>&1)
(cd "$imp_dir/test_repo" && grip-add file1.txt > /dev/null 2>&1)

echo "further modified content" > "$ref_dir/test_repo/file1.txt"
echo "further modified content" > "$imp_dir/test_repo/file1.txt"

(cd "$ref_dir/test_repo" && grip-status > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-status > "$imp_output" 2>&1)

if cmp -s "$ref_output" "$imp_output"
then
    echo "PASS: grip-status correctly shows modified and staged files."
else
    echo "FAIL: grip-status did not show modified and staged files as expected."
    exit 1
fi
