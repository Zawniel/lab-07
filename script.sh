#!/bin/bash

# loop to check directories
i=1
while true; do
    test_dir="Testcase${i}"

    if [ ! -d "$test_dir" ]; then
        break
    fi

    diff_dir="Testcase${i}Diff"
    rm -rf "$diff_dir"

    # loop to check files in directories
    has_diff=0
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

        if ! diff "$file1" "$file2"; then
            # create diff directory
            if [ "$has_diff" -eq 0 ]; then
                mkdir "$diff_dir"
                has_diff=1
            fi

            output_file="${diff_dir}/Version${j}Diff.txt"
            diff -u "$file1" "$file2" > "$output_file"
        fi
        ((j++))
   done

    ((i++))
done