#!/bin/bash

all_passed=1

# loop to check directories
i=1
while true; do
    test_dir="Testcase${i}"

    if [ ! -d "$test_dir" ]; then
        break
    fi

    test_pass=1
    diff_dir="Testcase${i}Diff"
    has_actual_diff=0  # track if any files in this testcase actually differ

    # loop to check files in directories
    j=1
    while true; do
        file1="${test_dir}/Version${j}.1.txt"
        file2="${test_dir}/Version${j}.2.txt"

        # check testcases
        if [ ! -f "$file1" ]; then
            break
        fi
        if [ ! -f "$file2" ]; then
            break
        fi

        output_file="${diff_dir}/Version${j}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            has_actual_diff=1  # mark that a difference was found
            
            # missing diff file
            if [ ! -f "$output_file" ]; then
                test_pass=0
                all_passed=0

            # if contents of file don't match
            elif [ "$(diff -u "$file1" "$file2" | tail -n +3)" != "$(tail -n +3 "$output_file")" ]; then
                test_pass=0
                all_passed=0
            fi

        else
            # identical files
            if [ -f "$output_file" ]; then
                test_pass=0
                all_passed=0
            fi
        fi
        ((j++))
    done

    if [ "$has_actual_diff" -eq 1 ] && [ ! -d "$diff_dir" ]; then
        test_pass=0
        all_passed=0
    elif [ "$has_actual_diff" -eq 0 ] && [ -d "$diff_dir" ]; then
        test_pass=0
        all_passed=0
    fi

    if [ "$test_pass" -eq 1 ]; then
        echo "Testcase${i}: PASS"
    else
        echo "Testcase${i}: FAIL"
        all_passed=0
    fi

    ((i++))
done

if [ "$all_passed" -eq 0 ]; then
    exit 1
else
    exit 0
fi