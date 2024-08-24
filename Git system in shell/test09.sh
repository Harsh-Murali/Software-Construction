#!/bin/dash

# Test 9 - checks if branch does not exist

PATH="$PATH:$(pwd)"
INDEX=".pushy"

trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Setup .pushy directory
mkdir -p .pushy/index/files
mkdir -p .pushy/branches/master
ln -s ../index/files .pushy/branches/master
mkdir -p .pushy/branches/new-branch

nonexistent_branch_output=$(./pushy-checkout non-existent-branch 2>&1)
echo "$nonexistent_branch_output" | grep -q "pushy-checkout: error: Branch 'non-existent-branch' does not exist"
if [ $? -eq 0 ]
then
    echo "Test 9 (branch does not exist) passed!"
else
    echo "Test 9 (branch does not exist) failed!"
    exit 1
fi

exit 0
