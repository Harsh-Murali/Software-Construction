#!/bin/dash

#Test 4 - Checks pushy-log command's ability to correctly list commit messages from the .pushy repository in descending order.

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

# Initialises the pushy repo
mkdir -p .pushy/index/files
echo "Initialized empty pushy repository in .pushy" > /dev/null

# Manually creates commit directories and message files
mkdir -p .pushy/commit_0 .pushy/commit_1
echo "First commit message" > .pushy/commit_0/commit_message.txt
echo "Second commit message" > .pushy/commit_1/commit_message.txt

# Defines the expected output
echo "1 Second commit message" > "$expected_output_file"
echo "0 First commit message" >> "$expected_output_file"

# Runs the pushy-log command and save its output
./pushy-log > "$actual_output_file" 2>&1

# Compare the expected outputs and actual outputs
if diff -q "$expected_output_file" "$actual_output_file" > /dev/null
then
    echo "Test 4 passed!"
else
    echo "Test 4 failed!"
fi

exit 0
