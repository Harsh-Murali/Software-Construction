#!/bin/dash

# test01.sh - Testing grip-add filename validation
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

touch "$ref_dir/test_repo/_file1"
touch "$ref_dir/test_repo/-file2"
touch "$ref_dir/test_repo/.file3"

touch "$imp_dir/test_repo/_file1"
touch "$imp_dir/test_repo/-file2"
touch "$imp_dir/test_repo/.file3"

(cd "$ref_dir/test_repo" && grip-add _file1 -file2 .file3 > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-add _file1 -file2 .file3 > "$imp_output" 2>&1)

if [ -f "$ref_dir/test_repo/.grip/index/files/_file1" ] && \
   [ -f "$ref_dir/test_repo/.grip/index/files/-file2" ] && \
   [ -f "$ref_dir/test_repo/.grip/index/files/.file3" ] && \
   [ -f "$imp_dir/test_repo/.grip/index/files/_file1" ] && \
   [ -f "$imp_dir/test_repo/.grip/index/files/-file2" ] && \
   [ -f "$imp_dir/test_repo/.grip/index/files/.file3" ]
then
    echo "FAIL: Files starting with _, -, or . were added."
else
    echo "PASS: Files starting with _, -, or . were not added."
    exit 1
fi
