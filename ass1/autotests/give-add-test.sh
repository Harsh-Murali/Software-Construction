#!/bin/dash
rm -rf .give
mkdir -p .give/multiply_exercise
echo "#!/bin/dash\na=\$1\nb=\$2\necho \$((a * b))" > .give/multiply_exercise/solution.sh
chmod +x .give/multiply_exercise/solution.sh
echo "test_a|2 3||\ntest_b|5 5||\ntest_c|4 4||" > .give/multiply_exercise/autotests.txt
echo "test_a|2 3||10" > .give/multiply_exercise/automarking.txt
2041 give-add multiply_exercise .give/multiply_exercise/solution.sh .give/multiply_exercise/autotests.txt .give/multiply_exercise/automarking.txt
