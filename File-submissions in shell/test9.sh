#!/bin/dash

# Test - give-mark with missing assignment name

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create an assignment and a submission for testing
assignment="lab1"
mkdir ".give/$assignment"

# Add necessary files for the assignment
solutionFile=".give/$assignment/solution.sh"
autotestsFile=".give/$assignment/autotests.txt"
automarkingFile=".give/$assignment/automarking.txt"
echo "#!/bin/dash\necho 'Hello, World!'" > "$solutionFile"
echo "test_1 | solution.sh | Hello, World! |" > "$autotestsFile"
echo "test_1 | solution.sh | Hello, World! | 10" > "$automarkingFile"

# Add a dummy submission
mkdir -p ".give/$assignment/z1234567"
echo "dummy content" > ".give/$assignment/z1234567/submission1.sh"

# Run give-mark with no arguments
output=$(give-mark 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "usage: give-mark <assignment>"
then
    echo "Test 9 passed!"
else
    echo "Test 9 failed!"
fi

exit 0
