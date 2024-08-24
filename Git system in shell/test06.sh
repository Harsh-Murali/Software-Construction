#!/bin/dash

# Test 6 - shows status after adding files and making a commit

PATH="$PATH:$(pwd)"
INDEX=".pushy"

trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$testingDir"' INT HUP QUIT TERM EXIT


testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# creates temp files
expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Initialises pushy repository and adds a file to the index
# then commits this file
mkdir -p .pushy/index/files
echo "File content" > .pushy/index/files/testfile.txt
mkdir -p .pushy/commit_0
cp .pushy/index/files/testfile.txt .pushy/commit_0/testfile.txt

# defines the expected output after adding file to index and making a commit
cat > "$expected_output" <<EOF
EOF

# Runs pushy-status and captures its output
pushy-status 2>&1 > "$actual_output"

# Compare the actual output with the expected output
if diff "$expected_output" "$actual_output" 2>&1
then
    echo "Test 6 passed!"
else
    echo "Test 6 failed!"
fi

exit 0