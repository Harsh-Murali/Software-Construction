#!/bin/dash

# test06.sh - Testing grip-rm with --cached option
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

(cd "$ref_dir/test_repo" && grip-rm --cached file1.txt > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-rm --cached file1.txt > "$imp_output" 2>&1)

if [ ! -f "$ref_dir/test_repo/.grip/index/files/file1.txt" ] && \
   [ -f "$ref_dir/test_repo/file1.txt" ] && \
   cmp -s "$ref_output" "$imp_output"
   then
    echo "PASS: grip-rm with --cached correctly removed file from index but not from working directory."
else
    echo "FAIL: grip-rm with --cached did not behave as expected."
    exit 1
fi
