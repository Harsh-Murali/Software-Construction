#!/bin/dash

# Test 2 - Committing a file with a message

originalDir=$(pwd)
PATH="$PATH:$originalDir"

trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

mkdir -p .pushy/index/files .pushy/staging

# Creates a file to be committed
testFile="file_to_commit.txt"
echo "Commit me" > "$testFile"
# Mimics pushy-add
cp "$testFile" ".pushy/index/files/$testFile"

# Creates expected and actual output files
expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Defines the expected outcome
echo "Commit directory exists and contains the commit message" > "$expected_output"

# Performs the commit with a message
pushy-commit -m "Initial commit" > /dev/null 2>&1

#  Check if the new commit directory was created and contains the commit message
commitDir=$(ls .pushy | grep 'commit_' | sort -n | tail -1)
if [ -d ".pushy/$commitDir" ] && grep -q "Initial commit" ".pushy/$commitDir/commit_message.txt"
then
    echo "Commit directory exists and contains the commit message" > "$actual_output"
else
    echo "Commit failed" > "$actual_output"
fi

# Compares the actual outcome against the expected outcome
if diff "$expected_output" "$actual_output" > /dev/null 2>&1
then
    echo "Test 2 passed!"
else
    echo "Test 2 failed!"
fi

exit 0