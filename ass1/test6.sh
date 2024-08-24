#!/bin/dash

# Test - give-status with invalid zid (random word)

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

# Run give-status with an invalid zid (random word)
output=$(give-status dog 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "invalid zid"
then
    echo "Test 6 passed!"
else
    echo "Test 6 failed!"
fi

exit 0
