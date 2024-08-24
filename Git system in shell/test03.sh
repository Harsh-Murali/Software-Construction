#!/bin/dash

# Test 3 - Checking pushy-status output


export PATH="$PATH:$(pwd)"

test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

expected_output_file="$(mktemp)"
actual_output_file="$(mktemp)"

# Makes a cleanup function to remove temporary files and directory after exiting
cleanup() {
  rm -f "$expected_output_file" "$actual_output_file"
  rm -rf "$test_dir"
}
trap cleanup INT HUP QUIT TERM EXIT

# Creates a test file
echo "file content" > testfile.txt

# Initialises the pushy repo
pushy-init > /dev/null 2>&1
# Adds the test file to the repo
pushy-add testfile.txt > /dev/null 2>&1

# Defines expected output for pushy-status
echo "testfile.txt - added to index" > "$expected_output_file"

# Runs pushy-status and save its output
pushy-status > "$actual_output_file" 2>&1

# Compares the expected output with actual output
if ! diff -q "$expected_output_file" "$actual_output_file" > /dev/null
then
    echo "Test 3 failed"
    exit 1
fi

echo "Test 3 passed!"

exit 0
