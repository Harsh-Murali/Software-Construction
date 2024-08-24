#!/bin/dash

# Test 0 - running pushy-init twice

PATH="$PATH:$(pwd)"
INDEX=".pushy"

trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$testingDir"' INT HUP QUIT TERM EXIT

testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

expected_output="$(mktemp)"
actual_output="$(mktemp)"

cat > "$expected_output" <<EOF
pushy-init: error: .pushy already exists
EOF

# Run pushy-init script twice and redirecting stderr to stdout
pushy-init 2>&1 >/dev/null

# Expets an error about .pushy existing to be produced
pushy-init 2>&1 > "$actual_output"

# Compare the actual output against the expected output
if diff "$expected_output" "$actual_output" 2>&1
then
    echo "Test 0 passed!"
else
    echo "Test 0 failed!"
fi

exit 0

