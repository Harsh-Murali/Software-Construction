#!/bin/dash

# Test 8 - checks if checkout existing branch works

PATH="$PATH:$(pwd)"
INDEX=".pushy"

trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Sets up .pushy directory
mkdir -p .pushy/index/files
mkdir -p .pushy/branches/master
ln -s ../index/files .pushy/branches/master

./pushy-checkout master 2>&1 | grep -q "Switched to branch 'master'"
if [ $? -eq 0 ]
then
    echo "Test 8 (checkout existing branch) passed!"
else
    echo "Test 8 (checkout existing branch) failed!"
    exit 1
fi

exit 0
