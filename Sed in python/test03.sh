#!/usr/bin/env sh

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

# Test Example: Testing the print command with regex '/^7/p' on sequence 60-85
echo "Testing print command with regex '/^7/p' on sequence 55-85"
cat > "$expected_output" <<EOF
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
70
71
71
72
72
73
73
74
74
75
75
76
76
77
77
78
78
79
79
80
81
82
83
84
85
EOF

# Run the command, ensuring to reference eddy.py from the originally saved current directory
seq 65 85 | python3 "$current_dir/eddy.py" '/^7/p' > "$actual_output"

# Check the output against expected output
if ! diff "$expected_output" "$actual_output" > /dev/null
then
    echo "Failed test: Output does not match expected for regex '/^7/p'"
    exit 1
fi

echo "Passed test"
