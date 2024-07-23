#!/bin/bash

pylint $(git ls-files '*.py') --disable=all --enable=error --output-format=parseable > pylint-errors.txt || true

# Extract files with errors using awk
awk -F: '{print $1}' pylint-errors.txt | sort | uniq > files_with_errors.txt

# List out all files that failed pylint check
echo "Files that failed pylint check:"
cat files_with_errors.txt

# Auto-fix line length errors using black and autopep8
while IFS= read -r file; do
    # Apply autopep8 for fixing specific issues
    autopep8 --in-place --aggressive --aggressive "$file"
    # Apply black for formatting
    black "$file"
done < files_with_errors.txt

# Show diffs of the changes made