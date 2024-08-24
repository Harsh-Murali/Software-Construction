#!/usr/bin/env dash

# Save the current working directory
current_dir="$(pwd)"

# Create a temporary directory for the test
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output
expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done
trap 'rm -rf "$expected_output" "$actual_output" "$test_dir"' EXIT INT HUP QUIT TERM

# Test Example: Testing global substitution command 's/e//g' on "Hello Andrew"
echo "Testing global substitution command 's/e//g' on 'Hello Andrew'"
cat > "$expected_output" <<EOF
Hllo Andrw
EOF

# Run the command, ensuring to reference eddy.py from the originally saved current directory
echo "Hello Andrew" | python3 "$current_dir/eddy.py" 's/e//g' > "$actual_output"

# Check the output against expected output
if ! diff "$expected_output" "$actual_output" > /dev/null
then
    echo "Failed test: Output does not match expected for 's/e//g'"
    exit 1
fi

echo "Passed test"
