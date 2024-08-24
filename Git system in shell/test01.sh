#!/bin/dash

# Test 1 - adding a new file to the index


PATH="$PATH:$(pwd)"
INDEX_DIR=".pushy/index/files"

trap 'rm -f "$testFile"; rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Creates a .pushy directory and necessary subdirectories mimicing .pushy-init
mkdir -p "$INDEX_DIR"

# Creates a test file to add words to
testFile="testfile.txt"
echo "This is a test file." > "$testFile"

# Attempts to add the file to the index
pushy-add "$testFile" 2>&1

# Checks if the file has been added to the index directory
if [ -f "$INDEX_DIR/$testFile" ]
then
    echo "Test 1 passed!"
else
    echo "Test 1 failed!"
fi

exit 0