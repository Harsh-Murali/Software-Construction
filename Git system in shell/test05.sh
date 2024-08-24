#!/bin/dash

# Test 5 - Verifies pushy-show command's ability to display the content of a file from a specified commit within the .pushy repository.


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

# Initialises the pushy repository
mkdir -p .pushy/index/files

# Mimics creating a commit with a file
commit_number="0"
mkdir -p ".pushy/commit_$commit_number"
file_name="testfile.txt"
echo "File content for commit $commit_number." > ".pushy/commit_$commit_number/$file_name"

# Defines the expected output
echo "File content for commit $commit_number." > "$expected_output_file"

# Execute the pushy-show command for the file in commit 0 and save its output
./pushy-show "$commit_number:$file_name" > "$actual_output_file" 2>&1

# Compare the expected outputs and actual outputs
if diff -q "$expected_output_file" "$actual_output_file" > /dev/nul
 then
    echo "Test passed!"
else
    echo "Test failed!"
fi

exit 0
