#!/bin/dash

# Test 2 - Invalid solution file path (starts with *)

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create necessary files
solutionFile="*solution.sh"
autotestsFile="autotests.txt"
automarkingFile="automarking.txt"
touch "$solutionFile"
echo "test_1 | solution.sh | Hello, World! |" > "$autotestsFile"
echo "test_1 | solution.sh | Hello, World! | 10" > "$automarkingFile"

# Attempt to add an assignment with an invalid solution file path
output=$(give-add lab1 "$solutionFile" "$autotestsFile" "$automarkingFile" 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "invalid pathname"
then
    echo "Test 1 passed!"
else
    echo "Test 1 failed!"
fi

exit 0
