#!/bin/dash

# Test - give-summary with no arguments

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create assignments and submissions for testing
assignment1="lab1"
assignment2="lab2"
mkdir ".give/$assignment1"
mkdir ".give/$assignment2"

# Add some dummy submissions
mkdir -p ".give/$assignment1/z1234567"
echo "dummy content" > ".give/$assignment1/z1234567/submission1.sh"

mkdir -p ".give/$assignment2/z2345678"
echo "dummy content" > ".give/$assignment2/z2345678/submission1.sh"

# Run give-summary with no arguments
output=$(give-summary 2>&1)

# Verify the output contains the expected summary
if echo "$output" | grep -q "assignment lab1: submissions from 1 student" &&
   echo "$output" | grep -q "assignment lab2: submissions from 1 student"
   then
    echo "Test 5 passed!"
else
    echo "Test 5 failed!"
fi

exit 0
