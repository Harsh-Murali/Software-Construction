#!/bin/dash

# test_09 - Testing grip-checkout branch switching
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

(cd "$ref_dir/test_repo" && grip-branch branch1 > /dev/null 2>&1 && grip-checkout branch1 > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-branch branch1 > /dev/null 2>&1 && grip-checkout branch1 > "$imp_output" 2>&1)

if grep -q "Switched to branch 'branch1'" "$imp_output"
then
    echo "PASS: grip-checkout correctly switched to 'branch1'."
else
    echo "FAIL: grip-checkout did not correctly switch to 'branch1'."
    exit 1
fi

(cd "$ref_dir/test_repo" && grip-checkout trunk > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-checkout trunk > "$imp_output" 2>&1)

if grep -q "Switched to branch 'trunk'" "$imp_output"
then
    echo "PASS: grip-checkout correctly switched back to 'trunk'."
else
    echo "FAIL: grip-checkout did not correctly switch back to 'trunk'."
    exit 1
fi

(cd "$ref_dir/test_repo" && grip-checkout non_existent_branch > "$ref_output" 2>&1)
(cd "$imp_dir/test_repo" && grip-checkout non_existent_branch > "$imp_output" 2>&1)

if grep -q "grip-checkout: error: unknown branch 'non_existent_branch'" "$imp_output"
then
    echo "PASS: grip-checkout correctly handled the non-existent branch error."
else
    echo "FAIL: grip-checkout did not correctly handle the non-existent branch error."
    exit 1
fi
