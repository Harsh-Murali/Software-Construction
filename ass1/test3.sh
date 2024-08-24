#!/bin/dash

# Test 2 - Invalid zid (11 digits long)

PATH="$PATH:$(pwd)"
trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Initialize the environment
mkdir .give

# Create an assignment
assignment="lab1"
mkdir ".give/$assignment"
solutionFile="solution.sh"
autotestsFile="autotests.txt"
automarkingFile="automarking.txt"
echo "#!/bin/dash\necho 'Hello, World!'" > ".give/$assignment/$solutionFile"
echo "test_1 | solution.sh | Hello, World! |" > ".give/$assignment/$autotestsFile"
echo "test_1 | solution.sh | Hello, World! | 10" > ".give/$assignment/$automarkingFile"

# Create a valid test submission file
submissionFile="submission.sh"
touch "$submissionFile"

# Attempt to submit the file with an invalid zid
output=$(give-submit "$assignment" z12345678901 "$submissionFile" 2>&1)

# Verify the output contains the expected error message
if echo "$output" | grep -q "invalid zid"
then
    echo "Test 3 passed!"
else
    echo "Test 3 failed!"
fi

exit 0
