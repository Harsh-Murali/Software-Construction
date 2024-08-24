#!/bin/dash

# Test 7 - tests branch creation and deletion


PATH="$PATH:$(pwd)"
INDEX=".pushy"


trap 'rm -rf "$testingDir"' INT HUP QUIT TERM EXIT


testingDir="$(mktemp -d)"
cd "$testingDir" || exit 1

# Sets up .pushy directory and does a commit
mkdir -p .pushy/index/files
mkdir .pushy/commit_0

# Checks for banch creation
pushy-branch new-branch
if [ ! -d ".pushy/branches/new-branch" ]
then
    echo "Branch creation failed!"
    exit 1
fi

# Checks for banch deletion
pushy-branch -d new-branch
if [ -d ".pushy/branches/new-branch" ]
then
    echo "Branch deletion failed!"
    exit 1
fi

echo "All tests passed!"

exit 0