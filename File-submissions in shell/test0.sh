#!/bin/dash

# Test 1 - Invalid assignment name (starts with an uppercase character)

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create necessary files
solutionFile="solution.sh"
autotestsFile="autotests.txt"
automarkingFile="automarking.txt"
echo "#!/bin/dash\necho 'Hello, World!'" > "$solutionFile"
echo "test_1 | solution.sh | Hello, World! |" > "$autotestsFile"
echo "test_1 | solution.sh | Hello, World! | 10" > "$automarkingFile"

# Attempt to add an assignment with an invalid name
output=$(give-add Lab1 "$solutionFile" "$autotestsFile" "$automarkingFile" 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -Eq "invalid assignment"
then
    echo "Test 0 passed!"
else
    echo "Test 0 failed!"
fi

exit 0
