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

# Test Example: Testing the quit command with regex '/^2.+/q' on sequence 10-30
echo "Testing quit command with regex '/^2.+/q' on sequence 10-30"
cat > "$expected_output" <<EOF
10
11
12
13
14
15
16
17
18
19
20
EOF

# Run the command, ensuring to reference eddy.py from the originally saved current directory
seq 10 30 | python3 "$current_dir/eddy.py" '/^2.+/q' > "$actual_output"

# Check the output against expected output
if ! diff "$expected_output" "$actual_output" > /dev/null
then
    echo "Failed test: Output does not match expected for regex '/^2.+/q'"
    exit 1
fi

echo "Passed test"