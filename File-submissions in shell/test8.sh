#!/bin/dash

# Test 2 - Invalid assignment name (using a zid as assignment name)

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

# Run give-fetch with a zid as the assignment name
output=$(give-fetch z1234567 z1234567 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "assignment z1234567 not found"
then
    echo "Test 8 passed!"
else
    echo "Test 8 failed!"
fi

exit 0
