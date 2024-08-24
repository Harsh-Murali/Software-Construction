#!/bin/dash

# Test 1 - Invalid zid (using a file name as zid)

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create an assignment and a submission for testing
assignment="lab1"
mkdir ".give/$assignment"

# Add a dummy submission
mkdir -p ".give/$assignment/z1234567"
echo "dummy content" > ".give/$assignment/z1234567/submission1.sh"

# Run give-fetch with a file name as zid
output=$(give-fetch "$assignment" submission1.sh 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "invalid zid"
then
    echo "Test 7 passed!"
else
    echo "Test 7 failed!"
fi

exit 0
