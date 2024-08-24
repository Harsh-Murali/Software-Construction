#!/bin/dash

# test05.sh - Testing grip-show with a file from a specific commit
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

echo "content v1" > "$ref_dir/test_repo/file1.txt"
echo "content v1" > "$imp_dir/test_repo/file1.txt"

(cd "$ref_dir/test_repo" && grip-add file1.txt && grip-commit -m "v1 commit" > /dev/null 2>&1)
(cd "$imp_dir/test_repo" && grip-add file1.txt && grip-commit -m "v1 commit" > /dev/null 2>&1)

echo "content v2" > "$ref_dir/test_repo/file1.txt"
echo "content v2" > "$imp_dir/test_repo/file1.txt"

(cd "$ref_dir/test_repo" && grip-add file1.txt && grip-commit -m "v2 commit" > /dev/null 2>&1 && grip-show 0:file1.txt > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-add file1.txt && grip-commit -m "v2 commit" > /dev/null 2>&1 && grip-show 0:file1.txt > "$imp_output" 2>&1)

if cmp -s "$ref_output" "$imp_output"
then
    echo "PASS: grip-show correctly displays file content from a specific commit."
else
    echo "FAIL: grip-show did not correctly display file content from a specific commit."
    exit 1
fi
